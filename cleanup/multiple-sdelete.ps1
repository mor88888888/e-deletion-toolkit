$carpetas = @(
	"C:\Users\User\Desktop\Test",
	"C:\Users\User\Documents\secret_folder"
)

$clave = "jfE0VtwoRh9vqhX7w" # Contraseña de ejemplo

$output = @()

$archivoSalida = Join-Path -Path "." -ChildPath "output.txt"

function BorradoSeguroRecursivo {
    param(
        [string]$carpeta
    )
	try{
		if (Test-Path $carpeta) {
			# Recuperar el valor de auditoria de la carpeta
			$acl = Get-Acl $carpeta -Audit
			$acl.SetAuditRuleProtection($true,$false)
			try{
				# Desactivar la auditoria de ficheros para esta carpeta
				Set-Acl $carpeta $acl
				# Eliminar carpeta de forma recursiva con sdelete
				$global:output += (.\sdelete64.exe -accepteula -nobanner -r -s -p 2 $carpeta)
			} catch {
				$global:output += "[ERROR] No se han podido modificar las propiedades de '$carpeta'"
			}
		} else {
			$global:output += "[WARN] '$carpeta' no existe"
		}
	} catch {
		$global:output += "[ERROR] Falló el borrado de '$carpeta'"
		$global:output +=$_
	}
}

foreach ($carpeta in $carpetas) {
	$output += "--- $carpeta ---"
    BorradoSeguroRecursivo -carpeta $carpeta
}

$output -join "`r`n" | .\openssl.exe enc -aes-256-cbc -a -salt -k $clave -out $archivoSalida