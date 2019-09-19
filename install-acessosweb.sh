#!/bin/bash

# Binarios
CD="/usr/bin/cd"
CHMOD="/usr/bin/chmod"
CHOWN="/usr/bin/chown"
CP="/usr/bin/cp"
ECHO="/usr/bin/echo"
FIREWALL="/usr/bin/firewall-cmd"
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
SQUIDG="/usr/bin/squidGuard"
SU="/usr/bin/su"
SYSTEMCTL="/usr/bin/systemctl"
TAR="/usr/bin/tar"
TOUCH="/usr/bin/touch"
USERDEL="/usr/sbin/userdel"
USERADD="/usr/sbin/useradd"
WGET="/usr/bin/wget"
YUM="/usr/bin/yum"

$CD /root/downloads/acessosweb

function update_start() {
     $ECHO -e "1. Atualizar sistema operacional"
     $YUM -y update
     $ECHO -e "Sistema operacional atualizado."
     $SLEEP
}

function install_start() {
    $ECHO -e "2. Instalar os pacotes \r" 
    $CHMOD +x /root/downloads/acessosweb/install-packages.sh
    /root/downloads/acessosweb/install-packages.sh
    $WGET -c https://www.carreiralinux.com.br/uploads/jre-9.0.4_linux-x64_bin.tar.gz 
    $ECHO -e "Pacotes instalados. \r" 
    $SLEEP
}

function database_start() {
    $ECHO -e "3. Configurar Banco de Dados MariaDB \r" 
    $ECHO -e "3.1 Configurar para iniciar automaticamente \r" 
    $SYSTEMCTL enable mariadb
    $ECHO -e "3.2 Iniciar MariaDB \r" 
    $SYSTEMCTL start mariadb
    $ECHO -e "3.3 Mudar a senha de root do Banco de Dados \r" 
    $MYSQL_SECURE
    $ECHO -e "3.4 Vamos criar a base de dados Acessos Web \r" 
    $ECHO -e "Agora digite a senha do banco de dados MariaDB \r" 
    $MYSQL -u root -p < /root/downloads/acessosweb/database.sql
    $ECHO -e "3.5 Base de dados ok. \r" 
    $SLEEP
}

function squidguard_start() {
   $ECHO  -e "4. Configurar o Squid Guard \r" 
   $ECHO  -e "4.1 Instalar o Squid Guard \r" 
   $YUM -y install squidGuard
   $SLEEP 
   $GREP squid /etc/passwd
   if [ $? -eq 0 ];then
        $ECHO -e "Remover usuario squid \r" 
	$USERDEL squid
   fi
   $ECHO -e "4.1 Criar usuario Squid \r" 
   $USERADD -r -d /var/cache/squid -s /bin/false squid
   $MKDIR -p /var/squidGuard/blacklists/permitidos
   $MKDIR -p /var/squidGuard/blacklists/procon
   $CP /root/downloads/acessosweb/domains /var/squidGuard/blacklists/procon/domains
   $TOUCH /var/squidGuard/blacklists/permitidos/domains
   $TOUCH /var/squidGuard/blacklists/permitidos/urls
   $TOUCH /var/squidGuard/blacklists/permitidos/ips
   $TOUCH /var/squidGuard/blacklists/procon/urls
   $TOUCH /var/squidGuard/blacklists/procon/expressions
   $CHOWN -R squid:squid /var/squidGuard
   $CHOWN -R squid:squid /var/log/squidGuard
   $MV /etc/squid/squidGuard.conf /etc/squid/squidGuard.conf.ori
   $CP /root/downloads/acessosweb/squidGuard.conf /etc/squid/squidGuard.conf
   $SQUIDG -C all
   $MKDIR -p /var/www/html/proxy
   $CP /root/downloads/acessosweb/index.php /var/www/html/proxy/index.php
   $SYSTEMCTL restart httpd
   $ECHO -e "Squid Guard instalado \r" 
   $SLEEP
}

