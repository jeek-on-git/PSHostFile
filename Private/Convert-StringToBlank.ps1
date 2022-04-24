function Convert-StringToBlank {
    <#
    .SYNOPSIS
    Converts HostFile entry to a blank line

    .DESCRIPTION
    Converts HostFile entry to a blank line

    .PARAMETER string
    HostFile entry

    .PARAMETER entryType
    HostFile entry type

    .PARAMETER lineNumber
    HostFile line number

    .EXAMPLE
    

    .NOTES
    
    #>

    [CmdletBinding()]
    [OutputType("HostFile")]
    param (
        [Parameter(ValueFromPipeline)]
        [ValidatePattern('^\s*$')]
        [String]$string,

        [ValidateSet('Header','Blank')]
        $entryType,

        [int]$lineNumber
    )

    begin {
        $TypeData = @{
            TypeName = 'HostFile'
            DefaultDisplayPropertySet = 'LineNumber','EntryType','IPAddress','Hostname','Comment'
        }
        $null = Update-TypeData @TypeData -force
    }

    process {
        if ($PSBoundParameters.ContainsKey('EntryType')) {
            $type = $entryType
        }
        else {
            $type = 'Blank'
        }
        [PSCustomObject]@{
            PSTypeName = 'HostFile'
            LineNumber = $lineNumber
            EntryType  = $type
            IPAddress  = ''
            Hostname   = ''
            Comment    = ''
            String     = $string
        }
    }

    end {
    }
}
