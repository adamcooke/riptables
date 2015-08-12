require 'riptables/dsl/base'
require 'riptables/table'
require 'riptables/host_group'

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

      def host_group(name, &block)
        host_group = Riptables::HostGroup.new(@base, name)
        host_group.dsl.instance_eval(&block)
        @base.host_groups[name] = host_group
      end

      def load(name)
        @base.load_from_file(File.expand_path(name))
      end

    end
  end
end
