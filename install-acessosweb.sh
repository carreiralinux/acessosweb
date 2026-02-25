#!/bin/bash
#######################################
# Atualização: 25/02/2026             #
# Autor: Luís Montes                  #
# Email: contato@carreiralinux.com.br #
# #####################################
#
# Binarios
#
UFW="usr/bin/ufw"
UNZIP="/usr/bin/unzip"
CAT="/usr/bin/cat"
CD="/usr/bin/cd"
CHMOD="/usr/bin/chmod"
CHOWN="/usr/bin/chown"
CP="/usr/bin/cp"
ECHO="/usr/bin/echo"
GREP="/usr/bin/grep"
JAVA="/usr/lib64/jre-9.0.4/bin/java"
LN="/usr/bin/ln"
MAKE="/usr/bin/make"
MKDIR="/usr/bin/mkdir"
MV="/usr/bin/mv"
MYSQL="/usr/bin/mysql"
MYSQLSECURE="/usr/bin/mysql_secure_installation"
READ="/usr/bin/read"
SED="/usr/bin/sed"
SLEEP="/usr/bin/sleep 3"
SQUID="/usr/sbin/squid"
SQUIDVERSION="squid-6.12.tar.bz2"
SQUIDPATH="squid-6.12"
SU="/usr/bin/su"
SYSTEMCTL="/usr/bin/systemctl"
TAR="/usr/bin/tar"
TOUCH="/usr/bin/touch"
USERDEL="/usr/sbin/userdel"
USERADD="/usr/sbin/useradd"
USERMOD="/usr/sbin/usermod"
WGET="/usr/bin/wget"
APT="/usr/bin/apt-get"

#
# Funcoes
#
function update_start() {
     $ECHO -e "1. Atualizar sistema operacional."
     $APT -y update
     $ECHO -e "Sistema operacional atualizado."
     $SLEEP
}

function install_start() {
    $ECHO -e "2. Instalar os pacotes. \r" 
    $CHMOD +x /root/downloads/acessosweb/install-packages.sh
    /root/downloads/acessosweb/install-packages.sh
    $WGET -c https://www.carreiralinux.com.br/uploads/jre-9.0.4_linux-x64_bin.tar.zip
    $ECHO -e "Pacotes baixados e instalados. \r" 
    $SLEEP
}

function database_start() {
    $ECHO -e "3. Configurar Banco de Dados MariaDB. \r" 
    $ECHO -e "3.1 Configurar para iniciar automaticamente. \r" 
    $SYSTEMCTL enable mariadb
    $ECHO -e "3.2 Iniciar MariaDB. \r" 
    $SYSTEMCTL start mariadb
    $ECHO -e "3.3 Mude a senha de root do servidor do banco de dados. \r" 
    $MYSQL_SECURE
    $SLEEP
    $ECHO -e "3.4 Vamos criar a base de dados Acessos Web. \r" 
    $ECHO -e "Agora digite a senha do banco de dados MariaDB. \r" 
    $MYSQL -u root -p < /root/downloads/acessosweb/database.sql
    $ECHO -e "3.5 Base de dados foi criada. \r" 
    $SLEEP
}

