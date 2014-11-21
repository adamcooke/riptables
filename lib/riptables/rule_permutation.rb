require 'riptables/condition'
require 'riptables/rule'

module Riptables
  class RulePermutation

    def initialize(rule, description, options = {})
      @rule = rule
      @description = description
      @options = options
      @conditions = Condition.conditions.dup - @rule.conditions
    end

    attr_reader :rule
    attr_reader :description
    attr_reader :options
    attr_reader :conditions

    #
    # Convert this permutation into a full rule in its own right
    #
    def to_rule
      new_rule = Rule.new(rule.chain)
      new_rule.description = "#{rule.description} (#{self.description})"
      new_rule.rule = rule.rule.gsub(/\{\{(\w+)\}\}/) do
        if value = self.options[$1.to_sym]
          value
        else
          "{{#{$1}}}"
        end
      end
      new_rule.action = rule.action
      new_rule.conditions = rule.conditions | self.conditions
      if v = (self.options[:v] || self.options[:version])
        new_rule.versions = [v.to_i]
      end
      new_rule
    end

  end
end
