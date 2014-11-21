require 'riptables/error'
require 'riptables/dsl/base'

module Riptables
  class Base

    attr_reader :tables

    def initialize(&block)
      @tables = []
      dsl.instance_eval(&block) if block_given?
    end

    def dsl
      @dsl ||= DSL::Base.new(self)
    end

    def self.load_from_file(file)
      if File.file?(file)
        base = Base.new
        base.dsl.instance_eval(File.read(file), file)
        base
      else
        raise Error, "File not found at `#{file}`"
      end
    end

  end
end
