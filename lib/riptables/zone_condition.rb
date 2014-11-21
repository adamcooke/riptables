require 'riptables/condition'

module Riptables
  class ZoneCondition < Condition

    def matches?(conditions)
      conditions[:zone] &&
      condition.any? do |c|
        c.is_a?(Regexp) ? c.match(conditions[:zone]) : conditions[:zone].to_s == c.to_s
      end
    end

  end
end
