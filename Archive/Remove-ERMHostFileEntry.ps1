function Remove-ERMHostFileEntry1 {
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

        [Parameter(ParameterSetName="ipaddress")]
        [string[]]$ipAddress,

        [Parameter(ParameterSetName="hostname")]
        [string[]]$hostname

    )

    begin {

        # path to Windows host file
        $hostFile = "$env:SystemDrive\Windows\System32\Drivers\etc\hosts"

        If (Test-Path $hostFile) {

            try {

                $content = Get-Content -Path $hostFile -ErrorAction Stop

            }
            catch {

                $_.Exception.Message

            }

        }
        else {

            Write-Warning "Can't find Host file"

        }

    }

    process {

        $newContent = foreach ($line in $content) {

            if ($line -notmatch '^$|^\s*$|^\s*#') {

                $array = $line -split('\s+'),3

                $newIpAddress = $array[0]
                $newHostname  = $array[1]
                $newComment   = $array[2]

                if ($psCmdlet.ParameterSetName -eq 'ipAddress') {

                    $item = $ipAddress
                    $exclude = $item -join "|"
                    $lineItem = $newIpAddress
                }
                if ($psCmdlet.ParameterSetName -eq 'hostname') {

                    $item = $hostname
                    $exclude = $item -join "|"
                    $lineItem = $newHostname
                }

                if ($lineItem -notmatch $exclude) {

                    ("$newIpAddress".PadRight(24, " ") + "$newHostname".PadRight(24, " ") + $newComment)

                }

            }
            else {

                $line

            }

        }

        try {

            Rename-ERMItem -fileName $hostFile

        }
        catch {

            $_.Exception.Message

        }

        Add-Content -Path $hostFile -Value $newContent
        #$newLine

    }

    end {
    }

}