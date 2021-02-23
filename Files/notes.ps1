for ($i = 0; $i -lt 10; $i++) {
    $i
}

$i = 0
foreach ($line in $content) {
    $i
    $i++
}

$space  = '\s+'
$i = 0
$a = foreach ($line in $content) {

    $hashSpace = $false
    $type = Get-HostFileLineType $line

    if ($type -eq 'Commented') {

        if ($line -match '^# \d') { $hashSpace = $true }

        $array = $line -split("#"),3
        $len = $array.Length

        if ($hashSpace) {
            $split = $array[1] -split('\s+')
            $ipAddress = $split[1]
            $hostname  = $split[2]
            $comment   = $array[2]
        }
        elseif ($len -eq 3) {
            $split = $array[1] -split('\s+')
            $ipAddress = $split[0]
            $hostname  = $split[1]
            $comment   = $array[2]
        }
        else {
            $split = $array -split('\s+')
            $ipAddress = $split[1]
            $hostname  = $split[2]
            $comment   = ''
        }

        $ipAddress  = "# " + $ipAddress
        $comment    = "#" + $comment

        [PSCustomObject]@{
            PSTypeName = 'HostFile'
            Line       = $i
            EntryType  = $type
            IPAddress  = $ipAddress
            Hostname   = $hostname
            Comment    = $comment
        }
    }
    #>
    $i++
}

$a | ft


$space  = '\s+'
$i = 0
$a = foreach ($line in $content) {

    $type = Get-HostFileLineType $line

    if ($type -eq 'Commented') {

        $array = $line -split("#"),3

        if ($line -match '^# \d') {
            $split = $array[1] -split('\s+')
            $ipAddress = $split[1]
            $hostname  = $split[2]
            $comment   = $split[3]
        }
        elseif ($line -match '^#\d'){
            $split = $array[1] -split('\s+')
            $ipAddress = $split[0]
            $hostname  = $split[1]
            $comment   = $array[2]
        }
        else {
            $split = $array -split('\s+')
            $ipAddress = $split[1]
            $hostname  = $split[2]
            $comment   = ''
        }

        $ipAddress  = "# " + $ipAddress
        $comment    = "#" + $comment

        [PSCustomObject]@{
            PSTypeName = 'HostFile'
            Line       = $i
            EntryType  = $type
            IPAddress  = $ipAddress
            Hostname   = $hostname
            Comment    = $comment
        }
    }
    #>
    $i++
}

$a | ft


$content = Get-Content "D:\Garry\Repos\Modules\HostFile\Files\hosts"

$i = 1
$r = foreach ($line in $content) {

    $line
    $array = $line -split('\s+'),4
    $array = $line -split("#"),2
    #$split = $array[1] -split('\s+'),4

    <#
    if ($array[1].Contains("#")) {
        $split = $array[1] -split('\s+'),4
    }
    else {
        $split = $array[1] -split('\s+'),3
    }
    #>

    [PSCustomObject]@{
        Count       = $i
        EntryType   = Get-HostFileLineType $line
        IPAddress   = $split[1]
        Host        = $split[2]
        Comment     = $split[3]
        ArrayLength = $array.Length

        # line = $line
    }
    $i++
}

$r | where EntryType -eq 'Commented' | ft


$line1 = "# 192.168.100.10    server.host.local	space singletab comment"
$array1 = $line1 -split("#"),2
$array1
$split1 = $array1[1] -split('\s+'),4
$split1


$line2 = "# 192.168.100.10    server.host.local	#spacetab hashsingletab comment"
$array2 = $line2 -split("#"),2
$array2
$split2 = $array2[1] -split('\s+'),4
$split2


$line = "#192.168.100.10    server"
$line = "#192.168.100.10    server	space singletab comment"
$line = "#192.168.100.10    server	#spacetab hashsingletab comment"
$line = "# 192.168.100.10		server.host.local"
$line = "# 192.168.100.10		server.host.local	doubletab singletab comment"
$line = "# 192.168.100.10		server.host.local	#doubletab hashsingletab comment"
$line = "# 192.168.100.10		server.host.local	# doubletab hash singletab comment"


$array = $line -split("#"),2
$array
$array.Length

if ($array[1].Contains("#")) {
    $split = $array[1] -split('\s+'),4
}
else {
    $split = $array[1] -split('\s+'),3
}

#$split
#$split.Length

$split[0]
$split[1]
$split[2]
$split[3]

if ($array.Length -eq 3) {

}


