Function GetReportFromFile
{
    <#
        .SYNOPSIS
        Returns a DMARC aggregate report as [System.Xml.XmlDocument].

        .PARAMETER Path
        A DMARC report or a directory contaning one or more DMARC report xml files.

        .PARAMETER Recurse
        If the path parameter is a direcotry the recurse parameter will include
        subdirectories in directory when looking for DMARC aggregate reports.  The
        default behavior when path is a directory is to exclude subdirectories.

        .EXAMPLE
        GetReport -Path C:\DmarcReports\Report.xml
        Returns the DMARC aggregate report in xml.

        .EXAMPLE
        GetReport -Path C:\DmarcReports
        Returns all of the DMARC aggregate reports in path.  Subdirectorys in path will be excluded.

        .EXAMPLE
        GetReport -Path C:\DmarcReports -Recurse
        Returns all of the DAMRC aggregate reports in path and in any subdirectories of path.
    #>
    [CmdletBinding()]
    [OutputType('System.Xml.XmlDocument')]
    Param (
        # Path
        [Parameter(Mandatory = $True, HelpMessage = 'Please enter the path to a DMARC aggregate report.')]
        [ValidateScript({
            if (-not ($_ | Test-Path)) { throw " $_ does not exist or is not a valid path." }
            if ( ($_ | Test-Path -PathType Leaf) -and ($_.Name -notlike '*.xml') ) { throw "Reports should be xml files" }
            return $True
        })]
        [System.IO.FileInfo]$Path,

        # Recurse
        [Switch]$Recurse
    )
    if (Test-Path -Path $Path -PathType Leaf) {
        [xml](Get-Content $Path)

    } else {
        $GetChildItemParams = @{
            Path = $Path
            File = $True
            Filter = '*.xml'
        }
        if ($PSBoundParameters['Recurse']) {
            $GetChildItemParams.add('Recurse', $True)
        }
        $reports = Get-ChildItem @GetChildItemParams
        foreach ($report in $reports) {
            [xml]($report | Get-Content)
        }
    }
} # GetReportFromFile