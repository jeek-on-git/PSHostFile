function Get-HostFileEntryType {
    <#
    .SYNOPSIS
    Returns the Hosts file host entry type from the $hostFileObject

    .DESCRIPTION
    Returns the Hosts file host entry type from the $hostFileObject

    .PARAMETER hostEntry
    Entry/Entries from the $hostFileObject

    .PARAMETER diag
    Switch parameter to toggles the output. If used an object

    .INPUTS
    [HostFile]

    .OUTPUTS
    [String]
    [PSCustomObject]. If the 'diag' switch is used then output is PSCustomObject.

    .EXAMPLE
    ghf | foreach { "Line {0}, {1} : {2}" -f $_.Line, $_.EntryType, $(Get-HostFileEntryType $_) }

    .NOTES

    #>

    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline)]
        [PSTypeName('HostFile')]$hostEntry,

        [switch]$diag
    )

    begin {
        # commented out lines
        # this pattern matches all lines that start with a # and then a number
        # $commented = '^# [0-9]+|^#[0-9]+'
        $patternCommented = @(
            '^# [0-9]+.'
            '^#[0-9]+.'
        ) -join '|'

        # all lines starting with # and nothing else
        $patternHash  = '^#$'

        # all lines that start with # then have a tab
        $patternTab   = '^#\t'

        # all lines starting with #, space, then non digit characters
        #$word = '[a-zA-Z]+'
        $patternWord  = '^# \D'

        # first octet of IP address
        $patternIp = '^[0-9]+.'

        # host entry, any line starting with a digit
        # $patternIp = '^\d'
        # $patternIp = '^\d+.\d+.\d+.\d+'

        # hash followed immediately by letter
        # $patternLetters = '^#[a-zA-Z]'
        $patternLetters = '[a-zA-Z]'

        # $comment = '^#$|^#\t|^# \D|^#[a-zA-Z]'
        $patternComment = @(
            $patternHash
            $patternTab
            $patternWord
            $patternLetters
        ) -join "|"

        # all lines that are blank
        $patternBlank = '^\s*$'

        $TypeData = @{
            TypeName = 'HostFile'
            DefaultDisplayPropertySet = 'LineNumber','EntryType','IPAddress','Hostname','Comment'
        }

        $null = Update-TypeData @TypeData -force
    }

    process {

        foreach ($entry in $hostEntry) {

            $ipAddress  = $false
            $hostName   = $false
            $commented  = $false
            $comment    = $false
            $blank      = $false

            #if ($entry.IPAddress -eq -and $null -eq $entry.Comment) {
            If ([string]::IsNullOrWhiteSpace($entry.IPAddress) -and [string]::IsNullOrWhiteSpace($entry.Comment)) {
                $blank = $true
                # $entryType = 'Blank'
            }
            if ($entry.IPAddress -match $patternIp) {
                $ipAddress = $true
                # $entryType = 'HostEntry'
            }
            # if ($entry.IPAddress -match '^# [0-9]+.|^#[0-9]+.') {
            if ($entry.IPAddress -match $patternCommented) {
                $commented = $true
                # $entryType = 'Commented'
            }
            # if ($entry.HostName -match '[a-zA-Z]+') {
            if ($entry.HostName -match $patternLetters) {
                $hostName = $true
                # $entryType = 'HostEntry'
            }
            # if ($entry.Comment -match '^#$|^# $|^#\t|^# \D|^#[a-zA-Z]') {
            if ($entry.Comment -match $patternComment) {
                $comment = $true
                # $entryType = 'Comment'
            }
            # if ($entry.Comment -match '^# [0-9]+.|^#[0-9]+.') {
            if ($entry.Comment -match $patternCommented) {
                $comment = $true
                # $entryType = 'Comment'
            }

            if ($comment) {
                $entryType = 'Comment'
            }
            if ($blank) {
                $entryType = 'Blank'
            }
            if ($commented) {
                $entryType = 'Commented'
            }
            if ($ipAddress -and $hostName) {
                $entryType = 'HostEntry'
            }

            if ($diag) {
                [PSCustomObject]@{
                    PSTypeName = 'HostFileDiag'
                    LineNumber = $entry.lineNumber
                    Entry      = $entry.EntryType
                    EntryType  = $entryType
                    Commented  = $commented
                    IPAddress  = $ipAddress
                    HostName   = $hostName
                    Comment    = $comment
                    Blank      = $blank
                }
            }
            else {
                $entryType
            }

        }

    }

    end {
    }

}
