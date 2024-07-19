require_relative 'lib/omniauth/edlink/version'

Gem::Specification.new do |gem|
  gem.name = 'omniauth-edlink'
  gem.version = Omniauth::Edlink::VERSION
  gem.authors = ['Kamil Bednarz', 'Tomasz Rosiek']
  gem.email = %w[kamil.bednarz@u2i.com tomasz.rosiek@u2i.com]
  gem.description = 'Unofficial OmniAuth strategy for Edlink SSO OAuth2 integration'
  gem.summary = 'The unofficial strategy for authenticating users using ed.link using OAuth2 provider'
  gem.homepage = 'https://github.com/u2i/omniauth-edlink'
  gem.license = 'Apache-2.0'

  gem.signing_key = ENV['GEM_PRIVATE_KEY']
  gem.cert_chain = ['gem-public_cert.pem']

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'omniauth-oauth2', '~> 1.4'
end
