function Get-HostFilePath {
    <#
    .SYNOPSIS
    Returns the path to the host file from the $script:hostFile variable

    .DESCRIPTION
    Returns the path to the host file from the $script:hostFile variable

    .EXAMPLE
    Get-HostFilePath

    .NOTES

    #>
    [CmdletBinding()]
    param (
    )

    begin {
    }

    process {
        try {
            Get-Variable -Name HostFile -Scope Script -ErrorAction Stop | Select-Object -ExpandProperty Value
        }
        catch {
            $_.Exception.Message
        }
    }

    end {
    }
}
