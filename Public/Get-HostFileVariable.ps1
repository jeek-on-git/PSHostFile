function Get-HostFileVariable {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER var
    Parameter description

    .EXAMPLE
    An example

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

    if ($hostFile) {
        Get-Variable -Name HostFile -scope script -ErrorAction SilentlyContinue
    }
    If ($hostFileObject) {
        Get-Variable -Name HostFileObject -scope script -ErrorAction SilentlyContinue
    }

}
