
# SCRIPT: Set-TabsToSpaces.ps1
# ============================
# Changes every tab found in a string or file to a row of spaces.
#
# Type          : Script
# Using         : Windows PowerShell (*.ps1)
#
# Written by    : Andrew D
# Last modified : 01/14/2016

#Requires -Version 3

<#
.SYNOPSIS
	Changes every tab found in a string or file to a row of spaces.
.DESCRIPTION
	This script replaces all tabs in a string or file with a row of spaces.
.PARAMETER Value
	Specifies an array of strings to be modified.
.PARAMETER Path
	Specifies the path to a file to be modified.
.PARAMETER Len
	Specifies the preferred tab size by number of spaces.
.INPUTS
	String[]
	An array of strings to be modified.
	
	String
	The path to a file to be modified.
.OUTPUTS
	String[]
	Array of modified strings.
.EXAMPLE
	PS C:\> Get-ChildItem -Recurse | % { .\Set-TabsToSpaces.ps1 -Path $_.FullName -Len 4 }
	This example modifies all the text files in the root directory, including subdirectories, changing every tab to four spaces.
.LINK
	Get-Content
#>

[CmdletBinding()]
Param
(
    [Parameter( ParameterSetName = 'StringOperation',
	            Mandatory,
                Position = 0,
                ValueFromPipeline )]
	[Alias("Content")]
    [String[]]
    $Value,
    
    [Parameter( ParameterSetName = 'FileOperation',
	            Mandatory,
                Position = 0,
	            ValueFromPipelineByPropertyName )]
    [Alias("FilePath")]
    [String]
    $Path,

    [Alias("NumberOfSpaces", "Spaces")]
    [Int64]
    $Len = 4
)

$ErrorActionPreference = "Stop"

$space = " "

Try
{
    if($PSCmdlet.ParameterSetName -eq 'FileOperation')
    {
        $Value = [String[]]
        $Value = (Get-Content $Path)
    }

    $newContent = @()
    
    foreach($line in $Value)
    {
        $newContent += $line.Replace("`t", "$($space*$Len)")
    }

    switch($PSCmdlet.ParameterSetName)
    {
        'StringOperation'
        {
            return $newContent
        }
        'FileOperation'
        {
            Set-Content -Path $Path -Value $newContent
			
			return
        }
    }
}
Catch [System.Exception]
{
    Throw $_
}
