#!/bin/bash

function update_os () {
     echo -e "1. Atualizar sistema operacional"
     yum -y update
}

function download_packages () {
   echo -e "2. Criar o diretorio /root/downloads: \r"
   if [ ! -d /root/downloads ]
   then
  	mkdir /root/downloads
   fi
   echo -e "Diretorio /root/downoads existe. \r"
   if [ -d "/root/downloads/acessosweb" ]
   then
        echo -e "Diretorio /root/downloads/acessosweb existe. \r"
        exit
    fi

    echo -e "3. Entrar no diretorio /root/downloads. \r"
    cd /root/downloads
    echo -e "3.1 Download do projeto acessos web \r" 
    if [ ! -f /usr/bin/git ];then
       yum -y install git
    fi
       git clone git://github.com/carreiralinux/acessosweb.git
    if [ ! -f /usr/bin/wget ];then
       yum -y install wget
    fi
       cd /root/downloads/acessosweb
       wget -c https://www.carreiralinux.com.br/uploads/jre-9.0.4_linux-x64_bin.tar.gz 
}

function install_packages () {
   echo -e "4. Instalar os pacotes \r" 
   chmod +x /root/downloads/acessosweb/install-packages.sh
   /root/downloads/acessosweb/install-packages.sh
}

function database () {
   echo -e "5. Configurar Banco de Dados MariaDB \r" 
   echo -e "5.1 Configurar para iniciar automaticamente \r" 
   systemctl enable mariadb
   echo -e "5.2 Iniciar MariaDB \r" 
   systemctl start mariadb
   echo -e "5.3 Mudar a senha de root do Banco de Dados \r" 
   /usr/bin/mysql_secure_installation
   echo -e "5.4 Vamos criar a base de dados Acessos Web \r" 
   echo -e "5.5 Agora digite a senha do banco de dados MariaDB \r" 
   mysql -u root -p < /root/downloads/acessosweb/database.sql
   echo -e "5.5 Base de dados ok. \r" 
   sleep 3
}

function squid_guard () {
   echo -e "Instalar Squid Guard \r" 
   mkdir -p /var/squidGuard/blacklists/permitidos
   mkdir -p /var/squidGuard/blacklists/procon
   touch /var/squidGuard/blacklists/permitidos/domains
   touch /var/squidGuard/blacklists/permitidos/urls
   touch /var/squidGuard/blacklists/permitidos/ips
   touch /var/squidGuard/blacklists/procon/urls
   touch /var/squidGuard/blacklists/procon/expressions
   cd /var/squidGuard/blacklists/procon
   wget -c http://www.carreiralinux.com.br/uploads/squidguard/procon/domains
   chown -R squid:squid /var/squidGuard
   chown -R squid:squid /var/log/squidGuard
   squidGuard -C all
   mv /etc/squid/squidGuard.conf /etc/squid/squidGuard.conf.ori
   cd /etc/squid
   wget -c http://www.carreiralinux.com.br/uploads/squidguard/squidGuard.conf
   mkdir /var/www/html/proxy
   cd /var/www/html/proxy
   wget -c http://www.carreiralinux.com.br/uploads/squidguard/index.php
   systemctl restart httpd
}

