function Convert-StringToHeader {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER string
    Parameter description

    .PARAMETER entryType
    Parameter description

    .PARAMETER lineNumber
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
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
