#
# Be sure to run `pod lib lint ajouanna2017.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ajouanna2017'
  s.version          = '0.1.0'
  s.summary          = 'D08 of Swift Pool'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Projet du jour 08 de la Piscine Swift IOS de l'Ecole 42
                       DESC

  s.homepage         = 'https://github.com/ajouanna/ajouanna2017'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ajouanna' => 'ajouanna@student.42.fr' }
  s.source           = { :git => 'https://github.com/ajouanna/ajouanna2017.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ajouanna2017/Classes/*.swift'

  s.resource_bundles = {
     'ajouanna2017' => ['ajouanna2017/Classes/**/*.xcdatamodeld']
  }

  #s.resource_bundles = {
  #   'ajouanna2017' => ['ajouanna2017/Assets/*.png']
  # }

# s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.frameworks = 'CoreData'
  # s.dependency 'AFNetworking', '~> 2.3'
end
