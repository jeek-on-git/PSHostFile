function New-FileName {
    <#
    .SYNOPSIS
    This function creates a new file name that can be used when either renaming or copying a file

    .DESCRIPTION
    This function creates a new file name that can be used when either renaming or copying a file

    .PARAMETER name
    The original file name. Accepts either a [String] or [System.Io.FileInfo].
    The results from a Get-ChildItem can be piped to this command.

    .PARAMETER newName
    The new name of the file. If the file name isn't changing this can be left blank.

    .PARAMETER fileExt
    The file extend to be added or replace the existing one.
    The dot (.) extension, i.e. .bak, is required

    .PARAMETER addDate
    A [Switch] parameter that when $true appends the date to the file name.

    .PARAMETER separator
    The separator between the file name and the date.
    Accepts on two values, dash ('-') or underscore ('_')

    .EXAMPLE
    This will get the 'hosts' file and pipe it to the New-FileName command.
    Get-ChildItem G:\Temp\hosts | New-FileName -fileExt .bak -addDate
    > hosts-20210108-0130-32.bak

    .NOTES

    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        #[ValidatePattern('(\.\w{3})$')]
        [System.IO.FileInfo]$name,

        [string]$newName,

        [ValidatePattern('^\.')]
        $fileExt,

        [switch]$addDate,

        [ValidateSet('-','_')]
        $separator = '-'
    )

    begin {}

    process {
        $date = Get-Date -f yyyyMMdd-hhmm-ss

        $extension = $name.Extension
        $baseName  = $name.BaseName

        if ($PSBoundParameters.ContainsKey('newName')) {
            $baseName = $newName
        }

        if ($addDate) {
            # Add date to basename
            $baseName = $baseName + $separator + $date
        }

        if ($PSBoundParameters.ContainsKey('fileExt')) {
            $newFileName = $baseName + $fileExt
        }
        else {
            $newFileName = $baseName + $extension
        }

        $newFileName

    }
    end {}
}
