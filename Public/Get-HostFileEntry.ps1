function Get-HostFileEntry {
    <#
    .SYNOPSIS
    The will return the a host file entry based on supplied parameter.

    .DESCRIPTION
    The will return the a host file entry based on supplied parameter.

    .PARAMETER line
    Host file line number to return

    .PARAMETER hostname
    Host file hostname entry to return

    .PARAMETER ipAddress
    Host file IPAddress entry to return

    .EXAMPLE
    Return line 23 of the host file.
    Get-HostFileEntry -line 23

    .EXAMPLE
    Return host file entry that equals the specified 'hostname' value.
    Get-HostFileEntry 'Server1'

    .EXAMPLE
    Return host file entry that equals the specified 'IPAddress' value.
    This example uses the commands alias.
    gfe '192.168.1.1'

    .EXAMPLE
    Return line 23 of the host file.
    $entry = Get-HostFileEntry -line 23

    # the result can then be used to Update, Add, or Remove Host File entries.
    # Update the returned entry with a new IP Address
    Set-HostFileEntry -hostFileEntry $entry -ipAddress 192.168.100.101

    # Remove the returned entry from the host file
    Remove-HostFileEntry $entry

    # Add the entry back
    $entry | Add-HostFileEntry

    .NOTES
    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

    [CmdletBinding(DefaultParameterSetName = 'lineNumber')]
    [Alias('gfe')]
    param (
        #[HostFile]$hostFileObject,

        [Parameter(Mandatory, Position = 0, ParameterSetName = 'lineNumber')]
        [int]$lineNumber,

        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Hostname')]
        [string]$hostname,

        [Parameter(Mandatory, Position = 0, ParameterSetName = 'IPAddress')]
        [ipaddress]$ipAddress
    )

    begin {
        try {
            $null = [bool](Get-Variable 'HostFileObject' -ErrorAction Stop)
        }
        catch {
            throw $_.Exception.Message
        }
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'lineNumber'){ $filter ={$_.lineNumber -eq $lineNumber }}
        if ($PSCmdlet.ParameterSetName -eq 'ipAddress') { $filter ={$_.IPAddress  -eq $ipAddress  }}
        if ($PSCmdlet.ParameterSetName -eq 'hostname')  { $filter ={$_.Hostname   -eq $hostname   }}

        try {
            Get-HostFile | Where-Object $filter
        }
        catch {
            $_.Exception.Message
        }
    }

    end {
    }

}