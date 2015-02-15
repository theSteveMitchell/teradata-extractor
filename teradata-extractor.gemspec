Gem::Specification.new do |gem|
  gem.name = 'teradata-extractor'
  gem.version = '1.0.0'
  gem.date = Date.today.to_s
  gem.authors = "Steve Mitchell"
  gem.description = "Get your data from Teradata AND GET TO THE CHOPPER!"
  gem.summary = "A pretty thin wrapper around the jdbc-teradata driver that encapsulates the ugly java bits and gives you back a nice ruby enumerable"
  gem.homepage = "http://github.com/theSteveMitchell/teradata-extractor"
  gem.email = "thestevemitchell@gmail.com"
  gem.license = "MIT"
  gem.files = Dir['lib/**/**']
  gem.require_path = 'lib'

  gem.platform = 'java'
  gem.add_runtime_dependency 'jdbc-teradata'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
end
