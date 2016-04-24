name             'qa_uat'
maintainer       'Nitro Gear'
maintainer_email 'nitrogear@gmail.com'
license          'All rights reserved'
description      'Installs/Configures qa_uat'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'java', '= 1.39.0'
depends 'windows', '= 1.39.1'
depends 'firefox', '= 2.0.7'

supports          'windows'
