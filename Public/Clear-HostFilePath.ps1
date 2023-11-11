function Clear-HostFilePath {
    <#
    .SYNOPSIS
    Clears (removes) the two Host File variables created by the New-HostFileObject function.

    .DESCRIPTION
    Clears (removes) the two Host File variables created by the New-HostFileObject function.
    This is a quick way to reset the variables.

    .OUTPUTS
    None.

    .EXAMPLE
    Clear-HostFileVariables

    .NOTES

    #>

    [CmdletBinding()]
    [Alias('chp')]
    param (
    )

    begin {
    }

    process {
        if ([bool](Get-Variable HostFile -Scope Script -ErrorAction SilentlyContinue)) {
            try {
                Remove-Variable -Name 'HostFile' -Scope script
            }
            catch {
                $_.Exception.Message
            }
        }
    }

    end {
    }
}