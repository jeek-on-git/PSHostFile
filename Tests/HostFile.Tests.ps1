Describe "HostFile Tests" {

    BeforeAll {

        Import-Module "..\PSHostFile.psd1" -Force

        Clear-HostFileObject
        Clear-HostFilePath


    } # beforeAll

    Context "Tests - Host File Path" {

        It "Test - HostFile Path with Default Path" {
            New-HostFilePath
            Get-HostFilePath | Should -Be 'C:\Windows\System32\Drivers\etc\hosts'
        }
        It "Test - HostFilePath variable is True" {
            Test-HostFileVariable -hostFile | Should -Be $true
        }

    }

    Context "Test - HostFile with non-default path" {

        BeforeEach {

            $file = "$PSScriptRoot\hosts"
            New-HostFilePath -hostFilePath $file

        } # beforeAll

        It "Test - HostFile Path - Specified Path" {
            Get-HostFilePath | Should -Be $file
        }
        It "Test - HostFilePath variable is True" {
            Test-HostFileVariable -hostFile | Should -Be $true
        }

        AfterEach {
            Clear-HostFileObject
            Clear-HostFilePath
        }

    } # context

}