if ($line.StartsWith("#")) {
    $line.Replace("#",'')
}
elseif ($line.StartsWith("# ") {
    $line.Replace("# ",'')
}
else {
    $line
}
#>



$i = 1
$r = foreach ($line in $content) {

    $type = Get-HostFileLineType $line

    if ($type -eq 'Commented') {

        if ($line.StartsWith("#")) {
            $line = $($line.Replace("#",'')).TrimStart()
        }
        <#
        elseif ($line.StartsWith("# ")) {
            $line = $($line.Replace("# ",'')).TrimStart()
        }
        #>

        $array = $line -split('\s+'),3

        $ipAddress = $array[0]
        $hostEntry = $array[1]
        $comment   = $array[2]

        $ipAddress = "# $ipAddress"

        if ([string]::IsNullOrWhiteSpace($comment)) {
            $comment = $null
        }
        else {
            $comment = "# $comment"
        }

        [PSCustomObject]@{
            count       = $i
            type        = $type
            IPAddress   = $ipAddress
            HostEntry   = $hostEntry
            Comment     = $comment
        }

        $i++

    }

}




$array = $line -split("#"),3

if ($line -match '^# \d') {
    $split = $array[1] -split('\s+')
    $ipAddress = $split[1]
    $hostname  = $split[2]
    $comment   = $split[3]
}
elseif ($line -match '^#\d') {
    $split = $array[1] -split('\s+')
    $ipAddress = $split[0]
    $hostname  = $split[1]
    $comment   = $array[2]
}
else {
    $split = $array -split('\s+')
    $ipAddress = $split[1]
    $hostname  = $split[2]
    $comment   = $null
}

$ipAddress  = "# " + $ipAddress

[PSCustomObject]@{
    PSTypeName = 'HostFile'
    Line       = $i
    EntryType  = $type
    IPAddress  = $ipAddress
    Hostname   = $hostname
    Comment    = $comment
}



$content = Get-Content 'D:\Garry\Repos\Modules\HostFile\Files\hosts_ppapp22'

$content | foreach {
    [PSCustomObject]@{
        Type = Get-HostFileLineType $_
        Line = $_
    }
}

$MatchPattern = @(
    '(?<Protocol>\w+)'
    '(?<LocalAddress>(?:[0-9]+\.){3}[0-9]+):(?<LocalPort>[0-9]+)'
    '(?<RemoteAddress>[\w\d_-]+):(?<RemotePort>[0-9]+)'
    '(?<State>\w+)'
) -join '\s+'

$headerPattern = "# lines or following the machine name denoted by a '#' symbol."
$space = "#"
$headerPattern = "#      102.54.94.97     rhino.acme.com          # source server"
$headerPattern = "#	127.0.0.1       localhost"
$headerPattern = "#	::1             localhost"

192.168.100.100	smtp
192.168.100.100	smtp.erm.local
192.168.100.100	smtp.ermpower.com.au	# Comment here

# 192.168.100.100	PPSPS01	    # Comment here
#192.168.100.100	PPSPS01.erm.local
#192.168.100.100	PPSPS01.ermpower.com.au	# Comment here

# Block Access to Prod 2016
#Block Access to Prod 2016

####################################################

(?<Commented>^(#\d|#\s\d))
# 192.168.100.100	PPSPS01	    # Comment here
#192.168.100.100	PPSPS01.erm.local

# Matches IP Address
(?<IPAddress>^\d+)
(?<IPAddress>[0-9]+\.){3}[0-9]+
192.168.100.100	smtp
192.168.100.100	smtp.erm.local
192.168.100.100	smtp.ermpower.com.au	# Comment here



# all commented out lines and spaces
# this pattern matches all lines that start with # or are blank
$pattern = '^$|^\s*$|^\s*#'

# commented out lines
# this pattern matches all lines that start with a # and then a number
$commented = @(
    '^# \d'
    '^#\d'
) -join "|"

# host entry, any line starting with a number
$hostEntry = '^\d'

# all lines starting with #, has a space, then non digit characters
$word  = '^# \D'

# comment, # no space then a word
$comment = '^#\D'

# all lines starting with #
$hash  = '^#$'

# all lines that start with # then have a tab space
$tab   = '^#\t'

# all lines that are blank
$blank = '^\s*$'

# these different regex pattern are join using the pipe, which means match either / or pattern
# if the line of text matches any of these patterns return true
# this set of patterns will match the text of the host file
$header = @(
    $word
    $hash
    $tab
) -join "|"

