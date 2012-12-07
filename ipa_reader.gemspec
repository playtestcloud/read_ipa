# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Nicholas Schlueter"]
  gem.email         = ["schlueter@gmail.com"]
  gem.description   = %q{I am using this gem to get version to build the over the air iPhone Ad Hoc distribution plist file.}
  gem.summary       = %q{Reads metadata form iPhone Package Archive Files (ipa).}
  gem.homepage      = "http://github.com/schlu/Ipa-Reader"

  gem.files         = Dir["lib/**/*"] + ["README.md"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec)/})
  gem.name          = "ipa_reader"
  gem.require_paths = ["lib"]
  gem.version       = "0.8.2"

  gem.add_dependency 'rubyzip', '~> 0.9.9'
  gem.add_dependency 'CFPropertyList', '2.1.1'
end
