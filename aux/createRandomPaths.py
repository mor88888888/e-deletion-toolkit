import os
import random
import shutil
import zipfile
import string

# Directorio base donde se crearán las carpetas y archivos
base_directory = "RandomPaths"

# Ruta del archivo para el listado de directorios
directory_list_file = "list_RandomPaths.txt"

# Lista de extensiones de archivos
file_extensions = ["txt", "docx", "xlsx", "pdf", "pptx"]

# Caracteres especiales para nombres de carpetas y archivos
special_characters = "áéíóúüñÁÉÍÓÚÜÑ .·"

# Número total de carpetas y subcarpetas que deseas crear
total_folders = 2000

# Número de niveles de carpetas
num_levels = 3

# Lista para almacenar los directorios creados
created_directories = []

# Función para crear archivos aleatorios en una carpeta
def create_random_files(folder_path):
    num_files = random.randint(1, 10)  # Cantidad aleatoria de archivos por carpeta
    for _ in range(num_files):
        file_extension = random.choice(file_extensions)
        file_name = ''.join(random.choice(special_characters + string.ascii_letters + string.digits) for _ in range(20))
        file_path = os.path.join(folder_path, file_name + f".{file_extension}")
        with open(file_path, "w") as f:
            f.write("Contenido de prueba")

# Crear la estructura de carpetas
if not os.path.exists(base_directory):
    os.makedirs(base_directory)

for i in range(total_folders):
    folder_name = ''.join(random.choice(special_characters + string.ascii_letters + string.digits) for _ in range(20))
    folder_path = os.path.join(base_directory, folder_name)
    os.makedirs(folder_path)
    created_directories.append(folder_path)
    create_random_files(folder_path)

    # Agregar niveles de carpetas
    for level in range(num_levels - 1):
        subfolder_name = ''.join(random.choice(special_characters + string.ascii_letters + string.digits) for _ in range(20))
        subfolder_path = os.path.join(folder_path, subfolder_name)
        os.makedirs(subfolder_path)
        folder_path = subfolder_path
        created_directories.append(folder_path)

# Crear un archivo con el listado de directorios
with open(directory_list_file, "w") as f:
    for dir_path in created_directories:
        f.write(dir_path + "\n")

# Crear un archivo ZIP de la estructura
shutil.make_archive(base_directory, "zip", base_directory)

# Eliminar la carpeta original
shutil.rmtree(base_directory)

print("Estructura de carpetas y archivos creada, listado de directorios generado, comprimida y carpeta original eliminada.")
