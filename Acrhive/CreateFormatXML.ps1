. D:\Garry\Repos\Working\_Testing\New-PSFormatXML.ps1
$tname = "HostFile"
$obj = [PSCustomObject]@{
    PSTypeName   = $tname
    Line         = $l
    EntryType    = (Get-Date)
    Computername = $env:computername
    OS           = (Get-Ciminstance win32_operatingsystem ).caption
}

$upParams = @{
    TypeName    = $tname
    MemberType  = "ScriptProperty"
    MemberName  = "Runtime"
    Value       = {(Get-Date) - [datetime]"1/1/2020"}
    Force       = $True
}

$fmt = "D:\Garry\Repos\Modules\HostFile\HostFile.Format.ps1xml"
$h | select -First 1 | New-PSFormatXML -Prop Line, EntryType, IPAddress, Hostname, Comment -path $fmt
$h | select -First 1 | New-PSFormatXML -Prop Line, EntryType, IPAddress, Hostname, Comment -view runtime -path $fmt -append


$obj = Get-HostFile
$obj | New-PSFormatXML -Prop Name,OS,Runtime -view runtime -path $fmt -append
$obj | New-PSFormatXML -FormatType List -path $fmt -append

$obj = Get-HostFile | Get-HostFileEntryType -diag
$obj | New-PSFormatXML -Prop LineNumber, Entry, EntryType, Commented, IPAddress, HostName, Comment, Blank -path $fmt -append
$obj | New-PSFormatXML -FormatType List -path $fmt -append

