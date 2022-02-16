# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name          = 'read_ipa'
  s.version       = '2.2.0'
  s.licenses      = ['MIT']
  s.summary       = 'Read metadata from iOS IPA package files'
  s.description   = "Extract metadata from iOS packages such as the app name, the app icons or the binary file. This is a diverging fork of github.com/schlu/Ipa-Reader."
  s.authors       = ['Marvin Killing']
  s.email         = 'marvinkilling@gmail.com'
  s.files         = ['README.md', 'Rakefile', 'lib/read_ipa.rb'] + Dir.glob("lib/read_ipa/*.rb")
  s.homepage      = 'https://github.com/playtestcloud/read_ipa'
  s.require_paths = ['lib']
  s.test_files    = ['test/test_read_ipa.rb']
  s.required_ruby_version = '>= 2.3'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'

  s.add_runtime_dependency 'apple_png', '>= 0.3.0'
  s.add_runtime_dependency 'CFPropertyList', '~> 3.0'
  s.add_runtime_dependency 'chunky_png', '~> 1.3'
  s.add_runtime_dependency 'oily_png', '~> 1.2'
  s.add_runtime_dependency 'rubyzip', '>= 1.0'
end
