function Get-HostFileBackups {
    <#
    .SYNOPSIS
    Returns a list of 'host file' backups

    .DESCRIPTION
    Returns a list of 'host file' backups from default Host File folder unless a 'backupFolder' is specified.
    Results can be filtered

    .PARAMETER backupFolder
    Parameter description

    .PARAMETER filter
    By default it will filter for .bak files.
    This uses the underlying Get-ChildItem filter API which only supports * and ? wildcards.

    .EXAMPLE
    Get-HostFileBackups

    .EXAMPLE
    Get-HostFileBackups -filter *bak

    .EXAMPLE
    Get-HostFileBackups -filter *20201227-0216-03*

    .NOTES
    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

    [CmdletBinding()]
    param (
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [Alias('filePath','path')]
        [System.IO.FileInfo]$backupFolder,

        $filter = '*.bak'
    )

    begin {
        if (($PSBoundParameters.ContainsKey('backupFolder'))) {
            $folder = $backupFolder
        }
        elseif (Test-Variable HostFile) {
            $folder = Get-HostFilePath
        }
        else {
            $folder = [System.IO.FileInfo]"$env:SystemDrive\Windows\System32\Drivers\etc"
        }
    }

    process {
        $backupFiles = Get-ChildItem $folder -Filter $filter

        foreach ($file in $backupFiles) {
            $file
        }
    }

    end {
    }
}
