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

=begin
remote_file "#{Chef::Config[:file_cache_path]}/zabbix-release-2.2-1.el6.noarch.rpm" do
  source "http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm"
  not_if "rpm -qa | grep -q '^zabbix'"
end
=end
=begin
package "zabbix" do
  action :install
  provider Chef::Provider::Package::Rpm
  source "#{Chef::Config[:file_cache_path]}/zabbix-release-2.2-1.el6.noarch.rpm"
end

package "zabbix-server" do
  source "#{Chef::Config[:file_cache_path]}/zabbix-release-2.2-1.el6.noarch.rpm"
  action :nothing
end

package "zabbix-server-mysql" do
  source "#{Chef::Config[:file_cache_path]}/zabbix-release-2.2-1.el6.noarch.rpm"
  action :nothing
end
=end
