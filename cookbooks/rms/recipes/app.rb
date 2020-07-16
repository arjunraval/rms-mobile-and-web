# Cookbook: "rms"
# Recipe: "app"

#==========================================================================================================

# DEFINE VARIABLES
cardless_tar_download = "#{Chef::Config['file_cache_path']}/cardless-atm-service-web.tar"
cardless_tar_package = node['rms']['cardless_tar']
cardless_tar_structure = "cardless-atm-service-web"
cardless_war_name = "cardless-atm-service-web"
#company_tar_download = "#{Chef::Config['file_cache_path']}/smb-company-service-web.tar"
#company_tar_package = node['rms']['company_tar']
#company_tar_structure = "smb-company-api"
#company_war_name = "smb-company-api"
product_tar_download = "#{Chef::Config['file_cache_path']}/product-selector-web.tar"
product_tar_package = node['rms']['product_tar']
product_tar_structure = "product-selector-web"
product_war_name = "product-selector-web"

 # Lobby One information
lobbyone_tar_download = "#{Chef::Config['file_cache_path']}/lobby-one.tar"
lobbyone_tar_package = node['rms']['lobbyone_tar']
lobbyone_tar_structure = "lobby-one"
lobbyone_war_name = "lobby-one"

tomcat_dir = node['rms']['tomcat_dir']

#===========================================================

# SETUP ENVIRONMENT
template "#{tomcat_dir}/bin/setenv.sh" do
	source 'setenv.sh.erb'
	owner node['rms']['appuser']
	group node['rms']['appgroup']  
  notifies :run, "execute[stop_tomcat]", :immediately
  notifies :run, "execute[start_tomcat]", :delayed 
	action :create
end

template "#{tomcat_dir}/conf/server.xml" do
	source 'server.xml.erb'
	owner node['rms']['appuser']
	group node['rms']['appgroup']  
  notifies :run, "execute[stop_tomcat]", :immediately
  notifies :run, "execute[start_tomcat]", :delayed 
	action :create
end

#===========================================================

# CONFIGURE CERTS
directory "#{tomcat_dir}/appConfig/certs" do
  owner node['rms']['appuser']
  group node['rms']['appgroup']
	recursive true  
	action :create 
end

cookbook_file "#{tomcat_dir}/appConfig/certs/#{node['rms']['rtm_keystore_cert_name']}" do
	source node['rms']['rtm_keystore_cert_name']
  owner node['rms']['appuser']
  group node['rms']['appgroup']
	action :create 
end

cookbook_file "#{tomcat_dir}/appConfig/certs/#{node['rms']['rtm_truststore_cert_name']}" do
	source node['rms']['rtm_truststore_cert_name']
  owner node['rms']['appuser']
  group node['rms']['appgroup']
	action :create
end

cookbook_file "#{tomcat_dir}/appConfig/certs/#{node['rms']['dgw_keystore_cert_name']}" do
	source node['rms']['dgw_keystore_cert_name']
  owner node['rms']['appuser']
  group node['rms']['appgroup']
	action :create 
end

cookbook_file "#{tomcat_dir}/appConfig/certs/#{node['rms']['dgw_truststore_cert_name']}" do
	source node['rms']['dgw_truststore_cert_name']
  owner node['rms']['appuser']
  group node['rms']['appgroup']
	action :create
end

#===========================================================

# CARDLESS ATM: CONFIGURE APPLICATION IF NEW TAR
remote_file "download_cardless_tar" do
  path cardless_tar_download
  source cardless_tar_package
  owner node['rms']['appuser']
  group node['rms']['appgroup']
	notifies :delete, "directory[delete_old_cardless_webapp]", :delayed
  notifies :run, "execute[extract_cardless_tar]", :delayed
  notifies :run, "execute[stop_tomcat]", :immediately  
  action :create
end

directory "delete_old_cardless_webapp" do
  path "#{tomcat_dir}/webapps/#{cardless_war_name}"
  ignore_failure true
  recursive true
  action :nothing
end

