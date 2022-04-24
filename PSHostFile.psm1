$public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

foreach($import in @($public + $private)) {
    Try {
        . $import.FullName
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }

}

Export-ModuleMember -Function $public.Basename -Alias *
