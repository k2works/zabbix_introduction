execute "Zabbix SIAのyumレポジトリを登録" do
  command "rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm"
  not_if "rpm -qa | grep -q '^zabbix'"
end
