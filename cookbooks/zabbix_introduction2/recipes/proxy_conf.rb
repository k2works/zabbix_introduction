include_recipe 'zabbix22::database'

service "zabbix-agent" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end
