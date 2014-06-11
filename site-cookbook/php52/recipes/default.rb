#
# Cookbook Name:: php52
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "wget" do
  action :install
end

remote_file "/vagrant/atomic-release-1.0-19.el6.art.noarch.rpm" do
  source "http://www6.atomicorp.com/channels/atomic/centos/6/x86_64/RPMS/atomic-release-1.0-19.el6.art.noarch.rpm"
end

package "inst-atomic-repo" do
  action :install
  source "/vagrant/atomic-release-1.0-19.el6.art.noarch.rpm"
end

php52_pkg = %w{
  atomic-php52-php atomic-php52-php-bcmath atomic-php52-php-common atomic-php52-php-devel atomic-php52-php-gd
  atomic-php52-php-imap atomic-php52-php-ldap atomic-php52-php-mbstring atomic-php52-php-mcrypt
  atomic-php52-php-mysql atomic-php52-php-ncurses atomic-php52-php-pdo atomic-php52-php-soap
  atomic-php52-php-xml atomic-php52-php-xmlrpc atomic-php52-php-zts
}

php52_pkg.each do |pkg|
  package pkg do
    action :install
  end
end

php_link = {
  "/opt/atomic/atomic-php52/root/etc/php.d" => "/etc/php.d",
  "/opt/atomic/atomic-php52/root/etc/php.ini" => "/etc/php.ini",
  "/opt/atomic/atomic-php52/root/etc/rpm/macros.php" => "/etc/rpm/macros.php",
  "/opt/atomic/atomic-php52/root/usr/bin/php" => "/usr/bin/php",
  "/opt/atomic/atomic-php52/root/usr/bin/php-cgi" => "/usr/bin/php-cgi",
  "/opt/atomic/atomic-php52/root/usr/bin/php-config" => "/usr/bin/php-config",
  "/opt/atomic/atomic-php52/root/usr/bin/phpize" => "/usr/bin/phpize",
  "/opt/atomic/atomic-php52/root/usr/include/php" => "/usr/include/php",
  "/opt/atomic/atomic-php52/root/usr/lib64/httpd/modules/libphp5.so" => "/usr/lib64/httpd/modules/libphp5.so",
  "/opt/atomic/atomic-php52/root/usr/lib64/httpd/modules/libphp5-zts.so" => "/usr/lib64/httpd/modules/libphp5-zts.so",
  "/opt/atomic/atomic-php52/root/usr/lib64/php" => "/usr/lib64/php",
  "/opt/atomic/atomic-php52/root/usr/share/doc/atomic-php52-php-cli-5.2.17" => "/usr/share/doc/atomic-php52-php-cli-5.2.17",
  "/opt/atomic/atomic-php52/root/usr/share/doc/atomic-php52-php-common-5.2.17" => "/usr/share/doc/atomic-php52-php-common-5.2.17",
  "/opt/atomic/atomic-php52/root/usr/share/doc/atomic-php52-php-gd-5.2.17" => "/usr/share/doc/atomic-php52-php-gd-5.2.17",
  "/opt/atomic/atomic-php52/root/usr/share/man/man1/php.1.gz" => "/usr/share/man/man1/php.1.gz",
  "/opt/atomic/atomic-php52/root/usr/share/man/man1/php-config.1.gz" => "/usr/share/man/man1/php-config.1.gz",
  "/opt/atomic/atomic-php52/root/usr/share/man/man1/phpize.1.gz" => "/usr/share/man/man1/phpize.1.gz",
  "/opt/atomic/atomic-php52/root/usr/share/php" => "/usr/share/php",
}

php_link.each do |opt_path, path|
  link path do
    to opt_path
    link_type :symbolic
    action :create
  end
end 

template "php.ini" do
  path "/opt/atomic/atomic-php52/root/etc/php.ini"
  source "php.ini.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, 'service[httpd]'
end

