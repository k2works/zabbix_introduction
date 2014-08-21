# ConnectionInfo
mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

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

# Create a mysql database
mysql_database 'zabbix' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'zabbix' do
  connection mysql_connection_info
  password 'zabbixpassword'
  action :create
end

mysql_database_user 'zabbix' do
  connection mysql_connection_info
  password 'zabbixpassword'
  database_name 'zabbix'
  privileges [:all]
  action :grant
end

template "/etc/zabbix/zabbix_server.conf" do
    owner "root"
    group "root"
    mode "0600"
end
=begin
execute "MySQLデータベースに初期データをインポート" do
  cwd '/usr/share/doc/zabbix-server-mysql-2.2.5/create/'
  command "cat schema.sql images.sql data.sql | mysql -uzabbix -pzabbixpassword zabbix"
end
=end
