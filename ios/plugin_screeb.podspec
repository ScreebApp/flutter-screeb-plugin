#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint plugin_screeb.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'plugin_screeb'
  s.version          = '0.2.6'
  s.summary          = 'Screeb is a Product-led User Research Platform'
  s.description      = 'Screeb is a Product-led User Research Platform'
  s.homepage         = 'https://screeb.app'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Clement Quaquin' => 'clement@screeb.app',
                         'Samuel Berthe' => 'samuel@screeb.app',
                         'Clement Chaban' => 'clement.chaban@screeb.app'}
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.4'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'Screeb', '1.13.2'
  s.preserve_paths = 'Screeb.xcframework'
    s.xcconfig = { 'OTHER_LDFLAGS' => '-framework Screeb' }
    s.vendored_frameworks = 'Screeb.xcframework'
end
