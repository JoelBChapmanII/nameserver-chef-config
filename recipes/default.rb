#
# Cookbook:: nameserver-chef-config
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Resource: Installs bind9, bind9utils, and bind9-doc
#
# Expected inputs: Nil
#
# Expected end state: Packages bind9, bind9utils, and bind9-doc are installed
apt_package %w(bind9 bind9utils bind9-doc) do
  action :install
end

# Resource: Configures named.conf.options for DNS caching
#
# Expected inputs: named.conf.options.erb
#
# Expected end state: named.conf.options is set up to forward to
#   specified server
template 'named.conf.options.erb' do
  source 'named.conf.options.erb'
  path 'etc/bind/named.conf.options'
end
