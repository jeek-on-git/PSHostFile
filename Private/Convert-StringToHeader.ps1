function Convert-StringToHeader {
    <#
    .SYNOPSIS
    Converts HostFile entry to an entry type of 'Header'

    .DESCRIPTION
    Converts HostFile entry to an entry type of 'Header'

    .PARAMETER string
    HostFile entry to convert

    .PARAMETER lineNumber
    HostFile line number

    .EXAMPLE
    

    .NOTES
    

    #>

    [CmdletBinding()]
    [OutputType("HostFile")]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyString()]
        [ValidatePattern('^\s*$|^#|^#\s+|^#\t|^# \D|^#[a-zA-Z]+|^#\s+[a-zA-Z]+')]
        [String]$string,

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
        # create a custom 'HostFile' Object
        [PSCustomObject]@{
            PSTypeName = 'HostFile'
            LineNumber = $lineNumber
            EntryType  = 'Header'
            IPAddress  = ''
            Hostname   = ''
            Comment    = $string
            String     = $string
        }
    }

    end {
    }
}
