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
      # QAQC flags for each feature
      ##
      class QAQC
        ##
        # _Hash_ - Hash of flags raised by QAQC measure for this feature during this reporting period
        #
        attr_accessor :eui_reasonableness,:end_use_by_category,:mechanical_system_part_load_efficiency,
                      :simultaneous_heating_and_cooling , :internal_loads , :schedules, :envelope_r_value,
                      :domestic_hot_water , :mechanical_system_efficiency , :supply_and_zone_air_temperature,
                      :total_qaqc_flags

        ##
        # QAQC class initialize quaqc attributes: +:eui_reasonableness,+:end_use_by_category,+:mechanical_system_part_load_efficiency,
        # +:simultaneous_heating_and_cooling , +:internal_loads , +:schedules, +:envelope_r_value,
        # +:domestic_hot_water , +:mechanical_system_efficiency , +:supply_and_zone_air_temperature, +:total_qaqc_flags
        ##
        # [parameters:]
        #
        # * +hash+ - _Hash_ - A hash containing qaqc attributes listed above.
        #
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @eui_reasonableness = hash[:eui_reasonableness]
          @end_use_by_category = hash[:end_use_by_category]
          @mechanical_system_part_load_efficiency = hash[:mechanical_system_part_load_efficiency]
          @simultaneous_heating_and_cooling = hash[:simultaneous_heating_and_cooling]
          @supply_and_zone_air_temperature = hash[:supply_and_zone_air_temperature]
          @internal_loads = hash[:internal_loads]
          @schedules = hash[:schedules]
          @envelope_r_value = hash[:envelope_r_value]
          @domestic_hot_water = hash[:domestic_hot_water]
          @mechanical_system_efficiency = hash[:mechanical_system_efficiency]
          @total_qaqc_flags = hash[:total_qaqc_flags]


          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema

        end


        ##
        # Assigns default values if values do not exist.
        ##
        def defaults
          hash = {}

          hash[:eui_reasonableness] = nil
          hash[:end_use_by_category] = nil
          hash[:mechanical_system_part_load_efficiency] = nil
          hash[:simultaneous_heating_and_cooling] = nil
          hash[:supply_and_zone_air_temperature] = nil
          hash[:internal_loads] = nil
          hash[:schedules] = nil
          hash[:envelope_r_value] = nil
          hash[:domestic_hot_water] = nil
          hash[:mechanical_system_efficiency] = nil
          hash[:total_qaqc_flags] = nil


          return hash
        end
        ##
        # Convert to a Hash equivalent for JSON serialization
        ##
        def to_hash
          result = {}

          result[:eui_reasonableness] = @eui_reasonableness
          result[:end_use_by_category] = @end_use_by_category
          result[:mechanical_system_part_load_efficiency] = @mechanical_system_part_load_efficiency
          result[:simultaneous_heating_and_cooling] = @simultaneous_heating_and_cooling
          result[:supply_and_zone_air_temperature] = @supply_and_zone_air_temperature
          result[:internal_loads] = @internal_loads
          result[:schedules] = @schedules
          result[:envelope_r_value] = @envelope_r_value
          result[:domestic_hot_water] = @domestic_hot_water
          result[:mechanical_system_efficiency] = @mechanical_system_efficiency
          result[:total_qaqc_flags] = @total_qaqc_flags

          # validate program properties against schema
          if @@validator.validate(@@schema[:definitions][:qaqc_flags][:properties], result).any?
            raise "qaqc properties does not match schema: #{@@validator.validate(@@schema[:definitions][:qaqc_flags][:properties], result)}"
          end

          return result

        end

        ##
        # Adds up +existing_value+ and +new_values+ if not nill.
        ##
        # [parameters:]
        # +existing_value+ - _Float_ - A value corresponding to a qaqc_flags attribute.
        ##
        # +new_value+ - _Float_ - A value corresponding to a qaqc_flags attribute.
        ##
        def add_values(existing_value, new_value) #:nodoc:
          if existing_value && new_value
            existing_value += new_value
          elsif new_value
            existing_value = new_value
          end
          return existing_value
        end

        ##
        # Merges qaqc_flags objects to each other by summing up values.
        ##
        # [parameters:]
        # +other+ - _QAQC_ - An object of Program class.
        ##
        def add_qaqc_flags(other)

          @eui_reasonableness = add_values(@eui_reasonableness, other.eui_reasonableness)
          @end_use_by_category = add_values(@end_use_by_category, other.end_use_by_category)
          @mechanical_system_part_load_efficiency = add_values(@mechanical_system_part_load_efficiency, other.mechanical_system_part_load_efficiency)
          @simultaneous_heating_and_cooling = add_values(@simultaneous_heating_and_cooling, other.simultaneous_heating_and_cooling)
          @supply_and_zone_air_temperature = add_values(@supply_and_zone_air_temperature, other.supply_and_zone_air_temperature)
          @internal_loads = add_values(@internal_loads, other.internal_loads)
          @schedules = add_values(@schedules, other.schedules)
          @envelope_r_value = add_values(@envelope_r_value, other.envelope_r_value)
          @domestic_hot_water = add_values(@domestic_hot_water, other.domestic_hot_water)
          @mechanical_system_efficiency = add_values(@mechanical_system_efficiency, other.mechanical_system_efficiency)
          @total_qaqc_flags = add_values(@total_qaqc_flags, other.total_qaqc_flags)

        end

      end
    end
  end
end
