function Set-HostFileEntry {
    <#
    .SYNOPSIS
    Updates an existing Host File Entry.

    .DESCRIPTION
    Updates an existing Host File Entry.

    .PARAMETER EntryType
    Only accepts either 'HostEntry' or 'Commented' entry.
    'HostEntry' is an IP Address and Host name entry
    'Commented' is an IP Address and Host name entry that is commented out. This prefixes the line with a "#".

    .PARAMETER IPAddress
    Updates the IP Address

    .PARAMETER Hostname
    Updates the Hostname

    .PARAMETER Comment
    Updates the Comment

    .INPUTS
    [HostFile]. The $hostFileEntry only accepts an object of the [HostFile] type.
    [String]

    .OUTPUTS
    HostFileEntry. Outputs a custom PS Object.

    .EXAMPLE
    Get-HostFile | where line -eq 35 | Set-HostFileEntry -ipAddress 192.168.1.11 -hostname Server2

    .NOTES

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [PSTypeName('HostFile')]$hostFileEntry,

        [string]$ipAddress,

        [string]$hostname,

        [string]$comment,

        [switch]$commented
    )

    begin {

        # check that the $hostFileObject exists
        try {
            $null = Test-HostFileVariable -HostFileObject -ErrorAction Stop
        }
        catch {
            throw $_.Exception.Message
        }

    }

    process {

        foreach ($entry in $hostFileEntry) {

            if ($PSBoundParameters.ContainsKey('ipAddress')) {
                $ipAddress = $ipAddress.Trim()
                $entry.ipAddress = $ipAddress
            }
            else {
                $ipAddress = $entry.ipAddress
                $entry.ipAddress = $ipAddress.Trim()
            }

            if ($commented) {
                if ($entry.ipAddress -match "^#") {
                    $entry.ipAddress = $($ipAddress -replace '#').Trim()
                }
                else {
                    $ipAddress = $($ipAddress -replace '#').Trim()
                    $entry.ipAddress = "# $ipAddress"
                }
            }

            if ($PSBoundParameters.ContainsKey('hostname')) {
                $entry.hostname = $hostname.trim()
            }
            else {
                $hostname = $entry.hostname
                $entry.hostname = $hostname.trim()
            }

            if ($PSBoundParameters.ContainsKey('comment')) {

                # remove the # and trim any whitespace from the start of the string
                $comment = $($comment -replace '#').Trim()
                $entry.comment = $comment = "# $comment"

            }
            else {

                # remove the # and trim any whitespace from the start of the string
                $comment = $($entry.comment -replace '#').Trim()
                $entry.comment = $comment = "# $comment"

            }

            try {
                $entry.EntryType = $(Get-HostFileEntryType $entry)
            }
            catch {
                $_.Exception.Message
            }

        }

    }

    end {
    }

}
