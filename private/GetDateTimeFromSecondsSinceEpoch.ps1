Function GetDateTimeFromSecondsSinceEpoch 
{
    <#
        .SYNOPSIS
        GetDateTimeFromSecondsSinceEpoch takes the number of seconds to have passed since epoch and
        converts it into a data time.

        .PARAMETER SecondsSinceEpoch
        The number of seconds that have passed since 1970-01-01 00:00:00.

        .EXAMPLE
        GetDateTimeFromSecondsSinceEpoch -SecondsSinceEpoch 1564953630
    #>
    [OutputType('System.DateTime')]
    Param (
        # SecondsSinceEpoch
        [int]$SecondsSinceEpoch
    )
    [datetime]$DateTime = '1970-01-01 00:00:00'
    $DateTime.AddSeconds($SecondsSinceEpoch)
} # GetDateTimeFromSecondsSinceEpoch