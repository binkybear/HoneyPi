#!/bin/bash
#set -x
########################################################################
#recreated the binkybear's HoneyPi.sh  by br0k3ngl255
# meant to be more stealthy & efficient.
########################################################################

###Vars


###Funcs

# =======================
# = UPDATE =
# =======================
f_update(){
cd /var/www/kippo-graph && git pull &&  chmod 777 generated-graphs
cd /opt/kippo-read-only && svn update
cd /opt/glastopf && git pull
cd /opt/honssh && git pull
cd /opt/wordpot && git pull
cd /opt/kippo-malware && git pull
cd /opt/twisted-honeypots && git pull
}

# =======================
# = INSTALLING WORDPOT =
# =======================
f_install_wordpot(){
cd /opt
git clone https://github.com/gbrindisi/wordpot.git
echo "Installed to /opt/wordpot"
sleep 5
f_install
}

# =================================
# = INSTALLING TWISTED HONEYPOTS =
# =================================
f_install_twisted_honeypots(){
	echo "Installing to /opt/twisted-honeypots"
		cd /opt/
		git clone https://code.google.com/p/twisted-honeypots/
		echo "Installed to /opt/twisted-honeypots"
	sleep 5
f_install
}

# =======================
# = INSTALLING DIONAEA =
# =======================
f_install_dionaea(){
echo "deb http://packages.s7t.de/raspbian wheezy main" | tee -a /etc/apt/sources.list
	echo "updating package cache"
 apt-get update >> /dev/null
		apt-get install -y libglib2.0-dev libssl-dev libcurl4-openssl-dev libreadline-dev
		apt-get install -y autoconf build-essential subversion git-core flex bison libsqlite3-dev
		apt-get install -y pkg-config libnl-3-dev libnl-genl-3-dev libnl-nf-3-dev libtool
		apt-get install --force-yes -y libnl-route-3-dev liblcfg libemu libev dionaea-python automake
		apt-get install --force-yes -y dionaea-cython libpcap udns dionaea sqlite3
		apt-get install --force-yes -y p0f
		cp /opt/dionaea/etc/dionaea/dionaea.conf.dist /opt/dionaea/etc/dionaea/dionaea.conf
		chown root:root /opt/dionaea/var/dionaea -R ## might be a problem with debian jessie--> chown utility upgraded to get only gid & not its name (root:0|br0k3ngl255:1000)
		echo "Install finished. Configuration at /opt/dionaea/etc/dionaea/dionaea.conf"
	sleep 5
f_install
}

f_install(){
clear
		echo "************************"
		toilet -f standard -F metal "RUN"
		echo "************************"
			echo "[1] Run Kippo"
			echo "[0] Exit"
			echo -n "Enter your menu choice [0-1]: "
			# wait for character input
				read -p "Choice:" menuchoice
					case $menuchoice in
						1) f_run_kippo ;;
						0) exit 0 ;;
						*) echo "Incorrect choice..." ;
					esac
}

# =======================
# = INSTALLING HONSSH =
# =======================
f_install_honssh(){
 apt-get update
 apt-get install -y python-twisted python-espeak espeak
cd /opt
git clone https://code.google.com/p/honssh/
cd honssh
 chmod +x honsshctrl.sh
echo "Modify /opt/honssh/conssh.cfg manually to set up"
sleep 5
f_install
}

