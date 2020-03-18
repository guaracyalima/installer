#!/bin/bash

echo -e "\n\n\n\n";

echo "***************************************************************";
echo "* Instalador automatizado do docker - Administração de dados  *";
echo "*                                                             *";
echo "* Developed By C1298001 Guaracy A Lima - Cast Group           *";
echo "*                                                             *";
echo "***************************************************************";

echo -e "\n\n\n\n";

echo -e "Removendo instalações anteriores do docker \n\n";

# sudo apt-get remove docker docker-engine docker.io

echo -e "\n\n";

echo "executando como SUDO atualização das dependências do so";
echo -e "Este processo solicitará a sua senha de usuario \n\n"

sudo apt update;

echo -e "\n\n";

echo -e "Instalando os pacotes necessários para baixar atualizações via HTTPS \n\n\n"

sudo apt-get install apt-transport-https  ca-certificates  curl  software-properties-common;

echo -e "\n\n";

echo -e "Setando variaveis de configuração de proxy \n"
read -p "Informe a sua chave: " chave;
read -sp "Informe a sua  senha: " senha;

echo -e "Exportando configurações de http \n"

MY_ACESS=$chave:$senha;

export HTTP_PROXY=http://$MY_ACESS@localhost:40080

echo -e "Exportando configurações de https \n"

export HTTPS_PROXY=http://$MY_ACESS@localhost:40080

echo -e "\n\n";

echo -e "Adicionando CURL à lista de pacotes intalados.... \n";

sudo apt install curl -y;

echo -e "Adicionando GPG key oficial do docker \n";

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo -e "Adicionando repositorios do docker no source lists \n";

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable";

echo -e "\n\n Atualizando lista de pacotes... \n\n";

sudo apt-get update;

echo -e "\n\n\n Instalando docker community edition";

sudo apt-get install docker-ce;

echo -e "\n\n\n Configurando docker para executar como usuário comun \n\n\n";

echo -e "Criando grupo de usuarios docker \n";

sudo groupadd docker;

echo -e "\n\n Incluindo usuario local no gurpo docker \n\n";

sudo usermod -aG docker $USER;

echo -e "\n\n Resolvendo conflitos de endereçamentos de rede \n\n";

# echo {"bip": "192.168.203.129/25", "mtu": 1500, "ipv6": false, "registry-mirrors": [ "https://atf.intranet.bb.com.br:5001" ] } | sudo tee -a  /etc/docker/daemon.json > /dev/null;
echo { "experimental":true, "bip":"192.168.203.129/24", "fixed-cidr":"192.168.203.129/25", "dns":[ "10.20.1.2", "10.20.1.3", "8.8.8.8","8.8.4.4", "10.8.4.1" ], "mtu":1500, "ipv6":false, "registry-mirrors":[ "https://atf.intranet.bb.com.br:5001"],"insecure-registries":["registry.labbs.com.br", "registry.workout.labbs.com.br", "https://harbor.servicos.bb.com.br", "docker-registry.apps.openshift.desenv.bb.com.br", "docker-registry-default.apps.openshift.desenv.bb.com.br", "https://atf.intranet.bb.com.br:5334", "atf.intranet.bb.com.br:5001" ]} | sudo tee -a /etc/docker/x.json > /dev/null;

echo -e "\n\n\n"

echo -e "Configurando docker compose \n\n";
sudo chmod +x /usr/local/bin/docker-compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose;

# try catch

sudo chmod +x /usr/local/bin/docker-compose;

echo -e "\n\n\n"

echo -e "Verificando versão do docker e do docker-composer: \n\n";

docker --version

echo -e "\n\n Realizando login no ATF \n\n";

docker login atf.intranet.bb.com.br:5001

echo -e "\n\n Recaregando configurações \n\n ";

sudo systemctl daemon-reload

echo -e "\n\n Reiniciando instancias \n\n ";

sudo systemctl restart docker

echo -e "\n\n\n\n\n";

echo -e "Executando hello world";

docker pull hello-world
docker run hello-world
