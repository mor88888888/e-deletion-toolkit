# Obten todas las subcarpetas y ficheros de forma recursiva de $carpetas

$carpetas = @(
	"C:\Users\User\Desktop\Test",
	"C:\Users\User\Documents\secret_folder"
)

$maxPathLength = 259
$maxFolderLength = 247
$clave = "jfE0VtwoRh9vqhX7w"
$contenido = @()

$archivoSalida = Join-Path -Path "." -ChildPath "output.txt"

function ListarContenidoRecursivo {
    param(
        [string]$carpeta
    )
	$rutaLength = $carpeta.Length
	$carpetaLength = ($carpeta -split '\\')[-1].Length
	
    if (($rutaLength -lt $maxPathLength) -and ($carpetaLength -lt $maxFolderLength)) {
		try{
        	if (Test-Path $carpeta) {
				$global:contenido += "[INFO] existe"
        	    $global:contenido += (Get-ChildItem -Path $carpeta -Force | ForEach-Object { $_.FullName })
        	    Get-ChildItem -Path $carpeta -Force | ForEach-Object {
            	    if ($_.PSIsContainer) {
                	    ListarContenidoRecursivo -carpeta $_.FullName
            	    }
			    } 
        	} else {
            	$global:contenido += "[WARN] no existe"
        	}
		} catch {
			$global:contenido += "[ERROR] No se ha podido listar el contenido de '$carpeta'. Error desconocido."
		}
    } else {
        $global:contenido += "[ERROR] No se ha podido listar el contenido de '$carpeta'. Ruta o nombre de carpeta demasiado grandes."
    }
}

foreach ($carpeta in $carpetas) {
    $contenido += "--- $carpeta ---"
    ListarContenidoRecursivo -carpeta $carpeta
}

$contenido -join "`r`n" | .\openssl.exe enc -aes-256-cbc -a -salt -k $clave -out $archivoSalida
