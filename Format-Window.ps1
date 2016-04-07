
[CmdletBinding(DefaultParameterSetName="SingleColumn")]
Param
(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	[Alias("Content")]
    [String]
    $Value,
    
    [Parameter(Mandatory=$true)]
    [UInt64]
    $Width,
    
    [UInt64]
    $MarginWidth = 2,
    
    [Char]
    $BorderCharacter = '*',
	
	[Char]
	$MarginCharacter = ' ',
    
    [Parameter(ParameterSetName="SplitColumn", Mandatory=$true)]
    [Switch]
    $SplitColumn,
    
    [Parameter(ParameterSetName="SplitColumn", Mandatory=$true)]
    [Int64]
    $FirstColumnWidth,
    
    [Parameter(ParameterSetName="SplitColumn")]
    [String]
    $Divider = " : ",
    
    [Parameter(Position=0)]
	[ValidateSet("Left", "Right")]
    [String]
    $AlignFirst = "Left",
    
    [Parameter(ParameterSetName="SplitColumn", Position=1)]
	[ValidateSet("Left", "Right")]
    [String]
    $AlignSecnd = "Left",
	
	[ValidateSet("Array", "String")]
	$ReturnAs = "String"
)

# Try
# {
# 	  $lines = $Value.Split("`n") | ForEach-Object { $_.Replace("`r", "") }
# 
# 	  if($lines[-1] -eq "") { $lines = $lines[0..($lines.Length - 2)] }
# 
#     $border = [String]$BorderCharacter * $Width
# 
#     $margin = [String]$MarginCharacter * $MarginWidth
# 
#     [String[]] $window = @($border)
# 
#     if($SplitColumn)
#     {
#         $secndColumnWidth  = $Width - 2 * ($MarginWidth + 1) - $FirstColumnWidth - $Divider.Length
#         
#         $FirstColumnWidth *= @{$true=-1; $false=1}[($AlignFirst.ToLower())[0] -eq 'l']
#         $secndColumnWidth *= @{$true=-1; $false=1}[($AlignSecnd.ToLower())[0] -eq 'l']
#         
#         $i = 0
#         
#         while($i -lt $lines.Length)
#         {
#             $window += ($BorderCharacter + $margin + `
#                         "{0, $FirstColumnWidth}$Divider{1, $secndColumnWidth}" -f $lines[$i++], $lines[$i++] + `
#                         $margin + $BorderCharacter)
#         }
#     }
#     else
#     {
#         $innerWidth  = $Width - 2 * ($MarginWidth + 1)
#         
#         $innerWidth *= @{$true=-1; $false=1}[($AlignFirst.ToLower())[0] -eq 'l']
# 		
#         foreach($line in $lines)
#         {
#             $window += ($BorderCharacter + $margin + `
#                         "{0, $innerWidth}" -f $line + `
#                         $margin + $BorderCharacter)
#         }
#     }
# 
#     return $window + $border
# }
# Catch [System.Exception]
# {
#     Throw
# }

Try
{
	$lines = $Value.Split("`n") | ForEach-Object { $_.Replace("`r", "") }
	
	if($lines[-1] -eq "") { $lines = $lines[0..($lines.Length - 2)] }

    $border = [String]$BorderCharacter * $Width

    $margin = [String]$MarginCharacter * $MarginWidth

    switch($ReturnAs)
	{
		"Array"
		{
			[String[]] $window = @($border)
		}
		"String"
		{
			[String]   $window = $border + "`r`n"
		}
	}

    if($SplitColumn)
    {
        $secndColumnWidth  = $Width - 2 * ($MarginWidth + 1) - $FirstColumnWidth - $Divider.Length
        
        $FirstColumnWidth *= @{$true=-1; $false=1}[($AlignFirst.ToLower())[0] -eq 'l']
        $secndColumnWidth *= @{$true=-1; $false=1}[($AlignSecnd.ToLower())[0] -eq 'l']
        
        $i = 0
        
        while($i -lt $lines.Length)
        {
            $window += ($BorderCharacter + $margin + `
                        "{0, $FirstColumnWidth}$Divider{1, $secndColumnWidth}" -f $lines[$i++], $lines[$i++] + `
                        $margin + $BorderCharacter + `
						@{$true="`r`n"; $false=""}[$ReturnAs -eq "String"])
        }
    }
    else
    {
        $innerWidth  = $Width - 2 * ($MarginWidth + 1)
        
        $innerWidth *= @{$true=-1; $false=1}[($AlignFirst.ToLower())[0] -eq 'l']
		
        foreach($line in $lines)
        {
            $window += ($BorderCharacter + $margin + `
                        "{0, $innerWidth}" -f $line + `
                        $margin + $BorderCharacter + `
						@{$true="`r`n"; $false=""}[$ReturnAs -eq "String"])
        }
    }

    return $window + ($border + @{$true="`r`n"; $false=""}[$ReturnAs -eq "String"])
}
Catch [System.Exception]
{
    Throw
}