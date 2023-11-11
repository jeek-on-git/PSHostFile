function New-HostFileEntry {
    <#
    .SYNOPSIS
    Creates a new Host File Entry.

    .DESCRIPTION
    This creates a new 'HostFileEntry' object, which can then used to either add or remove an entry from the HostFileObject.

    .PARAMETER IPAddress
    IP Address

    .PARAMETER Hostname
    Hostname

    .PARAMETER Comment
    Adds a comment to the host entry

    .PARAMETER Commented
    Comments out, i.e. adds a hash, to the IP Address

    .PARAMETER LineComment
    Adds a line comment

    .PARAMETER Blank
    Adds a blank line

    .OUTPUTS
    HostFileEntry. Outputs a custom PS Object.

    .EXAMPLE
    This creates a new Host File entry. The result is saved to the 'Entry' variable,
    which is then used by the Add-HostFileEntry command to update the HostFileObject.
    $entry = New-HostFileEntry -ipAddress 10.21.21.21 -hostname testServer21 -comment 'testcomment'
    Add-HostFileEntry -hostFileEntry $entry

    .EXAMPLE
    This creates a new 'Commented' Host File entry. The result is saved to the 'Commented' variable,
    which is then used by the Add-HostFileEntry command to update the HostFileObject.
    $commented = New-HostFileEntry -ipAddress 10.10.10.11 -hostname testServer11 -comment 'testcomment'
    Add-HostFileEntry -hostFileEntry $commented

    .EXAMPLE
    Using splatting to create the New Host File entry. The results are then pipled to
    $entryParams = @{
        entryType =  'hostEntry'
        ipAddress = '10.21.21.21'
        hostname  = 'testServer21'
        comment   = 'testcomment'
    }
    $entry =  New-HostFileEntry @entryParams
    $entry | Add-HostFileEntry

    .EXAMPLE
    New Host File Entry is created and then piped directly to the Remove-HostFileEntry command.
    New-HostFileEntry -ipAddress 10.21.21.23 -hostname testServer21 -comment 'testcomment3' | Remove-HostFileEntry

    .NOTES

    #>
    [CmdletBinding(DefaultParameterSetName = 'HostEntry')]
    param (

        [Parameter(Mandatory, ParameterSetName = 'HostEntry')]
        [string]$IPAddress,

        [Parameter(Mandatory, ParameterSetName = 'HostEntry')]
        [string]$Hostname,

        [Parameter(ParameterSetName = 'HostEntry')]
        [string]$Comment,

        [Parameter(ParameterSetName = 'HostEntry')]
        [switch]$Commented,

        [Parameter(ParameterSetName = 'LineComment')]
        [string]$LineComment,

        [Parameter(Mandatory, ParameterSetName = 'Blank')]
        [switch]$Blank

    )

    begin {
        try {
            $null = Test-HostFileVariable -HostFileObject -ErrorAction Stop
        }
        catch {
            throw $_.Exception.Message
        }
        $TypeData = @{
            TypeName = 'HostFile'
            DefaultDisplayPropertySet = 'Line','EntryType','IPAddress','Hostname','LineComment'
        }
        $null = Update-TypeData @TypeData -force
    }

    process {
        # get the last line number of the HostFileObject
        $lineNumber = Get-HostFileObject | Select-Object -Last 1 -ExpandProperty LineNumber
        $lineNumber = $lineNumber + 1

        if ($PSCmdlet.ParameterSetName -eq 'HostEntry') {
            $entryType = 'HostEntry'
            if ($PSBoundParameters.ContainsKey('Comment')) {
                $comment = $($comment -replace '#').Trim()
                $comment = "# $comment"
            }
            if ($PSBoundParameters.ContainsKey('IPAddress')) {
                $ipAddress = $($ipAddress -replace '#').Trim()
            }
            if ($PSBoundParameters.ContainsKey('Hostname')) {
                $hostname = $hostname.Trim()
            }
            if ($commented) {
                $ipAddress = "# $ipAddress"
                $entryType = 'Commented'
            }
            [PSCustomObject] @{
                PSTypeName = 'HostFile'
                LineNumber = $lineNumber
                EntryType  = $entryType
                ipAddress  = $ipAddress
                Hostname   = $hostname
                Comment    = $comment
                String     = $null
            }
        }
        if ($PSCmdlet.ParameterSetName -eq 'LineComment') {
            if ($lineComment -match "^#") {
                $lineComment = $lineComment -replace("#","# ")
            }
            else {
                $lineComment = "# $lineComment"
            }
            [PSCustomObject] @{
                PSTypeName = 'HostFile'
                LineNumber = $lineNumber
                EntryType  = 'Comment'
                ipAddress  = $null
                Hostname   = $null
                Comment    = $lineComment
                String     = $null
            }
        }
        if ($PSCmdlet.ParameterSetName -eq 'Blank') {
            [PSCustomObject] @{
                PSTypeName = 'HostFile'
                LineNumber = $lineNumber
                EntryType  = 'Blank'
                ipAddress  = $null
                Hostname   = $null
                Comment    = $null
                String     = $null
            }
        }
    }

    end {
    }
}