name 'rms-app1'
description 'Baseline configuration for Retail Mobile Services app servers'

run_list(
   'recipe[JMSP_Tomcat_AppServer_Provision]',
   'recipe[openupf_base_setup]',   
   'recipe[rms::app]',
   'recipe[openupf_hazelcast_grid]'
)

override_attributes(
  'javamsp' => {
    'appname' => 'rms',
    'appuser' => 'jmapp',	
    'appusers' => [
      [
        'jmapp',
        -1,
        'gjmapp',
        [],
        '/prod/users/jmapp',
        '/bin/bash'
      ]
    ],
    'appgroup' => 'gjmapp',
    'appgroups' => [
    	[
    		'gjmapp',
    		-1
    	]
    ],
    'os.image' => 'aws',
    'tomcat.instances' => {
      'tomcat_01' => {
        'domain_id' => 'tomcat_01',
        'tomcatVersion' => '7042',
        'httpPort' => '11400',
        'shutdownPort' => '11401',
        'maxMemory' => '2048',
        'minMemory' => '2048',
        'permMemory' => '256',
        'ssl' => 'NO',
        'httpsPort' => '11402',
        'keystoreFileLoc' => '',
        'keystoreAlias' => '',
        'keyStorePass'=> ''
      }
    }
  },
  'hazelcast' => {
    'domain.dir' => '/prod/msp/domains/rms_domains/msp_rms_tomcat_01/'
  }
)
