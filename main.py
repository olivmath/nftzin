import os

# Define o caminho da pasta que contém os arquivos a serem renomeados
folder_path = './cars'
# Define a extensão dos arquivos a serem renomeados (por exemplo, '.txt' para arquivos de texto)
file_extension = '.png'
# Inicializa o contador
counter = 1

# Lista todos os arquivos na pasta
for filename in os.listdir(folder_path):
    # Constrói o caminho completo do arquivo atual
    src = os.path.join(folder_path, filename)
    # Verifica se o item atual é um arquivo (e não uma pasta, por exemplo)
    if os.path.isfile(src):
        # Constrói o novo nome do arquivo usando o contador e mantém a extensão original do arquivo
        dst = os.path.join(folder_path, f"{counter}{file_extension}")
        # Renomeia o arquivo
        print(f"Renaming file: {src} to: {dst}")
        os.rename(src, dst)
        # Incrementa o contador
        counter += 1

print("Renomeação concluída.")
