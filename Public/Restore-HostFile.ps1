function Restore-HostFile {
    <#
    .SYNOPSIS
    Restore a Hosts file from backup

    .DESCRIPTION
    Restore a Hosts file from the specified backup.

    .PARAMETER backupFile
    The path to the backup file

    .EXAMPLE
    Replaces the hosts file specified in the $hostFile variable with the specified "backup file"
    Restore-HostFile 'C:\Windows\System32\Drivers\Etc\Hosts-01012021.bak'

    .NOTES

    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

    [CmdletBinding()]
    param (

        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [System.IO.FileInfo]$backupFile
    )

    begin {

        if (!(Test-Variable hostFile)) {
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