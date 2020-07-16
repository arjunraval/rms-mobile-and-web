name 'rms-prod'
description 'Retail Mobile Services prod environment'

cookbook_versions(
  {
    'JMSP_Tomcat_AppServer_Provision' => '= 1.0.7',
    'JMSP_Apache_WebServer_Provision' => '= 1.0.7', 
    'openupf_base_setup' => '= 1.5.0',
    'rms' => '= 1.0.5'
  }
)

override_attributes(
  'javamsp' => {
    'environment' => 'prod'
  },
  'openupf' => {
    'epf.config.env' => 'prod'
  },
  'rms' => {
    'apache_log_level' => 'warn',
    'cardless_app_elb' => 'http://checkmikecheck.elb.amazonaws.com',
    'cardless_tar' => 'https://checkmikecheck.com/mother/service/local/repo_groups/Releases/content/com/checkmikecheck/retailmobileservices/cardless/cardless-atm-service-web/01.00.00.09/cardless-atm-service-web-01.00.00.09-dist.tar',
    'ct_agents' => 'checkmikecheck.com:11818,checkmikecheck.com:11818,checkmikecheck.com:11818,checkmikecheck.com:11818',
    'dgw_keystore_cert_alias' => 'rms_client',
    'dgw_keystore_cert_name' => 'dgwprod-clientid.jks',
    'dgw_truststore_cert_name' => 'dgwprod-clientid.jks',  
    'epf_content_runtime_repo_server' => 'https://stsdcsrcrapipd.checkmikecheck.com',
    'epf_content_static_image_host' => 'https://qa-content.checkmikecheck.com',
    'product_tar' => 'https://checkmikecheck.com/mother/service/local/repo_groups/Releases/content/com/checkmikecheck/retailmobileservices/ps/product-selector-web/01.00.00.13/product-selector-web-01.00.00.13-dist.tar',
    'lobbyone_tar' => 'https://checkmikecheck.com/mother/service/local/repo_groups/Releases/content/com/checkmikecheck/retailmobileservices/ps/lobbyone/01.00.00.01/lobby-one-01.00.00.01-dist.tar',
    'rtm_keystore_cert_name' => 'rtmprod-clientid.jks',
    'rtm_truststore_cert_name' => 'rtmprod-clientid.jks',
    'rsa_enabled' => true,
    'rsa_log_level' => 'Security',
    'webserver' => 'rms-prod'
  }
)
