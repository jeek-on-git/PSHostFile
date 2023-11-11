function Get-HostFileVariable {
    <#
    .SYNOPSIS
    Returns either the HostFile or HostFileObject variable

    .DESCRIPTION
    Returns either the HostFile or HostFileObject variable

    .PARAMETER HostFile
    Switch parameter to select the HostFile variable.

    .PARAMETER HostFileObject
    Switch parameter to select the HostFileObject variable.

    .EXAMPLE
    Get-HostFileVariable -hostFile

    .EXAMPLE
    Get-HostFileVariable -hostFileObject

    .NOTES

    #>

    [CmdletBinding(DefaultParameterSetName = 'HostFile')]
    param (
        [Parameter(ParameterSetName = 'HostFile')]
        [switch]$HostFile,

        [Parameter(ParameterSetName = 'HostFileObject')]
        [switch]$HostFileObject
    )

    if ($hostFile) {
        Get-Variable -Name HostFile -scope script -ErrorAction SilentlyContinue
    }
    If ($hostFileObject) {
        Get-Variable -Name HostFileObject -scope script -ErrorAction SilentlyContinue
    }

}
