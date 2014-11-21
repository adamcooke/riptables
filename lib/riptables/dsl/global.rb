require 'riptables/zone_condition'
require 'riptables/role_condition'

module Riptables
  module DSL
    class Global

      #
      # Any rules which are defined while inside this block should only apply
      # to the associated zones.
      #
      def zone(*zones, &block)
        ZoneCondition.new(zones) do
          block.call
        end
      end

      #
      # Any rules which are defined while inside this block should only apply
      # to the associated roles.
      #
      def role(*roles, &block)
        RoleCondition.new(roles) do
          block.call
        end
      end

    end
  end
end
