function Remove-HostFileEntry {
    <#
    .SYNOPSIS
    Removes a Hosts file entry from the $hostFileObject

    .DESCRIPTION
    Removes a Hosts file entry from the $hostFileObject

    .PARAMETER hostFileEntry
    The Hosts file entry to be removed

    .EXAMPLE
    Returns lin number 26 from the $HostFileObject and then pipes it to the Remove-HostFileEntry which removes the hosts file entry
    Get-HostFileEntry -LineNumber 26 | Remove-HostFileEntry

    .EXAMPLE
    41..46 | foreach {Get-HostFile | where line -eq $_ } | Remove-HostFileEntry

    .NOTES

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [PSTypeName('HostFile')]$hostFileEntry
    )

    begin {
        try {
            $null = Test-HostFileVariable -HostFile -ErrorAction Stop
        }
        catch {
            throw $_.Exception.Message
        }
    }

    process {
        foreach ($entry in $hostFileEntry) {
            if ($script:hostFileObject -contains $entry) {
                $script:hostFileObject.remove($entry)
            }
            else {
                Write-Warning "[HostFileObject] doesn't contain [HostFileEntry]"
            }
        }
    }

    end {
        Update-HostFileObject
    }
}