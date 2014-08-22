# 時刻同期サーバのインストール
%w{ntp}.each do |pkg|
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
