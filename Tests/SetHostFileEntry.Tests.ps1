
Describe "HostFile Tests" {

    BeforeAll {

        Import-Module "..\PSHostFile.psd1" -Force

        Clear-HostFileObject
        Clear-HostFilePath

        $file = "$PSScriptRoot\hosts"
        $null = New-HostFileObject -hostFilePath $file
        $null = Get-HostFile

    } # beforeAll

    Context "Tests - Set-HostFileEntry" {

        It "Test - Set-HostFileEntry 'Commented'" {
            Get-HostFileEntry 34 | Set-HostFileEntry -commented
            Get-HostFileEntry 34 | Get-HostFileEntryType | Should -be 'Commented'
        }
        It "Test - Set-HostFileEntry 'IPAddress'" {
            Get-HostFileEntry 34 | Set-HostFileEntry -ipAddress '10.10.10.10'
            (Get-HostFileEntry 34).IPAddress | Should -be '10.10.10.10'
        }
        It "Test - Set-HostFileEntry 'HostName'" {
            Get-HostFileEntry 34 | Set-HostFileEntry -hostname 'TestHostName'
            (Get-HostFileEntry 34).HostName | Should -be 'TestHostName'
        }
        It "Test - Set-HostFileEntry 'Comment'" {
            Get-HostFileEntry 34 | Set-HostFileEntry -comment 'Test Comment'
            (Get-HostFileEntry 34).Comment | Should -be 'Test Comment'
        }

    }

    AfterAll {
        Clear-HostFileObject
        Clear-HostFilePath
    }

}