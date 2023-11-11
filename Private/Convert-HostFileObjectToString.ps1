function Convert-HostFileObjectToString {
    <#
    .SYNOPSIS
    Converts a 'HostFile' object to into a string.

    .DESCRIPTION
    Converts a 'HostFile' object to into a string.

    .PARAMETER HostFileObject
    HostFile

    .PARAMETER padding
    The amount of padding between fields

    .EXAMPLE
    Convert-HostFileObjectToString

    .EXAMPLE
    Convert-HostFileObjectToString | Update-HostFile

    .NOTES

    #>

    [CmdletBinding()]
    [OutputType("String")]
    param (
        # Accepts HostFileObject
        [Parameter(ValueFromPipeline)]
        [PSTypeName('HostFile')]$object,

        [Int]$padding = 24
    )

    begin {
    }

    process {
        $object | ForEach-Object {
            if ($_.EntryType -eq 'Header') {
                $_.comment
            }
            elseif ($_.EntryType -eq 'HostEntry') {
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
