# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-reporting-gem/blob/develop/LICENSE.md
# *********************************************************************************

require 'json'
require 'urbanopt/reporting/default_reports/solar_pv'
require 'urbanopt/reporting/default_reports/wind'
require 'urbanopt/reporting/default_reports/generator'
require 'urbanopt/reporting/default_reports/storage'
require 'json-schema'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # Onsite distributed generation system (i.e. SolarPV, Wind, Storage, Generator) design attributes and financial metrics.
      ##
      class DistributedGeneration
        ##
        # _Float_ - Lifecycle costs for the complete distributed generation system in US Dollars
        #
        attr_accessor :lcc

        ##
        # _Float_ - Lifecycle costs for the complete distributed generation system in US Dollars
        #
        attr_accessor :lcc_bau

        ##
        # _Float_ - Net present value of the complete distributed generation system in US Dollars
        #
        attr_accessor :npv

        ##
        # _Float_ - Total amount paid for utility energy in US Dollars in the first year of operation
        #
        attr_accessor :year_one_energy_cost_before_tax

        ##
        # _Float_ - Total amount paid in utility demand charges in US Dollars in the first year of operation
        #
        attr_accessor :year_one_demand_cost_before_tax

        ##
        # _Float_ - Total amount paid to the utility in US Dollars in the first year of operation
        #
        attr_accessor :year_one_bill_before_tax

        ##
        # _Float_ - Total energy costs in US Dollars over the life of the system after tax
        #
        attr_accessor :lifecycle_energy_cost_after_tax

        ##
        # _Float_ - Total demand costs in US Dollars over the life of the system after tax
        #
        attr_accessor :lifecycle_demand_cost_after_tax

        ##
        # _Float_ -  Year one energy cost in the business as usual scenario (i.e no new system) before tax, us dollars
        #
        attr_accessor :year_one_energy_cost_before_tax_bau

        ##
        # _Float_ -  Year one demand cost in the business as usual scenario (i.e no new system), us dollars
        #
        attr_accessor :year_one_demand_cost_before_tax_bau

        ##
        # _Float_ -  Year one demand energy bill in the business as usual scenario (i.e no new system), us dollars
        #
        attr_accessor :year_one_bill_before_tax_bau

        ##
        # _Float_ -  Total lifetime demand costs in the business as usual scenario (i.e no new system) after tax, us dollars
        #
        attr_accessor :lifecycle_demand_cost_after_tax_bau

        ##
        # _Float_ -  Total lifetime energy costs in the business as usual scenario (i.e no new system) after tax, us dollars
        #
        attr_accessor :lifecycle_energy_cost_after_tax_bau

        ##
        # _Array_ - List of _SolarPV_ systems
        #
        attr_accessor :solar_pv

        ##
        # _Array_ - List of _Wind_ systems
        #
        attr_accessor :wind

        ##
        # _Array_ - List of _Generator_ systems
        #
        attr_accessor :generator

        ##
        # _Array_ - List of _Storage_ systems
        #
        attr_accessor :storage

        ##
        # _Float_ -  Installed solar PV capacity
        #
        attr_accessor :total_solar_pv_kw

        ##
        # _Float_ -  Installed wind capacity
        #
        attr_accessor :total_wind_kw

        ##
        # _Float_ -  Installed storage capacity
        #
        attr_accessor :total_storage_kw

        ##
        # _Float_ -  Installed storage capacity
        #
        attr_accessor :total_storage_kwh

        ##
        # _Float_ -  Installed generator capacity
        #
        attr_accessor :total_generator_kw

        ##
        # _Float_ -  Minimum hour the system can support critical load during a grid outage
        #
        attr_accessor :resilience_hours_min

        ##
        # _Float_ -  Maximum hour the system can support critical load during a grid outage
        #
        attr_accessor :resilience_hours_max

        ##
        # _Float_ -  Average hour the system can support critical load during a grid outage
        #
        attr_accessor :resilience_hours_avg

        ##
        # _Float_ -  Average probability the system can sustain critical load during a grid outage
        #
        attr_accessor :probs_of_surviving

        ##
        # _Float_ -  Average monthly probabiliies that the system can sustain critical load during a grid outage
        #
        attr_accessor :probs_of_surviving_by_month

        ##
        # _Float_ -  Average hourly probabiliies that the system can sustain critical load during a grid outage
        #
        attr_accessor :probs_of_surviving_by_hour_of_the_day

        ##
        # _String_ - Filepath of reopt assumptions file used, if known
        attr_accessor :reopt_assumptions_file_path

        ##
        # _Float_ - Annual fraction of electricity supplied by renewable sources
        #
        attr_accessor :renewable_electricity_fraction

        ##
        # Initialize distributed generation system design and financial metrics.
        #
        # * Technologies include +:solar_pv+, +:wind+, +:generator+, and +:storage+.
        # * Financial metrics include +:lcc+, +:npv+, +:year_one_energy_cost_before_tax+, +:year_one_demand_cost_before_tax+,
        # +:year_one_bill_before_tax+, and +:lifecycle_energy_cost_after_tax+
        ##
        # [parameters:]
        #
        # * +hash+ - _Hash_ - A hash containing key/value pairs for the distributed generation system attributes listed above.
        #
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }

          @renewable_electricity_fraction = hash[:renewable_electricity_fraction]
          @lcc = hash[:lcc]
          @lcc_bau = hash[:lcc_bau]
          @npv = hash[:npv]
          @year_one_energy_cost_before_tax = hash[:year_one_energy_cost_before_tax]
          @year_one_energy_cost_before_tax_bau = hash[:year_one_energy_cost_before_tax_bau]
          @year_one_demand_cost_before_tax = hash[:year_one_demand_cost_before_tax]
          @year_one_demand_cost_before_tax_bau = hash[:year_one_demand_cost_before_tax_bau]
          @year_one_bill_before_tax = hash[:year_one_bill_before_tax]
          @year_one_bill_before_tax_bau = hash[:year_one_bill_before_tax_bau]
          @lifecycle_energy_cost_after_tax = hash[:lifecycle_energy_cost_after_tax]
          @lifecycle_energy_cost_after_tax_bau = hash[:lifecycle_energy_cost_after_tax_bau]
          @lifecycle_demand_cost_after_tax = hash[:lifecycle_demand_cost_after_tax]
          @lifecycle_demand_cost_after_tax_bau = hash[:lifecycle_demand_cost_after_tax_bau]

          @resilience_hours_min = hash[:resilience_hours_min]
          @resilience_hours_max = hash[:resilience_hours_max]
          @resilience_hours_avg = hash[:resilience_hours_avg]
          @probs_of_surviving = hash[:probs_of_surviving]
          @probs_of_surviving_by_month = hash[:probs_of_surviving_by_month]
          @probs_of_surviving_by_hour_of_the_day = hash[:probs_of_surviving_by_hour_of_the_day]

          # optional
          @reopt_assumptions_file_path = nil
          if hash[:reopt_assumptions_file_path]
            @reopt_assumptions_file_path = hash[:reopt_assumptions_file_path]
          end

          @total_solar_pv_kw = nil
          @total_wind_kw = nil
          @total_generator_kw = nil
          @total_storage_kw = nil
          @total_storage_kwh = nil

          @solar_pv = []
          if hash[:solar_pv].instance_of?(Hash)
            hash[:solar_pv] = [hash[:solar_pv]]
          elsif hash[:solar_pv].nil?
            hash[:solar_pv] = []
          end

          hash[:solar_pv].each do |s|
            if !s[:size_kw].nil? && (s[:size_kw] != 0)
              @solar_pv.push SolarPV.new(s)
              if @total_solar_pv_kw.nil?
                @total_solar_pv_kw = @solar_pv[-1].size_kw
              else
                @total_solar_pv_kw += @solar_pv[-1].size_kw
              end
            end
          end

          @wind = []
          if hash[:wind].instance_of?(Hash)
            hash[:wind] = [hash[:wind]]
          elsif hash[:wind].nil?
            hash[:wind] = []
          end

          hash[:wind].each do |s|
            if !s[:size_kw].nil? && (s[:size_kw] != 0)
              @wind.push Wind.new(s)
              if @total_wind_kw.nil?
                @total_wind_kw = @wind[-1].size_kw
              else
                @total_wind_kw += @wind[-1].size_kw
              end
            end
          end

          @generator = []
          if hash[:generator].instance_of?(Hash)
            hash[:generator] = [hash[:generator]]
          elsif hash[:generator].nil?
            hash[:generator] = []
          end

          hash[:generator].each do |s|
            if !s[:size_kw].nil? && (s[:size_kw] != 0)
              @generator.push Generator.new(s)
              if @total_generator_kw.nil?
                @total_generator_kw = @generator[-1].size_kw
              else
                @total_generator_kw += @generator[-1].size_kw
              end
            end
          end

          @storage = []
          if hash[:storage].instance_of?(Hash)
            hash[:storage] = [hash[:storage]]
          elsif hash[:storage].nil?
            hash[:storage] = []
          end

          hash[:storage].each do |s|
            if !s[:size_kw].nil? && (s[:size_kw] != 0)
              @storage.push Storage.new(s)
              if @total_storage_kw.nil?
                @total_storage_kw = @storage[-1].size_kw
                @total_storage_kwh = @storage[-1].size_kwh
              else
                @total_storage_kw += @storage[-1].size_kw
                @total_storage_kwh += @storage[-1].size_kwh
              end
            end
          end

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema

          # initialize @@logger
          @@logger ||= URBANopt::Reporting::DefaultReports.logger
        end

        ##
        # Add a tech
        ##
        def add_tech(name, tech)
          if name == 'solar_pv'
            @solar_pv.push tech
            if @total_solar_pv_kw.nil?
              @total_solar_pv_kw = tech.size_kw
            else
              @total_solar_pv_kw += tech.size_kw
            end
          end

          if name == 'wind'
            @wind.push tech
            if @total_wind_kw.nil?
              @total_wind_kw = tech.size_kw
            else
              @total_wind_kw += tech.size_kw
            end
          end

          if name == 'storage'
            @storage.push tech
            if @total_storage_kw.nil?
              @total_storage_kw = tech.size_kw
              @total_storage_kwh = tech.size_kwh
            else
              @total_storage_kw += tech.size_kw
              @total_storage_kwh += tech.size_kwh
            end
          end

          if name == 'generator'
            @generator.push tech
            if @total_generator_kw.nil?
              @total_generator_kw = tech.size_kw
            else
              @total_generator_kw += tech.size_kw
            end
          end
        end

        ##
        # Convert to a Hash equivalent for JSON serialization
        ##
        def to_hash
          result = {}
          result[:reopt_assumptions_file_path] = @reopt_assumptions_file_path if @reopt_assumptions_file_path
          result[:renewable_electricity_fraction] = @renewable_electricity_fraction if @renewable_electricity_fraction
          result[:lcc] = @lcc if @lcc
          result[:lcc_bau] = @lcc_bau if @lcc_bau
          result[:npv] = @npv if @npv

          result[:year_one_energy_cost_before_tax] = @year_one_energy_cost_before_tax if @year_one_energy_cost_before_tax
          result[:year_one_demand_cost_before_tax] = @year_one_demand_cost_before_tax if @year_one_demand_cost_before_tax
          result[:year_one_bill_before_tax] = @year_one_bill_before_tax if @year_one_bill_before_tax
          result[:lifecycle_demand_cost_after_tax] = @lifecycle_demand_cost_after_tax if @lifecycle_demand_cost_after_tax
          result[:lifecycle_energy_cost_after_tax] = @lifecycle_energy_cost_after_tax if @lifecycle_energy_cost_after_tax

          result[:year_one_energy_cost_before_tax_bau] = @year_one_energy_cost_before_tax_bau if @year_one_energy_cost_before_tax_bau
          result[:year_one_demand_cost_before_tax_bau] = @year_one_demand_cost_before_tax_bau if @year_one_demand_cost_before_tax_bau
          result[:year_one_bill_before_tax_bau] = @year_one_bill_before_tax_bau if @year_one_bill_before_tax_bau
          result[:lifecycle_energy_cost_after_tax_bau] = @lifecycle_energy_cost_after_tax_bau if @lifecycle_energy_cost_after_tax_bau
          result[:lifecycle_demand_cost_after_tax_bau] = @lifecycle_demand_cost_after_tax_bau if @lifecycle_demand_cost_after_tax_bau

          result[:total_solar_pv_kw] = @total_solar_pv_kw if @total_solar_pv_kw
          result[:total_wind_kw] = @total_wind_kw if @total_wind_kw
          result[:total_generator_kw] = @total_generator_kw if @total_generator_kw
          result[:total_storage_kw] = @total_storage_kw if @total_storage_kw
          result[:total_storage_kwh] = @total_storage_kwh if @total_storage_kwh

          result[:resilience_hours_min] = @resilience_hours_min if @resilience_hours_min
          result[:resilience_hours_max] = @resilience_hours_max if @resilience_hours_max
          result[:resilience_hours_avg] = @resilience_hours_avg if @resilience_hours_avg
          result[:probs_of_surviving] = @probs_of_surviving if @probs_of_surviving
          result[:probs_of_surviving_by_month] = @probs_of_surviving_by_month if @probs_of_surviving_by_month
          result[:probs_of_surviving_by_hour_of_the_day] = @probs_of_surviving_by_hour_of_the_day if @probs_of_surviving_by_hour_of_the_day

          result[:solar_pv] = []
          @solar_pv.each do |pv|
            result[:solar_pv].push pv.to_hash
          end
          result[:wind] = []
          @wind.each do |wind|
            result[:wind].push wind.to_hash
          end
          result[:generator] = []
          @generator.each do |generator|
            result[:generator].push generator.to_hash
          end
          result[:storage] = []
          @storage.each do |storage|
            result[:storage].push storage.to_hash
          end
          return result
        end

        ### get keys ...not needed
        # def self.get_all_keys(h)
        #   h.each_with_object([]){|(k,v),a| v.is_a?(Hash) ? a.push(k,*get_all_keys(v)) : a << k }
        # end

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
        # Merge a distributed generation system with a new system
        ##
        def self.merge_distributed_generation(existing_dgen, new_dgen)
          existing_dgen.renewable_electricity_fraction = add_values(existing_dgen.renewable_electricity_fraction, new_dgen.renewable_electricity_fraction)
          existing_dgen.lcc = add_values(existing_dgen.lcc, new_dgen.lcc)
          existing_dgen.lcc_bau = add_values(existing_dgen.lcc_bau, new_dgen.lcc_bau)
          existing_dgen.npv = add_values(existing_dgen.npv, new_dgen.npv)

          existing_dgen.year_one_energy_cost_before_tax = add_values(existing_dgen.year_one_energy_cost_before_tax, new_dgen.year_one_energy_cost_before_tax)
          existing_dgen.year_one_demand_cost_before_tax = add_values(existing_dgen.year_one_demand_cost_before_tax, new_dgen.year_one_demand_cost_before_tax)
          existing_dgen.year_one_bill_before_tax = add_values(existing_dgen.year_one_bill_before_tax, new_dgen.year_one_bill_before_tax)
          existing_dgen.lifecycle_energy_cost_after_tax = add_values(existing_dgen.lifecycle_energy_cost_after_tax, new_dgen.lifecycle_energy_cost_after_tax)
          existing_dgen.lifecycle_demand_cost_after_tax = add_values(existing_dgen.lifecycle_demand_cost_after_tax, new_dgen.lifecycle_demand_cost_after_tax)

          existing_dgen.year_one_energy_cost_before_tax_bau = add_values(existing_dgen.year_one_energy_cost_before_tax_bau, new_dgen.year_one_energy_cost_before_tax_bau)
          existing_dgen.year_one_demand_cost_before_tax_bau = add_values(existing_dgen.year_one_demand_cost_before_tax_bau, new_dgen.year_one_demand_cost_before_tax_bau)
          existing_dgen.year_one_bill_before_tax_bau = add_values(existing_dgen.year_one_bill_before_tax_bau, new_dgen.year_one_bill_before_tax_bau)
          existing_dgen.lifecycle_energy_cost_after_tax_bau = add_values(existing_dgen.lifecycle_energy_cost_after_tax_bau, new_dgen.lifecycle_energy_cost_after_tax_bau)
          existing_dgen.lifecycle_demand_cost_after_tax_bau = add_values(existing_dgen.lifecycle_demand_cost_after_tax_bau, new_dgen.lifecycle_demand_cost_after_tax_bau)

          existing_dgen.resilience_hours_min = add_values(existing_dgen.resilience_hours_min, new_dgen.resilience_hours_min)
          existing_dgen.resilience_hours_max = add_values(existing_dgen.resilience_hours_max, new_dgen.resilience_hours_max)
          existing_dgen.resilience_hours_avg = add_values(existing_dgen.resilience_hours_avg, new_dgen.resilience_hours_avg)
          existing_dgen.probs_of_surviving = add_values(existing_dgen.probs_of_surviving, new_dgen.probs_of_surviving)
          existing_dgen.probs_of_surviving_by_month = add_values(existing_dgen.probs_of_surviving_by_month, new_dgen.probs_of_surviving_by_month)
          existing_dgen.probs_of_surviving_by_hour_of_the_day = add_values(existing_dgen.probs_of_surviving_by_hour_of_the_day, new_dgen.probs_of_surviving_by_hour_of_the_day)

          new_dgen.solar_pv.each do |pv|
            existing_dgen.solar_pv.push pv
            if existing_dgen.total_solar_pv_kw.nil?
              existing_dgen.total_solar_pv_kw = pv.size_kw
            else
              existing_dgen.total_solar_pv_kw += pv.size_kw
            end
          end

          new_dgen.wind.each do |wind|
            existing_dgen.wind.push wind
            if existing_dgen.total_wind_kw.nil?
              existing_dgen.total_wind_kw = wind.size_kw
            else
              existing_dgen.total_wind_kw += wind.size_kw
            end
          end

          new_dgen.storage.each do |storage|
            existing_dgen.storage.push storage
            if existing_dgen.total_storage_kw.nil?
              existing_dgen.total_storage_kw = storage.size_kw
              existing_dgen.total_storage_kwh = storage.size_kwh
            else
              existing_dgen.total_storage_kw += storage.size_kw
              existing_dgen.total_storage_kwh += storage.size_kwh
            end
          end

          new_dgen.generator.each do |generator|
            existing_dgen.generator.push generator
            if existing_dgen.total_wind_kw.nil?
              existing_dgen.total_generator_kw = generator.size_kw
            else
              existing_dgen.total_generator_kw += generator.size_kw
            end
          end

          return existing_dgen
        end
      end
    end
  end
end
