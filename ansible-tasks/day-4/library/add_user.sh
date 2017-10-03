
cat << EOF > /opt/tomcat/8.0.46/conf/tomcat-users.xml
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
<user username="super" password="super" roles="admin-gui,standart,manager-gui,manager-script"/>
</tomcat-users>
EOF

#if [ -f "/opt/tomcat/8.0.46/webapps/manager/WEB-INF/web.xml" ]
#then
#	sed -i "s#.*max-file-size.*#\t<max-file-size>52428800</max-file-size>#g" /opt/tomcat/8.0.46/webapps/manager/WEB-INF/web.xml
#	sed -i "s#.*max-request-size.*#\t<max-request-size>52428800</max-request-size>#g" /opt/tomcat/8.0.46/webapps/manager/WEB-INF/web.xml
#fi