execute "extract_cardless_tar" do
	command "tar -xvf #{cardless_tar_download}"
	cwd Chef::Config['file_cache_path']
	notifies :run, "execute[move_cardless_war]", :immediately
  action :nothing
  only_if { :: File.exist?(cardless_tar_download) }
end

execute "move_cardless_war" do
	command "cp -rfa #{Chef::Config['file_cache_path']}/#{cardless_tar_structure}/Development/#{cardless_tar_structure}/#{cardless_war_name}.war #{tomcat_dir}/webapps"
  notifies :run, "execute[move_cardless_config]", :immediately
  action :nothing
  only_if { :: File.exist?(cardless_tar_download) }
end

execute "move_cardless_config" do
	command "cp -rfa #{Chef::Config['file_cache_path']}/#{cardless_tar_structure}/AppConfiguration/* #{tomcat_dir}/appConfig"
	notifies :delete, "directory[delete_old_cardless_cache]", :immediately
	notifies :run, "execute[start_tomcat]", :delayed  
  action :nothing
  only_if { :: File.exist?(cardless_tar_download) }
end

directory "delete_old_cardless_cache" do
  path "#{Chef::Config['file_cache_path']}/#{cardless_tar_structure}"
  ignore_failure true
  recursive true
  action :nothing
end

#===========================================================

# PRODUCT SELECTOR: CONFIGURE APPLICATION IF NEW TAR
remote_file "download_product_tar" do
  path product_tar_download
  source product_tar_package
  owner node['rms']['appuser']
  group node['rms']['appgroup']
	notifies :delete, "directory[delete_old_product_webapp]", :delayed  
	notifies :run, "execute[extract_product_tar]", :delayed
  notifies :run, "execute[stop_tomcat]", :immediately
  action :create
end

directory "delete_old_product_webapp" do
  path "#{tomcat_dir}/webapps/#{product_war_name}"
  ignore_failure true
  recursive true
  action :nothing
end

execute "extract_product_tar" do
	command "tar -xvf #{product_tar_download}"
	cwd Chef::Config['file_cache_path']
	notifies :run, "execute[move_product_war]", :immediately
  action :nothing
  only_if { :: File.exist?(product_tar_download) }
end

execute "move_product_war" do
	command "cp -rfa #{Chef::Config['file_cache_path']}/#{product_tar_structure}/Development/#{product_tar_structure}/#{product_war_name}.war #{tomcat_dir}/webapps"
	notifies :run, "execute[move_product_config]", :immediately
  action :nothing
  only_if { :: File.exist?(product_tar_download) }
end

execute "move_product_config" do
	command "cp -rfa #{Chef::Config['file_cache_path']}/#{product_tar_structure}/AppConfiguration/* #{tomcat_dir}/appConfig"
	notifies :delete, "directory[delete_old_product_app_cache]", :immediately
	notifies :run, "execute[start_tomcat]", :delayed  
  action :nothing
  only_if { :: File.exist?(product_tar_download) }
end

directory "delete_old_product_app_cache" do
  path "#{Chef::Config['file_cache_path']}/#{product_tar_structure}"
  ignore_failure true  
  recursive true
  action :nothing
end

#===========================================================

#=========================== LOBBY ONE START =======================

# LOBBY ONE: CONFIGURE APPLICATION IF NEW TAR
remote_file "download_lobbyone_tar" do
  path lobbyone_tar_download
  source lobbyone_tar_package
  owner node['rms']['appuser']
  group node['rms']['appgroup']
  notifies :delete, "directory[delete_old_lobbyone_webapp]", :delayed  
  notifies :run, "execute[extract_lobbyone_tar]", :delayed
  notifies :run, "execute[stop_tomcat]", :immediately
  action :create
end

directory "delete_old_lobbyone_webapp" do
  path "#{tomcat_dir}/webapps/#{lobbyone_war_name}"
  ignore_failure true
  recursive true
  action :nothing
end

