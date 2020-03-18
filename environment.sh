
echo -e "\n\n\n\n";

hostname -I | awk '{print $1}'

echo "*******************************************************************";
echo "* Instação automatizada de ambiente de desenvolvimento front end  *";
echo "*                                                                 *";
echo "* Developed By C1298001 Guaracy A Lima - Cast Group               *";
echo "*               V 1.0.2                                           *";
echo "*                                                                 *";
echo "*******************************************************************";

echo -e "\n\n Instalando softwares principais \n\n";

sudo apt-get update


sudo apt-get install git -y

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

sudo a2enmod proxy_http

sudo systemctl reload apache2

sudo systemctl restart apache2

echo -e "\n Configurando proxy reverso \n\n";

sudo mv /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/backup_default_ssl.conf
cat ./vhostbase.tmp | sudo tee  /etc/apache2/sites-available/default-ssl.conf

echo -e "\n\n Verificando se as configurações do apache estão funfando \n\n";

sudo apachectl configtest

sudo service apache2 restart

echo -e "\n\n\n Iniciando instalação do NodeJS \n\n";

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

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
