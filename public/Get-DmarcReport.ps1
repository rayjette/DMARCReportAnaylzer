Function Get-DmarcReport
{
    <#
        .SYNOPSIS
        Outputs a pscustom object representing a DMARC report.

        .DESCRIPTION
        Outputs a pscustom object representing a DMARC report.

        .PARAMETER Path
        Can be directory name or filename.  

        .PARAMETER Recurse
        If the path parameter is a directory any subdirectory found will be searched for reports.
        Without the recurse parameter subdirectories will be ignored.

        .EXAMPLE
        Get-DmarcReport -Path C:\DmarcAggrageteReports\Report.xml

        .EXAMPLE
        Get-DmarcReport -Path C:\DmarcAggregateReport -Recurse
    #>
    [CmdletBinding()]
    Param (
        # Path
        [Parameter(Mandatory = $True, HelpMessage = 'Please enter a path to a DMARC aggregate report.')]
        [ValidateScript({
            if (-not ($_ | Test-Path)) { throw " $_ does not exist or is not a valid path." }
            if ( ($_ | Test-Path -PathType Leaf) -and ($_.Name -notlike '*.xml') ) { throw "Reports should be xml files" }
            return $True
        })]
        [System.IO.FileInfo]$Path,

        [Switch]$Recurse
    )
    $GetReportParams = @{Path = $Path}
    if ($PSBoundParameters['Recurse']) {
        $GetReportParams.Add('Recurse', $True)
    }

    GetReportFromFile @GetReportParams | ConvertFromReportXml
} # Get-DmarcReport