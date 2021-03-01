function Clear-HostFileObject {
    <#
    .SYNOPSIS
    Clears (removes) the HostFileObject variable created by the New-HostFileObject function.

    .DESCRIPTION
    Clears (removes) the HostFileObject variable created by the New-HostFileObject function.

    .EXAMPLE
    Clear-HostFileObject

    .NOTES

    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

    [CmdletBinding()]
    [Alias('cho')]
    param (
    )

    begin {
    }

    process {

        if (Test-HostFileVariable -HostFileObject) {

            Write-Verbose "[HostFileObject] exists, removing"

            try {
                Remove-Variable -Name HostFileObject -Scope Script
            }
            catch {
                $_.Exception.Message
            }

        }
    }

    end {
    }

}
