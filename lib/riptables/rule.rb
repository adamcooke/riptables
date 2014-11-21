require 'riptables/dsl/rule'

module Riptables
  class Rule

    def initialize(chain)
      @chain = chain
      @permutations = []
      @conditions = Condition.conditions.dup
      @versions = [4, 6]
    end

    attr_accessor :description
    attr_accessor :rule
    attr_accessor :action
    attr_accessor :conditions
    attr_accessor :versions
    attr_reader :chain
    attr_reader :permutations
    attr_reader :conditions

    def dsl
      @dsl ||= DSL::Rule.new(self)
    end

    def include?(conditions)
      @conditions.all? { |c| c.matches?(conditions) }
    end

    def permuted_rules
      if permutations.empty?
        [self]
      else
        permutations.map(&:to_rule)
      end
    end

  end
end
