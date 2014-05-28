# Default Root/mysql Password: honeypi
# Kippo mysql database: kippo / kippopi
# SSH port: ssh pi@IPADDRESS:65534

# SOFTWARE
#
# # Glastopf - Vulnerable web server
# # Dionaea - Low interaction malware trap
# # Honssh - High Interaction MiTM SSH Honeypot
# # Kippo - SSH Honeypot
# # Wordpot - Wordpress Honeypot
# # Ragpicker - Malware Crawler
# # Twisted Honeypots - Simple password collection python scripts w/ no shell
# https://www.digitalocean.com/community/articles/how-to-set-up-an-artillery-honeypot-on-an-ubuntu-vps

##################################################################
#                   		MENU                                 #
##################################################################
f_interface(){

clear
echo "************************"
echo "        HoneyPI         "
echo "************************"
echo "[1] Update Honeypi Programs"
echo "[2] Install Menu"
echo "[3] Run Programs"
echo "[4] Change timezone"
echo "[0] Exit"
echo -n "Enter your menu choice [1-4]: "

# wait for character input

read -p "Choice:" menuchoice

case $menuchoice in

1) f_update ;;
2) f_install ;;
3) f_run ;;
4) dpkg-reconfigure tzdata;;
0) exit 0 ;;
*) echo "Incorrect choice..." ;
esac

}
##################################################################
#                   INSTALL MENU                                 #
##################################################################
f_install(){
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
0) f_interface ;;
*) echo "Incorrect choice..." ;
esac

}
##################################################################
#                  		 RUN MENU                                #
##################################################################
f_install(){
clear
echo "************************"
toilet -f standard -F metal "RUN"
echo "************************"
echo "[1] Run Kippo"
echo "[0] Exit"
echo -n "Enter your menu choice [1-4]: "

# wait for character input

read -p "Choice:" menuchoice

case $menuchoice in

1) f_run_kippo ;;
0) exit 0 ;;
*) echo "Incorrect choice..." ;
esac

}
# =======================
# =     UPDATE          =
# =======================
f_update(){
cd /var/www/kippo-graph && sudo git pull && sudo chmod 777 generated-graphs
cd /opt/kippo-read-only && sudo svn update
cd /opt/glastopf && sudo git pull
cd /opt/honssh && sudo git pull
cd /opt/wordpot && sudo git pull
cd /opt/kippo-malware && sudo git pull
cd /opt/twisted-honeypots && sudo git pull
}
# =======================
# = INSTALLING DIONAEA  =
# =======================
f_install_dionaea(){
echo "deb http://packages.s7t.de/raspbian wheezy main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get install -y libglib2.0-dev libssl-dev libcurl4-openssl-dev libreadline-dev
sudo apt-get install -y autoconf build-essential subversion git-core flex bison libsqlite3-dev
sudo apt-get install -y pkg-config libnl-3-dev libnl-genl-3-dev libnl-nf-3-dev libtool
sudo apt-get install --force-yes -y libnl-route-3-dev liblcfg libemu libev dionaea-python automake
sudo apt-get install --force-yes -y dionaea-cython libpcap udns dionaea sqlite3
sudo apt-get install --force-yes -y p0f 
sudo cp /opt/dionaea/etc/dionaea/dionaea.conf.dist /opt/dionaea/etc/dionaea/dionaea.conf
sudo chown nobody:nogroup /opt/dionaea/var/dionaea -R
echo "Install finished. Configuration at /opt/dionaea/etc/dionaea/dionaea.conf"
sleep 5
f_install
}
# =================================
# = INSTALLING TWISTED HONEYPOTS  =
# =================================
f_install_twisted_honeypots(){
echo "Installing to /opt/twisted-honeypots"
cd /opt/
sudo git clone https://code.google.com/p/twisted-honeypots/
echo "Installed to /opt/twisted-honeypots"
sleep 5
f_install
}
# =======================
# = INSTALLING HONSSH   =
# =======================
f_install_honssh(){
sudo apt-get update
sudo apt-get install -y python-twisted python-espeak espeak
cd /opt
git clone https://code.google.com/p/honssh/
cd honssh
sudo chmod +x honsshctrl.sh
echo "Modify /opt/honssh/conssh.cfg manually to set up"
sleep 5
f_interface
}
# ===============================
# = INSTALLING MALWARECRAWLER   =
# ===============================
f_install_malwarecrawler(){
sudo apt-get update
sudo apt-get install -y python-m2crypto python-pyasn1 python-magic python-pip
sudo pip install hachoir-core hachoir-parser hachoir-regex hachoir-subfile
sudo pip install httplib2 yapsy beautifulsoup Jinja2 pymongo
cd /opt
sudo mkdir ragpicker
cd ragpicker
sudo wget https://malware-crawler.googlecode.com/git/MalwareCrawler/versions/ragpicker_v0.02.10.tar.gz
sudo tar xvf ragpicker_v0.02.10.tar.gz
sudo rm -rf ragpicker_v0.02.10.tar.gz
cd /opt
sudo chown -R pi ragpicker
sudo chmod 777 ragpicker/dumpdir
echo "Installed to /opt/ragpicker"
sleep 5
f_install
}
# =======================
# = INSTALLING KOJONEY  =
# =======================
f_install_kojoney(){
sudo apt-get update
sudo apt-get install -y python-setuptools python-dev
sudo apt-get install -y gcc cpp wget m4
sudo apt-get install -y python-xmpp python-dns python-psycopg2
#python-devel zlib zlib-devel MySQL-python glibc-headers glibc-devel kernel-headers 
cd /opt
sudo wget https://kojoney-patch.googlecode.com/files/kojoney-0.0.5.2.tar.gz
sudo chmod 777 kojoney-0.0.5.2.tar.gz
sudo tar -zxvf kojoney-0.0.5.2.tar.gz
sudo rm -rf kojoney-0.0.5.2.tar.gz
sudo chmod -R 755 kojoney
cd kojoney
sudo ./INSTALL.sh
echo "Install to /opt/kojoney"
sleep 5
f_install
}
# =======================
# = INSTALLING WORDPOT  =
# =======================
f_install_wordpot(){
cd /opt
sudo git clone https://github.com/gbrindisi/wordpot.git
echo "Installed to /opt/wordpot"
sleep 5
f_install
}
# =======================
# = INSTALLING KIPPO    =
# =======================
f_install_kippo(){
echo "Installing dependencies..."
sudo apt-get install -y python-pip
sudo apt-get install -y mysql-server python-mysqldb git
sudo apt-get install -y subversion python-twisted apache2 authbind
sudo apt-get install -y libapache2-mod-php5 php5-cli php5-common php5-cgi php5-mysql php5-gd
cd /opt
sudo svn checkout http://kippo.googlecode.com/svn/trunk/ kippo-read-only
cd /opt/kippo-read-only/kippo/commands
sudo mv base.py base.py.bakup
sudo wget https://gist.githubusercontent.com/zwned/5588521/raw/7b351a17c760e48c1efed064aaf73a28b0f36a73/base.py
cd /opt/kippo-read-only/kippo
sudo mv __init__.py __init__.py.bak
echo "from kippo_extra import loader" | sudo tee -a __init__.py
cd /opt
sudo chown -R pi /opt/kippo-read-only
sudo chown -R pi /usr/local/lib/python2.7/
sudo touch /etc/authbind/byport/22
sudo chown -R pi /etc/authbind/byport/22
sudo chmod 777 /etc/authbind/byport/22
sudo chmod +x /opt/kippo-read-only/start.sh
cd /opt/kippo-read-only/doc/sql
read -p "Enter your mysql password for database installation:" $mysqlpass
read -p "Create a new password for a kippo database:" $kippopass
mysql -h localhost --user="root" --password="$mysqlpass" --execute="CREATE DATABASE kippo;GRANT ALL ON kippo.* TO 'kippo'@'localhost' IDENTIFIED BY '$kippopass';"
mysql -h localhost --user="kippo" --password="$kippopass" --execute="use kippo;source mysql.sql;"
cd /opt/kippo-read-only/
sudo cp kippo.cfg.dist kippo.cfg
sudo sed -i 's/ssh_port = 2222/ssh_port = 22/g' /opt/kippo-read-only/kippo.cfg
sudo sed -i '161s/.*/[database_mysql]/' /opt/kippo-read-only/kippo.cfg
sudo sed -i 's/#host = localhost/host = localhost/g' /opt/kippo-read-only/kippo.cfg
sudo sed -i 's/#database = kippo/database = kippo/g' /opt/kippo-read-only/kippo.cfg
sudo sed -i 's/#username = kippo/username = kippo/g' /opt/kippo-read-only/kippo.cfg
sudo sed -i 's/#password = secret/password = '$kippopass'/g' /opt/kippo-read-only/kippo.cfg
sudo sed -i 's/#port = 3306/port = 3306/g' /opt/kippo-read-only/kippo.cfg
sudo mv start.sh start.sh.bak
echo "
#!/bin/sh
echo -n 'Starting kippo in background...'
authbind --deep twistd -y kippo.tac -l log/kippo.log --pidfile kippo.pid" | sudo tee -a start.sh
echo "Installing Kippo Extra commands"
sudo pip install kippo-extra
echo "Installing Kippo-Graph which will be available at http://{IPADDRESS_OF_PI}/kippo-graph/"
sleep 3
cd /var/www
sudo git clone https://github.com/ikoniaris/kippo-graph.git
cd kippo-graph
sudo chmod 777 generated-graphs
sudo sed -i 's/username/kippo/' /var/www/kippo-graph/config.php
sudo sed -i 's/password/$kippopass/' /var/www/kippo-graph/config.php
sudo sed -i 's/database/kippo;/' /var/www/kippo-graph/config.php
#cd /opt/
#sudo git clone https://github.com/ikoniaris/kippo-malware.git
echo "Your Raspberry Pi SSH port must be changed so kippo can run on port 22"
read -p "Enter new port number" $sshport
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
echo "Backup made to /etc/ssh/sshd_config_backup"
sleep 3
sudo sed -i 's/Port 22/Port $sshport/' /etc/ssh/sshd_config
echo "SSH will now start on port $sshport"
sleep 10
echo "Restart SSH service with: /etc/init.d/ssh to complete changes."
echo "To run kippo, go into /opt/kippo-read-only/ and run ./start.sh"
echo "Modify the kippo.cfg file to your liking"
sleep 5
f_install
}

