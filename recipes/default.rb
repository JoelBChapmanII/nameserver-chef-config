#
# Cookbook:: nameserver-chef-config
# Recipe:: default

# Resource: Installs bind9, bind9utils, and bind9-doc
#
# Expected inputs: Nil
#
# Expected end state: Packages bind9, bind9utils, and bind9-doc are installed
apt_package %w(bind9 bind9utils bind9-doc) do
  action :install
end

# Resource: Configures bind9.service for IPv4 and reloads the daemon
#
# Expected inputs: None
#
# Expected end state: bind9 service is set to use IPv4 and not IPv6 & 4
systemd_unit 'bind9.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=BIND Domain Name Server
  Documentation=man:named(8)
  After=network.target

  [Service]
  EnvironmentFile=/etc/default/bind9
  ExecStart=/usr/sbin/named -f -u bind -4
  ExecReload=/usr/sbin/rndc reload
  ExecStop=/usr/sbin/rndc stop

  [Install]
  WantedBy=multi-user.target
  EOU
  action [:create, :enable]
end

# Resource: Configures named.conf.options for DNS caching
#
# Expected inputs: named.conf.options.erb
#
# Expected end state: named.conf.options is set up to forward to
#   specified server
template 'named.conf.options.erb' do
  source 'named.conf.options.erb'
  path '/etc/bind/named.conf.options'
end
