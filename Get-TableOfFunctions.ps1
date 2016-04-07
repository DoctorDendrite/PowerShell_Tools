
Param
(
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
	[Alias("FilePath")]
	[String]
	$Path,
	
	[Parameter(Position = 1)]
	[String]
	$StartLinesWith = "# "
)

$strings = cmd '/c' 'find "function"' $LocalFilePath

if($strings.Count -gt 0) { $strings = $strings[1..($strings.Count - 1)] }

foreach($string in $strings)
{
	$string = $StartLinesWith + $string
}

return $strings