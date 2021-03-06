name 'rms-dev1'
description 'Retail Mobile Services dev1 environment.'

cookbook_versions(
  {
    'JMSP_Tomcat_AppServer_Provision' => '= 1.0.7',
    'JMSP_Apache_WebServer_Provision' => '= 1.0.7', 
    'openupf_base_setup' => '= 1.5.0',
    'rms' => '= 1.0.6'
  }
)

override_attributes(
  'javamsp' => {
    'environment' => 'dev'
  },
  'openupf' => {
    'epf.config.env' => 'dev'
  },
  'rms' => {
    'apache_log_level' => 'debug',
    'cardless_app_elb' => 'http://check-mike-check.elb.amazonaws.com',
    'cardless_tar' => 'https://check-mike-check.com/mother/service/local/artifact/maven/redirect?r=snapshots&g=com.capitalone.retailmobileservices.cardless&a=cardless-atm-service-web&c=dist&p=tar&v=LATEST',
    'ct_agents' => 'check-mike-check.com:11818,check-mike-check.com:11818,check-mike-check.com:11818,check-mike-check.com:11818',
    'dgw_keystore_cert_alias' => 'rms_client',    
    'dgw_keystore_cert_name' => 'dgwnonprod-clientid.jks',
    'dgw_truststore_cert_name' => 'dgwnonprod-clientid.jks',   
    'epf_content_runtime_repo_server' => 'http://stsdcsrcrdev.checkmikecheck.com',
    'epf_content_static_image_host' => 'https://qa-content.checkmikecheck.com',
    'product_tar' => 'https://checkmikecheck.com/mother/service/local/artifact/maven/redirect?r=snapshots&g=com.checkmikecheck.retailmobileservices.ps&a=product-selector-web&c=dist&p=tar&v=LATEST', 
    'lobbyone_tar' => 'https://checkmikecheck.com/mother/service/local/artifact/maven/redirect?r=snapshots&g=com.checkmikecheck.retailmobileservices.lobbyone&a=lobby-one&c=dist&p=tar&v=LATEST',   
    'rtm_keystore_cert_name' => 'rtmnonprod-clientid.jks',
    'rtm_truststore_cert_name' => 'rtmnonprod-clientid.jks',
    'rsa_enabled' => true,
    'rsa_log_level' => 'Massive',
    'webserver' => 'rms-nonprod'   
  }
)
