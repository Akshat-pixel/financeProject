FROM ubuntu:22.04

RUN apt-get update && apt-get install -y apache2

WORKDIR /var/www/html

COPY . /var/www/html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]