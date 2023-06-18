function Convert-HostFileObjectToText {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSTypeName('HostFile')]$hostFileObject
    )

    begin {
    }

    process {
        $string = foreach ($line in $hostFileObject) {
            $type = $line.EntryType
            switch ($type) {
                'header'    { "{0}" -f $line.Comment }
                'comment'   { "{0}" -f $line.Comment }
                'blank'     { "{0}" -f $line.Comment }
                'commented' { "{0,-18}{1,-30}{2}" -f $line.IPAddress, $line.Hostname, $line.Comment }
                'hostentry' { "{0,-18}{1,-30}{2}" -f $line.IPAddress, $line.Hostname, $line.Comment }
                Default {}
            }
        }
    }

    end {
        $string
        # Set-Content -Path $filePath -Value $string -Encoding UTF8
    }
}
