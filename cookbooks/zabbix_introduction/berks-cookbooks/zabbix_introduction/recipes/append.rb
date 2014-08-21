%w{zabbix-web zabbix-web-mysql zabbix-web-japanese}.each do |pkg|
  package pkg do
    action :install
  end
end
