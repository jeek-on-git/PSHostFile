function Clear-HostFileEntry {
    <#
    .SYNOPSIS
    Removes all entries from host file excluding the 'header' lines.

    .DESCRIPTION
    Removes all entries, comments as well, from host file, however, it retains the host file header comments.

    .OUTPUTS
    HostFile

    .EXAMPLE
    Clear-HostFile

    .NOTES
    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>
    [CmdletBinding()]
    param (
    )

    begin {
        try {
            $null = Test-HostFileVariable -HostFileObject -ErrorAction Stop
        }
        catch {
            throw $_.Exception.Message
        }
    }

    process {
        $entry = Get-HostFile | Where-Object lineNumber -ge 23

        if ($null -ne $entry) {

            try {
                Remove-HostFileEntry $entry
            }
            catch {
                $_.Exception.Message
            }

        }
        else {
            Write-Warning 'No Host Entries found, nothing to clear'
        }
    }

    end {
    }
}