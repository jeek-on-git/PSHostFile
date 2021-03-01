function Convert-StringToBlank {
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
