function Convert-HostFileObjectToString2 {
    <#
    .SYNOPSIS
    Converts each line of a 'HostFile' object to a string.

    .DESCRIPTION
    Converts each line of a 'HostFile' object to a string.

    .PARAMETER HostFileObject
    Not used

    .PARAMETER padding
    The amount of padding between fields

    .EXAMPLE
    Convert-HostFileObjectToString

    .EXAMPLE
    Convert-HostFileObjectToString | Update-HostFile
    .NOTES

    #>

    [CmdletBinding()]
    param (

        # Accepts HostFileObject
        [Parameter(ValueFromPipeline)]
        [PSTypeName('HostFile')]$entry,
        #[String]$entry,

        [Int]$padding = 24

    )

    begin {

    }

    process {

        $entry | ForEach-Object {

            if ($_.EntryType -eq 'entry') {
                $_.comment
            }
            if ($_.EntryType -eq 'HostEntry') {
                $_.ipAddress.PadRight($padding, ' ') + $_.hostname.PadRight($padding, ' ') + $_.comment
            }
            elseif ($_.EntryType -eq 'Commented') {
                $_.ipAddress.PadRight($padding, ' ') + $_.hostname.PadRight($padding, ' ') + $_.comment
            }
            elseif ($_.EntryType -eq 'Comment') {
                $_.comment
            }
            elseif ($_.EntryType -eq 'Blank') {
                ""
            }

        }

    }

    end {
    }

}
