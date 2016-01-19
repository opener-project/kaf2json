require File.expand_path('../lib/opener/kaf_to_json/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name                  = 'opener-kaf2json'
  gem.version               = Opener::KafToJson::VERSION
  gem.authors               = ['development@olery.com']
  gem.summary               = 'Converts KAF input into JSON'
  gem.description           = gem.summary
  gem.homepage              = "http://opener-project.github.com/"
  gem.has_rdoc              = 'yard'
  gem.required_ruby_version = '>= 1.9.2'
  gem.platform              = 'java'

  gem.license = 'Apache 2.0'

  gem.files = Dir.glob([
    'config/*',
    'lib/**/*',
    'config.ru',
    '*.gemspec',
    'README.md',
    'LICENSE.txt',
    'exec/**/*'
  ]).select { |file| File.file?(file) }

  gem.executables = Dir.glob('bin/*').map { |file| File.basename(file) }

  gem.add_dependency 'opener-daemons', '~> 2.2'
  gem.add_dependency 'opener-webservice', '~> 2.1'
  gem.add_dependency 'opener-core', '~> 2.2'

  gem.add_dependency 'builder'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'saxon-xslt'
  gem.add_dependency 'slop', '~> 3.5'
  gem.add_dependency 'rumoji'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
end
