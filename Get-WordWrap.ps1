
[CmdletBinding()]
Param
(
	[Parameter(Mandatory, ValueFromPipeline, Position = 0)]
	[Alias("Content", "Text")]
	[String]
	$Value,
	
	[Parameter(Mandatory, Position = 1)]
	[Alias("Width")]
	[Int64]
	$Len
)

if($Value -eq "" -or $Len -eq 0) { return "" }

[String[]] $wordWrap = @()

[String[]] $words = $Value -Split "\s+"
[String]   $line  = ""

foreach($word in $words)
{
	if($line.Length -ge $Len)
	{
		$wordWrap += $line
		$line = ""
	}
	
	$line += $word + " "
}

if($line -ne "") { $wordWrap += $line }

return $wordWrap.TrimEnd(" ")