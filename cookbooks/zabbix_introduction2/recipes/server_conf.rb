include_recipe 'zabbix22::database'
include_recipe 'zabbix22::agent'
include_recipe 'zabbix22::service'

# ODBCの設定
%w{unixODBC mysql-connector-odbc}.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/odbcinst.ini" do
    source "odbcinst.ini.erb"
    mode 0644
end

template "/etc/odbc.ini" do
    source "odbc.ini.erb"
    mode 0644
end
