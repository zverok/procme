Gem::Specification.new do |s|
  s.name     = 'procme'
  s.version  = '0.0.2'
  s.authors  = ['Victor Shepelev']
  s.email    = 'zverok.offline@gmail.com'
  s.homepage = 'https://github.com/zverok/procme'

  s.summary = 'Useful DRY proc-s for Ruby'
  s.description = <<-EOF
    ProcMe provides you with methods for DRY and clean processing of
    enumerables.
  EOF
  s.licenses = ['MIT']

  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ /^(?:
    spec\/.*
    |Gemfile
    |Rakefile
    |\.rspec
    |\.gitignore
    |\.rubocop.yml
    |\.travis.yml
    )$/x
  end
  s.require_paths = ["lib"]

  s.has_rdoc = 'yard'

  s.add_development_dependency 'rubocop', '~> 0.30'
  s.add_development_dependency 'rspec', '~> 3'
end
