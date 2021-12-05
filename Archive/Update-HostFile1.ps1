function Update-HostFile1 {
    [CmdletBinding()]
    param (
        [Int]$padding = 24
    )

    begin {
        try {
            $null = Get-Variable 'HostFileObject' -ErrorAction Stop
        }
        catch {
            $_.Exception.Message
        }
        try {
            $null = Get-Variable 'HostFile' -ErrorAction Stop
        }
        catch {
            $_.Exception.Message
        }
    }

    process {

        $hostfileObject | Where-Object EntryType -eq header | ForEach-Object {
            $value = $_.comment
            $value
            # Add-Content -Path $hostsFile -Encoding UTF8 -Value $value
        }

        $hostfileObject | Where-Object EntryType -eq HostEntry | ForEach-Object {
            # "{0} {1} {2}" -f $_.IPAddress, $_.Hostname, $_.Comment
            $value = $_.ipAddress.PadRight($padding, ' ') + $_.hostname.PadRight($padding, ' ') + $_.comment
            $value
            # Add-Content -Path $hostsFile -Encoding UTF8 -Value $value
        }

        $hostfileObject | Where-Object EntryType -eq Commented | ForEach-Object {
            $value = $_.ipAddress.PadRight($padding, ' ') + $_.hostname.PadRight($padding, ' ') + $_.comment
            $value
            # Add-Content -Path $hostsFile -Encoding UTF8 -Value $value
        }

    }

    end {
    }

}
