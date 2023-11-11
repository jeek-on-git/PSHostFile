function Save-HostFile {
    <#
    .SYNOPSIS
    Updates (overwrites) the 'host' file with the values from the 'HostFileObject' variable.

    .DESCRIPTION
    Updates (overwrites) the 'host' file with the values from the 'HostFileObject' variable.

    .PARAMETER Backup
    Switch parameter. Takes a backup before saving (overwriting) the hostfile.

    .EXAMPLE
    Save-Host

    .NOTES

    #>

    [CmdletBinding()]
    param (
        [switch]$Backup
    )

    begin {
        $isAdmin = Test-IsAdmin

        # if writing to default hosts file location and not an Admin, break
        if ($hostFile -eq "$env:SystemDrive\Windows\System32\Drivers\etc\hosts" -and $isAdmin -eq $false) {
            Write-Warning "Updating the Host File requires Administrator rights"
            Break
        }

        try {
            $null = Test-HostFileVariable -HostFileObject -ErrorAction Stop
        }
        catch {
            throw $_.Exception.Message
        }
        if ($backup) {
            try {
                Backup-HostFile
            }
            catch {
                $_.Exception.Message
            }
        }
        $hostfile = Get-HostFile
        $filePath = Get-HostFilePath
    }

    process {
        try {
            $string = Convert-HostFileObjectToText $hostfile -ErrorAction Stop
            Set-Content -Path $filePath -Value $string -Encoding UTF8 -ErrorAction Stop
        }
        catch {
            $_.Exception.Message
        }
    }

    end {
    }
}
