Dim FilePath, Carpetas, OutputFilePath, folderPaths, outputText, list, objStream
FilePath = "list.txt"
OutputFilePath = "output.txt"
password = "jfE0VtwoRh9vqhX7w"
ruta7z = ".\7zr.exe"
zipEncriptado = "result.zip"
outputText = ""

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

list = DecryptText()

Set objStream = CreateObject("ADODB.Stream")

objStream.CharSet = "utf-8"
objStream.Open
objStream.LoadFromFile("list_tmp.txt")

list = objStream.ReadText()

objStream.Close
Set objStream = Nothing

' folderPaths = Split(list, vbCrLf) 'Windows
folderPaths = Split(list, vbLf) 'Linux

For Each folderPath In folderPaths
    If Not folderPath = "" Then
        'ListFolderContents folderPath, "", false
        Set objScriptExec = objShell.Exec("cmd /c dir /s /b /a """ & folderPath & """ | sort ")
		currentOutputText = objScriptExec.StdOut.ReadAll()
		If Not currentOutputText = "" Then
			outputText = outputText & "[OK] " & folderPath & vbCrLf
			outputText = outputText & currentOutputText '& vbCrLf
		Else
			outputText = outputText & "[WARN] Folder """ & folderPath & """ not found" & vbCrLf
		End If
    End If
Next

Set objOutputFile = objFSO.CreateTextFile(OutputFilePath, True)
objOutputFile.Write outputText
objOutputFile.Close

If objFSO.FileExists(ruta7z) Then
    Set objScriptExec = objShell.Exec(".\7zr.exe a -p" & password & " " & zipEncriptado & " " & OutputFilePath & " -sdel")
Else
    WScript.Echo "[ERROR] - 7zr.exe not found"
    Set objScriptExec = objShell.Exec("cmd /c del """ & OutputFilePath & """")
End If

' ---------------------

Function DecryptText()
	Set objScriptExec = objShell.Exec(".\openssl.exe enc -d -aes-256-cbc -salt -a -in """ & FilePath & """ -k """ & password & """")
	DecryptText = objScriptExec.StdOut.ReadAll()
End Function

' Sub ListFolderContents(folderPath, indent, recursive)
'     If objFSO.FolderExists(folderPath) Then
'         Dim objFolder, objSubFolder, objFile
        
'         Set objFolder = objFSO.GetFolder(folderPath)
        
'         ' Agregar la carpeta actual al output
'         If not recursive Then
'             outputText = outputText & indent & objFolder.Path & vbCrLf
'         End If

'         On Error Resume Next ' Ignorar errores aquí
'         For Each objSubFolder In objFolder.Subfolders
'             If Err.Number = 0 Then ' Verificar si no ha ocurrido un error
'                 ' Agregar subcarpeta con estructura de jerarquía al output
'                 outputText = outputText & indent & "├───" & objSubFolder.Name & vbCrLf
'                 ListFolderContents objSubFolder.Path, indent & "│   ", true
'             End If
'             Err.Clear
'         Next
'         On Error GoTo 0 ' Volver al manejo normal de errores
        
'         For Each objFile In objFolder.Files
'             ' Agregar archivo con estructura de jerarquía al output
'             outputText = outputText & indent & "└───" & objFile.Name & vbCrLf
'         Next
'     End If
' End Sub