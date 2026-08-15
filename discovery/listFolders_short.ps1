# Obtiene las rutas cortas de $carpetas

$carpetas = @(
	"C:\Users\User\Desktop\Test",
	"C:\Users\User\Documents\secret_folder"
)

$contenido = @()
foreach ($carpeta in $carpetas) {
    try{
        if (Test-Path $carpeta) {
            $contenido += "[INFO] Preguntando ruta corta de $carpeta"
            $contenido += ((New-Object -ComObject Scripting.FileSystemObject).GetFolder($carpeta).ShortPath)
        } else {
            $contenido += "[WARN] no existe"
        }
    } catch {
        $contenido += "[ERROR] No se ha podido obtener la ruta corta de '$carpeta'. Error desconocido."
    }
}

$clave = "jfE0VtwoRh9vqhX7w"
$archivoSalida = Join-Path -Path "." -ChildPath "output.txt"
$contenido -join "`r`n" | .\openssl.exe enc -aes-256-cbc -a -salt -k $clave -out $archivoSalida