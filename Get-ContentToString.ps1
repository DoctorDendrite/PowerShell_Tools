
Param
(
	[Parameter(Mandatory, ValueFromPipeline, Position = 0)]
	[Alias("FilePath")]
	[String]
	$Path
)

return (Get-Content $Path | Out-String) -Replace "`n", "`r`n"