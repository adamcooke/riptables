module Riptables
  class Host

    attr_reader :host_group
    attr_reader :name
    attr_reader :ips

    def initialize(host_group, name, ips = {})
      @host_group = host_group
      @name = name
      @ips = ips
    end

  end
end
