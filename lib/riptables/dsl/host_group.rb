require 'riptables/dsl/global'
require 'riptables/host'

module Riptables
  module DSL
    class HostGroup < Global

      def initialize(host_group)
        @host_group = host_group
      end

      def host(name, options = {})
        @host_group.hosts[name] = Riptables::Host.new(self, name, options)
      end

    end
  end
end
