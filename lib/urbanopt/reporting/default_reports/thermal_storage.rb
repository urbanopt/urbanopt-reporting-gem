# *********************************************************************************
# URBANopt™, Copyright © Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-reporting-gem/blob/develop/LICENSE.md
# *********************************************************************************

require 'json'
require 'urbanopt/reporting/default_reports/validator'
require 'json-schema'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # Ice Thermal Storage Systems
      ##
      class ThermalStorage
        ##
        # _Float_ - Total ice storage capacity on central plant loop in kWh
        #
        attr_accessor :its_size_kwh

        # _Float_ - Total ice storage capacity distributed to packaged systems in kWh
        #
        attr_accessor :ptes_size_kwh

        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }

          @its_size = hash[:its_size_kwh]
          @ptes_size = hash[:ptes_size_kwh]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema

          # initialize @@logger
          @@logger ||= URBANopt::Reporting::DefaultReports.logger
        end

        ##
        # Assigns default values if attribute values do not exist.
        ##
        def defaults
          hash = {}
          hash[:its_size_kwh] = nil
          hash[:ptes_size_kwh] = nil

          return hash
        end

        ##
        # Convert to hash equivalent for JSON serialization
        ##
        def to_hash
          result = {}
          result[:its_size_kwh] = @its_size_kwh if @its_size_kwh
          result[:ptes_size_kwh] = @ptes_size_kwh if @ptes_size_kwh

          return result
        end

        ##
        # Add up old and new values
        ##
        def self.add_values(existing_value, new_value) #:nodoc:
          if existing_value && new_value
            existing_value += new_value
          elsif new_value
            existing_value = new_value
          end
          return existing_value
        end

        ##
        # Merge thermal storage
        ##
        def self.merge_thermal_storage(existing_tes, new_tes)
          existing_tes.its_size_kwh = add_values(existing_tes.its_size_kwh, new_tes.its_size_kwh)
          existing_tes.ptes_size_kwh = add_values(existing_tes.ptes_size_kwh, new_tes.ptes_size_kwh)

          return existing_tes
        end
      end
    end
  end
end
