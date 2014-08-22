%w{zabbix-web}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{zabbix-web-pgsql}.each do |pkg|
  package pkg do
    action :remove
  end
end

%w{zabbix-web-mysql}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{zabbix-web-japanese}.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/httpd/conf.d/zabbix.conf" do
    owner "root"
    group "root"
    mode "0600"
end
