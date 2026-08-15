# Obtén la lista de unidades y rutas indexadas utilizando consultas a la BBDD
$indexedList = Get-WmiObject -Query "SELECT * FROM Win32_Volume WHERE IndexingEnabled = 'True'" | ForEach-Object {
    [PSCustomObject]@{
        LetraUnidad = $_.DriveLetter
        RutaIndexada = $_.DeviceID
    }
}

if ($indexedList.Count -eq 0) {
    Write-Host "No se encontraron unidades indexadas en el sistema."
} else {
    Write-Host "Unidades indexadas y sus rutas:"
    $indexedList
}