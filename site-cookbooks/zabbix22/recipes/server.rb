# 時刻同期サーバのインストール
%w{ntp}.each do |pkg|
  package pkg do
    action :install
  end
end

# 関連ツールのインストール
%w{bind-utils traceroute net-snmp snmptt ipmitool}.each do |pkg|
  package pkg do
    action :install
  end
end

# ZabbixサーバのRPMをインストール
%w{zabbix zabbix-server zabbix-server-mysql}.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/zabbix/zabbix_server.conf" do
    owner "root"
    group "root"
    mode "0644"
    only_if {File.exists?("/etc/zabbix")}
end
