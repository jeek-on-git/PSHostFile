function Test-Variable {
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

    #>

    [CmdletBinding()]
    param (
        [string]$var
    )

    begin {
    }

    process {

        [bool](Get-Variable -Name $var -Scope Script)

    }

    end {
    }

}