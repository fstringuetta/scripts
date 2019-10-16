#!/bin/bash
# Script para copia dos Arquivos XML para envio manual
# Devido a nao envio automatico do SAT
# Funcional em sistemas KW
# by: Francisco Stringuetta <stringuetta@gmail.com>

# Variaveis
satpen="/retag/sat-pend-0001.txt"
arquivo1="/retag/arquivo1"
arquivo2="/retag/arquivo2"
arquivo3="/retag/arquivo3"
srv="/servidor/NFCEPROC/"
cnpj="00000000000000" # Necessario informar CNPJ da empresa

## Inicio Script
if [ -e $satpen ]; then
echo "Entre com a data que deseja pesquisar(ex: AAAA-MM-DD): "
read DATA

echo "Aguarde copiando os arquivos..."

# Comando para exibir e depois selecionar somente o numero do XML
cat $satpen | grep $DATA | cut -d " " -f 10 > $arquivo1

# Adiciona a palavra AD no inicio do arquivo para procura posterior do XML na pasta do servidor
awk '{print "AD"$0}' $arquivo1 > $arquivo2 && rm $arquivo1

# Insere a extensao ".xml" no final do arquivo criado para copia
sed 's/$/.xml/' $arquivo2 >> $arquivo3 && rm $arquivo2

# Criar a pasta de destino na raiz(/) do sistema
mkdir /$DATA

# Iniciar a copia dos XML para pasta destino
cd /$srv/$cnpj/$DATA
	for i in `cat $arquivo3` ;
do
	find . -type f -iname "*$i" -exec cp --parents {} /$DATA/ \; ; done

# Remove o arquivo base com nome dos XML
rm $arquivo3

else
	clear
	echo "Arquivo SAT pendente nao encontrado."
fi
