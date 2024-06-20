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
      # Onsite wind system attributes
      ##
      class Wind
        ##
        # _Float_ - power capacity in kilowatts
        #
        attr_accessor :size_kw, :average_yearly_energy_produced_kwh, :size_class

        ##
        # Initialize Wind attributes from a hash. Wind attributes currently are limited to power capacity.
        ##
        # [parameters:]
        #
        # * +hash+ - _Hash_ - A hash containing a +:size_kw+ key/value pair which represents the nameplate capacity in kilowatts (kW)
        #
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }

          @size_kw = hash[:size_kw]
          @avg_energy_kwh = hash[:average_yearly_energy_produced_kwh]
          @size_class = hash[:size_class]

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
          result[:average_yearly_energy_produced_kwh] = @avg_energy_kwh if @avg_energy_kwh
          result[:size_class] = @size_class if @size_class

          return result
        end

        ##
        # Merge Wind systems
        ##
        def self.add_wind(existing_wind, new_wind)
          if existing_wind.size_kw.nil? && new_wind.size_kw.nil?
            existing_wind.size_kw = nil
          else
            existing_wind.size_kw = (existing_wind.size_kw || 0) + (new_wind.size_kw || 0)
          end
          if existing_wind.average_yearly_energy_produced_kwh.nil? && new_wind.average_yearly_energy_produced_kwh.nil?
            existing_wind.average_yearly_energy_produced_kwh = nil
          else
            existing_wind.average_yearly_energy_produced_kwh = (existing_wind.average_yearly_energy_produced_kwh || 0) + (new_wind.average_yearly_energy_produced_kwh || 0)
          end

          return existing_wind
        end
      end
    end
  end
end
