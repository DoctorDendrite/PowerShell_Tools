
[CmdletBinding()]
Param
(
	[Parameter(ValueFromPipeline, Position = 0)]
	[String]
	$Path,
	
	[Parameter(Position = 1)]
	[Int64]
	$FirstIndent = 4,
	
	[Parameter(Position = 2)]
	[Alias("SecondIndent", "Second")]
	[Int64]
	$SecndIndent = 8
)

$leadingWhitespace = "^\s*"
$header  = "(?-i)$leadingWhitespace\.[A-Z]+"
$example = "(?-i)$leadingWhitespace\.EXAMPLE"
$space   = " "

$content    = (Get-Content $Path)
$newContent = @()

$i = 0

while($content[$i] -notmatch "$leadingWhitespace\<#.*$" -and $i -lt $content.Count)
{
	$newContent += $content[$i]; ++$i
}

$newContent += $content[$i]

$j = $i

while($content[$j] -notmatch "$leadingWhitespace#\>\s*$" -and $j -lt $content.Count) { ++$j }

foreach($k in ($i + 1)..($j - 1))
{
	if(![String]::IsNullOrWhitespace($content[$k]))
	{
		$newContent += $content[$k] `
			-Replace $leadingWhitespace, `
		        [String]($space * @{ $true  = $FirstIndent; `
									 $false = $SecndIndent }[$content[$k] -match $header]) 
	}
}

foreach($l in ($k + 1)..($content.Count - 1))
{
	$newContent += $content[$l]
}

Set-Content -Path $Path -Value $newContent