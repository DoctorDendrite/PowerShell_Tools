
[CmdletBinding()]
Param
(
	[Parameter( ParameterSetName  = 'ByValue',
	            ValueFromPipeline = $true,
				Position          = 0 )]
	[String]
	$Value
)

$ErrorActionPreference = "Stop"

Try
{
	return @($Value -Split "`n")
}
Catch [System.Exception]
{
	Throw $_
}