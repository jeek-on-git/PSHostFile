function Rename-ERMItem {
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

        # [Parameter(ParameterSetName = "Name")]
        [string]$newName,

        [string]$newExtension,

        [ValidateSet('_','-')]
        [string]$separator = '-',

        # [Parameter(ParameterSetName = "Name")]
        [switch]$addDate,

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

