FROM ubuntu:22.04

RUN apt-get update && apt-get install -y apache2 git

RUN useradd -m -d /var/www/html -s /bin/bash webuser

USER webuser

WORKDIR /var/www/html

RUN rm -rf /var/www/html/*

RUN git clone git@github.com:Akshat-pixel/financeProject.git /var/www/html