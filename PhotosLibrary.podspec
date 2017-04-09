#
# Be sure to run `pod lib lint Photos.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PhotosLibrary'
  s.version          = '0.1.0'
  s.summary          = 'an iOS control that allows picking single or multiple photos from user\'s photo library. And integrated an image cropping tool'

  s.description      = 'an iOS control that allows picking single or multiple photos from user\'s photo library. And integrated an image cropping tool'

  s.homepage         = 'https://github.com/iCell/Photos'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "iCell" => "icell.vip@gmail.com" }
  s.source           = { :git => 'https://github.com/iCell/Photos.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'PhotosLibrary/Classes/**/*'
  s.resources = 'PhotosLibrary/Assets.xcassets/*'

  # s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  s.frameworks = 'UIKit', 'Photos'

end
