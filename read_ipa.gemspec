# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name          = 'read_ipa'
  s.version       = '0.0.1'
  s.licenses      = ['MIT']
  s.summary       = 'Read metadata from iOS IPA package files'
  s.description   = "Extract metadata from iOS packages such as the app name, the app icons or the binary file. This is a diverging fork of github.com/schlu/Ipa-Reader."
  s.authors       = ['Marvin Killing']
  s.email         = 'marvinkilling@gmail.com'
  s.files         = ['README.md', 'Rakefile', 'lib/read_ipa.rb', 'lib/read_ipa/plist_binary.rb', 'lib/read_ipa/png_file.rb']
  s.homepage      = 'https://github.com/playtestcloud/read_ipa'
  s.require_paths = ['lib']
  s.test_files    = ['test/test_read_ipa.rb']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'

  s.add_runtime_dependency 'rubyzip', '~> 0.9.9'
  s.add_runtime_dependency 'CFPropertyList', '= 2.1.1'
end