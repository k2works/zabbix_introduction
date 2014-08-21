#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# MySQLのインストールと起動
%w{mysql mysql-server mysql-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

service "mysqld" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end

# /etc/my.cnfを修正
template "/etc/my.cnf" do
    owner "root"
    group "root"
    mode "0600"
end

# DBユーザの作成
execute "set root password" do
  command "mysqladmin -u root password '#{node['mysql']['db']['rootpass']}'"
  only_if "mysql -u root -e 'show databases;'"
end

execute "mysql-create-user" do
    command "/usr/bin/mysql -u root --password=\"#{node['mysql']['db']['rootpass']}\"  < /tmp/grants.sql"
    action :nothing
end

template "/tmp/grants.sql" do
    owner "root"
    group "root"
    mode "0600"
    variables(
        :user     => node['mysql']['db']['user'],
        :password => node['mysql']['db']['pass'],
        :database => node['mysql']['db']['database']
    )
    notifies :run, "execute[mysql-create-user]", :immediately
end

# DBの作成
package "mysql-devel" do
    action :install
end

chef_gem "mysql" do
    action :nothing
    subscribes :install, "package[mysql-devel]", :immediately
end

execute "mysql-create-database" do
    command "/usr/bin/mysqladmin -u root create #{node['mysql']['db']['database']}"
    not_if do
        require 'rubygems'
        Gem.clear_paths
        require 'mysql'
        m = Mysql.new(node['mysql']['db']['host'], "root", node['mysql']['db']['rootpass'])
        m.list_dbs.include?(node['mysql']['db']['database'])
    end
end

# 初期データをインポート
