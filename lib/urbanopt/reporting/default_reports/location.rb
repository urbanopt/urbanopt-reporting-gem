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
      # Location include all location information.
      ##
      class Location
        attr_accessor :latitude_deg, :longitude_deg, :surface_elevation_ft, :weather_filename #:nodoc:

        ##
        # Location class initialize location attributes: +:latitude_deg+ , +:longitude_deg+ , +:surface_elevation_ft+ , +:weather_filename+
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized location.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @latitude_deg = hash[:latitude_deg]
          @longitude_deg = hash[:longitude_deg]
          @surface_elevation_ft = hash[:surface_elevation_ft]
          @weather_filename = hash[:weather_filename]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Convert to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate location hash properties against schema.
        ##
        def to_hash
          result = {}
          result[:latitude_deg] = @latitude_deg if @latitude_deg
          result[:longitude_deg] = @longitude_deg if @longitude_deg
          result[:surface_elevation_ft] = @surface_elevation_ft if @surface_elevation_ft
          result[:weather_filename] = @weather_filename if @weather_filename

          # validate location properties against schema
          if @@validator.validate(@@schema[:definitions][:Location][:properties], result).any?
            raise "end_uses properties does not match schema: #{@@validator.validate(@@schema[:definitions][:Location][:properties], result)}"
          end

          return result
        end

        ##
        # Assign default values if values does not exist
        ##
        def defaults
          hash = {}
          hash[:latitude_deg] = nil
          hash[:longitude_deg] = nil
          hash[:surface_elevation_ft] = nil
          hash[:weather_filename] = nil

          return hash
        end
      end
    end
  end
end
