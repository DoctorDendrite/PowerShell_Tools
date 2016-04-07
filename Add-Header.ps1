
$AppendContent = "Append-Content.ps1"
$ArrayToString = "Get-ArrayToString.ps1"
$WordWrap      = "Get-WordWrap.ps1"

[CmdletBinding()]
Param
(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	[Alias("FilePath")]
	[String]
	$Path,
	
	[String]   $Synopsis    = "[TO DO]",
	[String]   $Description = "[TO DO]",
	[String]   $Type,
	[String]   $Using,
	[String]   $Author      = "Andrew D",
	[String]   $Date        = (Get-Date).ToString("MM/dd/yyy"),
	[String[]] $Requires    = @("-Version 3", "-Modules Azure"),
	[Int64]    $StartOnLine = 2,
	[String]   $ScriptLoc   = $PSScriptRoot,
	
	[ValidateSet("Replace", "Stack", "Fail", "SilentlyFail")]
	[String]   $OverwriteAction = "Replace"
)

$ErrorActionPreference = "Stop"

$headerPattern = "\W+.+\W*.+\..+`n" + `
                 "\W+`n" + `
                 “(\W+.+`n)+” + `
                 "\W+`n" + `
                 "\W+Type\s*\W*.+`n" + `
                 "\W+Using\s*\W*.+`n" + `
                 "\W+`n" + `
                 "\W+Written by\s*\W*.+`n" + `
                 "\W+Last modified\s*\W*\d{2}/\d{2}/\d{4}"
				 
$content = ""
(Get-Content $Path) | ForEach { $content += $_ + "`n" }

if($content -match $headerPattern)
{
	Switch($OverwriteAction)
	{
		"Replace"
		{
			$requiresPattern = "`n`n\W+Requires\W+(.+`n)+`n"
			
			if($content -match ($headerPattern + $requiresPattern))
			{
				$headerPattern += $requiresPattern
			}
			
			$content -Replace $headerPattern, "" | Set-Content -Path $Path
		}
		"Fail"
		{
			Throw "This file is already documented."
		}
		"SilentlyFail"
		{
			return
		}
	}
}

Remove-Variable headerPattern
Remove-Variable content

[String] $name          = $Path.Split("\")[-1]
[Int64]  $synopsisWidth =  80
[Int64]  $labelWidth    = -13
[String] $firstDivider  = ": "
[String] $secndDivider  = " : "
[Char]   $horizon       = '='

if([String]$horizon -notmatch "\W")
{
	Throw "It is recommended that you use a nonword characters for the dividers."
}

$extension = $Path.Split(".")[-1]

if($Type -eq "")
{
	if(@("bat", "cmd", "nt") -contains $extension)
	{
		$Type  = "Script"
		$Using = "Windows Batch Command"
		$remOp = ":: "
	}
	elseif($extension -match "^ps.*\d$")
	{
		$Type  = "Script"
		$Using = "Windows PowerShell"
		$remOp = "# "
	}
	else
	{
		Throw "File type not found."
	}
}

$Using += " (*.$extension)"

Remove-Variable extension

[String[]] $header = @()

for($i = 1; $i -lt $StartOnLine; ++$i) { $header += "" }

$titleLine = $Type.ToUpper() + $firstDivider + $name

$header += ($remOp + $titleLine)
$header += ($remOp + ([String]$horizon * ($titleLine.Length)))

Remove-Variable titleLine

foreach($line in (& "$ScriptLoc\$WordWrap" -Text $Synopsis -Width ($synopsisWidth - $remOp.Length)))
{
	$header += ($remOp + $line)
}

$header +=  $remOp
$header += ($remOp + "{0, $labelWidth}$secndDivider$Type"   -f "Type")
$header += ($remOp + "{0, $labelWidth}$secndDivider$Using"  -f "Using")
$header +=  $remOp
$header += ($remOp + "{0, $labelWidth}$secndDivider$Author" -f "Written by")
$header += ($remOp + "{0, $labelWidth}$secndDivider$Date"   -f "Last modified")
$header +=  ""

$requireLabel = ($remOp + "{0, $labelWidth}$secndDivider" -f "Requires")

foreach($requirement in $Requires)
{
	$header += @{$true  = "#Requires "; `
	             $false = $requireLabel}[$Using -like "*PowerShell*"] + $requirement

	$requireLabel = ($remOp + ("{0, $($labelWidth + $secndDivider.Length)}" -f " "))
}

Remove-Variable requireLabel

$header += "" + ""
# $header += "<#"
# $header += ""
# 
# $header += ".SYNOPSIS"
# $header += ""
# 
# $header += $Synopsis
# $header += ""
# $header += ""
# 
# $header += ".DESCRIPTION"
# $header += ""
# 
# $header += $Description
# $header += ""
# $header += ""
# 
# $fileContent = [String](Get-Content $Path)
# 
# function Get-Parameters([String] $content)
# {
# 	
# }
# 
# $header += "#>"
# $header += ""

(& "$ScriptLoc\$ArrayToString" -Array $header) | & "$ScriptLoc\$AppendContent" -Path $Path -Front