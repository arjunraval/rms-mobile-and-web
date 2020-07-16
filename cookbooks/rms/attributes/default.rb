# Cookbook: "rms"

#==========================================================================================================

# APP PACKAGES
default['rms']['cardless_tar'] = 'https://check-mike-check.com/mother/service/local/artifact/maven/redirect?r=snapshots&g=com.mike-check.retailmobileservices.cardless&a=cardless-atm-service-web&c=dist&p=tar&v=LATEST'
default['rms']['company_tar'] = 'https://check-mike-check.com/mother/service/local/artifact/maven/redirect?r=snapshots&g=com.mike-check.retailmobileservices.smb.company&a=smb-company-service-web&c=dist&p=tar&v=LATEST'
default['rms']['product_tar'] = 'https://check-mike-check.com/mother/service/local/artifact/maven/redirect?r=snapshots&g=com.mike-check.retailmobileservices.ps&a=product-selector-web&c=dist&p=tar&v=LATEST'
default['rms']['lobbyone_tar'] = 'https://check-mike-check.com/mother/service/local/artifact/maven/redirect?r=snapshots&g=com.mike-check.retailmobileservices.lobbyone&a=lobby-one&c=dist&p=tar&v=LATEST'

# BASE
default['rms']['appgroup'] = node['javamsp']['appgroup']
default['rms']['appname'] = node['javamsp']['appname']
default['rms']['appuser'] = node['javamsp']['appuser']
default['rms']['environment'] = node['javamsp']['environment']
default['rms']['secure'] = 'false'

# CERTIFICATES
default['rms']['dgw_keystore_cert_alias'] = 'rms_client'
default['rms']['dgw_keystore_cert_name'] = 'dgwnonprod-clientid.jks'
default['rms']['dgw_truststore_cert_name'] = 'dgwnonprod-clientid.jks'
default['rms']['rtm_keystore_cert_name'] = 'rtmnonprod-clientid.jks'
default['rms']['rtm_truststore_cert_name'] = 'rtmnonprod-clientid.jks'

# DIRECTORIES
default['rms']['apps_dir'] ="/prod/msp/app/#{node['rms']['appname']}_apps"
default['rms']['domains_dir'] = "/prod/msp/domains/#{node['rms']['appname']}_domains"
default['rms']['logs_dir'] ="/prod/msp/logs/#{node['rms']['appname']}_logs"
default['rms']['apache_dir'] = "#{node['rms']['domains_dir']}/msp_#{node['rms']['appname']}_apache_01"
default['rms']['tomcat_dir'] = "#{node['rms']['domains_dir']}/msp_#{node['rms']['appname']}_tomcat_01"

# WEBSERVER
default['rms']['apache_listen_port'] = "8080"
default['rms']['apache_log_level'] = "warn"
default['rms']['apache_version'] = "2.2.15"
default['rms']['cardless_app_elb'] = 'http://check-mike-check.elb.amazonaws.com'
default['rms']['ct_agents'] = 'check-mike-check.com:11818,check-mike-check.com:11818,check-mike-check.com:11818,check-mike-check.com:11818'
default['rms']['rsa_enabled'] = 'true'
default['rms']['rsa_log_level'] = 'Massive'
default['rms']['webserver'] = 'rms-nonprod'
