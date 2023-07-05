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
      # Onsite storage system attributes
      ##
      class Storage
        ##
        # _Float_ - power capacity in kilowatts
        #
        attr_accessor :size_kw

        ##
        # _Float_ - storage capacity in kilowatt-hours
        #
        attr_accessor :size_kwh

        ##
        # Initialize Storage attributes from a hash. Storage attributes currently are limited to power and storage capacity.
        ##
        # [parameters:]
        #
        # * +hash+ - _Hash_ - A hash containting +:size_kw+ and +:size_kwh+ key/value pair which represents the power and storage capacity in kilowatts (kW) and kilowatt-hours respectively.
        #
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }

          @size_kw = hash[:size_kw]
          @size_kwh = hash[:size_kwh]

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
          result[:size_kwh] = @size_kwh if @size_kwh

          return result
        end

        ##
        # Merge Storage systems
        ##
        def self.add_storage(existing_storage, new_storage)
          if existing_storage.size_kw.nil?
            existing_storage.size_kw = new_storage.size_kw
          else
            existing_storage.size_kw = (existing_storage.size_kw || 0) + (new_storage.size_kw || 0)
          end

          if existing_storage.size_kw.nil?
            existing_storage.size_kwh = new_storage.size_kwh
          else
            existing_storage.size_kwh = (existing_storage.size_kwh || 0) + (new_storage.size_kwh || 0)
          end

          return existing_storage
        end
      end
    end
  end
end
