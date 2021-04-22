#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint livechat.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'livechatt'
  s.version          = '1.0.1+3'
  s.summary          = 'A livechat package for embedding mobile chat window in your mobile application.'
  s.description      = <<-DESC
  A livechat package for embedding mobile chat window in your mobile application.
                       DESC
  s.homepage         = 'http://github.com/mastersam07/livechat'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'mastersam' => 'admin@mastersam.tech' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'LiveChat', '~> 2.0.20'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
