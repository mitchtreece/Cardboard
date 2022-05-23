Pod::Spec.new do |s|

  s.name             = 'Cardboard'
  s.version          = '1.0.0'
  s.summary          = 'Customizable modal-card library for iOS'

  s.description      = <<-DESC
  Cardboard is a customizable iOS modal-card library that makes it incredibly
  easy to build highly-stylized cards, sheets, notifications, toasts, or alerts.
  DESC

  s.homepage              = 'https://github.com/mitchtreece/Cardboard'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Mitch Treece' => 'mitchtreece@me.com' }
  s.source                = { :git => 'https://github.com/mitchtreece/Cardboard.git', :tag => s.version.to_s }
  s.social_media_url      = 'https://twitter.com/mitchtreece'

  s.swift_version         = '5'
  s.ios.deployment_target = '13.0'
  s.source_files          = 'Cardboard/Classes/**/*'

  s.dependency            'SnapKit', '~> 5.0'

end
