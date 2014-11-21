require 'riptables/dsl/table'
require 'riptables/chain'
require 'riptables/table_export'

module Riptables
  class Table

    attr_reader :base
    attr_reader :name
    attr_reader :chains

    def initialize(base, name)
      @base = base
      @name = name
      @chains = {}
    end

    def dsl
      @dsl ||= DSL::Table.new(self)
    end

    def chain(name)
      @chains[name] ||= Chain.new(self, name)
    end

    def export(options = {})
      TableExport.new(self, options)
    end

  end
end
