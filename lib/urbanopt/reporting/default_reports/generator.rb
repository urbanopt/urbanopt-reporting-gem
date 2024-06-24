# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-reporting-gem/blob/develop/LICENSE.md
# *********************************************************************************

require 'json'
require 'json-schema'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # Onsite generator system attributes
      ##
      class Generator
        ##
        # _Float_ - power capacity in kilowatts
        #
        attr_accessor :size_kw

        ##
        # Initialize Generator attributes from a hash. Generator attributes currently are limited to power capacity.
        ##
        # [parameters:]
        #
        # * +hash+ - _Hash_ - A hash containing a +:size_kw+ key/value pair which represents the nameplate capacity in kilowatts (kW)
        #
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }

          @size_kw = hash[:size_kw]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema

          # initialize @@logger
          @@logger ||= URBANopt::Reporting::DefaultReports.logger
        end

        ##
        # Convert to a Hash equivalent for JSON serialization
        ##
        def to_hash
          result = {}

          result[:size_kw] = @size_kw if @size_kw
          return result
        end

        ##
        # Merge Generator systems
        ##
        def self.add_generator(existing_generator, new_generator)
          if existing_generator.size_kw.nil? && new_generator.size_kw.nil?
            existing_generator.size_kw = nil
          else
            existing_generator.size_kw = (existing_generator.size_kw || 0) + (new_generator.size_kw || 0)
          end

          return existing_generator
        end
      end
    end
  end
end