# ===============================
# = INSTALLING MALWARECRAWLER =
# ===============================
f_install_malwarecrawler(){
 apt-get update
 apt-get install -y python-m2crypto python-pyasn1 python-magic python-pip
 pip install hachoir-core hachoir-parser hachoir-regex hachoir-subfile
 pip install httplib2 yapsy beautifulsoup Jinja2 pymongo
cd /opt
 mkdir ragpicker
cd ragpicker
 wget https://malware-crawler.googlecode.com/git/MalwareCrawler/versions/ragpicker_v0.02.10.tar.gz
 tar xvf ragpicker_v0.02.10.tar.gz
 rm -rf ragpicker_v0.02.10.tar.gz
cd /opt
 chown -R pi ragpicker
 chmod 777 ragpicker/dumpdir
echo "Installed to /opt/ragpicker"
sleep 5
f_install
}
# =======================
# = INSTALLING GLASTOPF =
# =======================
f_install_glastopf(){
# DEPENDENCIES #
gpg --keyserver pgpkeys.mit.edu --recv-key 8B48AD6246925553
gpg -a --export 8B48AD6246925553 | apt-key add -
echo "deb http://ftp.debian.org/debian wheezy-backports main contrib non-free" | tee -a /etc/apt/sources.list
 apt-get update
 apt-get install -y python python-openssl python-gevent libevent-dev python-dev build-essential make\
					python-argparse python-chardet python-requests python-sqlalchemy python-lxml\
					python-numpy-dev python-scipy libatlas-dev g++ git php5 php5-dev liblapack-dev gfortran\
					libxml2-dev libxslt-dev libmysqlclient-dev git-core
					 
 pip install --upgrade distribute
 pip install greenlet --upgrade
 pip install cython
 pip install pylibinjection
# INSTALL BFR (PHP DEPENDENCY) #
cd /opt
 git clone git://github.com/glastopf/BFR.git
cd BFR
 phpize
 ./configure
 make && make install
cd modules
 cp bfr.so /usr/lib/php5/20100525+lfs/
echo "zend_extension = /usr/lib/php5/20100525+lfs/bfr.so" |tee -a /etc/php5/cli/php.ini
# INSTALL GLASTOPF #
cd /opt
 git clone https://github.com/glastopf/glastopf.git
cd glastopf
 python setup.py install
cd /opt
 mkdir glastopfi
 service apache2 restart
 rm -rf BFR
echo "Installed to /opt/glastopf"
sleep 5
f_install
}


