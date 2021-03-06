Gem::Specification.new do |s|
  s.name        = "syc-ontact"
  s.version     = "0.0.2"
  s.author      = "Pierre Sugar"
  s.email       = "pierre@sugaryourcoffee.de"
  s.homepage    = "https://github.com/sugaryourcoffee/syc-ontact"
  s.summary     = "Lookup contacts from any source by providing customized source files"
  s.licenses    = "MIT"

  s.files       = Dir["{bin,lib,spec}/**/*"] + %w(LICENSE.md README.md)
  s.test_files  = Dir["spec/**/*"]
  s.executables = [ 'sycontact' ]
  s.has_rdoc    = true

  s.required_ruby_version = '>=1.9'
  s.add_development_dependency 'rspec', '~> 0'
end
