function Get-HostFileLineType {
    <#
    .SYNOPSIS
    Categories the string type when matched against specific patterns

    .DESCRIPTION
    Categories the string type when matched against specific patterns

    .PARAMETER entry
    The string to be categorised

    .INPUTS
    String

    .OUTPUTS
    String

    .EXAMPLE
    The contents of the Windows host file is piped to Get-HostFileLineType, which then assigns an 'EntryType' to each line
    $content = Get-Content C:\Windows\System32\drivers\etc\hosts
    $content | Get-HostFileLineType

    .NOTES

    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

[CmdletBinding()]
    param (
        [parameter(ValueFromPipeline)]
        [string]$entry
    )

    begin {

        # commented out lines
        # this pattern matches all lines that start with a # and then a number
        # $commented = '^# [0-9]+|^#[0-9]+'
        $patternCommented = @(
            '^# [0-9]+'
            '^#[0-9]+'
        ) -join '|'

        # all lines starting with # and nothing else
        #$patternHash  = '^#$'
        $patternHash  = '^#|^#\s+'

        # all lines that start with # then have a tab
        $patternTab   = '^#\t'

        # all lines starting with #, space, then non digit characters
        #$word = '[a-zA-Z]+'
        $patternWords  = '^# \D'

        # hash followed immediately by letter
        # $patternLetters = '^#[a-zA-Z]'
        $patternLetters = '^#[a-zA-Z]+|^#\s+[a-zA-Z]+'

        # $comment = '^#|^#\s+|^#\t|^# \D|^#[a-zA-Z]+|^#\s+[a-zA-Z]+'
        $patternComment = @(
            $patternHash
            $patternTab
            $patternWords
            $patternLetters
        ) -join "|"

        # first octet of IP address
        $patternIp = '^[0-9]+.'

        # host entry, any line starting with a digit
        # $patternIp = '^\d'
        # $patternIp = '^\d+.\d+.\d+.\d+'

        # all lines that are blank
        $patternBlank = '^\s*$'

    }

    process {

        foreach ($line in $entry) {

            switch -regex ($line) {
                $patternBlank      { $type = 'Blank'     }
                $patternComment    { $type = 'Comment'   }
                $patternCommented  { $type = 'Commented' }
                $patternIp         { $type = 'HostEntry' }
                Default            { $type = 'Blank'     }
            }
            $type
        }

    }

    end {
    }

}

<#

    # all commented out lines and spaces
    # this pattern matches all lines that start with # or are blank
    $pattern = '^$|^\s*$|^\s*#'

    # commented out lines
    # this pattern matches all lines that start with a # and then a number
    <#
    $commented = @(
        '^# \d'
        '^#\d'
        ) -join "|"
    $commented = @(
        '^# [0-9]+'
        '^#[0-9]+'
    ) -join '|'

    # host entry, any line starting with a number
    $hostEntry = '^\d'

    # comment, # no space then a word
    # $comment = '^#\D'
    # $comment = "^# [0-9]+|^#[0-9]+"

    <#
    '^#\s+[a-zA-Z]+|^#[a-zA-Z]+|^#\s+:'
    $comment = @(
        '^#\s+[a-zA-Z]+'
        '^#[a-zA-Z]+'
        '^#\s+:'
    ) -join "|"

    # hash followed immediately by letter
    $letter = '^#[a-zA-Z]'

    # all lines starting with # and nothing else
    $hash  = '^#$'

    # all lines that start with # then have a tab space
    $tab   = '^#\t'

    # all lines starting with #, has a space, then non digit characters
    $word  = '^# \D'

    # all lines that are blank
    $blank = '^\s*$'

    <#
    $comment = '^#$|^#\t|^# \D|^#[a-zA-Z]'
    $comment = @(
        '^#$'
        '^#\t'
        '^# \D'
        '^#[a-zA-Z]'
    )

    $comment = @(
        $hash
        $tab
        $word
        $letter
    ) -join "|"

    # these different regex pattern are join using the pipe: alternate pattern
    # if the line of text matches any of these patterns return true
    # this set of patterns will match the text of the host file
    $header = @(
        $hash
        $tab
        $word
    ) -join "|"

#>