# =======================
# = INSTALLING KIPPO =
# =======================
f_install_kippo(){
echo "Installing dependencies..."
 apt-get install -y python-pip
 apt-get install -y mysql-server python-mysqldb git
 apt-get install -y subversion python-twisted apache2 authbind
 apt-get install -y libapache2-mod-php5 php5-cli php5-common php5-cgi php5-mysql php5-gd
cd /opt
 svn checkout http://kippo.googlecode.com/svn/trunk/ kippo-read-only
cd /opt/kippo-read-only/kippo/commands
 mv base.py base.py.bakup
 wget https://gist.githubusercontent.com/zwned/5588521/raw/7b351a17c760e48c1efed064aaf73a28b0f36a73/base.py
cd /opt/kippo-read-only/kippo
 mv __init__.py __init__.py.bak
echo "from kippo_extra import loader" |tee -a __init__.py
cd /opt
 chown -R pi /opt/kippo-read-only
 chown -R pi /usr/local/lib/python2.7/
 touch /etc/authbind/byport/22
 chown -R pi /etc/authbind/byport/22
 chmod 777 /etc/authbind/byport/22
 chmod +x /opt/kippo-read-only/start.sh
cd /opt/kippo-read-only/doc/sql
read -p "Enter your mysql password for database installation:" $mysqlpass
read -p "Create a new password for a kippo database:" $kippopass
mysql -h localhost --user="root" --password="$mysqlpass" --execute="CREATE DATABASE kippo;GRANT ALL ON kippo.* TO 'kippo'@'localhost' IDENTIFIED BY '$kippopass';"
mysql -h localhost --user="kippo" --password="$kippopass" --execute="use kippo;source mysql.sql;"
cd /opt/kippo-read-only/
 cp kippo.cfg.dist kippo.cfg
 sed -i 's/ssh_port = 2222/ssh_port = 22/g' /opt/kippo-read-only/kippo.cfg
 sed -i '161s/.*/[database_mysql]/' /opt/kippo-read-only/kippo.cfg
 sed -i 's/#host = localhost/host = localhost/g' /opt/kippo-read-only/kippo.cfg
 sed -i 's/#database = kippo/database = kippo/g' /opt/kippo-read-only/kippo.cfg
 sed -i 's/#username = kippo/username = kippo/g' /opt/kippo-read-only/kippo.cfg
 sed -i 's/#password = secret/password = '$kippopass'/g' /opt/kippo-read-only/kippo.cfg
 sed -i 's/#port = 3306/port = 3306/g' /opt/kippo-read-only/kippo.cfg
 mv start.sh start.sh.bak
echo "
#!/bin/sh
echo -n 'Starting kippo in background...'
authbind --deep twistd -y kippo.tac -l log/kippo.log --pidfile kippo.pid" |tee -a start.sh
echo "Installing Kippo Extra commands"
 pip install kippo-extra
echo "Installing Kippo-Graph which will be available at http://{IPADDRESS_OF_PI}/kippo-graph/"
sleep 3
cd /var/www
 git clone https://github.com/ikoniaris/kippo-graph.git
cd kippo-graph
 chmod 777 generated-graphs
 sed -i 's/username/kippo/' /var/www/kippo-graph/config.php
 sed -i 's/password/$kippopass/' /var/www/kippo-graph/config.php
 sed -i 's/database/kippo;/' /var/www/kippo-graph/config.php
#cd /opt/
#sudo git clone https://github.com/ikoniaris/kippo-malware.git
echo "Your Raspberry Pi SSH port must be changed so kippo can run on port 22"
read -p "Enter new port number" $sshport
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
echo "Backup made to /etc/ssh/sshd_config_backup"
sleep 3
 sed -i 's/Port 22/Port $sshport/' /etc/ssh/sshd_config
echo "SSH will now start on port $sshport"
sleep 10
echo "Restart SSH service with: /etc/init.d/ssh to complete changes."
echo "To run kippo, go into /opt/kippo-read-only/ and run ./start.sh"
echo "Modify the kippo.cfg file to your liking"
sleep 5
f_install
}
# =======================
# = INSTALLING KOJONEY =
# =======================
f_install_kojoney(){
echo "updating apt-get cache"
 apt-get update >> /dev/null
 apt-get install -y python-setuptools python-dev gcc cpp wget m4\
							python-xmpp python-dns python-psycopg2
#python-devel zlib zlib-devel MySQL-python glibc-headers glibc-devel kernel-headers
cd /opt
 wget https://kojoney-patch.googlecode.com/files/kojoney-0.0.5.2.tar.gz
 chmod 777 kojoney-0.0.5.2.tar.gz
 tar -zxvf kojoney-0.0.5.2.tar.gz
 rm -rf kojoney-0.0.5.2.tar.gz
 chmod -R 755 kojoney
cd kojoney
 ./INSTALL.sh
echo "Install to /opt/kojoney"
sleep 5
f_install
}

###
#Main
###
##################################################################
# INSTALL MENU #
##################################################################
f_install(){
if [ $UID == "0" ];then
clear
	echo "************************"
		toilet -f standard -F metal "INSTALL"
	echo "************************"
	echo "[1] Install Kippo (SSH HONEYPOT/Low Intercation)"
	echo "[2] Install Honssh (SSH HONEYPOT/High Interaction)"
	echo "[3] Install Dionaea (Multiple Services/Malware collection)"
	echo "[4] Install Ragpicker (Malware Web Crawler)"
	echo "[5] Install Kojoney (SSH HONEYPOT/Low Intercation)"
	echo "[6] Install Twisted Honeypots (SSH/FTP/Telnet Password Collection/Low Interaction)"
	echo "[7] Install Glastopf (Multiple Services/Low Interaction)"
	echo "[0] Exit to Main Menu"
	echo -n "Enter your menu choice [1-4]: "
# wait for character input
		read -p "Choice:" menuchoice
			case $menuchoice in
				1) f_install_kippo ;;
				2) f_install_honssh ;;
				3) f_install_dionaea ;;
				4) f_install_malwarecrawler ;;
				5) f_install_kojoney ;;
				6) f_install_twisted_honeypots ;;
				7) f_install_glastopf ;;
				0) exit 0 ;;
				*) echo "Incorrect choice..." ;
			esac
else 
 echo "Get Root or Get Lost"
fi
}

f_install
