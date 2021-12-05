function Clear-XXHostFileObjectXX {
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
    param (
    )

    begin {
    }

    process {
        if ([bool](Get-Variable HostFileObject  -scope script -ErrorAction SilentlyContinue)) {

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