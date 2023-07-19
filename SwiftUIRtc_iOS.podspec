#
# Be sure to run `pod lib lint SwiftUIRtc.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftUIRtc_iOS'
  s.module_name      = 'SwiftUIRtc'
  s.version          = ENV['LIB_VERSION']
  s.summary          = 'SwiftUI classes for Agora\'s Video Real-time Engine.'

  s.description      = <<-DESC
Use this pod to create SwiftUI Video calling or live streaming applications.
                       DESC

  s.homepage         = 'https://github.com/AgoraIO-Community/SwiftUIRtc'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Max Cobb' => 'max@agora.io' }
  s.source           = { :git => 'https://github.com/AgoraIO-Community/SwiftUIRtc.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.0'
  s.swift_versions = ['5.7']

  s.static_framework = true
  s.source_files = 'Sources/SwiftUIRtc/*'
  s.dependency 'AgoraRtcEngine_iOS', '~> 4.2.0'
end
