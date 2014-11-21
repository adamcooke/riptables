require 'riptables/dsl/global'
require 'riptables/rule_permutation'

module Riptables
  module DSL
    class Rule < Global

      def initialize(rule)
        @rule = rule
      end

      def rule(rule)
        @rule.rule = rule
      end

      def action(action)
        @rule.action = action
      end

      def permutation(description, options = {})
        @rule.permutations << RulePermutation.new(@rule, description, options)
      end

      def version(number)
        @rule.versions = [number]
      end

    end
  end
end
