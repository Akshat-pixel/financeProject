FROM ubuntu:22.04

RUN apt-get update && apt-get install -y apache2 git

RUN useradd -m -d /var/www/html -s /bin/bash webuser \
&& chown -R webuser:webuser /var/www/html

WORKDIR /var/www/html

RUN rm -rf /var/www/html/*

RUN git clone https://github.com/Akshat-pixel/financeProject.git /var/www/html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]