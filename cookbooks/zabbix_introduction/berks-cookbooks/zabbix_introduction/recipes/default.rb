#
# Cookbook Name::
# Recipe:: default
#
# Copyright (C) 2014
#
#
#
bash 'bootstrap' do
  code <<-EOC
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
  EOC
  command "yum update -y"
end

execute "Zabbix SIAのyumレポジトリを登録" do
  command "rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm"
  only_if "yum search zabbix"
end