execute "extract_lobbyone_tar" do
  command "tar -xvf #{lobbyone_tar_download}"
  cwd Chef::Config['file_cache_path']
  notifies :run, "execute[move_lobbyone_war]", :immediately
  action :nothing
  only_if { :: File.exist?(lobbyone_tar_download) }
end

execute "move_lobbyone_war" do
  command "cp -rfa #{Chef::Config['file_cache_path']}/#{lobbyone_tar_structure}/Development/#{lobbyone_tar_structure}/#{lobbyone_war_name}.war #{tomcat_dir}/webapps"
  notifies :run, "execute[move_lobbyone_config]", :immediately
  action :nothing
  only_if { :: File.exist?(lobbyone_tar_download) }
end

# since there is no configuration folder for lobby one project, we are just listing the files
execute "move_lobbyone_config" do
  command "ls"
  notifies :delete, "directory[delete_old_lobbyone_app_cache]", :immediately
  notifies :run, "execute[start_tomcat]", :delayed  
  action :nothing
  only_if { :: File.exist?(lobbyone_tar_download) }
end

directory "delete_old_lobbyone_app_cache" do
  path "#{Chef::Config['file_cache_path']}/#{lobbyone_tar_structure}"
  ignore_failure true  
  recursive true
  action :nothing
end

#=========================== LOBBY ONE END =======================

# SMB COMPANY: CONFIGURE APPLICATION IF NEW TAR -Commenting out per Deep Dive
#remote_file "download_company_tar" do
#  path company_tar_download
#  source company_tar_package
#  owner node['rms']['appuser']
#  group node['rms']['appgroup']
#  notifies :delete, "directory[delete_old_company_webapp]", :delayed
#  notifies :run, "execute[extract_company_tar]", :delayed
#  notifies :run, "execute[stop_tomcat]", :immediately  
#  action :create
#end

#directory "delete_old_company_webapp" do
#  path "#{tomcat_dir}/webapps/#{company_war_name}"
#  ignore_failure true
#  recursive true
#  action :nothing
#end

#execute "extract_company_tar" do
#  command "tar -xvf #{company_tar_download}"
#  cwd Chef::Config['file_cache_path']
#  notifies :run, "execute[move_company_war]", :immediately
#  action :nothing
#  only_if { :: File.exist?(company_tar_download) }
#end

#execute "move_company_war" do
#  command "cp -rfa #{Chef::Config['file_cache_path']}/#{company_tar_structure}/Development/#{company_tar_structure}/#{company_war_name}.war #{tomcat_dir}/webapps"
#  notifies :run, "execute[move_company_config]", :immediately
#  action :nothing
#  only_if { :: File.exist?(company_tar_download) }
#end

#execute "move_company_config" do
#  command "cp -rfa #{Chef::Config['file_cache_path']}/#{company_tar_structure}/AppConfiguration/* #{tomcat_dir}/appConfig"
#  notifies :delete, "directory[delete_old_company_cache]", :immediately
#  notifies :run, "execute[start_tomcat]", :delayed  
#  action :nothing
#  only_if { :: File.exist?(company_tar_download) }
#end

#directory "delete_old_company_cache" do
#  path "#{Chef::Config['file_cache_path']}/#{company_tar_structure}"
#  ignore_failure true
#  recursive true
#  action :nothing
#end

#===========================================================
#Reset Permissions to jmapp:gjmapp

execute "fix_perms" do
          command "chown -R jmapp:gjmapp #{tomcat_dir}/webapps/ #{tomcat_dir}/appConfig/"
          user "root"
          action :run
end

#===========================================================
# STOP / START SERVICES

execute 'stop_tomcat' do
  command './shutdown.sh'
  cwd "#{tomcat_dir}/bin"  
	user node['rms']['appuser']
	group node['rms']['appgroup']   
  ignore_failure true
  notifies :run, "execute[sleep]", :immediately
  action :nothing
end

execute "sleep" do
	command "sleep 30"
  action :nothing    
end

execute 'start_tomcat' do
  command './startup.sh'
  cwd "#{tomcat_dir}/bin"
	user node['rms']['appuser']
	group node['rms']['appgroup']
  action :nothing           
end
