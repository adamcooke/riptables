require 'riptables/dsl/global'
require 'riptables/table'

module Riptables
  module DSL
    class Root < Global

      #
      # Rules within a given table
      #
      def table(name, &block)
        table = Riptables::Table.new(name)
        table.dsl.instance_eval(&block)
        Riptables.tables << table
      end

    end
  end
end
