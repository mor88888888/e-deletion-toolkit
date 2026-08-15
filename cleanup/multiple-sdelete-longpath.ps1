function filetoFolder{
	# -- Dado una ruta que termina en un fichero, eliminar la parte del fichero y quedarme con la carpeta
    param (
        [string]$rutaFichero
    )
	# Dividir la ruta en partes usando el carácter '\'
    $partesRuta = $rutaFichero -split '\\'

    # Eliminar la última entrada del array (nombre del archivo)
    $partesRuta = $partesRuta[0..($partesRuta.Length - 2)]

    # Volver a unir las partes con '\'
    $rutaSinArchivo = $partesRuta -join '\'

	return $rutaSinArchivo
}

function genRandomString {
	# --Generar un string aleatorio de 5 caracteres
	# Caracteres y números disponibles para generar el string aleatorio
	$caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    $stringAleatorio = ""

    for ($i = 0; $i -lt 5; $i++) {
        $indiceAleatorio = $random.Next(0, $caracteres.Length)
        $caracterAleatorio = $caracteres[$indiceAleatorio]
        $stringAleatorio += $caracterAleatorio
    }

	return $stringAleatorio
}

$clave = "jfE0VtwoRh9vqhX7w" # Example

$rutaFicheros = @(
	"C:\Users\User\WhyDoYouHaveLoooo\ooooooooooo\oooooooooooo\oooooooooo\ooooooooo\ooooooo\ooooooooooooo\oooongPaths",
	"D:\Very\very\very\looooooooo\oooooooooooo\ooooooooooooooooooo\ooooooooooooo\oooooooooooo\oooooooo\ooong\path",
	"\\?\G:\Path\UTF8dir"
)

# Unidad intermedia donde se copiaran las carpetas para eliminarse
$tmp_path_unit = "D:\"
$output = @()

$archivoSalida = Join-Path -Path "." -ChildPath "output.txt"

$random = New-Object Random

foreach ($rutaFichero in $rutaFicheros) { 
	$stringAleatorio = genRandomString

	#$rutaSinArchivo = filetoFolder -rutaFichero $rutaFichero
	$rutaSinArchivo = $rutaFichero

    $nuevaRutaCompleta = $tmp_path_unit + $stringAleatorio
    
	# -- Mover la carpeta
	try {
		# Desactivar la auditoria de ficheros para esta carpeta
		$acl = Get-Acl $rutaSinArchivo -Audit
		$acl.SetAuditRuleProtection($true,$false)
		Set-Acl $rutaSinArchivo $acl
		
		# Usar la API Unicode para mover la carpeta
        [System.IO.Directory]::Move($rutaSinArchivo, $nuevaRutaCompleta)
        $output += "[INFO] Carpeta movida exitosamente: $rutaFichero a $nuevaRutaCompleta"
    } catch {
        $output += "[ERROR] No se pudo mover la carpeta: $rutaFichero"
        $output += "$($_.Exception.Message)"
    }

	# -- Eliminar con sdelete de forma recursiva
    try{
		if (Test-Path $nuevaRutaCompleta) {
			try{
				$output += (.\sdelete64.exe -accepteula -nobanner -r -s -p 2 $nuevaRutaCompleta)
			} catch {
				$output += "[ERROR] No se han podido modificar las propiedades de '$nuevaRutaCompleta'"
			}
		} else {
			$output += "[WARN] '$nuevaRutaCompleta' no existe"
		}
	} catch {
		$output += "[ERROR] Falló el borrado de '$nuevaRutaCompleta'"
		$output += "$($_.Exception.Message)"
	}
}

# Vuelva el output en un fichero encriptado
$output -join "`r`n" | .\openssl.exe enc -aes-256-cbc -a -salt -k $clave -out $archivoSalida