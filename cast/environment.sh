
echo -e "\n\n\n\n";

hostname -I | awk '{print $1}'

echo "*******************************************************************";
echo "* Instação automatizada de ambiente de desenvolvimento            *";
echo "* para distros não oficiais do bb                                 *";
echo "*                                                                 *";
echo "* Developed By C1298001 Guaracy A Lima - Cast Group               *";
echo "*               V 1.0.2                                           *";
echo "*                                                                 *";
echo "*******************************************************************";

echo -e "\n\n Instalando softwares principais \n\n";

sudo apt-get update

echo -e "\n\n Começando o apocalipse.... \n\n";

echo -e "\n\n Realizando configurações do stunnel \n\n";

sudo apt install stunnel4 -y

sudo cp ./cachessl-global.pem /etc/stunnel/cachessl-global.pem

cat ./proxysettings.cfg | sudo tee /etc/stunnel/stunnel.conf

cat ./stunnel4.service | sudo tee /etc/systemd/system/stunnel.service

sudo systemctl enable stunnel.service

sudo systemctl start stunnel.service

echo -e "\n\n Realizando configurações do squid \n\n";

sudo apt install squid -y

read -p "Informe a sua chave: " chave;
read -sp "Informe a sua  senha: " senha;

echo -e "Exportando configurações de http \n"

MY_ACESS=$chave:$senha;

sed -i 's/<BB_USER>:<BB_PASSWORD>/'$MY_ACESS'/g' ./squid.cfg

cat ./squid.cfg | sudo tee /etc/squid/squid.conf

sudo service squid restart

echo -e "\n\n Squid configurado com sucesso.... \n\n";

echo -e "Configurando proxy \n\n";

export NO_PROXY="127.0.0.1,localhost,*.bb.com.br,*.labbs.com.br"

sh -c "echo export {http,https,ftp}_proxy=\"http://127.0.0.1:3124\"" >> ~/.bashrc
sh -c "echo export no_proxy=\"$NO_PROXY\"" >> ~/.bashrc

cat ./proxy.conf | sudo tee /etc/apt/apt.conf.d/proxy.conf


echo -e "\n\n Instalando e configurando git \n\n";

sudo apt-get install git -y

sudo apt install git git-flow -y

sudo apt-get install gitk -y

sudo apt-get install inotify-tools -y

sudo apt install net-tools -y

sudo apt install curl -y

echo -e "\n\n\n Iniciando instalação do Apache \n\n";

sudo apt install apache2 -y

echo -e "\n\n\n Habilitando proxy e https \n\n";

sudo a2enmod ssl

sudo a2ensite default-ssl.conf

sudo a2enmod proxy
stunnel4.service
sudo a2enmod proxy_http

sudo systemctl reload apache2

sudo systemctl restart apache2

echo -e "\n Configurando proxy reverso \n\n";

sudo mv /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/backup_default_ssl.conf
cat ./vhostbase.tmp | sudo tee  /etc/apache2/sites-available/default-ssl.conf

echo -e "\n\n Verificando se as configurações do apache estão funfando \n\n";

sudo apachectl configtest

sudo service apache2 restart

pwd home
echo $home

echo -e "\n\n\n Iniciando instalação do NodeJS \n\n";

# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
#
#
#
#

cd .nvm

git checkout v0.35.3

cat ./bashrc | sudo tee -a ~/.bashrc

source ~/.bashrc

nvm install --lts


echo -e "Node.: " $(node -v)
echo -e "NPM.: "$(npm -v)

echo -e "\n\n Configurando acesso npm bb repo \n\n"

npm config set registry http://atf.intranet.bb.com.br/artifactory/api/npm/bb-npm-repo/

npm login

echo -e "\n\n Verificando se as credenciais foram setadas corretamente \n\n";

cat ~/.npmrc

echo -e "\n\n Instalando dependências mais canrivoras \n\n\n";

npm install -g grunt-cli

echo -e "Grunt.: " $(grunt -version)

npm i -g karma-cli

echo -e "\n\n Configurando VPN cast \n\n";

cd $home

sudo apt install wget -y

wget www.niser.ac.in/docs/forticlientsslvpn_linux_4.4.2332.tar.gz

ls

tar –zxvf forticlientsslvpn_linux_4.4.2332.tar.gz

cd cast/forticlientsslvpn

echo -e "\n\n configurando hosts \n\n";

cat ./hosts | sudo tee -a /etc/hosts

bash fortisslvpn.sh

echo -e "\n\n Configuração finalizada \n\n";
