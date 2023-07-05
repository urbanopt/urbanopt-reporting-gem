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
      # scenario_power_distribution include eletrical power distribution systems information.
      ##
      class ScenarioPowerDistribution
        attr_accessor :substations, :distribution_lines, :capacitors

        ##
        # ScenarioPowerDistribution class initialize all scenario_power_distribution attributes:
        # +:substations+ , +:distribution_lines+
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized power_distribution.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @substations = hash[:substations]
          @distribution_lines = hash[:distribution_lines]
          @capacitors = hash[:capacitors]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Assigns default values if attribute values do not exist.
        ##
        def defaults
          hash = {}
          hash[:substations] = []
          hash[:distribution_lines] = []
          hash[:capacitors] = []

          return hash
        end

        ##
        # Converts to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate power_distribution hash properties against schema.
        ##
        def to_hash
          result = {}
          result[:substations] = @substations if @substations
          result[:distribution_lines] = @distribution_lines if @distribution_lines
          result[:capacitors] = @capacitors if @capacitors

          # validate power_distribution properties against schema
          if @@validator.validate(@@schema[:definitions][:ScenarioPowerDistribution][:properties], result).any?
            raise "scenario_power_distribution properties does not match schema: #{@@validator.validate(@@schema[:definitions][:ScenarioPowerDistribution][:properties], result)}"
          end

          return result
        end

        ##
        # Add a substation
        ##
        def add_substation(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          # field: nominal_voltage
          substation = {}
          substation['nominal_voltage'] = hash[:nominal_voltage]
          @substations << substation
        end

        ##
        # Add a line
        ##
        def add_line(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          # fields: length, ampacity, commercial_line_type
          line = {}
          line['length'] = hash[:length]
          line['ampacity'] = hash[:ampacity]
          line['commercial_line_type'] = hash[:commercial_line_type]

          @distribution_lines << line
        end

        ##
        # Add a capacitor
        ##
        def add_capacitor(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          # fields: nominal_capacity
          cap = {}
          cap['nominal_capacity'] = hash[:nominal_capacity]
          cap
        end
      end
    end
  end
end
