Pod::Spec.new do |s|

	s.name         =  'DDHotKey'
	s.version      =  '1.0.0'
	s.summary      =	'Simple Cocoa global hotkeys'
	s.author       =	{ 'Dave DeLong' => '' }

	s.homepage     =  'https://github.com/davedelong/DDHotKey'

	s.license      =	{ :file => 'LICENSE' }

	s.source       =  { :git => 'https://github.com/davedelong/DDHotKey.git', :tag => s.version.to_s }

  s.platform     =  :osx, '10.8'
	s.frameworks   =	'Carbon'

	s.source_files =  'DDHotKeyCenter.{h,m}','DDHotKeyUtilities.{h,m}','DDHotKeyTextField.{h,m}'
	s.requires_arc =  true

end
