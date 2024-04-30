# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-reporting-gem/blob/develop/LICENSE.md
# *********************************************************************************

require_relative 'validator'

require 'json'
require 'json-schema'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # scenario_power_distribution_cost include eletrical power distribution system violation and
      # upgrade cost information.
      ##
      class ScenarioPowerDistributionCost
        attr_accessor :results, :outputs, :violation_summary, :costs_per_equipment, :equipment

        ##
        # ScenarioPowerDistributionCost class initializes all
        # scenario_power_distribution_cost attributes:
        # +:results+, +:outputs+, +:violation_summary+, +:costs_per_equipment+, +:equipment+
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @results = hash[:results]
          @outputs = hash[:outputs]
          @violation_summary = hash[:violation_summary]
          @costs_per_equipment = hash[:costs_per_equipment]
          @equipment = hash[:equipment]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Assigns default values if attribute values do not exist.##
        def defaults
          hash = {}
          hash[:results] = []
          hash[:outputs] = {}
          hash[:violation_summary] = []
          hash[:costs_per_equipment] = []
          hash[:equipment] = []

          return hash
        end

        ##
        # Converts to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate power_distribution_cost hash properties against schema.
        ##
        def to_hash
          result = {}
          result[:results] = @results if @results
          result[:outputs] = @outputs if !@outputs.empty?
          result[:violation_summary] = @violation_summary if @violation_summary
          result[:costs_per_equipment] = @costs_per_equipment if @costs_per_equipment
          result[:equipment] = @equipment if @equipment

          # validate power_distribution_cost properties against schema
          if @@validator.validate(@@schema[:definitions][:ScenarioPowerDistributionCost][:properties], result).any?
            raise "scenario_power_distribution_cost properties does not match schema: #{@@validator.validate(@@schema[:definitions][:ScenarioPowerDistributionCost][:properties], result)}"
          end

          return result
        end

        ##
        # Add a result
        ##
        def add_result(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          result = {}
          result['num_violations'] = hash[:num_violations]
          @results << result
        end

        ##
        ## Add outputs
        ##
        def add_outputs(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          output = {}
          output['log_file'] = hash[:log_file]
          output['jobs'] = []
          hash[:jobs].each do |job|
            output['jobs'] << job
          end
          @outputs = output
        end

        ##
        ## Add a violation summary
        ##
        def add_violation_summary(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          violation_summary = {}
          violation_summary['scenario'] = hash[:scenario]
          violation_summary['stage'] = hash[:stage]
          violation_summary['upgrade_type'] = hash[:upgrade_type]
          violation_summary['simulation_time_s'] = hash[:simulation_time_s]
          violation_summary['thermal_violations_present'] = hash[:thermal_violations_present]
          violation_summary['voltage_violations_present'] = hash[:voltage_violations_present]
          violation_summary['max_bus_voltage'] = hash[:max_bus_voltage]
          violation_summary['min_bus_voltage'] = hash[:min_bus_voltage]
          violation_summary['num_voltage_violation_buses'] = hash[:num_voltage_violation_buses]
          violation_summary['num_overvoltage_violation_buses'] = hash[:num_overvoltage_violation_buses]
          violation_summary['voltage_upper_limit'] = hash[:voltage_upper_limit]
          violation_summary['num_undervoltage_violation_buses'] = hash[:num_undervoltage_violation_buses]
          violation_summary['voltage_lower_limit'] = hash[:voltage_lower_limit]
          violation_summary['max_line_loading'] = hash[:max_line_loading]
          violation_summary['max_transformer_loading'] = hash[:max_transformer_loading]
          violation_summary['num_line_violations'] = hash[:num_line_violations]
          violation_summary['line_upper_limit'] = hash[:line_upper_limit]
          violation_summary['num_transformer_violations'] = hash[:num_transformer_violations]
          violation_summary['transformer_upper_limit'] = hash[:transformer_upper_limit]

          @violation_summary << violation_summary
        end

        ##
        # Add costs per equipment
        ##
        def add_costs_per_equipment
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          costs_per_equipment = {}
          costs_per_equipment['name'] = hash[:name]
          costs_per_equipment['type'] = hash[:type]
          costs_per_equipment['count'] = hash[:count]
          costs_per_equipment['total_cost_usd'] = hash[:costs_per_equipment]

          @costs_per_equipment << costs_per_equipment
        end

        ##
        # Add equipment
        ##
        def add_equipment
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          equipment = {}
          equipment['equipment_type'] = hash[:equipment_type]
          equipment['equipment_name'] = hash[:equipment_name]
          equipment['status'] = hash[:status]
          equipment['parameter1_name'] = hash[:parameter1_name]
          equipment['parameter1_original'] = hash[:parameter1_original]
          equipment['parameter1_upgraded'] = hash[:parameter1_upgraded]
          equipment['parameter2_name'] = hash[:parameter2_name]
          equipment['parameter2_original'] = hash[:parameter2_original]
          equipment['parameter2_upgraded'] = hash[:parameter2_upgraded]
          equipment['parameter3_name'] = hash[:parameter3_name]
          equipment['parameter3_original'] = hash[:parameter3_original]
          equipment['parameter3_upgraded'] = hash[:parameter3_upgraded]
          equipment['name'] = hash[:name]

          @equipment << equipment
        end
      end
    end
  end
end
