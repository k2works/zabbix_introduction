execute "Zabbix SIAのyumレポジトリを登録" do
  command "rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm"
  only_if "rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm"
end

%w{zabbix zabbix-server zabbix-server-mysql}.each do |pkg|
  package pkg do
    action :install
  end
end

service "zabbix-server" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end
