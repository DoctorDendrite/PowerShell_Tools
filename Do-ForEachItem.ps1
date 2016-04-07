
[CmdletBinding()]
Param
(
	[String]
	$Script,
	
	[String]
	$Path,
	
	[Switch]
	$Recurse
)

if([String]::IsNullOrWhitespace($Path))
{
	$Path = (Get-Location).Path
}

Get-ChildItem -Path $Path -Recurse:$Recurse | ForEach { $_.FullName ? { $_.Extension } | & $Script }