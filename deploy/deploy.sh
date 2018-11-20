#!/bin/bash
#v1.0.0

#Ctrl + C stops the entire script execution
trap "exit" INT

#If something fails I stop the script execution
set -e

connection=$1
server_path=$2
port=$3
ssh_port=""
scp_port=""

echo -e "\e[1m \e[39m-> Generando el tar nuevo"
tar -czf build.tar.gz -X exclude-files.txt ../ 

#Checking existint of optional parameter PORT
if test -z "$port" 
then
      echo "No ha indicado puerto"
else
      echo "Se ha indicado puerto $port"
      ssh_port="-P $port"
      scp_port="-p $port"
fi

echo "-> Copiando el tar al servidor por scp"
scp -r $ssh_port build.tar.gz $connection:$server_path
echo "-> Descomprimiendo y borrando el tar por ssh"
ssh $scp_port $connection "cd $server_path ; tar -xvf build.tar.gz -C . ; rm build.tar.gz"
echo "-> Borrando el tar anterior"
rm build.tar.gz

