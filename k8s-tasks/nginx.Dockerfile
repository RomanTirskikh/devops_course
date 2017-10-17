FROM nginx
MAINTAINER ROMAN TIRSKIKH
COPY ./html/env.sh /env.sh #копируем скрипт
CMD /bin/bash /env.sh > /usr/share/nginx/html/index.html; nginx -g 'daemon off;' #комманды при запуске