#
# Be sure to run `pod lib lint MCToast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MCToast'
  s.version          = '1.0.3'
  s.summary          = 'Swift版本的HUD，支持多种自定义方案。使用方便。'
  s.homepage         = 'https://github.com/iAmMccc/MCToast'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MC' => 'https://github.com/iAmMccc/MCToast' }
 
  s.source           = { :git => 'https://github.com/iAmMccc/MCToast.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
 
  s.swift_version = '5.0'
  
  s.source_files = 'MCToast/Classes/**/*'
  
  
  s.ios.resource_bundle = { 'ToastBundle' => 'MCToast/Assets/**/*' }


end