# =======================
# = INSTALLING GLASTOPF =
# =======================
f_install_glastopf(){
# DEPENDENCIES #
gpg --keyserver pgpkeys.mit.edu --recv-key  8B48AD6246925553      
gpg -a --export 8B48AD6246925553 | sudo apt-key add -
echo "deb http://ftp.debian.org/debian wheezy-backports main contrib non-free" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get install -y python python-openssl python-gevent libevent-dev python-dev build-essential make
sudo apt-get install -y python-argparse python-chardet python-requests python-sqlalchemy python-lxml
sudo apt-get install -y python-numpy-dev python-scipy libatlas-dev g++ git php5 php5-dev liblapack-dev gfortran
sudo apt-get install -y libxml2-dev libxslt-dev libmysqlclient-dev git-core
sudo pip install –-upgrade distribute
sudo pip install greenlet --upgrade
sudo pip install cython 
sudo pip install pylibinjection
# INSTALL BFR (PHP DEPENDENCY) #
cd /opt
sudo git clone git://github.com/glastopf/BFR.git
cd BFR
sudo phpize
sudo ./configure
sudo make && make install
cd modules
sudo cp bfr.so /usr/lib/php5/20100525+lfs/
echo "zend_extension = /usr/lib/php5/20100525+lfs/bfr.so" | sudo tee -a /etc/php5/cli/php.ini
# INSTALL GLASTOPF #
cd /opt
sudo git clone https://github.com/glastopf/glastopf.git
cd glastopf
sudo python setup.py install
cd /opt
sudo mkdir glastopfi
sudo service apache2 restart
sudo rm -rf BFR
echo "Installed to /opt/glastopf"
sleep 5
f_install
}
# =======================
# =  RUNNING GLASTOPF   =
# =======================
f_run_glastopf(){
service apache2 start
cd /opt/glastopfi && sudo glastopf-runner
}
# =======================
# =  RUNNING DIONAEA   =
# =======================
f_run_dionaea(){
export PATH=$PATH:/opt/dionaea/bin
dionaea -l all,debug -r /opt/dionaea -w /opt/dionaea -p /opt/dionaea/var/dionaea.pid
}
# =======================
# =  RUNNING RAGPICKER  =
# =======================
f_run_ragpicker(){
python /opt/ragpicker/ragpicker.py -t 5 --log-filename=/opt/ragpicker/log.txt
}
# =======================
# =  RUNNING HONSSH  =
# =======================
f_run_honssh(){
cd /opt/honssh
sudo ./honsshctrl START
}
# =======================
# =  RUNNING KIPPO  =
# =======================
f_run_kippo(){
cd /opt/kippo-read-only
./start.sh
}
# =======================
# =  BEING PROGRAM	  =
# =======================
f_interface