function Test-HostFileVariable {
    <#
    .SYNOPSIS
    Test if a variable exists and returns True or False

    .DESCRIPTION
    Test if a variable exists and returns True or False.
    Mainly used for troubleshooting and the modules internals.

    .PARAMETER HostFile
    Swtich parameter to select the HostFile

    .PARAMETER HostFileObject
    Swtich parameter to select the HostFileObject

    .EXAMPLE
    Test-HostFileVariable -HostFile

    .EXAMPLE
    Test-HostFileVariable -HostFileObject

    .INPUTS
    [String]

    .OUTPUTS
    $true or $false

    .NOTES

    #>

    [CmdletBinding(DefaultParameterSetName = 'HostFile')]
    param (
        [Parameter(ParameterSetName = 'HostFile')]
        [switch]$HostFile,
        [Parameter(ParameterSetName = 'HostFileObject')]
        [switch]$HostFileObject
    )

    begin {
    }

    process {
        if ($hostFile) {
            [bool](Get-Variable -Name 'HostFile' -Scope Script -ErrorAction SilentlyContinue)
        }
        if ($hostFileObject) {
            [bool](Get-Variable -Name 'HostFileObject' -Scope Script -ErrorAction SilentlyContinue)
        }
    }

    end {
    }
}