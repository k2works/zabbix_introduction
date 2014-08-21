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

%w{ntp}.each do |pkg|
  package pkg do
    action :install
  end
end

service "ntpd" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end
