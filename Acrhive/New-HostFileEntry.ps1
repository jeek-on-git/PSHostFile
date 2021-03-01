function New-HostFileEntry {
    <#
    .SYNOPSIS
    Creates a new Host File Entry.

    .DESCRIPTION
    This creates a new 'HostFileEntry' object, which can then used to either add or remove an entry from the HostFileObject.

    .PARAMETER entryType
    Only accepts either 'HostEntry' or 'Commented' entry.
    'HostEntry' is an IP Address and Host name entry
    'Commented' is an IP Address and Host name entry that is commented out. This prefixes the line with a "#".

    .PARAMETER ipAddress
    IP Address

    .PARAMETER hostname
    Hostname

    .PARAMETER comment
    Comment

    .OUTPUTS
    HostFileEntry. Outputs a custom PS Object.

    .EXAMPLE
    This creates a new Host File entry. The result is saved to the 'Entry' variable,
    which is then used by the Add-HostFileEntry command to update the HostFileObject.
    $entry = New-HostFileEntry -entryType hostEntry -ipAddress 10.21.21.21 -hostname testServer21 -comment 'testcomment'
    Add-HostFileEntry -hostFileEntry $entry

    .EXAMPLE
    This creates a new 'Commented' Host File entry. The result is saved to the 'Commented' variable,
    which is then used by the Add-HostFileEntry command to update the HostFileObject.
    $commented = New-HostFileEntry -entryType commented -ipAddress 10.10.10.11 -hostname testServer11 -comment 'testcomment'
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
    New-HostFileEntry -entryType hostEntry -ipAddress 10.21.21.23 -hostname testServer21 -comment 'testcomment3' | Remove-HostFileEntry

    .NOTES

    #>
    [CmdletBinding()]
    param (

        #[Parameter(Mandatory)]
        [validateSet('Blank','HostEntry','Commented','Comment')]
        [string]$entryType,

        #[Parameter(Mandatory)]
        [string]$ipAddress,

        #[Parameter(Mandatory)]
        [string]$hostname,

        [string]$comment

    )

    begin {

        try {
            $null = Test-HostFileVariable HostFileObject -ErrorAction Stop
        }
        catch {
            throw $_.Exception.Message
        }

        $TypeData = @{
            TypeName = 'HostFile'
            DefaultDisplayPropertySet = 'Line','EntryType','IPAddress','Hostname','Comment'
        }

        $null = Update-TypeData @TypeData -force

    }

    process {

        # get the last line number
        $line = $script:hostFileObject | Select-Object -Last 1 -ExpandProperty Line
        $line = $line + 1

        if ($PSBoundParameters.ContainsKey('ipAddress')) {
            if ($ipAddress -match "^#") {
                $ipAddress = $ipAddress -replace("#","# ")
            }
        }

        if ($PSBoundParameters.ContainsKey('Comment')) {
            if ($comment -match "^#") {
                $comment = $comment -replace("#","# ")
            }
            else {
                $comment = "# $comment"
            }
        }

        <#
        if (!([string]::IsNullOrWhiteSpace($comment))) {
            if ($comment -match "^#") {
                $comment = $comment -replace("#","# ")
            }
        }
        #>

        [PSCustomObject] @{
            PSTypeName = 'HostFile'
            Line       = $line
            EntryType  = $entryType
            ipAddress  = $ipAddress
            Hostname   = $hostname
            Comment    = $comment
            String     = $null
        }

    }

    end {
    }

}