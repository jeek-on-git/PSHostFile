function Convert-StringToCommented {
    <#
    .SYNOPSIS
    Converts HostFile entry to an entry type of 'Commented'

    .DESCRIPTION
    Converts HostFile entry to an entry type of 'Commented'

    .PARAMETER string
    The HostFile entry to convert

    .PARAMETER lineNumber
    The HostFile line number

    .EXAMPLE
    

    .NOTES
    
    #>

    [CmdletBinding()]
    [OutputType("HostFile")]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        #[ValidatePattern('^#\D')]
        [ValidatePattern('^# [0-9]+|^#[0-9]+')]
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
        # remove all "#" from the string
        $line = $($string.Replace("#",'')).TrimStart()

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

        $type = 'Commented'

        # create an custom 'HostFile' object
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