function squid_start() {
    $ECHO -e "4. Instalar Squid Proxy. \r" 
    $ECHO -e "4.1 Desempacotar pacote squid em /usr/src. \r" 
    $SLEEP
    $TAR -xjvf /root/downloads/acessosweb/ $SQUIDVERSION -C /usr/src
    $GREP squid /etc/passwd
    if [ $? -eq 0 ];then
        $ECHO -e "Usuario squid existente, vamos ajustar o diretorio home. \r" 
	$USERMOD -r -d /var/cache/squid -s /bin/false squid
    	else
        	$ECHO -e "4.2 Criar usuario Squid. \r" 
        	$USERADD -r -d /var/cache/squid -s /bin/false squid
    fi
    $ECHO -e "4.3 Configure Squid. \r" 
    $SLEEP
    $CD /usr/src/$SQUIDPATH
    $CP /root/downloads/acessosweb/configure.sh /usr/src/$SQUIDPATH/configure.sh
    $CHMOD +x /usr/src/$SQUIDPATH/configure.sh
    /usr/src/$SQUIDPATH/configure.sh
    $ECHO -e "4.4 Make Squid. \r" 
    $MAKE
    $ECHO -e "4.5 Make install Squid. \r" 
    $SLEEP
    $MAKE install
    $ECHO -e "4.6 Configurar squid.conf. \r" 
    $SLEEP
    $ECHO -e "Criar /var/log/squid/access.log."
    $TOUCH /var/log/squid/access.log
    $ECHO -e "Criar /var/log/squid/cache.log."
    $TOUCH /var/log/squid/cache.log
    $ECHO -e "Criar /usr/local/squid."
    $MKDIR /usr/local/squid
    $ECHO -e "Criar /usr/local/squid/squid.pid."
    $TOUCH /usr/local/squid/squid.pid 
    $ECHO -e "Alterar o chowner /usr/local/squid."
    $CHOWN -R squid:squid /usr/local/squid
    $ECHO -e "Alterar o owner /var/cache/squid."
    $CHOWN -R squid:squid /var/cache/squid
    $ECHO -e "Alterar o owner /var/cache/squid/access.log."
    $CHOWN -R squid:squid /var/log/squid/access.log
    $ECHO -e "Alterar o owner /var/cache/squid/cache.log."
    $CHOWN -R squid:squid /var/log/squid/cache.log
    $ECHO -e "Alterar o owner /var/run/squid.pid."
    $CHOWN -R squid:squid /var/run/squid.pid
    $ECHO -e "Copiar o log_db_daemon."
    $CP /usr/src/$SQUIDPATH/helpers/log_daemon/DB/log_db_daemon.pl.in /usr/lib/squid/log_db_daemon.pl.in
    $ECHO -e "Substituir a variavel PERL."
    $SED -i 's/@PERL@/\/bin\/perl/' /usr/lib/squid/log_db_daemon.pl.in 
    $ECHO -e "Criar uma backup do squid.conf."
    $MV /etc/squid/squid.conf /etc/squid/squid.conf.ori
    $ECHO -e "Mudar a penmissão do pinger."
    $CHMOD 4775 /usr/lib/squid/pinger
    $ECHO -e "Copiar a nova versão do squid.conf."
    $ECHO -e "Lembre-se depois de alterar o seu squid.conf."
    $CP /root/downloads/acessosweb/squid.conf /etc/squid/squid.conf
    $ECHO -e "Rodar o squid -z para criar o cache."
    $SQUID -z
    $ECHO -e "4.7 Criar o System Service Unit File do Squid. \r" 
    $CP /root/downloads/acessosweb/squid.service /etc/systemd/system
    $ECHO -e "Executar o daemon-reload."
    $SYSTEMCTL daemon-reload
    $ECHO -e "Ativar o squid para iniciar automaticamente."
    $SYSTEMCTL enable squid	
    $ECHO -e "4.8 Iniciar o Squid."
    $SYSTEMCTL start squid
    $ECHO -e "Checar a sintaxe no squid.conf."
    $SQUID -k parse
    $ECHO -e "Checar squid."
    $SQUID -k check
    $ECHO -e "FIM, o seu servidor Squid Proxy está em execução."
}

