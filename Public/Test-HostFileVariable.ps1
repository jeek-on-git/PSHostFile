function Test-HostFileVariable {
    <#
    .SYNOPSIS
    Test if a variable exists and returns True or False

    .DESCRIPTION
    Test if a variable exists and returns True or False

    .PARAMETER var
    The name of the variable

    .EXAMPLE
    Test-HostFileVariable HostFile

    .INPUTS
    [String]

    .OUTPUTS
    $true or $false

    .NOTES
    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

    [CmdletBinding(DefaultParameterSetName = 'HostFile')]
    param (
        [Parameter(ParameterSetName = 'HostFile')]
        [switch]$hostFile,
        [Parameter(ParameterSetName = 'HostFileObject')]
        [switch]$hostFileObject
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