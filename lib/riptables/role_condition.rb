require 'riptables/condition'

module Riptables
  class RoleCondition < Condition

    def matches?(conditions)
      return false unless conditions[:role]
      roles = conditions[:role].split(/\s?\,\s?/)
      roles.each do |role|
        return true if condition.any? { |c|  c.is_a?(Regexp) ? c.match(role) : role.to_s == c.to_s }
      end
      return false
    end

  end
end