function compile_squid () {
   echo -e "6. Instalar Squid Proxy \r" 
   echo -e "6. Criar usuario Squid \r" 
   sleep 2 
   useradd -r -d /var/cache/squid -s /bin/false squid
   echo -e "6.1 Desempacotar pacote squid em /usr/src \r" 
   sleep 2
   tar -xjvf /root/downloads/acessosweb/squid-3.5.22.tar.bz2 -C /usr/src
   echo -e "6.2 Configure Squid \r" 
   sleep 2
   cd /usr/src/squid-3.5.22/
   cp /root/downloads/acessosweb/configure.sh /usr/src/squid-3.5.22/configure.sh
   chmod +x configure.sh
   ./configure.sh
   echo -e "6.3 Make Squid \r" 
   make
   echo -e "6.4 Make install Squid \r" 
   eleep 2
   make install
   echo -e "6.5 Configurar squid.conf \r" 
   sleep 2
   touch /var/log/squid/access.log
   touch /var/log/squid/cache.log
   touch /var/run/squid/squid.pid
   chown -R squid:squid /var/cache/squid
   chown -R squid:squid /var/log/squid
   chown squid:squid /var/run/squid/squid.pid
   cp /usr/src/squid-3.5.22/helpers/log_daemon/DB/log_db_daemon.pl.in /usr/libexec/squid/
   sed -i 's/@PERL@/\/bin\/perl/' /usr/libexec/squid/log_db_daemon.pl.in 
   mv /etc/squid/squid.conf /etc/squid/squid.conf.ori
   chmod 4775 /usr/libexec/squid/pinger
   cp /root/downloads/acessosweb/squid.conf /etc/squid/squid.conf
   squid -z
   echo -e "6.6 Configurar rc.conf \r" 
   sleep 2
   chmod +x /etc/rc.d/rc.local
   echo "/usr/bin/su -c /usr/sbin/squid" >> /etc/rc.d/rc.local
   echo -e "6.7 Iniciar Squid \r" 
   sleep 2
   /usr/sbin/squid
}

function jre () {
   echo -e "7. Desempacotar Java JRE \r" 
   tar -xzvf /root/downloads/acessosweb/jre-9.0.4_linux-x64_bin.tar.gz -C /usr/lib64
   echo -e "7.1 Criar link simbolico \r" 
   cd /usr/lib64
   /usr/bin/ln -s jre-9.0.4/ java
   echo -e "7.2 Criar variaveis JAVA \r" 
   cp /root/downloads/acessosweb/jre.sh /etc/profile.d/jre.sh
   chmod +x /etc/profile.d/jre.sh
   source /etc/profile.d/jre.sh
   echo $JAVA_HOME
   java -version
}
function tomcat () {
   echo -e "8. Criar usuario tomcat \r" 
   useradd -r -d /home/tomcat -m -s /bin/bash tomcat
   echo -e "8.1 Desempacotar pacote Apache Tomcat \r" 
   tar -xzvf /root/downloads/acessosweb/apache-tomcat-8.5.6.tar.gz -C /home/tomcat
   cd /home/tomcat/
   /usr/bin/ln -s apache-tomcat-8.5.6/ tomcat
   mkdir -p /home/tomcat/tomcat/conf/Catalina/localhost 
   cp /root/downloads/acessosweb/manager.xml /home/tomcat/tomcat/conf/Catalina/localhost/
   cp /root/downloads/acessosweb/acessosweb.war /home/tomcat/tomcat/webapps
   chown -R tomcat:tomcat /home/tomcat
   echo -e "8.2 Iniciar Apache Tomcat \r" 
   /usr/bin/su - tomcat -c /home/tomcat/tomcat/bin/startup.sh
   echo -e "8.3 Configurar Apache Tomcat iniciar automaticamente \r" 
   echo "/usr/bin/su - tomcat -c /home/tomcat/tomcat/bin/startup.sh" >> /etc/rc.d/rc.local
}
function firewall (){
   echo -e "Criando regras de firewall \r" 
   firewall-cmd --permanent --add-port=80/tcp
   firewall-cmd --permanent --add-port=8080/tcp
   firewall-cmd --permanent --add-port=3128/tcp
   firewall-cmd --reload
   echo -e "Sistema instalado ! \r"
   echo -e "Abra o navegador http://ip_do_servidor:8080/acessosweb \r"
}

echo -e "\t***     ***** *****  *****  *****  ******  *****
       ** **    **    **     **     **     **  **  **
      *******   **    *****  *****  *****  **  **  *****
     **     **  **    **         *     **  **  **     **
    **       ** ***** *****  *****  *****  ******  ***** \n"
echo -e "Autor: Luis Fernando Montes \r"
echo -e "email: luis@carreiralinux.com.br \r"
echo -e "www.carreiralinux.com.br \n"

echo -e "[ 1 ] Instalar "
echo -e "[ 2 ] Sair "
read -p "Escolha uma alternativa: " OPCAO; 
if [ $OPCAO -eq 2 ] 
  then
    exit
else
        update_os
	download_packages
	install_packages
	database
	squid_guard
	compile_squid
	jre
        tomcat
	firewall
fi
