# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-reporting-gem/blob/develop/LICENSE.md
# *********************************************************************************

require 'json'
require_relative 'validator'
require 'json-schema'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # ConstructionCost include construction cost information.
      ##
      class ConstructionCost
        attr_accessor :category, :item_name, :unit_cost, :cost_units, :item_quantity, :total_cost # :nodoc:

        ##
        # ConstructionCost class initialize all construction_cost attributes:
        # +:category+ , +:item_name+ , +:unit_cost+ , +:cost_units+ , +:item_quantity+ , +:total_cost+
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized construction_cost.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @category = hash[:category]
          @item_name = hash[:item_name]
          @unit_cost = hash[:unit_cost]
          @cost_units = hash[:cost_units]
          @item_quantity = hash[:item_quantity]
          @total_cost = hash[:total_cost]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Assigns default values if attribute values do not exist.
        ##
        def defaults
          hash = {}
          hash[:category] = nil
          hash[:item_name] = nil
          hash[:unit_cost] = nil
          hash[:cost_units] = nil
          hash[:item_quantity] = nil
          hash[:total_cost] = nil

          return hash
        end

        ##
        # Converts to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate construct_cost hash properties against schema.
        ##
        def to_hash
          result = {}
          result[:category] = @category if @category
          result[:item_name] = @item_name if @item_name
          result[:unit_cost] = @unit_cost if @unit_cost
          result[:cost_units] = @cost_units if @cost_units
          result[:item_quantity] = @item_quantity if @item_quantity
          result[:total_cost] = @total_cost if @total_cost

          # validate construct_cost properties against schema
          if @@validator.validate(@@schema[:definitions][:ConstructionCost][:properties], result).any?
            raise "construction_cost properties does not match schema: #{@@validator.validate(@@schema[:definitions][:ConstructionCost][:properties], result)}"
          end

          return result
        end

        ##
        # Merges an +existing_cost+ with a +new_cost+:
        # - modify the existing_cost by summing the +:total_cost+ and +:item_quantity+ of new_cost and existing_cost.
        # - raise an error if +:category+ , +:cost_units+ and +:unit_cost+ are not identical
        ##
        # [Parameters:]
        # +existing_cost+ - _ConstructionCost_ - An object of ConstructionCost class.
        ##
        # +new_cost+ - _ConstructionCost_ - An object of ConstructionCost class.
        ##
        def self.merge_construction_cost(existing_cost, new_cost)
          # modify the existing_cost by adding the :total_cost and :item_quantity
          existing_cost.total_cost += new_cost.total_cost
          existing_cost.item_quantity += new_cost.item_quantity

          if existing_cost.category != new_cost.category
            raise "Cannot merge existing cost of category \"#{existing_cost.category}\" with new cost of category \"#{new_cost.category}\"."
          end

          if existing_cost.cost_units != new_cost.cost_units
            raise "Cannot merge existing cost with cost units \"#{existing_cost.cost_units}\" with new cost with cost units \"#{new_cost.cost_units}\". "
          end

          if existing_cost.unit_cost != new_cost.unit_cost
            raise "Cannot merge existing cost with unit cost \"#{existing_cost.unit_cost}\" with new cost with unit cost \"#{new_cost.unit_cost}\"; identical items should have identical unit cost."
          end

          return existing_cost
        end

        ##
        # Merges multiple construction costs together.
        # - loops over the new_costs and find the index of the cost with identical +:item_name+.
        # - if +item_name+ is identical then modify the existing_cost array by summing the :total_cost and :item_quantity. Else add the new_cost to existing_costs array.
        ##
        # [Parameters:]
        # +existing_costs+ - _Array_ - An array of ConstructionCost objects.
        ##
        # +new_costs+ - _Array_ - An array of ConstructionCost objects.
        def self.merge_construction_costs(existing_costs, new_costs)
          item_name_list = []
          item_name_list = existing_costs.collect(&:item_name)

          new_costs.each do |x_new|
            if item_name_list.include?(x_new.item_name)

              # when looping over the new_cost item_names find the index of the item_name_list with the same item name
              id = item_name_list.find_index(x_new.item_name) # the order of the item_name_list is the same as the order of the existing_cost hash-array

              # modify the existing_cost array by adding the :total_cost and :item_quantity when looping over costs
              existing_costs[id] = merge_construction_cost(existing_costs[id], x_new)

            else

              # insert the new hash in to the array
              existing_costs << x_new

            end
          end

          return existing_costs
        end
      end
    end
  end
end
