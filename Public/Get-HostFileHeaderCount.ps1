function Get-HostFileHeaderCount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$hostFile
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
