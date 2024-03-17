#
#  Be sure to run `pod spec lint Botter.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  

  spec.name         = "Botter SDK"
  spec.version      = "1.1.9"
  spec.summary      = "Botter is an integration with Botter Chatbot"

  spec.homepage     = "https://github.com/bluecrunch-com/botter-ios-sdk"
  
  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.authors            = { "BOTTER" => "hello@botter.ai"}
  # spec.social_media_url   = "https://twitter.com/Nora"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  
  spec.platform     = :ios, "11.0"
  spec.ios.framework  = 'WebKit' , 'AVKit' , 'AVFoundation'
  #spec.dependency 'Alamofire'
  #spec.dependency 'LazyImage'
  #spec.dependency 'IQKeyboardManagerSwift'



 #:path => '/Users/bluecrunch/Desktop/Projects/Native/BotterSDK'
#:git => 'https://github.com/NoraSayed135/Botter.git', :tag => spec.version

  spec.source       = { :http => 'https://github.com/NoraSayed135/Botter/archive/1.1.8.tar.gz' }

  spec.source_files  = "**/*.{swift,h,m,strings}"
  spec.resource_bundles = {
    'Botter' => ['**/*.{xib,storyboard,xcassets,mp3}']
}
  spec.exclude_files = "Botter/BotterSample/*"
#['Botter/BotterSample/Base.lproj/Main.storyboard' , 'Botter/BotterSample/Base.lproj/#LaunchScreen.storyboard' , 'Botter/BotterSample/Assets.xcassets']


  spec.swift_version = "5" 
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5' }


end
