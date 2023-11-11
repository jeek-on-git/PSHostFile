function New-HostFilePath {
    <#
    .SYNOPSIS
    Specifies path to a Hosts file.

    .DESCRIPTION
    Specifies path to a Hosts file.

    .PARAMETER hostFilePath
    Path to the Hosts file

    .EXAMPLE
    New-HostFilePath C:\Temp\Hosts

    .NOTES

    #>
    [CmdletBinding()]
    param (
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf})]
        [string]$hostFilePath,

        [switch]$passThru
    )

    begin {
    }

    process {
        if ($PSBoundParameters.ContainsKey('hostFilePath')) {
            $script:hostFile = $hostFilePath
            Write-Verbose "[HostFile] $script:hostFile"
        }
        else {
            # path to Windows host file
            $script:hostFile = "$env:SystemDrive\Windows\System32\Drivers\etc\hosts"
            Write-Verbose "[HostFile] $script:hostFile"
        }
    }

    end {
        if ($passThru) {
            $script:hostFile
        }
    }
}