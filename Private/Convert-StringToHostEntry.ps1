function Convert-StringToHostEntry {
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
        [ValidatePattern('^\d+.\d+.\d+.\d+')]
        [String]$string,

        $entryType,

        [int]$lineNumber

    )

    begin {

        $space = '\s+'

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
            $type = 'HostEntry'
        }

        $array = $string -split($space),3

        # assign each element in the array to a variable
        $ipAddress = $array[0]
        $hostname  = $array[1]
        $comment   = $array[2]

        # if the $comment is empty then assign it a null value, otherwise, prePend a "# " to the comment.
        if ([string]::IsNullOrWhiteSpace($comment)) {
            $comment = $null
        }
        else {
            if ($comment.StartsWith("#")) {
                $comment = $($comment.Replace("#",'')).TrimStart()
                $comment = "# $comment"
            }
            <#
            elseif ($comment.StartsWith("# ")) {
                $comment = $($comment.Replace("# ",'')).TrimStart()
                $comment = "# $comment"
            }
            #>
            else {
                $comment = "# $comment"
            }
        }

        [PSCustomObject]@{
            PSTypeName = 'HostFile'
            LineNumber = $lineNumber
            EntryType  = $type
            IPAddress  = $ipAddress
            Hostname   = $hostname
            Comment    = $comment
            String     = $string
        }

    }

    end {
    }
}
