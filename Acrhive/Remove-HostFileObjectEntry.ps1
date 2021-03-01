function Remove-HostFileObjectEntry {
    [CmdletBinding()]
    param (

        [PSTypeNameAttribute('ERM.Hostfile')]$hostFileObject,

        [Parameter(ParameterSetName='ipAddress')]
        [string]$ipAddress,

        [Parameter(ParameterSetName='hostname')]
        [string]$hostname
    )

    begin {
    }

    process {

        if ($PSCmdlet.ParameterSetName -eq 'ipAddress') {

            $filter = @{"Filter" = {$_.ipAddress -eq $ipAddress}}

        }
        if ($PSCmdlet.ParameterSetName -eq 'hostname') {

            $filter = @{"Filter" = {$_.hostname -eq $hostname}}

        }

        $objectToRemove = $hostFileObject | where @filter

        if ($null -ne $objectToRemove) {

            foreach ($object in $objectToRemove) {

                try {

                    $object
                    # $null = $hostFileObject.Remove($object)

                }
                catch {

                    $_.Exception.Message

                }

            }

        }

    }

    end {
    }

}