function New-HostFileLineObject {
    <#
    .SYNOPSIS
    Converts line (string) from a host file into a custom PS Object

    .DESCRIPTION
    Converts line (string) from a host file into a custom PS Object

    .PARAMETER hostFileLine
    Test string line from a Windows Host file

    .EXAMPLE
    This will loop through each line in the host file and convert it to a custom PS ([HostFile]) Object
    $content = Get-Content 'C:\Windows\System32\Drivers\etc\hosts'
    $content | foreach { New-HostFileLineObject $_ }

    .NOTES
    $i = 0
    $content = get-content D:\Garry\Repos\Modules\HostFile\Files\hosts
    $a = $content | foreach {New-HostFileLineObject $_ $i ; $i++ }
    $a | ft
    #>

    [CmdletBinding()]
    param (

        [Parameter(Mandatory,ValueFromPipeline)]
        [AllowEmptyString()]
        [string]$hostFileLine,
        [int]$lineNumber

    )

    begin {

        # space, i.e. space between words
        $space = '\s+'

        $TypeData = @{
            TypeName = 'HostFileEntry'
            DefaultDisplayPropertySet = 'Line','EntryType','IPAddress','Hostname','Comment'
        }

        $null = Update-TypeData @TypeData -force
        #>

    }

    process {

        foreach ($line in $hostFileLine) {

            $type = Get-HostFileLineType $line

            if ($type -eq 'Unknown') {
                Write-Warning "Unknown line type"
            }

            # header and comments have the same format, therefore any line after line 22 is a comment
            if ($type -match 'Comment' -and $lineNumber -le 22) {
                $type = 'Header'
            }
            elseif ($type -match 'Comment' -and $lineNumber -le 22) {
                HostEntry
            }

            if ($type -eq 'Commented') {

                # if the line starts with a hash then replace (remove) it
                if ($line.StartsWith("#")) {
                    $line = $($line.Replace("#",'')).TrimStart()
                }
                <#
                elseif ($line.StartsWith("# ")) {
                    $line = $($line.Replace("# ",'')).TrimStart()
                }
                #>

                # split the string into an array
                $array = $line -split('\s+'),3

                # assign each element in the array to a variable
                $ipAddress = $array[0]
                $hostname  = $array[1]
                $comment   = $array[2]

                # if the $comment is empty then assign it a null value, otherwise, prePend a "# " to the comment.
                if ([string]::IsNullOrWhiteSpace($comment)) {
                    $comment = $null
                }
                else {
                    $comment = "# $comment"
                }

                # prePend "# " to the IP Address
                $ipAddress = "# $ipAddress"

                # create an custom 'HostFile' object
                [PSCustomObject]@{
                    PSTypeName = 'HostFile'
                    Line       = $lineNumber
                    EntryType  = $type
                    IPAddress  = $ipAddress
                    Hostname   = $hostname
                    Comment    = $comment
                }

            } # if

            elseif ($type -eq 'Comment') {

                # assign the $line variable to $comment
                $comment = $line

                # if the $comment starts with either a "#" then remove it, will remove any combination of # and space.
                # then add "# ". this was done to keep the comment format consistent
                if ($comment.StartsWith("#")) {
                    $comment = $($comment.Replace("#",'')).TrimStart()
                    $comment = "# $comment"
                }
                else {
                    # $comment = $($comment.Replace("# ",'')).TrimStart()
                    $comment = "# $comment"
                }

                # create a custom 'HostFile' Object
                [PSCustomObject]@{
                    PSTypeName = 'HostFile'
                    Line       = $lineNumber
                    EntryType  = $type
                    IPAddress  = ''
                    Hostname   = ''
                    Comment    = $comment
                }

            } # elseif

            elseif ($type -eq 'HostEntry') {

                # split the string into an array
                $array = $line -split($space),3

                # assign each element in the array to a variable
                $ipAddress = $array[0]
                $hostname  = $array[1]
                $comment   = $array[2]

                # if the $comment is empty then assign it a null value, otherwise, prepend a "# " to the comment.
                if ([string]::IsNullOrWhiteSpace($comment)) {
                    $comment = $null
                }
                else {
                    if ($comment.StartsWith("#")) {
                        $comment = $($comment.Replace("#",'')).TrimStart()
                        $comment = "# $comment"
                    }
                    elseif ($comment.StartsWith("# ")) {
                        $comment = $($comment.Replace("# ",'')).TrimStart()
                        $comment = "# $comment"
                    }
                    else {
                        $comment = "# $comment"
                    }
                }

                [PSCustomObject]@{
                    PSTypeName = 'HostFile'
                    Line       = $lineNumber
                    EntryType  = $type
                    IPAddress  = $ipAddress
                    Hostname   = $hostname
                    Comment    = $comment
                }

            } # elseif

            elseif ($type -eq 'Header') {

                # host file header, the first 21 characters
                [PSCustomObject]@{
                    PSTypeName = 'HostFile'
                    Line       = $lineNumber
                    EntryType  = $type
                    IPAddress  = ''
                    Hostname   = ''
                    Comment    = $line
                }

            } # else

            elseif ($type -eq 'Blank') {

                # host file header, the first 21 characters
                [PSCustomObject]@{
                    PSTypeName = 'HostFile'
                    Line       = $lineNumber
                    EntryType  = $type
                    IPAddress  = ''
                    Hostname   = ''
                    Comment    = $line
                }

            } # else

            else {

                # the default should be a blank line
                [PSCustomObject]@{
                    PSTypeName = 'HostFile'
                    Line       = $lineNumber
                    EntryType  = $type
                    IPAddress  = ''
                    Hostname   = ''
                    Comment    = $line
                }

            } # else

        } # foreach

    } # process

    end {
    }

}

