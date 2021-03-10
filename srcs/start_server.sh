#!bin/bash

service mysql restart
service php7.3-fpm start
service nginx restart

echo "docker build -t ft_server ."
echo "docker run --name MYSERVER -it -p80:80 -p443:443 ft_server:lastest"
echo "https://localhost"

bash
