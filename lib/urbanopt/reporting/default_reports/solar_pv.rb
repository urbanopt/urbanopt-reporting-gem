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
      # Onsite solar PV system attributes
      ##
      class SolarPV
        ##
        # _Float_ - power capacity in kilowatts
        #
        attr_accessor :size_kw
        attr_accessor :location, :tilt, :azimuth, :module_type

        ##
        # Initialize SolarPV attributes from a hash. Solar PV attributes currently are limited to power capacity.
        ##
        # [parameters:]
        #
        # * +hash+ - _Hash_ - A hash containing a +:size_kw+ key/value pair which represents the nameplate capacity in kilowatts (kW)
        #
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }

          @size_kw = hash[:size_kw]
          @id = hash[:id]
          @location = hash[:location]
          @approx_area_m2 = 0

          if hash[:azimuth]
            @azimuth = hash[:azimuth]
          end
          if hash[:tilt]
            @tilt = hash[:tilt]
          end
          if hash[:module_type]
            @module_type = hash[:module_type]

            # calculate area with PVWatts formulas
            # Size (kW) = Array Area (m²) × 1 kW/m² × Module Efficiency (%)
            # also grab module efficiency: 0 (standard) = 15%, 1 (premium) = 19%, 2 (thin film) = 10%
            eff = 0
            case @module_type
            when 0
              eff = 0.15
            when 1
              eff = 0.19
            when 2
              eff = 0.10
            end
            if @size_kw != 0
              @approx_area_m2 = (@size_kw / eff).round(3)
            end
          end
          if hash[:gcr]
            @gcr = hash[:gcr]
          end
          if hash[:average_yearly_energy_produced_kwh]
            @annual_energy_produced = hash[:average_yearly_energy_produced_kwh]
          end

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
          result[:location] = @location if @location
          result[:azimuth] = @azimuth if @azimuth
          result[:tilt] = @tilt if @tilt
          result[:module_type] = @module_type if @module_type
          result[:approximate_area_m2] = @approx_area_m2 if @approx_area_m2
          result[:gcr] = @gcr if @gcr
          result[:average_yearly_energy_produced_kwh] = @annual_energy_produced if @annual_energy_produced

          return result
        end

        ##
        # Merge PV systems
        ##
        def self.add_pv(existing_pv, new_pv)
          if existing_pv.size_kw.nil? && new_pv.size_kw.nil?
            existing_pv.size_kw = nil
          else
            existing_pv.size_kw = (existing_pv.size_kw || 0) + (new_pv.size_kw || 0)
          end
          # KAF: todo, recalculate area?
          return existing_pv
        end
      end
    end
  end
end
