{\rtf1\ansi\ansicpg1252\cocoartf1404\cocoasubrtf470
{\fonttbl\f0\fnil\fcharset0 Calibri;}
{\colortbl;\red255\green255\blue255;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0

\f0\fs24 \cf0 \CocoaLigature0 docker::run \{ 'webserver':\
  image        => 'httpd:latest',\
  ports        => ['80:80'],\
  env	       => ['APACHE_LOG_DI=R"/var/log/httpd"', 'APACHE_PID_FILE="/var/run/httpd/httpd.pid"'],\
  volumes      => ['/docker-data/www/:/usr/local/apache2/htdocs'],\
  hostname     => 'webserver',\
\}\
\
docker::run \{ 'dbserver':\
  image        => 'mysql:latest',\
  env	       => ['MYSQL_ROOT_PASSWORD=crossover', 'MYSQL_USER=crossover', 'MYSQL_PASSWORD=crossover', 'MYSQL_DATABASE=crossover'],\
  ports        => ['3006:3006'],\
  hostname     => 'dbserver',\
\}\
\
docker::run \{ 'monitoring':\
  image        => 'icinga/icinga2',\
  ports        => ['3080:80'],\
  hostname     => 'monitoring',\
  volumes      => ['/docker-data/config_files/crossover.conf:/etc/icinga2/conf.d/crossover.conf'],\
  links        => ['dbserver:dbserver', 'webserver:webserver'],\
  after        => [ 'webserver', 'dbserver' ],\
  depends      => [ 'webserver', 'dbserver' ],\
\}\
}