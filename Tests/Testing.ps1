
Import-Module D:\Garry\Repos\Modules\HostFile\HostFile.psd1 -Force
New-HostFilePath D:\Garry\Repos\Modules\HostFile\Files\hosts
ghf

ghf | Get-HostFileEntryType -diag

$content = Get-Content "D:\Garry\Repos\Modules\HostFile\Files\hosts"

$content | Get-HostFileLineType

$content | foreach {

}


$patternCommented = @(
    '^# [0-9]+.'
    '^#[0-9]+.'
) -join '|'

# all lines starting with # and nothing else
$patternHash  = '^#$'

# all lines that start with # then have a tab
$patternTab   = '^#\t'

# all lines starting with #, space, then non digit characters
#$word = '[a-zA-Z]+'
$patternWord  = '^# \D'

# first octet of IP address
$patternIp = '^[0-9]+.'

# host entry, any line starting with a digit
# $patternIp = '^\d'
# $patternIp = '^\d+.\d+.\d+.\d+'

# hash followed immediately by letter
# $patternLetters = '^#[a-zA-Z]'
$patternLetters = '[a-zA-Z]'

# $comment = '^#$|^#\t|^# \D|^#[a-zA-Z]'
$patternComment = @(
    $patternHash
    $patternTab
    $patternWord
    $patternLetters
) -join "|"

# all lines that are blank
$patternBlank = '^\s*$'


$strings = @{
    Blank = @(
    ''
    ' '
    '  '
    '   '
    '    '
    ""
    " "
    "  "
    "   "
    "    "
    )
    Commented = @(
        '# 127.0.0.1'
        '# 10.21.21.21   server.local'
        )
    Comment =@(
        '#'
        '# '
        '#  '
        '#   '
        '# ::1'
        '# text'
        '# text text'
    )
    HostEntry =@(
        '10.10.10.10'
        '0.0.0.0'
        '192.168.0.0'
        '172.16.0.0'
    )
}
<#
HostName = @(
    'Test Test Test'
)
#>

$strings.GetEnumerator() | ForEach-Object {

    $name = $_.Key
    "-------------- $name --------------"

    foreach ($item in $strings.$name) {
        Get-HostFileLineType $item
    }
    #>

}




$i = 1
foreach ($line in $content) {

    New-HostFileLineObject -hostFileLine $line -LineNumber $i

    # increment line count
    $i++

}