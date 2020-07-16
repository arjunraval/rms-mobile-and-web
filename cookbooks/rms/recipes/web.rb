# Cookbook: "rms"
# Recipe: "web"

#==========================================================================================================

# DEFINE VARIABLES
apache_dir = node['rms']['apache_dir']
rsa_conf = "#{node['rms']['apache_dir']}/webservers/Apache_#{node['rms']['apache_version']}/conf"

#===========================================================

# COPY EXISTING RSA CONF
execute "copy_config" do
	command "cp -R --no-preserve=ownership /opt/rsa/agent-49SP3-apache/rsa-axm/agent-49SP3-apache/webservers #{apache_dir}/webservers"
  action :run
  not_if do FileTest.directory?("#{apache_dir}/webservers") end
end

#===========================================================

# CONFIGURE APACHE
template "#{apache_dir}/conf/httpd.conf" do
	source "httpd.conf.erb"
	owner node['rms']['appuser']
	group node['rms']['appgroup']
  notifies :run, "execute[restart_apache]", :delayed
  action :create
end

#===========================================================

# CONFIGURE RSA
template "#{rsa_conf}/ct-httpd.conf" do
	source "ct-httpd.conf.erb"
	owner node['rms']['appuser']
	group node['rms']['appgroup']
	mode '0750'
  notifies :run, "execute[restart_apache]", :delayed
  action :create  
end

template "#{rsa_conf}/instances.conf" do
	source "instances.conf.erb"
	owner node['rms']['appuser']
	group node['rms']['appgroup']
	mode '0750'
  notifies :run, "execute[restart_apache]", :delayed
  action :create  
end

template "#{rsa_conf}/rules.xml" do
	source "rules.xml.erb"
	owner node['rms']['appuser']
	group node['rms']['appgroup']
	mode '0750'
  notifies :run, "execute[restart_apache]", :delayed
  action :create   
end

template "#{rsa_conf}/rules.xsd" do
	source "rules.xsd.erb"
	owner node['rms']['appuser']
	group node['rms']['appgroup']
	mode '0750'
  notifies :run, "execute[restart_apache]", :delayed
  action :create   
end

template "#{rsa_conf}/webagent.conf" do
	source "webagent.conf.erb"
	owner node['rms']['appuser']
	group node['rms']['appgroup']
	mode '0750'
  notifies :run, "execute[restart_apache]", :delayed
  action :create  
end

#===========================================================

# STOP / START SERVICES
execute 'restart_apache' do
  command './restartApache.sh'
  cwd "#{apache_dir}/bin"
  action :nothing
end