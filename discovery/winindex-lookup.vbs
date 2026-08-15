On Error Resume Next

' Definicion de variables
Dim keywords, arrKeywords, fs, outFile, currentDate, currentTime, dt, computerName, outputFileName, clave

' ############ EDITAR ############
keywords = "probar, test, factura, usuario, ejecutar, hacer, kk"
clave = ""
outputFileName = "result.csv"
zipEncriptado = "result.zip"
' ################################

Set objConnection = CreateObject("ADODB.Connection")
Set objRecordSet = CreateObject("ADODB.Recordset")

objConnection.Open "Provider=Search.CollatorDSO;Extended Properties='Application=Windows';"

arrKeywords = Split(keywords, ", ")

Set fs = CreateObject("Scripting.FileSystemObject")

' Creamos el archivo de salida y escribimos la primera linea
Set outFile = fs.CreateTextFile(outputFileName, True, True)
outFile.WriteLine "Archivo,Ruta,Fecha (UTC),Palabra"

' Recorremos todas las palabras clave a buscar
For Each keyword In arrKeywords
	Dim searchQuery, keywords_splitted
	' Inicializamos la variable con el texto a injectar a la consulta SQL
	searchQuery = ""
	
	' Comprueba si contiene varias palabras
	If InStr(keyword, " ") > 0 Then
		' Divimos el string
		keywords_splitted = Split(keyword, " ")
		' Construimos el where de la consulta
		For Each word In keywords_splitted
			searchQuery = searchQuery & "(CONTAINS('" & word & "') OR CONTAINS(System.FileName, '" & word & "') OR CONTAINS(System.ItemName, '" & word & "')) AND "
		Next
	Else
		' En caso de no tener varias palabras
		word = keyword
		searchQuery = "CONTAINS('" & word & "') OR CONTAINS(System.FileName, '" & word & "') OR CONTAINS(System.ItemName, '" & word & "')"
	End If
	
	' Eliminamos el ultimo "AND" de haberlo
	Set reg = New RegExp
    reg.Pattern = " AND $"
	searchQuery = reg.Replace(searchQuery, "")
	
    ' Construir la consulta SQL para cada palabra clave individualmente
	WScript.Echo searchQuery
	objRecordSet.Open "SELECT System.FileName,System.ItemPathDisplay,System.DateCreated FROM SYSTEMINDEX WHERE " & searchQuery, objConnection
	WScript.Echo "[INFO] Done"

	' Comprobar si hay registros en el conjunto
	If Not objRecordSet.EOF And Not objRecordSet.BOF Then
		' Mover al primer registro
		objRecordSet.MoveFirst
		' Recorremos todos los resultados
		Do Until objRecordSet.EOF
			' Obtener el valor de System.ItemPathDisplay y System.DateCreated
			path = objRecordSet.Fields.Item("System.ItemPathDisplay").Value
			dateCreated = objRecordSet.Fields.Item("System.DateCreated").Value
			' Escribir el resultado en el archivo CSV junto con las palabras clave coincidentes
			If Len(path) > 0 Then
				' Creamos un nuevo registro para cada resultado, excepto del mismo script
				If InStr(path, WScript.ScriptName) = 0 Then
					outFile.WriteLine """" & objRecordSet.Fields.Item("System.FileName").Value & """,""" & path & """,""" & dateCreated & """,""" & keyword & """"
				End If
			End If
			objRecordSet.MoveNext
		Loop
	Else
		WScript.Echo "No se encontraron registros o la consulta devolvió un error."
	End If

	' Cerrar el conjunto de registros y la conexión
    objRecordSet.Close
Next

objConnection.Close
outFile.Close

Set objFSO = CreateObject("Scripting.FileSystemObject")

' Ruta al ejecutable que deseas verificar
rutaEjecutable = ".\7zr.exe"

' El ejecutable existe, puedes llamarlo utilizando WScript.Shell
Set objShell = CreateObject("WScript.Shell")

If objFSO.FileExists(rutaEjecutable) Then
	' Comando de CMD para utilizar 7-Zip y encriptar
	comandoCMD = "7zr.exe a -p" & clave & " " & zipEncriptado & " " & outputFileName & " -sdel"
Else
    ' El ejecutable no existe
    WScript.Echo "ERROR - No se encuentra 7zr.exe"
	comandoCMD = "cmd /c del """ & outputFileName & """"
End If

' Ejecutar el comando CMD
resultado = objShell.Run(comandoCMD, 0, True)
