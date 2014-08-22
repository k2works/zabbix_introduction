%w{zabbix zabbix-agent}.each do |pkg|
  package pkg do
    action :install
  end
end

service "zabbix-agent" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end
