
$string = @(
    '#Pester Comment'
    '# Pester Comment'
    '#  Pester Comment'
    '#   Pester Comment'
    '#    Pester Comment'
    ' # Pester Comment'
    ' #  Pester Comment'
    ' #   Pester Comment'
    ' #    Pester Comment'
    '  # Pester Comment'
    '  #  Pester Comment'
    '  #   Pester Comment'
    '  #    Pester Comment'
)

$string = @(
    '#1.1.1.1'
    '# 1.1.1.1'
    '#  1.1.1.1'
    '#   1.1.1.1'
    ' #1.1.1.1'
    ' # 1.1.1.1'
    ' #  1.1.1.1'
    ' #   1.1.1.1'
    '  #1.1.1.1'
    '  # 1.1.1.1'
    '  #  1.1.1.1'
    '  #   1.1.1.1'
    '   #1.1.1.1'
    '   # 1.1.1.1'
    '   #  1.1.1.1'
    '   #   1.1.1.1'
)

$string =@(
    'hostname'
    ' hostname '
    '  hostname  '
    '   hostname   '
    '    hostname   '
    'hostname.local'
    ' hostname.local '
    '  hostname.local  '
    '   hostname.local   '
    '    hostname.local    '
    'www.test.com'
    ' www.test.com '
    '  www.test.com  '
    '   www.test.com   '
    '    www.test.com    '
)

$string | foreach {
    # $($_ -replace '#').TrimStart()
    $($_).TrimStart()
}
