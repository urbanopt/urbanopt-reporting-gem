# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-reporting-gem/blob/develop/LICENSE.md
# *********************************************************************************

require_relative 'validator'
require 'json-schema'
require 'json'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # Date class include information of simulation run date.
      ##
      class Date
        attr_accessor :month, :day_of_month, :year #:nodoc:

        ##
        # Date class intialize all date attributes:
        # +:month+ , +:day_of_month+ , +:year+
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized date.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @month = hash[:month].to_i
          @day_of_month = hash[:day_of_month].to_i
          @year = hash[:year].to_i

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Converts to a hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate date properties against schema.
        ##
        def to_hash
          result = {}
          result[:month] = @month if @month
          result[:day_of_month] = @day_of_month if @day_of_month
          result[:year] = @year if @year

          # validate date hash properties against schema
          if @@validator.validate(@@schema[:definitions][:Date][:properties], result).any?
            raise "end_uses properties does not match schema: #{@@validator.validate(@@schema[:definitions][:Date][:properties], result)}"
          end

          return result
        end

        ##
        # Assigns default values if values do not exist.
        ##
        def defaults
          hash = {}
          hash[:month] = nil
          hash[:day_of_month] = nil
          hash[:year] = nil

          return hash
        end
      end
    end
  end
end
