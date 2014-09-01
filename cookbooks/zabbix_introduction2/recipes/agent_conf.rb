%w{elinks}.each do |pkg|
  package pkg do
    action :install
  end
end

#ルートindex.htmlの記述
template "/var/www/html/index.html" do
    source "index.html.erb"
    mode 0644
    variables(
        :message=>node['attrfrom']['message']
    )
end

execute "Enabling site default" do
  user "root"
  cwd "/etc/httpd"
  command "a2ensite default"
  action :run
  notifies :reload, 'service[apache2]'
end

# ConnectionInfo
mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

mysql_database_user 'root' do
  connection mysql_connection_info
  password node['mysql']['server_root_password']
  database_name 'mysql'
  host '192.168.33.%'
  privileges [:all]
  action :grant
end

# Template App MySQLでユーザーパラメータを有効するのに必要
mysql_database_user 'vagrant' do
  connection mysql_connection_info
  password ''
  action :create
end

mysql_database_user 'vagrant' do
  connection mysql_connection_info
  password ''
  database_name 'mysql'
  privileges [:all]
  action :grant
end


mysql_database_user 'testuser' do
  connection mysql_connection_info
  password 'testuserpassword'
  action :create
end

template "/etc/zabbix/zabbix_agentd.conf" do
    source "zabbix_agentd.conf.erb"
    mode 0644
    notifies :restart, 'service[zabbix-agent]'
end
