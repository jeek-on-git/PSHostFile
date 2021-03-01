function Test-IsValidEntry {

    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline)]
        [PSTypeName('HostFile')]$entry
    )

    begin {
    }

    process {

        <#
        if ($null -eq $entry.IPAddress -and $null -eq $entry.Comment) {
            'blank'
        }
        elseif ($null -eq $entry.IPAddress -and $null -ne $entry.Comment) {
            'Comment'
        }
        elseif ($entry.IPAddress -match '^# [0-9]+|^#[0-9]+') {
            'Commented'
        }
        elseif ($entry.IPAddress -match '^\d+.\d+.\d+.\d+') {
            'HostEntry'
        }
        #>

        $entry | ForEach-Object {

            <#
            if ($_.IPAddress -match '^[0-9]+.') {
                [PSCustomObject]@{
                    Line        = $_.line
                    EntryType   = 'HostEntry'
                    IsValid     = $true
                }
                #'HostEntry'
            }
            elseif ($_.IPAddress -match '^# [0-9]+.|^#[0-9]+.') {
                [PSCustomObject]@{
                    Line        = $_.line
                    EntryType   = 'Commented'
                    IsValid     = $true
                }
                # 'Commented'
            }
            elseif ($_.Comment -match '^#$|^# $|^#\t|^# \D|^#[a-zA-Z]') {
                [PSCustomObject]@{
                    Line        = $_.line
                    EntryType   = 'Comment'
                    IsValid     = $true
                }
                # 'Comment'
            }
            elseif ($null -eq $_.IPAddress -and $null -eq $_.Comment) {
                [PSCustomObject]@{
                    Line        = $_.line
                    EntryType   = 'Blank'
                    IsValid     = $true
                }
                #'Blank'
            }
            else {
                [PSCustomObject]@{
                    Line        = $_.line
                    EntryType   = 'Unknown'
                    IsValid     = $false
                }
                #'Unknown'
            }
            #>
            # this will be host entry
            if ($null -ne $_.IPAddress) {

                if ($_.IPAddress -match '^[0-9]+.') {
                    [PSCustomObject]@{
                        Line        = $_.line
                        EntryType   = 'HostEntry'
                        IsValid     = $true
                    }
                    #'HostEntry'
                }
                elseif ($_.IPAddress -match '^# [0-9]+.|^#[0-9]+.') {
                    [PSCustomObject]@{
                        Line        = $_.line
                        EntryType   = 'Commented'
                        IsValid     = $true
                    }
                    # 'Commented'
                }
            }
            elseif ($_.Comment -match '^#$|^# $|^#\t|^# \D|^#[a-zA-Z]') {
                [PSCustomObject]@{
                    Line        = $_.line
                    EntryType   = 'Comment'
                    IsValid     = $true
                }
                # 'Comment'
            }
            else {
                [PSCustomObject]@{
                    Line        = $_.line
                    EntryType   = 'Blank'
                    IsValid     = $true
                }
                #'Blank'
            }
        }


        <#
        else {

        }


        IPAddress | commented
        Hostname
        Comment

        Comment

        #'Blank','HostEntry','Commented','Comment'

        if ($entry.entryType -eq 'Blank'){

        }

        <#
        $inputType = $entry.String | Get-HostFileLineType
        $entryType = $entry.EntryType

        "InputType : $inputType"
        "EntryType : $entryType"

        if ($inputType -eq $entryType) {
            $true
        }
        else {
            $false
        }
        #>

    }

    end {
    }

}

