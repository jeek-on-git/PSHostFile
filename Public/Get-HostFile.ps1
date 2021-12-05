function Get-HostFile {
    <#
    .SYNOPSIS
    Returns the Windows HostFileObject from memory.

    .DESCRIPTION
    Returns the Windows HostFileObject from memory, however, if the $hostFileObject doesn't exist it will create one.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    HostFile

    .EXAMPLE
    Get-HostFile

    .EXAMPLE
    # alias
    ghf

    .NOTES
    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

    [CmdletBinding()]
    [Alias('ghf','Get-HostFileObject')]
    param (
    )

    begin {
        if (!(Test-HostFileVariable -HostFile)) {
            try {
                New-HostFilePath
            }
            catch {
                throw $_.Exception.Message
            }
        }
    }

    process {
        If (Test-HostFileVariable -HostFileObject) {
            $script:hostFileObject
        }
        else {
            New-HostFileObject -passThru
        }
    }

    end {
    }
}