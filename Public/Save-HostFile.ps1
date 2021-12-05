function Save-HostFile {
    <#
    .SYNOPSIS
    Updates (overwrites) the 'host' file with the values from the 'HostFileObject' variable.

    .DESCRIPTION
    Updates (overwrites) the 'host' file with the values from the 'HostFileObject' variable.

    .PARAMETER value


    .EXAMPLE
    An example

    .NOTES
    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        $content,

        [switch]$backup
    )

    begin {
        $isAdmin = Test-IsAdmin

        # if writing to default hosts file location and not an Admin, break
        if ($hostFile -eq "$env:SystemDrive\Windows\System32\Drivers\etc\hosts" -and $isAdmin -eq $false) {
            Write-Warning "Updating the Host File requires Administrator rights"
            Break
        }

        try {
            $null = Test-HostFileVariable HostFile -ErrorAction Stop
        }
        catch {
            throw $_.Exception.Message
        }

        $firstWrite = $false

        if ($backup) {
            try {
                Backup-HostFile
            }
            catch {
                $_.Exception.Message
            }
        }
    }

    process {
        foreach ($line in $content) {
            if ($firstWrite -eq $false) {
                Set-Content -Path $script:hostFile -Value $line -Encoding UTF8
                $firstWrite = $true
            }
            else {
                Add-Content -Path $script:hostFile -Value $line -Encoding UTF8
            }
        }
    }

    end {
    }
}
