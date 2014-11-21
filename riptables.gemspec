$:.push File.expand_path("../lib", __FILE__)

require "riptables/version"

Gem::Specification.new do |s|
  s.name        = "riptables"
  s.version     = Riptables::VERSION
  s.authors     = ["Adam Cooke"]
  s.email       = ["me@adamcooke.io"]
  s.homepage    = "http://adamcooke.io"
  s.licenses    = ['MIT']
  s.summary     = "An Ruby DSL for generating iptables configuration."
  s.description = "An Ruby DSL for generating iptables configuration. "
  s.required_ruby_version = ">= 2.0", "< 3"
  s.bindir      = "bin"
  s.executables << 'riptables'
  s.files = Dir["{bin,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
