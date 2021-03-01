Enum HostEntryTypes {
    Blank
    Comment
    Commented
    HostEntry
    Header
}

Class HostFile {
    [int]$lineNumber
    [HostEntryTypes]$entryType
    [IPAddress]$ipAddress
    [string]$Hostname
    [string]$Comment
    [string]$string
}

