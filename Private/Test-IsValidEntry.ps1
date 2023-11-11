function Test-IsValidEntry {
    
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline)]
        [PSTypeName('HostFile')]$entry
    )

    begin {
    }

    process {
        $entry | ForEach-Object {
            if ($null -ne $_.IPAddress) {
                if ($_.IPAddress -match '^[0-9]+.') {
                    [PSCustomObject]@{
                        Line        = $_.line
                        EntryType   = 'HostEntry'
                        IsValid     = $true
                    }
                }
                elseif ($_.IPAddress -match '^# [0-9]+.|^#[0-9]+.') {
                    [PSCustomObject]@{
                        Line        = $_.line
                        EntryType   = 'Commented'
                        IsValid     = $true
                    }
                }
            }
            elseif ($_.Comment -match '^#$|^# $|^#\t|^# \D|^#[a-zA-Z]') {
                [PSCustomObject]@{
                    Line        = $_.line
                    EntryType   = 'Comment'
                    IsValid     = $true
                }
            }
            else {
                [PSCustomObject]@{
                    Line        = $_.line
                    EntryType   = 'Blank'
                    IsValid     = $true
                }
            }
        }
    }

    end {
    }
}