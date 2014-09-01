%w{zabbix zabbix-agent}.each do |pkg|
  package pkg do
    action :install
  end
end

service "zabbix-agent" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end

template "/etc/zabbix/zabbix_agentd.conf" do
    owner "root"
    group "root"
    mode "0644"
    only_if {File.exists?("/etc/zabbix")}
end
