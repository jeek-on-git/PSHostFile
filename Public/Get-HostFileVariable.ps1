function Get-HostFileVariable {
    <#
    .SYNOPSIS
    Returns either the HostFile or HostFileObject variable

    .DESCRIPTION
    Returns either the HostFile or HostFileObject variable

    .EXAMPLE
    Get-HostFileVariable -hostFile

    .EXAMPLE
    Get-HostFileVariable -hostFileObject

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
