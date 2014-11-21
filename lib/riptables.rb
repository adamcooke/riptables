require 'riptables/dsl/root'
require 'riptables/error'

module Riptables

  # 
  # Store all tables configured
  #
  def self.tables
    @tables ||= []
  end

  #
  # Parse a given file
  #
  def self.load_from_file(file)
    if File.file?(file)
      dsl = DSL::Root.new
      dsl.instance_eval(File.read(file), file)
      true
    else
      raise Error, "File not found at `#{file}`"
    end
  end

end
