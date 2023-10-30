#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint keychain_signin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'keychain_signin'
  s.version          = '1.0.0'
  s.summary          = 'Sign in using Security and LocalAuthentication frameworks'
  s.description      = <<-DESC
Plugin that allows account sign in using the Security and LocalAuthentication frameworks.
                       DESC
  s.homepage         = 'https://saveoursecrets.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Save Our Secrets' => 'dev@saveoursecrets.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.15'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
