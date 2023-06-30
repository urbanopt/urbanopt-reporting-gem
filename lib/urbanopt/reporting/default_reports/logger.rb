# *********************************************************************************
# URBANopt™, Copyright © Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-reporting-gem/blob/develop/LICENSE.md
# *********************************************************************************

require 'logger'

module URBANopt
  module Reporting
    module DefaultReports
      @@logger = Logger.new($stdout)

      @@logger.level = Logger::WARN
      ##
      # Definining class variable "@@logger" to log errors, info and warning messages.
      def self.logger
        @@logger
      end
    end
  end
end