function squid_start() {
    $ECHO -e "5. Instalar Squid Proxy \r" 
    $ECHO -e "5.1 Desempacotar pacote squid em /usr/src \r" 
    $SLEEP
    $TAR -xjvf /root/downloads/acessosweb/squid-3.5.22.tar.bz2 -C /usr/src
    $ECHO -e "5.2 Configure Squid \r" 
    $SLEEP
    $CD /usr/src/squid-3.5.22/
    $CP /root/downloads/acessosweb/configure.sh /usr/src/squid-3.5.22/configure.sh
    $CHMOD +x /usr/src/squid-3.5.22/configure.sh
    /usr/src/squid-3.5.22/configure.sh
    $ECHO -e "5.3 Make Squid \r" 
    $MAKE
    $ECHO -e "5.4 Make install Squid \r" 
    $SLEEP
    $MAKE install
    $ECHO -e "5.6 Configurar squid.conf \r" 
    $SLEEP
    #$MKDIR /var/cache/squid
    #$MKDIR /var/log/squid
    $TOUCH /var/log/squid/access.log
    $TOUCH /var/log/squid/cache.log
    $TOUCH /var/run/squid.pid
    $CHOWN -R squid:squid /var/cache/squid
    $CHOWN -R squid:squid /var/log/squid
    $CHOWN -R squid:squid /var/run/squid.pid
    $CP /usr/src/squid-3.5.22/helpers/log_daemon/DB/log_db_daemon.pl.in /usr/libexec/squid/log_db_daemon.pl.in
    $SED -i 's/@PERL@/\/bin\/perl/' /usr/libexec/squid/log_db_daemon.pl.in 
    $MV /etc/squid/squid.conf /etc/squid/squid.conf.ori
    $CHMOD 4775 /usr/libexec/squid/pinger
    $CP /root/downloads/acessosweb/squid.conf /etc/squid/squid.conf
    $SQUID -z
    $ECHO -e "5.7 Configurar rc.conf \r" 
    $SLEEP
    $CHMOD +x /etc/rc.d/rc.local
    $GREP "/usr/sbin/squid" /etc/rc.d/rc.local
    if [ $? -eq 1 ]; then
    	$ECHO "/usr/bin/su -c /usr/sbin/squid start" >> /etc/rc.d/rc.local
    fi
    $ECHO -e "5.8 Iniciar Squid \r" 
    $SLEEP
    $SQUID start 
    $SQUID -k parse
    $SQUID -k check
}

function jre_start() {
   $ECHO -e "6. Desempacotar Java JRE \r" 
   $TAR -xzvf /root/downloads/acessosweb/jre-9.0.4_linux-x64_bin.tar.gz -C /usr/lib64
   $ECHO  -e "6.1 Criar link simbolico \r" 
   $CD /usr/lib64
   $LN -sf /usr/lib64/jre-9.0.4 /usr/lib64/java
   $ECHO -e "6.2 Criar variaveis JAVA \r" 
   $CP /root/downloads/acessosweb/jre.sh /etc/profile.d/jre.sh
   $CHMOD +x /etc/profile.d/jre.sh
   source /etc/profile.d/jre.sh
   $ECHO $JAVA_HOME
   $JAVA -version
}
function tomcat_start() {
   $ECHO -e "7. Criar usuario tomcat \r" 
   $USERADD -r -d /home/tomcat -m -s /bin/bash tomcat
   $ECHO  -e "7.1 Desempacotar pacote Apache Tomcat \r" 
   $TAR -xzvf /root/downloads/acessosweb/apache-tomcat-8.5.6.tar.gz -C /home/tomcat
   $CD /home/tomcat/
   $LN -sf /home/tomcat/apache-tomcat-8.5.6/ tomcat
   $MKDIR -p /home/tomcat/apache-tomcat-8.5.6/conf/Catalina/localhost 
   $CP /root/downloads/acessosweb/manager.xml /home/tomcat/apache-tomcat-8.5.6/conf/Catalina/localhost/
   $CP /root/downloads/acessosweb/acessosweb.war /home/tomcat/apache-tomcat-8.5.6/webapps
   $CHOWN -R tomcat:tomcat /home/tomcat
   $ECHO -e "7.2 Iniciar Apache Tomcat \r" 
   $ECHO -e "7.3 Configurar Apache Tomcat iniciar automaticamente \r" 
   $GREP "startup.sh" /etc/rc.d/rc.local
   if [ $? -eq 1 ]; then 
   	$ECHO "/usr/bin/su - tomcat -c /home/tomcat/apache-tomcat-8.5.6/bin/startup.sh" >> /etc/rc.d/rc.local
   fi
   $SU - tomcat -c /home/tomcat/apache-tomcat-8.5.6/bin/startup.sh
}
function firewall_start(){
   $ECHO -e "8. Criando regras de firewall \r" 
   $FIREWALL --permanent --add-port=80/tcp
   $FIREWALL --permanent --add-port=8080/tcp
   $FIREWALL --permanent --add-port=3128/tcp
   $FIREWALL --reload
}
function wpad_start(){
   $ECHO -e "9. Criar aquivo wpad.dat \r" 
   $CP wpad.dat /var/www/html/wpad.dat

}
function msg_start(){
    $ECHO -e "Sistema instalado ! \r"
    $ECHO -e "Abra o navegador http://ip_do_servidor:8080/acessosweb \r"
}

$ECHO -e "\t***     ***** *****  *****  *****  ******  *****
       ** **    **    **     **     **     **  **  **
      *******   **    *****  *****  *****  **  **  *****
     **     **  **    **         *     **  **  **     **
    **       ** ***** *****  *****  *****  ******  ***** \n"
$ECHO -e "Autor: Luis Fernando Montes \r"
$ECHO -e "email: luis@carreiralinux.com.br \r"
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
	squidguard_start
	squid_start
	jre_start
        tomcat_start
	firewall_start
	wpad_start
        msg_start
fi
