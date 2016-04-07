
[CmdletBinding()]
Param
(
	[Parameter( ParameterSetName  = 'ByValue',
	            ValueFromPipeline = $false,
				Position          = 0 )]
	[Alias("Value")]
	[String[]]
	$Array,
	
	[Parameter( ParameterSetName  = 'ByReference',
	            ValueFromPipeline = $true,
				Position          = 0 )]
	[Alias("Reference")]
	[Ref][String[]]
	$ArrayRef
)

$ErrorActionPreference = "Stop"

Try
{
	switch($PSCmdlet.ParameterSetName)
	{
		'ByValue'
		{
			$Value = $Array
			break
		}
		'ByReference'
		{
			Set-Variable -Name Value -Value $ArrayRef.Value -Option Constant
			break
		}
	}

	[String] $str = ""

	foreach($e in $Value) { $str += $e + "`r`n" }

	return $str
}
Catch [System.Exception]
{
	Throw $_
}