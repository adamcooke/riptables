require 'riptables/error'
require 'riptables/dsl/base'

module Riptables
  class Base

    attr_reader :tables
    attr_reader :host_groups

    def initialize(&block)
      @tables = []
      @host_groups = {}
      dsl.instance_eval(&block) if block_given?
    end

    def dsl
      @dsl ||= DSL::Base.new(self)
    end

    def self.load_from_file(file)
      base = Base.new
      if File.file?(file)
        base.load_from_file(file)
        base
      else
        raise Error, "File not found at `#{file}`"
      end
    end

    def load_from_file(file)
      self.dsl.instance_eval(File.read(file), file)
    end

  end
end
