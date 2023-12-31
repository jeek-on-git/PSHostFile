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
    $content = get-content $PS .\$PSScriptRoot\Files\hosts
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
        $headerCount = Get-HostFileHeaderCount -hostFile $(Get-HostFilePath)
    }

    process {
        foreach ($line in $hostFileLine) {

            $type = Get-HostFileLineType $line

            # header and comments have the same format, therefore any line after the $headercount is a comment
            # conversely any line before is a header
            if ($lineNumber -le $headerCount -and $type -match 'Comment|Commented|Blank') {
                $type = 'Header'
            }

            switch ($type) {
                'Commented'   { Convert-StringToCommented -String $line -lineNumber $lineNumber                     }
                'Comment'     { Convert-StringToComment   -String $line -EntryType $type -lineNumber $lineNumber    }
                'Header'      { Convert-StringToHeader    -String $line -lineNumber $lineNumber                     }
                'HostEntry'   { Convert-StringToHostEntry -String $line -EntryType $type -lineNumber $lineNumber    }
                'Blank'       { Convert-StringToBlank     -String $line -lineNumber $lineNumber                     }
                Default       { Convert-StringToBlank     -String $line -lineNumber $lineNumber                     }
            }
        }
    }

    end {
    }
}

