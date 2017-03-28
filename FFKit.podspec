Pod::Spec.new do |spec|
  spec.name             = 'FFKit'
  spec.version          = '1.0.0'
  spec.license          = { :type => 'BSD' }
  spec.homepage         = 'http://www.baidu.com'
  spec.authors          = { 'fyz' => '645743245@qq.com' }
  spec.summary          = 'my first cocospods'
  spec.source           = { :git => 'https://git.oschina.net/fanyingzhao/ffkit.git', :tag => 'v1.0.0' }
  s.platform	        = :ios,"8.0"
  s.ios.deployment_target = "8.0"
  s.source_files 	= "FFKit/**/*.{m,h}"
  s.requires_arc = true
end
