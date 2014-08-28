service "mysqld" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end

service "ntpd" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end

service "zabbix-server" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end

service "httpd" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end
