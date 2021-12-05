<#
class Hostfile {
    [ipaddress]$ipAddress
    [string]$hostname
    [string]$comment

    Hostfile ([string] $entry) {
        $this.ipAddress, $this.hostname, $this.comment = $entry -split('\s+'),3
    }
}
#>
function Get-ERMHostFileEntry {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .EXAMPLE
    Get-ERMHostFileEntry

    .EXAMPLE
    Invoke-Command -ComputerName localhost -ScriptBlock ${function:Get-ERMHostFileEntry} | select -ExcludeProperty RunspaceId | ft

    .OUTPUT
    ERM.Hostfile Object

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param (
    )

    begin {

        # path to Windows host file
        $hostFile = "$env:SystemDrive\Windows\System32\Drivers\etc\hosts"

        $TypeData = @{
            TypeName = 'ERM.HostFile'
            DefaultDisplayPropertySet = 'IPAddress','Hostname','Comment'
        }

        #Update-TypeData @TypeData -force

    }

    process {

        If (Test-Path $hostFile) {

            try {

                $content = Get-Content -Path $hostFile -ErrorAction Stop

            }
            catch {

                $_.Exception.Message

            }

            $header = @()
            $obj = foreach ($line in $content) {


                $hostHeader = '^#.\D'
                $commentedOut = '^#.\d'

                if ($line -match $hostheader) {
                    $header += $line
                }

                if ($line -eq $commentedOut) {

                }

                if ($line -notmatch '^$|^\s*$|^\s*#') {

                    #[Hostfile]$line
                    $array = $line -split('\s+'),3

                    $ipAddress = $array[0]
                    $hostname  = $array[1]
                    $comment   = $array[2]

                    #[Hostfile]@{
                    [ordered]@{
                        #PSTypeName = 'ERM.Hostfile'
                        IPAddress = $ipAddress
                        Hostname  = $hostname
                        Comment   = $comment
                        Header    = $header
                    }
                    #>

                }

            }

        }
        else {

            Write-Warning "Can't find Host file"

        }

    }

    end {
    }

}