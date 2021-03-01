function Set-HostFileEntry {
    <#
    .SYNOPSIS
    Updates an existing Host File Entry.

    .DESCRIPTION
    Updates an existing Host File Entry.

    .PARAMETER entryType
    Only accepts either 'HostEntry' or 'Commented' entry.
    'HostEntry' is an IP Address and Host name entry
    'Commented' is an IP Address and Host name entry that is commented out. This prefixes the line with a "#".

    .PARAMETER ipAddress
    Updates the IP Address

    .PARAMETER hostname
    Updates the Hostname

    .PARAMETER comment
    Updates the Comment

    .INPUTS
    [HostFile]. The $hostFileEntry only accepts an object of the [HostFile] type.
    [String]

    .OUTPUTS
    HostFileEntry. Outputs a custom PS Object.

    .EXAMPLE
    Get-HostFile | where line -eq 35 | Update-HostFileEntry -ipAddress 192.168.1.11 -hostname Server2

    .NOTES

    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

    [CmdletBinding()]
    param (

        [Parameter(Mandatory,ValueFromPipeline)]
        [PSTypeName('HostFile')]$hostFileEntry,

        #[Parameter(Mandatory)]
        [string]$ipAddress,

        #[Parameter(Mandatory)]
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
                $entry.ipAddress = $ipAddress
            }
            else {
                $entry.ipAddress = $entry.ipAddress
            }

            if ($commented) {
                if ($entry.ipAddress -match "^#") {
                    $entry.ipAddress = $ipAddress -replace("#","# ")
                }
                else {
                    $entry.ipAddress = "# $($entry.ipAddress)"
                }
            }

            if ($PSBoundParameters.ContainsKey('hostname')) {
                $entry.hostname = $hostname
            }
            else {
                $entry.hostname = $entry.hostname
            }

            if ($PSBoundParameters.ContainsKey('comment')) {
                $entry.comment = $comment
            }
            else {
                $entry.comment = $entry.comment
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
