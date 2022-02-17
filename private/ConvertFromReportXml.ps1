Function ConvertFromReportXml
{
    <#
        .SYNOPSIS
        Creates a PSCustomObject representing a DMARC aggregate report.

        .PARAMETER Report
        An xml dmarc aggregate report.

        .EXAMPLE
        GetReportFromFile -Path C:\DmarcReports | ConvertFromReportXml
    #>
    [CmdletBinding()]
    [OutputType('Dmarc.Report.DmarcAggregateReport')]
    Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $true)]
        [System.Xml.XmlDocument[]]$Report
    )
    PROCESS {
        foreach($xmlReport in $Report) {
            foreach ($record in ($xmlReport.feedback.record)) {
                $spfResultObject = foreach ($spfResult in ($record.auth_results.spf)) {
                    [PSCustomObject]@{
                        Domain = $spfResult.Domain
                        Result = $spfResult.Result
                    }
                }
                $AuthResults = [PSCustomObject]@{
                    DKIM = [PSCustomObject]@{
                        Domain = $record.auth_results.dkim.domain
                        Result = $record.auth_results.dkim.result
                    }
                    SPF = $spfResultObject
                }

                [PSCustomObject]@{
                    PSTypeName = 'Dmarc.Report.DmarcAggregateReport'
                    ReportMetadata = @{ 
                        ReportingOrgName = $xmlReport.feedback.report_metadata.org_name 
                        ReportingOrgContactInfo = $xmlReport.feedback.report_metadata.extra_contact_info
                        ReportID = $xmlReport.feedback.report_metadata.report_id
                        DateBeing = GetDateTimeFromSecondsSinceEpoch -SecondsSinceEpoch $xmlReport.feedback.report_metadata.date_range.begin 
                        DateEnd = GetDateTimeFromSecondsSinceEpoch -SecondsSinceEpoch $xmlReport.feedback.report_metadata.date_range.end
                    }
                    PolicyPublished = @{
                        PolicyDomain = $xmlReport.feedback.policy_published.domain
                        AlignmentModeDkim = $( if ($xmlReport.feedback.policy_published.adkim -eq 'r') {'relaxed'} else {'strict'} )
                        AlignmentModeSpf = $( if ($xmlReport.feedback.policy_published.aspf -eq 'r') {'relaxed'} else {'strict'} )
                        DomainPolicy = $xmlReport.feedback.policy_published.p
                        SubDomainPolicy = $xmlReport.feedback.policy_published.sp
                        PctSubjectedToFiltering = $xmlReport.feedback.policy_published.pct
                    }
                    SourceIp = $record.row.source_ip
                    Count = $record.row.count
                    Disposition = $record.row.policy_evaluated.disposition
                    DkimAlignmentResult = $record.row.policy_evaluated.dkim
                    SpfAlignmentResult = $record.row.policy_evaluated.spf
                    HeaderFrom = $record.identifiers.header_from
                    EnvelopeFrom = $record.identifiers.envelope_from

                    AuthResults = $AuthResults # Collection of auth_results objects
                }
            }
        }
    }
} # ConvertFromReportXml