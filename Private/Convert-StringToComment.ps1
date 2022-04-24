function Convert-StringToComment {
    <#
    .SYNOPSIS
    Converts HostFile entry to an entry type of 'Comment'

    .DESCRIPTION
    Converts HostFile entry to an entry type of 'Comment'

    .PARAMETER string
    The HostFile entry to convert

    .PARAMETER entryType
    Specify the HostFile Entry Type

    .PARAMETER lineNumber
    The HostFile line number

    .EXAMPLE
    

    .NOTES
    
    #>

    [CmdletBinding()]
    [OutputType("HostFile")]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyString()]
        # [ValidatePattern("^#\s+[a-zA-Z]+|^#[a-zA-Z]+|^#\s+:")]
        # [ValidatePattern('^#$|^#\t|^# \D|^#[a-zA-Z]')]
        [ValidatePattern('^\s*$|^#|^#\s+|^#\t|^# \D|^#[a-zA-Z]+|^#\s+[a-zA-Z]+')]
        [String]$string,

        [ValidateSet('Header','Comment')]
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
            $type = 'Comment'
        }
        $comment = $string
        # if the $comment starts with either a "#" then remove it, will remove any combination of '#' and space.
        # then adds a "# ". This is done to keep the 'comment' format consistent. i.e. always a hash then a space then the comment
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
            LineNumber = $lineNumber
            EntryType  = $type
            IPAddress  = ''
            Hostname   = ''
            Comment    = $comment
            String     = $string
        }
    }

    end {
    }
}
