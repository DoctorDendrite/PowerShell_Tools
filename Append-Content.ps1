
[CmdletBinding()]
Param
(
    [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
	[Alias("FilePath")]
    [String]
    $Path,
    
    [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
	[Alias("Content, NewContent")]
    [String]
    $Value,
    
    [Switch]
	[Alias("Prepend")]
    $Front,
    
    [Switch]
	[Alias("Append", "Add")]
    $Back
)

$ErrorActionPreference = "Stop"

Try
{
    if(!$Front -and !$Back)
    {
        Throw "'Front' and/or 'Back' must be selected."
    }
    
    $content = Get-Content -Path $Path | Out-String
    
    if($Front)
    {
		$content = $Value + $content
    }
	
	if($Back)
    {
        $content = $content + $Value
    }
	
	$content | Out-File $Path
}
Catch [System.Exception]
{
    Throw $_
}