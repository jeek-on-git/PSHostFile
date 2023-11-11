function New-HostFileObject {
    <#
    .SYNOPSIS
    Creates a PowerShell "Object" of the Windows' Hosts file.

    .DESCRIPTION
    Reads the specified Windows host file and creates a custom object from it.
    If a path isn't specified it will load the default Windows host file.
    The object is saved to a script scoped variable called "HostFileObject".

    .INPUTS
    None.

    .OUTPUTS
    [HostFile]

    .EXAMPLE
    New-HostFileObject

    .EXAMPLE
    # allows for an alternate host file to loaded
    New-HostFileObject -hostFilePath C:\temp\hosts

    .NOTES
    This will create two script scoped variables
    $HostFileObject  - This is the a custom PSObject representing the Hosts file
    $HostFile        - This is path to the host file currently loaded

    #>

    [CmdletBinding()]
    [OutputType("HostFile")]
    param (
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf})]
        [string]$hostFilePath,

        [switch]$passThru
    )

    begin {
        if ($PSBoundParameters.ContainsKey('HostFilePath')) {
            New-HostFilePath -hostFilePath $hostFilePath
        }

        if (!(Test-HostFileVariable -HostFile)) {
            try {
                New-HostFilePath
            }
            catch {
                throw $_.Exception.Message
            }
        }
    }

    process {
        If (Test-Path $script:hostFile) {
            try {
                $content = Get-Content -Path $script:hostFile -ErrorAction Stop
            }
            catch {
                $_.Exception.Message
            }

            $script:hostFileObject = New-Object System.Collections.Generic.List[object]

            # line counter
            $i = 1

            foreach ($line in $content) {
                $script:hostFileObject.add($(New-HostFileLineObject -hostFileLine $line -LineNumber $i))
                $i++
            }
        }
        else {
            Write-Warning "Can't find [$script:HostFile]"
        }
    }

    end {
        if ($passThru) {
            Get-HostFileObject
            # $script:hostFileObject
        }
    }
}
