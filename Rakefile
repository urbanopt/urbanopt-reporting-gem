# *********************************************************************************
# URBANopt™, Copyright © Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-reporting-gem/blob/develop/LICENSE.md
# *********************************************************************************

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

# Load in the rake tasks from the base extension gem
require 'openstudio/extension/rake_task'
require 'urbanopt/reporting'
rake_task = OpenStudio::Extension::RakeTask.new
rake_task.set_extension_class(URBANopt::Reporting::Extension, 'urbanopt/urbanopt-reporting-gem')

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: :spec
