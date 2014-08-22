%w{ntp}.each do |pkg|
  package pkg do
    action :install
  end
end

execute "Zabbix SIAのyumレポジトリを登録" do
  command "rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm"
  not_if "rpm -qa | grep -q '^zabbix'"
end

%w{zabbix zabbix-server zabbix-server-mysql}.each do |pkg|
  package pkg do
    action :install
  end
end
