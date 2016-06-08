docker::run { 'webserver':
  image        => 'httpd:latest',
  ports        => ['80:80'],
  env	       => ['APACHE_LOG_DI=R"/var/log/httpd"', 'APACHE_PID_FILE="/var/run/httpd/httpd.pid"'],
  volumes      => ['/docker-data/www/:/usr/local/apache2/htdocs'],
  hostname     => 'webserver',
}

docker::run { 'dbserver':
  image        => 'mysql:latest',
  env	       => ['MYSQL_ROOT_PASSWORD=crossover', 'MYSQL_USER=crossover', 'MYSQL_PASSWORD=crossover', 'MYSQL_DATABASE=crossover'],
  ports        => ['3006:3006'],
  hostname     => 'dbserver',
}

docker::run { 'monitoring':
  image        => 'icinga/icinga2',
  ports        => ['3080:80'],
  hostname     => 'monitoring',
  volumes      => ['/docker-data/config_files/crossover.conf:/etc/icinga2/conf.d/crossover.conf'],
  links        => ['dbserver:dbserver', 'webserver:webserver'],
  after        => [ 'webserver', 'dbserver' ],
  depends      => [ 'webserver', 'dbserver' ],
}
}
