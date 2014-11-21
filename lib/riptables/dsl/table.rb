require 'riptables/dsl/global'
require 'riptables/rule'

module Riptables
  module DSL
    class Table < Global

      def initialize(table)
        @table = table
      end

      #
      # Defines a default rule for a chain on this table
      #
      def default_action(chain, action)
        @table.chain(chain).default_action = action
      end

      #
      # Add a new rule in this table
      #
      def rule(chain, description = nil, &block)
        rule = Riptables::Rule.new(@table.chain(chain))
        rule.description = description
        rule.dsl.instance_eval(&block)
        @table.chain(chain).rules << rule
      end

      #
      # Any method which do not exist are most likely just new rules when inside
      # this block.
      #
      def method_missing(chain, *args, &block)
        if block_given?
          self.rule(chain, *args, &block)
        else
          super
        end
      end

    end
  end
end