#function squidguard_start() {
#   $ECHO  -e "5. Configurar o Squid Guard \r" 
#   $ECHO  -e "5.1 Instalar o Squid Guard \r" 
#   $APT -y install squidGuard
#   $SLEEP 
#   $GREP squid /etc/passwd
#   if [ $? -eq 0 ];then
#         ECHO -e "Usuario squid existente, vamos alterar\r" 
#	$USERMOD -r -d /var/cache/squid -s /bin/false squid
#   fi
#   $ECHO -e "5.1 Criar usuario Squid \r" 
#   $USERADD -r -d /var/cache/squid -s /bin/false squid
#   $ECHO -e "Usuario squid foi criado \r" 
#   $MKDIR -p /var/squidGuard/blacklists/permitidos
#   $MKDIR -p /var/squidGuard/blacklists/procon
#   $CP /root/downloads/acessosweb/domains /var/squidGuard/blacklists/procon/domains
#   $TOUCH /var/squidGuard/blacklists/permitidos/domains
#   $TOUCH /var/squidGuard/blacklists/permitidos/urls
#   $TOUCH /var/squidGuard/blacklists/permitidos/ips
#   $TOUCH /var/squidGuard/blacklists/procon/urls
#   $TOUCH /var/squidGuard/blacklists/procon/expressions
#   $CHOWN -R squid:squid /var/squidGuard
#   $CHOWN -R squid:squid /var/log/squidGuard
#   $MV /etc/squid/squidGuard.conf /etc/squid/squidGuard.conf.ori
#   $CP /root/downloads/acessosweb/squidGuard.conf /etc/squid/squidGuard.conf
#   $SQUIDG -C all
#   $MKDIR -p /var/www/html/proxy
#   $CP /root/downloads/acessosweb/index.php /var/www/html/proxy/index.php
#   $ECHO -e "SquidGuard instalado \r" 
#   $SLEEP
#}
function jre_start() {
   $ECHO -e "6. Desempacotar Java JRE. \r" 
   $UNZIP /root/downloads/acessosweb/jre-9.0.4_linux-x64_bin.tar.zip
   $TAR /root/downloads/acessosweb/jre-9.0.4_linux-x64_bin.tar -C /usr/lib64
   $ECHO  -e "6.1 Criar link simbolico. \r" 
   $CD /usr/lib64
   $LN -sf /usr/lib64/jre-9.0.4 /usr/lib64/java
   $ECHO -e "6.2 Criar variaveis JAVA. \r" 
   $CP /root/downloads/acessosweb/jre.sh /etc/profile.d/jre.sh
   $CHMOD +x /etc/profile.d/jre.sh
   source /etc/profile.d/jre.sh
   $ECHO $JAVA_HOME
   $JAVA -version
}
function tomcat_start() {
   $ECHO -e "7. Criar usuario tomcat. \r" 
   $USERADD -r -d /home/tomcat/apache-tomcat-8.5.6 -m -s /bin/bash tomcat
   $ECHO  -e "Desempacotar pacote Apache Tomcat. \r" 
   $TAR -xzvf /root/downloads/acessosweb/apache-tomcat-8.5.6.tar.gz -C /home/tomcat
   $ECHO -e "Criar diretório Catalina. \r"
   $MKDIR -p /home/tomcat/apache-tomcat-8.5.6/conf/Catalina/localhost 
   $ECHO -e "Copiar o arquivo manager.xml. \r"
   $CP /root/downloads/acessosweb/manager.xml /home/tomcat/apache-tomcat-8.5.6/conf/Catalina/localhost/
   $ECHO -e "Copiar o arquivo acessosweb.war. \r"
   $CP /root/downloads/acessosweb/acessosweb.war /home/tomcat/apache-tomcat-8.5.6/webapps
   $ECHO -e "Copiar o arquivo tomcat-users.xml. \r"
   $CP /root/downloads/acessosweb/tomcat-users.xml /home/tomcat/apache-tomcat-8.5.6/conf/tomcat-users.xml
   $ECHO -e "Mudar o owner do diretorio tomcat. \r"
   $CHOWN -R tomcat:tomcat /home/tomcat
   $ECHO -e "Configurar Apache Tomcat iniciar automaticamente. \r"       
   $CP /root/downloads/acessosweb/tomcat.service /etc/systemd/system
   $ECHO -e "Reload no system daemon. \r" 
   $SYSTEMCTL daemon-reload
   $ECHO -e "Iniciar Apache Tomcat. \r" 
   $SYSTEMCTL start tomcat.service
}
function firewall_start(){
   $ECHO -e "8. Criando regras de firewall. \r" 
   $ECHO -e "Permitir conexões ssh. \r" 
   $UFW allow 22
   $ECHO -e "Permitir conexões http. \r" 
   $UFW allow 80
   $ECHO -e "Permitir conexões http Apache Tomcat. \r" 
   $UFW allow 8080
   $ECHO -e "Permitir conexões https. \r" 
   $UFW allow 443
   $ECHO -e "Iniciar o Firewall UFW. \r" 
   $UFW enable	
}
function wpad_start(){
   $ECHO -e "9. Criar aquivo wpad.dat. \r" 
   $ECHO -e "Copiar o arquivo. \r" 
   $CP /root/downloads/acessosweb/wpad.dat /var/www/html/wpad.dat
   $ECHO -e "Habilitar o httpd para iniciar com o boot. \r" 
   $SYSTEMCTL enable httpd
   $ECHO -e "Iniciar o Apache. \r" 
   $SYSTEMCTL start httpd

}
function msg_start(){
    $ECHO -e "Sistema instalado ! \r"
    $ECHO -e "Abra o navegador http://ip_do_servidor:8080/acessosweb \r"
}

$ECHO -e "\t
        ***     ***** *****  *****  *****  ******  *****
       ** **    **    **     **     **     **  **  **
      *******   **    *****  *****  *****  **  **  *****
     **     **  **    **         *     **  **  **     **
    **       ** ***** *****  *****  *****  ******  ***** \n"
$ECHO -e "\n"
$ECHO -e "Dashboard moderno para visualizar os logs dos acessos da Internet. Projeto desenvolvido com as tecnologias: Java Web, Apache Tomcat/8.5.6, Mysql e Squid Cache. Todos os direitos reservados 2026. \r"
$ECHO -e "Autor: Luis Montes \r"
$ECHO -e "email: contato@carreiralinux.com.br \r"
$ECHO -e "www.carreiralinux.com.br \n"

$ECHO -e "[ 1 ] Instalar "
$ECHO -e "[ 2 ] Sair "
read -p "Escolha uma alternativa: " OPCAO 
if [ $OPCAO -eq 2 ];then 
    exit
else
        update_start
	install_start
	database_start
	squid_start
	jre_start
        tomcat_start
	firewall_start
	wpad_start
        msg_start
fi
