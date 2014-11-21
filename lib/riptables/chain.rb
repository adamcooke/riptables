module Riptables
  class Chain

    def initialize(table, name)
      @table = table
      @name = name
      @default_action = :accept
      @rules = []
    end

    attr_accessor :default_action
    attr_reader :table
    attr_reader :name
    attr_reader :rules

  end
end
