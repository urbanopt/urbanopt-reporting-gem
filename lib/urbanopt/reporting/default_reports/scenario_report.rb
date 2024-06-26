# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-reporting-gem/blob/develop/LICENSE.md
# *********************************************************************************

require_relative 'construction_cost'
require_relative 'feature_report'
require_relative 'logger'
require_relative 'program'
require_relative 'reporting_period'
require_relative 'timeseries_csv'
require_relative 'distributed_generation'
require_relative 'validator'
require_relative 'scenario_power_distribution'
require_relative 'scenario_power_distribution_cost'
require_relative 'qaqc_flags'

require 'json'
require 'json-schema'
require 'pathname'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # ScenarioReport can generate two types of reports from a scenario.
      # The first is a JSON format saved to 'default_scenario_report.json'.
      # The second is a CSV format saved to 'default_scenario_report.csv'.
      ##
      class ScenarioReport
        attr_accessor :id, :name, :directory_name, :timesteps_per_hour, :number_of_not_started_simulations,
                      :number_of_started_simulations, :number_of_complete_simulations, :number_of_failed_simulations,
                      :timeseries_csv, :location, :program, :construction_costs, :reporting_periods, :feature_reports, :distributed_generation,
                      :scenario_power_distribution, :scenario_power_distribution_cost, :qaqc_flags # :nodoc:

        # ScenarioReport class initializes the scenario report attributes:
        # +:id+ , +:name+ , +:directory_name+, +:timesteps_per_hour+ , +:number_of_not_started_simulations+ ,
        # +:number_of_started_simulations+ , +:number_of_complete_simulations+ , +:number_of_failed_simulations+ ,
        # +:timeseries_csv+ , +:location+ , +:program+ , +:construction_costs+ , +:reporting_periods+ , +:feature_reports+,
        # +:distributed_generation+, +:scenario_power_distribution+, +:qaqc_flags+
        ##
        # Each ScenarioReport object corresponds to a single Scenario.
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash of a previously serialized ScenarioReport.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @id = hash[:id]
          @name = hash[:name]
          @directory_name = hash[:directory_name]
          @timesteps_per_hour = hash[:timesteps_per_hour]
          @number_of_not_started_simulations = hash[:number_of_not_started_simulations]
          @number_of_started_simulations = hash[:number_of_started_simulations]
          @number_of_complete_simulations = hash[:number_of_complete_simulations]
          @number_of_failed_simulations = hash[:number_of_failed_simulations]
          @timeseries_csv = TimeseriesCSV.new(hash[:timeseries_csv])
          @location = Location.new(hash[:location])
          @program = Program.new(hash[:program])
          @distributed_generation = DistributedGeneration.new(hash[:distributed_generation] || {})
          @scenario_power_distribution = ScenarioPowerDistribution.new(hash[:scenario_power_distribution] || {})
          @scenario_power_distribution_cost = ScenarioPowerDistributionCost.new(hash[:scenario_power_distribution_cost] || {})
          @qaqc_flags = QAQC.new(hash[:qaqc_flags])

          @construction_costs = []
          hash[:construction_costs].each do |cc|
            @construction_costs << ConstructionCost.new(cc)
          end

          @reporting_periods = []
          hash[:reporting_periods].each do |rp|
            @reporting_periods << ReportingPeriod.new(rp)
          end

          # feature_report is initialized here to be used in the add_feature_report method
          @feature_reports = []
          hash[:feature_reports].each do |fr|
            @feature_reports << FeatureReport.new(fr)
          end

          @file_name = 'default_scenario_report'

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema

          # initialize @@logger
          @@logger ||= URBANopt::Reporting::DefaultReports.logger
        end

        ##
        # Assigns default values if values do not exist.
        ##
        def defaults
          hash = {}
          hash[:id] = nil.to_s
          hash[:name] = nil.to_s
          hash[:directory_name] = nil.to_s
          hash[:timesteps_per_hour] = nil # unknown
          hash[:number_of_not_started_simulations] = 0
          hash[:number_of_started_simulations] = 0
          hash[:number_of_complete_simulations] = 0
          hash[:number_of_failed_simulations] = 0
          hash[:timeseries_csv] = TimeseriesCSV.new.to_hash
          hash[:location] = Location.new.defaults
          hash[:program] = Program.new.to_hash
          hash[:qaqc_flags] = QAQC.new.to_hash
          hash[:construction_costs] = []
          hash[:reporting_periods] = []
          hash[:feature_reports] = []
          return hash
        end

        ##
        # Gets the saved JSON file path.
        ##
        def json_path
          File.join(@directory_name, "#{@file_name}.json")
        end

        ##
        # Gets the saved CSV file path.
        ##
        def csv_path
          File.join(@directory_name, "#{@file_name}.csv")
        end

        ##
        # Saves the 'default_scenario_report.json' and 'default_scenario_report.csv' files
        ##
        # [parameters]:
        # +file_name+ - _String_ - Assign a name to the saved scenario results file without an extension
        def save(file_name = 'default_scenario_report', save_feature_reports = true, save_csv_reports = true)
          # reassign the initialize local variable @file_name to the file name input.
          @file_name = file_name

          if save_csv_reports == true
            # save the scenario reports csv and json data
            old_timeseries_path = nil
            if !@timeseries_csv.path.nil?
              old_timeseries_path = @timeseries_csv.path
            end

            @timeseries_csv.path = File.join(@directory_name, "#{file_name}.csv")
            @timeseries_csv.save_data
          end

          hash = {}
          hash[:scenario_report] = to_hash
          hash[:feature_reports] = []
          @feature_reports.each do |feature_report|
            hash[:feature_reports] << feature_report.to_hash
          end

          json_name_path = File.join(@directory_name, "#{file_name}.json")

          File.open(json_name_path, 'w') do |f|
            f.puts JSON.pretty_generate(hash)
            # make sure data is written to the disk one way or the other
            begin
              f.fsync
            rescue StandardError
              f.flush
            end
          end

          if save_csv_reports == true
            if !old_timeseries_path.nil?
              @timeseries_csv.path = old_timeseries_path
            else
              @timeseries_csv.path = File.join(@directory_name, "#{file_name}.csv")
            end
          end

          if save_feature_reports
            if file_name == 'default_scenario_report'
              file_name = 'default_feature_report'
            end
            # save the feature reports csv and json data
            @feature_reports.each do |feature_report|
              feature_report.save file_name
            end
          end

          return true
        end

        ##
        # Converts to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate reporting_period hash properties against schema.
        ##
        def to_hash
          result = {}
          result[:id] = @id if @id
          result[:name] = @name if @name
          result[:directory_name] = @directory_name if @directory_name
          result[:timesteps_per_hour] = @timesteps_per_hour if @timesteps_per_hour
          result[:number_of_not_started_simulations] = @number_of_not_started_simulations if @number_of_not_started_simulations
          result[:number_of_started_simulations] = @number_of_started_simulations if @number_of_started_simulations
          result[:number_of_complete_simulations] = @number_of_complete_simulations if @number_of_complete_simulations
          result[:number_of_failed_simulations] = @number_of_failed_simulations if @number_of_failed_simulations
          result[:timeseries_csv] = @timeseries_csv.to_hash if @timeseries_csv
          result[:location] = @location.to_hash if @location
          result[:program] = @program.to_hash if @program
          result[:distributed_generation] = @distributed_generation.to_hash if @distributed_generation
          result[:scenario_power_distribution] = @scenario_power_distribution.to_hash if @scenario_power_distribution
          result[:scenario_power_distribution_cost] = @scenario_power_distribution_cost.to_hash if @scenario_power_distribution_cost
          result[:qaqc_flags] = @qaqc_flags.to_hash if @qaqc_flags

          result[:construction_costs] = []
          @construction_costs&.each { |cc| result[:construction_costs] << cc.to_hash }

          result[:reporting_periods] = []
          @reporting_periods&.each { |rp| result[:reporting_periods] << rp.to_hash }

          # result[:feature_reports] = []
          # @feature_reports.each { |fr| result[:feature_reports] << fr.to_hash } if @feature_reports

          # validate scenario_report properties against schema
          if @@validator.validate(@@schema[:definitions][:ScenarioReport][:properties], result).any?
            raise "scenario_report properties does not match schema: #{@@validator.validate(@@schema[:definitions][:ScenarioReport][:properties], result)}"
          end

          # have to use the module method because we have not yet initialized the class one
          unless @name == '' || @name.nil?
            @@logger.info("Scenario name: #{@name}")
          end

          return result
        end

        ##
        # Add feature reports to each other.
        ##
        # - check if a feature report have been already added.
        # - check feature simulation status
        # - merge timeseries_csv information
        # - merge program information
        # - merge qaqc_flags information
        # - merge construction_cost information
        # - merge reporting_periods information
        # - add the array of feature_reports
        # - scenario report location takes the location of the first feature in the list
        ##
        # [parameters:]
        # +feature_report+ - _FeatureReport_ - An object of FeatureReport class.
        ##
        def add_feature_report(feature_report)
          # check if the timesteps_per_hour are identical
          if @timesteps_per_hour.nil? || @timesteps_per_hour == ''
            @timesteps_per_hour = feature_report.timesteps_per_hour
          else
            if feature_report.timesteps_per_hour.is_a?(Integer) && feature_report.timesteps_per_hour != @timesteps_per_hour
              raise "FeatureReport timesteps_per_hour = '#{feature_report.timesteps_per_hour}' does not match scenario timesteps_per_hour '#{@timesteps_per_hour}'"
            end
          end

          # check if first report_report_datetime are identical.
          if @timeseries_csv.first_report_datetime.nil? || @timeseries_csv.first_report_datetime == ''
            @timeseries_csv.first_report_datetime = feature_report.timeseries_csv.first_report_datetime
          else
            if feature_report.timeseries_csv.first_report_datetime != @timeseries_csv.first_report_datetime
              raise "first_report_datetime '#{@first_report_datetime}' does not match other.first_report_datetime '#{feature_report.timeseries_csv.first_report_datetime}'"
            end
          end

          # check that we have not already added this feature
          id = feature_report.id
          @feature_reports.each do |existing_feature_report|
            if existing_feature_report.id == id
              raise "FeatureReport with id = '#{id}' has already been added"
            end
          end

          # check feature simulation status
          case feature_report.simulation_status
          when 'Not Started'
            @number_of_not_started_simulations += 1
          when 'Started'
            @number_of_started_simulations += 1
          when 'Complete'
            @number_of_complete_simulations += 1
          when 'Failed'
            @number_of_failed_simulations += 1
          else
            raise "Unknown feature_report simulation_status = '#{feature_report.simulation_status}'"
          end

          # merge timeseries_csv information
          @timeseries_csv.add_timeseries_csv(feature_report.timeseries_csv)

          @timeseries_csv.run_dir_name(@directory_name)

          # merge program information
          @program.add_program(feature_report.program)

          # merge construction_cost information
          @construction_costs = ConstructionCost.merge_construction_costs(@construction_costs, feature_report.construction_costs)

          # merge reporting_periods information
          @reporting_periods = ReportingPeriod.merge_reporting_periods(@reporting_periods, feature_report.reporting_periods)

          # merge distributed_generation information
          @distributed_generation = DistributedGeneration.merge_distributed_generation(@distributed_generation, feature_report.distributed_generation)

          # merge qaqc_flags information
          @qaqc_flags.add_qaqc_flags(feature_report.qaqc_flags)

          # add feature_report
          @feature_reports << feature_report

          # scenario report location takes the location of the first feature in the list
          @location = feature_reports[0].location
        end
      end
    end
  end
end
