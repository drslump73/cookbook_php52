#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{httpd httpd-devel mod_ssl}.each do |pkg|
  package pkg do
  	action :install
  end
end

service "httpd" do
  action [:enable, :start]
end

execute "change japan timezone" do
  command "cp /usr/share/zoneinfo/Japan /etc/localtime"
end

template "httpd.conf" do
  path "/etc/httpd/conf/httpd.conf"
  source "httpd.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, 'service[httpd]'
end

template "httpd japan timezone" do
  path "/etc/sysconfig/httpd"
  source "etc_sysconfig_httpd.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, 'service[httpd]'
end
