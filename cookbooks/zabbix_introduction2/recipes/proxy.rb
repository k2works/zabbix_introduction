include_recipe 'mysql::server'
include_recipe 'zabbix22::base'
include_recipe 'zabbix22::proxy'
include_recipe 'zabbix22::agent'
