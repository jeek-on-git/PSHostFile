function Restore-HostFile {
    <#
    .SYNOPSIS
    Restore a Hosts file from backup.

    .DESCRIPTION
    Restore a Hosts file from the specified backup.

    .PARAMETER BackupFile
    The path to the backup file

    .EXAMPLE
    Replaces the hosts file specified in the $hostFile variable with the specified "backup file"
    Restore-HostFile 'C:\Windows\System32\Drivers\Etc\Hosts-01012021.bak'

    .NOTES

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [System.IO.FileInfo]$BackupFile
    )

    begin {
        # Unfinshed.
        Break

        if (!(Test-HostFileVariable -HostFile)) {
            $script:hostFile = "$env:SystemDrive\Windows\System32\Drivers\etc\hosts"
        }

        $targetFolder = [System.IO.FileInfo]"$env:SystemDrive\Windows\System32\Drivers\etc"

        Backup-HostFile

    }

    process {

        <#
        Backup existing file
        Rename existing host file
        Rename backup file
        #>
        #
        $hostFileName = $backupFile.basename.Substring(0,5)
        $hostFileName
        Join-Path $targetFolder $hostFileName

    }

    end {
    }

}