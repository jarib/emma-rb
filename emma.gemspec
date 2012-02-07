# -*- encoding: utf-8 -*-
require File.expand_path('../lib/emma/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jari Bakken"]
  gem.email         = ["jari.bakken@gmail.com"]
  gem.description   = %q{CLI wrapper for the Emma Java library http://emma.sourceforge.net/}
  gem.summary       = %q{CLI wrapper for the Emma Java library http://emma.sourceforge.net/}
  gem.homepage      = "http://github.com/jarib/emma-rb"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "emma"
  gem.require_paths = ["lib"]
  gem.version       = Emma::VERSION

  gem.add_dependency "childprocess"
end
