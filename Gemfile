source 'http://rubygems.org'

# Specify your gem's dependencies in urbanopt-reporting-gem.gemspec
gemspec

# Local gems are useful when developing and integrating the various dependencies.
# To favor the use of local gems, set the following environment variable:
#   Mac: export FAVOR_LOCAL_GEMS=1
#   Windows: set FAVOR_LOCAL_GEMS=1
# Note that if allow_local is true, but the gem is not found locally, then it will
# checkout the latest version (develop) from github.
allow_local = ENV['FAVOR_LOCAL_GEMS']

# if allow_local && File.exist?('../openstudio-extension-gem')
#   gem 'openstudio-extension', path: '../openstudio-extension-gem'
# elsif allow_local
#   gem 'openstudio-extension', github: 'NREL/openstudio-extension-gem', branch: 'bundler-hack'
# gem 'openstudio-extension', '~> 0.8.1'
# end
