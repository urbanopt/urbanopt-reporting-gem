# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-reporting-gem/blob/develop/LICENSE.md
# *********************************************************************************

require 'json'

module URBANopt
  module Reporting
    module DefaultReports
      class Validator
        @@schema = nil

        # Initialize the root directory
        def initialize
          super

          @root_dir = File.absolute_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..'))

          @instance_lock = Mutex.new
          @@schema ||= schema
        end

        # Return the absolute path of the default reports files
        def files_dir
          File.absolute_path(File.join(@root_dir, 'lib/urbanopt/reporting/default_reports/'))
        end

        # return path to schema file
        def schema_file
          File.join(files_dir, 'schema/scenario_schema.json')
        end

        # return schema
        def schema
          @instance_lock.synchronize do
            if @@schema.nil?
              File.open(schema_file, 'r') do |f|
                @@schema = JSON.parse(f.read, symbolize_names: true)
              end
            end
          end

          @@schema
        end

        # get csv headers from csv schema
        def csv_headers
          # read scenario csv schema headers
          scenario_csv_schema = open(File.expand_path('schema/scenario_csv_columns.txt', File.dirname(__FILE__))) # .read()

          scenario_csv_schema_headers = []
          File.readlines(scenario_csv_schema).each do |line|
            l = line.delete("\n")
            a = l.delete("\t")
            scenario_csv_schema_headers << a
          end

          return scenario_csv_schema_headers
        end

        ##
        # validate data against schema
        ##
        # [parameters:]
        # +schema+ - _Hash_ - A hash of the JSON scenario_schema.
        # +data+ - _Hash_ - A hash of the data to be validated against scenario_schema.
        ##
        def validate(schema, data)
          JSON::Validator.fully_validate(schema, data)
        end

        # check if the schema is valid
        def schema_valid?
          metaschema = JSON::Validator.validator_for_name('draft6').metaschema
          JSON::Validator.validate(metaschema, @@schema)
        end

        # return detailed schema validation errors
        def schema_validation_errors
          metaschema = JSON::Validator.validator_for_name('draft6').metaschema
          JSON::Validator.fully_validate(metaschema, @@schema)
        end
      end
    end
  end
end
