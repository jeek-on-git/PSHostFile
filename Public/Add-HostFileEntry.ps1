function Add-HostFileEntry {
    <#
    .SYNOPSIS
    Adds an 'Host' entry to the HostFileObject.

    .DESCRIPTION
    Adds an 'Host' entry to the HostFileObject.

    .PARAMETER HostFileEntry
    This is a custom 'HostFileEntry' object created using the New-HostFileEntry command.

    .INPUTS
    HostFileEntry. This is a custom PS Object created using the New-HostFileEntry command.

    .EXAMPLE
    $entry =  New-HostFileEntry -entryType HostEntry -ipAddress '192.168.10.2' -hostname 'server2'
    Add-HostFileEntry $entry

    .NOTES

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [PSTypeName('HostFile')]$HostFileEntry
    )

    begin {
        try {
            $null = Test-HostFileVariable -HostFileObject -ErrorAction Stop
        }
        catch {
            throw $_.Exception.Message
        }
        $object = Get-HostFile
    }

    process {
        if ($script:hostFileObject -NotContains $hostFileEntry) {
            $script:hostFileObject.Add($hostFileEntry)
            Return $true
        }
        else {
            Write-Warning "[HostFileObject] already contains [HostFileEntry]"
        }
    }

    end {
        Update-HostFileObject
    }
}