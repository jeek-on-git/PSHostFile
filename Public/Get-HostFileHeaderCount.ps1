function Get-HostFileHeaderCount {
    <#
    .SYNOPSIS
    Gets the 'header' count, i.e. lines that start with a #, on a hosts file

    .DESCRIPTION
    Gets the 'header' count, i.e. lines that start with a #, on a hosts file

    .PARAMETER HostFile
    Path to the hosts file

    .EXAMPLE
    Get-HostFileHeaderCount -hostFile 'C:\Windows\System32\drivers\etc\hosts'

    .NOTES

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$HostFile
    )

    begin {
    }

    process {
        [int]$i = 0
        $content = get-content $hostFile
        foreach ($c in $content) {
            if ($c -match '^#') {
                $header = $true
                $i++
            }
            else {
                $header = $false
            }
            if ($header -eq $false){
                $i
                break
            }
        }
    }

    end {
    }
}
