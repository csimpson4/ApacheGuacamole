#Created by Jonathan Johnson
#Only supports Ubuntu 16.04

#!/bin/bash

#Checking to see if user is running as root
if [[ $EUID -ne 0 ]]; then
   echo "You need to be root to run this script."
   exit 1
fi


apt-get install libcairo2-dev libjpeg62-dev libpng12-dev libossp-uuid-dev libfreerdp-dev libpango1.0-dev libssh2-1-dev libssh-dev tomcat7 tomcat7-admin tomcat7-user -y

wget http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-0.9.9.tar.gz

tar zxf guacamole-server-0.9.9.tar.gz

cd guacamole-server-0.9.9

sudo ./configure

sudo make

sudo make install

ldconfig

cd ../

wget http://sourceforge.net/projects/guacamole/files/current/binary/guacamole-0.9.9.war 

mv guacamole-0.9.9.war /var/lib/tomcat7/webapps/guacamole.war

sudo mkdir /usr/share/tomcat7/.guacamole

sudo mkdir /etc/guacamole/

sudo cp resources/guacamole.properties /etc/guacamole/guacamole.properties

ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat7/.guacamole/

cp resources/user-mapping.xml /etc/guacamole/user-mapping.xml
#Start keystore
keytool -genkey -alias tomcat -keyalg RSA -keystore /etc/tomcat7/.keystore<<EOF
guacadmin
guacadmin






yes
guacadmin
gaucadmin
EOF
#End Keystore
cp resources/server.xml /etc/tomcat7/server.xml

cp resources/web.xml /etc/tomcat7/web.xml

sudo mv resources/sshd_config /etc/ssh/sshd_config
sudo mv resources/guac /etc/cron.d/guac

service tomcat7 start

cd ../
rm -r ApacheGuacamole/

/usr/local/sbin/guacd &

service tomcat7 restart

echo "Installation is complete!!"


echo "Go to https://localhost:8443/guacamole to visit Apache Guacamole"

