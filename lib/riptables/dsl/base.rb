require 'riptables/dsl/base'
require 'riptables/table'

module Riptables
  module DSL
    class Base < Global

      def initialize(base, &block)
        @base = base
      end

      def table(name, &block)
        table = Riptables::Table.new(@base, name)
        table.dsl.instance_eval(&block)
        @base.tables << table
      end

    end
  end
end
