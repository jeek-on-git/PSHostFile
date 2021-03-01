function Backup-HostFile {
    <#
    .SYNOPSIS
    Backs up (Copies) the Host File.

    .DESCRIPTION
    Backs up (Copies) the Host File. By default this will be the same folder as the hostfile.
    However, it can be redirected to an alternate 'backupFolder'.
    The file name is modifed when copied; The current date and time is appended to the file name and the .bak file extension is added.

    .PARAMETER backupFolder
    The folder location where the file is copied to.

    .PARAMETER passThru
    Switch parameter to output the result from the copy-item command.

    .OUTPUTS
    True or System.IO.FileInfo. When the passThru switch is used it generates a System.IO.FilInfo object that represents the file.

    .EXAMPLE
    Creates a copy of the host in the default host file directory, $env:SystemDrive\Windows\System32\Drivers\etc\hosts
    Backup-HostFile

    .EXAMPLE
    Creates a copy of the 'hosts' file to the C:\Temp folder.
    Backup-HostFile -backupFolder C:\Temp -passThru

    .NOTES
    Use the Get-HostFileBackups command to return list of backup files.

    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>
    [CmdletBinding()]
    param (

        [ValidateScript({ Test-Path -Path $_})]
        [Alias('filePath','path')]
        [System.IO.FileInfo]$backupFolder,

        [switch]$passThru

    )

    begin {

        try {
            $null = Test-HostFileVariable -HostFile -ErrorAction Stop
        }
        catch {
            throw $_.Exception.Message
        }

        [System.Io.FileInfo]$path = Get-HostFilePath

        $hostFileName = $path.BaseName

        try {
            $newHostFileName = New-FileName -Name $hostFileName -fileExt '.bak' -addDate
        }
        catch {
            Throw $_.Exception.
            Break
        }

        if ($PSBoundParameters.ContainsKey('backupFolder')) {
            $hostFileDir = $backupFolder.Directory.FullName
        }
        else {
            [System.IO.FileInfo]$backupFolder = Get-HostFilePath
            $hostFileDir = $backupFolder.Directory.FullName
        }

        Write-Verbose $hostFileDir
        Write-Verbose $newHostFileName

        $hostFilePath = Join-Path $hostFileDir $newHostFileName

    }

    process {

        $copyParams = @{
            Path        = $(Get-HostFilePath)
            Destination = $hostFilePath
            ErrorAction = 'Stop'
        }

        if ($passThru) {
            $copyParams.Add('PassThru',$true)
        }

        try {
            #Copy-Item -Path $hostFile -Destination $hostFileBackup -ErrorAction Stop
            Copy-Item @copyParams
        }
        catch {
            $_.Exception
        }

    }

    end {
        if (!($passThru)) {
            Test-Path $hostFilePath
        }
    }

}