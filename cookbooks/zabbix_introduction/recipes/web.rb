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

service "httpd" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end

template "/etc/httpd/conf.d/zabbix.conf" do
    owner "root"
    group "root"
    mode "0600"
    notifies :restart, 'service[httpd]', :immediately
    notifies :restart, 'service[zabbix-server]', :immediately
end
