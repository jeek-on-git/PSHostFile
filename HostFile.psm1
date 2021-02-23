$Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

Foreach($import in @($Public + $Private)) {

    Try {

        . $import.FullName

    }

    Catch {

        Write-Error -Message "Failed to import function $($import.FullName): $_"

    }

}

Export-ModuleMember -Function $Public.Basename -Alias * #-Variable hostFile,hostFileObject

# Set-Variable -Name HostFilePath -Value $null -Scope Script -Force
# Set-Variable -Name HostFileObject -Value $null -Scope Script -Force