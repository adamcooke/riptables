require 'riptables/condition'

module Riptables
  class Condition

    def self.conditions
      @conditions ||= []
    end

    def initialize(condition, &block)
      @condition = [condition].flatten
      @block = block
      self.call
    end

    attr_reader :condition

    def call
      Condition.conditions << self
      @block.call
      Condition.conditions.delete(self)
    end

  end
end
