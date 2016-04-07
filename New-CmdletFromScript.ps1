
# SCRIPT: New-CmdletFromScript.ps1
# ================================
# Creates a cmdlet using a functional PowerShell script.
#
# Type          : Script
# Using         : Windows PowerShell (*.ps1)
#
# Written by    : Andrew D
# Last modified : 01/14/2016

#Requires -Version 3

<#
.SYNOPSIS
	Creates a cmdlet using a functional PowerShell script.
.DESCRIPTION
	This script converts a PowerShell script to a cmdlet (adds function-syntax); to be used on multiple scripts that chould be compiled into a module.
.PARAMETER Path
	Specifies the path to a PowerShell script file.
.PARAMETER DefinitionsPath
	Specifies the path to a set of PowerShell cmdlet definitions.
.PARAMETER Define
	Specifies to execute the command that defines the cmdlet in PowerShell.
.INPUTS
	String
	The path to a PowerShell script file.
.OUTPUTS
	String[]
	An array of strings containing the new cmdlet script.
.EXAMPLE
	PS C:\> Get-ChildItem .\PowerShellScripts\ | % { Add-Content -Path .\Tools.psm1 -Value "`n`n"; $_.FullName | .\New-CmdletFromScript.ps1 -Definitions .\Tools.psm1 }
	This example takes the content from every script in the folder and adds it to a file containing cmdlet definitions, separated by new lines.
.LINK
	Get-Content
#>

[CmdletBinding()]
Param
(
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
	[Alias("FilePath")]
	[String]
	$Path,
	
	[Parameter(Position = 1)]
	[String]
	$DefinitionsPath,
	
	[Switch]
	$Define
)

$tabWidth = 4
$space    = " "

if(Test-Path "$PSScriptRoot\$Path")
{
	$fileName = [Regex]::Match($Path, "(?<=\\)[^\.\\]+(?=\.\w+$)").Value
	
	$content = @(Get-Content $Path)
	
	$newContent = @("function $fileName", "{")
	
	$final = $content.Count - 1
	
	$i = 0; while([String]::IsNullOrWhiteSpace($content[$i]) -and $i -lt $final) { ++$i }
	$j = $final; while([String]::IsNullOrWhiteSpace($content[$j]) -and $j -gt 0) { --$j }
	
	foreach($k in $i..$j)
	{
		$newContent += [String]($space*$tabWidth + $content[$k])
	}
	
	$newContent += "}"
	
	if([String]::IsNullOrWhitespace($DefinitionsPath))
	{
		if(!$Define)
		{
			return $newContent
		}
	}
	else
	{
		foreach($line in $newContent)
		{
			Add-Content -Path $DefinitionsPath -Value $line
		}
	}
	
	if($Define)
	{
		Invoke-Expression -Command ([String]$newContent)
	}
}