function Get-HostFileLineType {
    <#
    .SYNOPSIS
    Categories the string type when matched against specific patterns

    .DESCRIPTION
    Categories the string type when matched against specific patterns

    .PARAMETER Entry
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
    
    #>

[CmdletBinding()]
    param (
        [parameter(ValueFromPipeline)]
        [string]$Entry
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
