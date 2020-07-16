name 'rms-web'
description 'Baseline configuration for Retail Mobile Services web servers'

run_list(
   'recipe[JMSP_Apache_WebServer_Provision]',
   'recipe[rms::web]'
)

override_attributes(
  'javamsp' => {
    'apache.instances' => {
      'msp_rms_apache_01' => {
        port:8080
      }
    },
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
    'os.image' => 'aws'			
  }
)