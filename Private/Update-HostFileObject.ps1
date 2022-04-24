function Update-HostFileObject {
    <#
    .SYNOPSIS
    Updates the $hostFileObject after it has been modified.

    .DESCRIPTION
    Updates the $hostFileObject after it has been modified.

    .INPUTS
    None.

    .OUTPUTS
    HostFile Object

    .EXAMPLE
    New-HostFileObject

    .EXAMPLE
    New-HostFileObject -hostFilePath C:\temp\hosts

    .NOTES
    This will create two global variables
    HostFileObject  - This is the Host File
    HostFile        - This is path to the host file

    Author: Garry O'Neill

    Change log:
    01/01/2020 - Garry O'Neill - Created.

    #>

    [CmdletBinding()]
    param (
        <#
        [Parameter(Mandatory)]
        [PSTypeName('HostFile')]$hostFileObject,
        #>
        [int]$startingValue = 1
    )

    begin {
        $object = Get-HostFile
    }

    process {
        $newObject = New-Object System.Collections.Generic.List[object]

        # line counter
        $i = $startingValue

        foreach ($obj in $object) {
            # update the LineNumber
            $obj.lineNumber = $i
            $newObject.add($($obj))

            # increment line count
            $i++
        }

    }

    end {
        $script:hostFileObject = $newObject
    }
}
