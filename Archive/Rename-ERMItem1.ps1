function Backup-Item {
    <#
    .SYNOPSIS
    Renames a specified file

    .DESCRIPTION
    Renames a specified file

    .PARAMETER fileName
    Parameter description

    .PARAMETER newName
    Parameter description

    .PARAMETER separator
    Parameter description

    .PARAMETER addDate
    Parameter description

    .PARAMETER passThru
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes

    #>
    [CmdletBinding(DefaultParameterSetName = 'Pipeline')]
    param (
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        #[ValidateScript({ Test-Path -Path $_ -PathType Leaf})]
        [ValidateScript({ Test-Path -Path $_ })]
        [Alias('FullName')]
        [System.IO.FileInfo]$fileName,

        [ValidateSet('_','-')]
        [string]$separator = '-',

        [switch]$passThru

    )

    begin {
        $date = Get-Date -f yyyyMMdd-hhmm-ss
    }

    process {

        foreach ($file in $fileName) {



            if ($PSBoundParameters.ContainsKey('newExtension')) {
                if ($newExtension -notmatch '^\.') {
                    $newExtension = ".$newExtension"
                }
                $extension = $newExtension
            }
            else {
                $extension = $file.Extension
            }

            if ($PSBoundParameters.ContainsKey('NewName')) {
                if ($addDate) {
                    $newName = $file.BaseName + $separator + $date + $extension
                }
                else {
                    $newName = $newName + $extension
                }
            }
            else {
                $newName = $file.BaseName + $separator + $date + $extension
            }

            try {

                Copy-Item -Path $file.FullName
                Rename-Item -path $file.fullName -NewName $newName

                $newFullName = Join-Path $file.Directory $newName

                $fileObject = [PSCustomObject]@{
                    OldName  = $file.Name
                    NewName  = $newName
                    FilePath = $newFullName
                    Exists   = Test-Path $newFullName
                }

            }
            catch {
                $_.Exception.Message
            }

        } # foreach

    } # process

    end {
        if ($passThru) {
            $fileObject
        }
    }
}

