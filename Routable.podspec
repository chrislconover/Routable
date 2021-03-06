#
# Be sure to run `pod lib lint Routable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Routable'
  s.version          = '0.1.0'
  s.summary          = 'Simple composable screen routing in Swift.'

  s.description      = <<-DESC
Screen routing for UIKit based controllers.  Suports deep linking into modal views and controllers.
                       DESC

  s.homepage         = 'https://github.com/chrislconover/Routable'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chrislconover' => 'github@curiousapplications.com' }
  s.source           = { :git => 'https://github.com/chrislconover/Routable.git' }
# s.source           = { :git => 'https://github.com/chrislconover/Routable.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '4.2'
  s.ios.deployment_target = '8.0'

  s.source_files = 'Sources/**/*'

  # s.resource_bundles = {
  #   'Routable' => ['Routable/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  
  s.dependency 'Veneer' # * -see below
  # # requires that pod 'Veneer' :git => 'https://github.com/chrislconover/Veneer.git' be included above Routable in podfile
end
