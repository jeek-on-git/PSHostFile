
Describe "HostFile Tests" {

    BeforeAll {

        Import-Module "..\PSHostFile.psd1" -Force

        $file = "D:\Garry\Repos\Modules\HostFile\Files\hosts"
        New-HostFilePath $file
        Get-HostFile

    } # beforeAll

    Context "Tests - New-HostFileEntry" {

        It "Test - New-HostFileEntry 'HostEntry'" {
            $entry = New-HostFileEntry -ipAddress 10.10.10.10 -hostname server
            $entry | Get-HostFileEntryType | Should -Be 'HostEntry'
        }
        It "Test - New-HostFileEntry 'Commented'" {
            $entry = New-HostFileEntry -ipAddress 10.10.10.10 -hostname server -commented
            $entry | Get-HostFileEntryType | Should -Be 'Commented'
        }
        It "Test - New-HostFileEntry 'Blank'" {
            $entry = New-HostFileEntry -blank
            $entry | Get-HostFileEntryType | Should -Be 'Blank'
        }

    }

}