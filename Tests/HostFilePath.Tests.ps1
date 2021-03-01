BeforeAll {

    Import-Module "..\PSHostFile.psd1" -Force

} # beforeAll

Describe "HostFile Tests" {

    Context "Tests - Host File Path" {

        It "Test - Host File Path - Default Path" {
            New-HostFilePath
            Get-HostFilePath | Should -Be 'C:\Windows\System32\Drivers\etc\hosts'
        }
        It "Test - Host File Path - Specified Path" {
            $path = "D:\Garry\Repos\Modules\HostFile\Files\hosts"
            New-HostFilePath -hostFilePath $path
            Get-HostFilePath | Should -Be $path
        }
        AfterEach {
            Clear-HostFileObject
            Clear-HostFilePath
        }

    } # context

}
