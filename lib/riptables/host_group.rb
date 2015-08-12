require 'riptables/dsl/host_group'

module Riptables
  class HostGroup

    attr_reader :base
    attr_reader :name
    attr_reader :hosts

    def initialize(base, name)
      @base = base
      @name = name
      @hosts = {}
    end

    def dsl
      @dsl ||= DSL::HostGroup.new(self)
    end

  end
end
