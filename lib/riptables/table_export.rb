module Riptables
  class TableExport

    def initialize(table, options = {})
      @table = table
      @options = options
    end

    def to_savefile(version = 4)
      Array.new.tap do |s|
        s << "*#{col 31, @table.name}"
        @table.chains.each do |_, chain|
          s << ":#{col 32, chain.name.to_s.upcase} #{col 35, chain.default_action.to_s.upcase} [0:0]"
        end

        @table.chains.each do |_, chain|
          chain.rules.map(&:permuted_rules).flatten.each do |rule|
            next unless rule.include?(@options[:conditions] || {})
            next unless rule.versions.include?(version)
            action = rule.action ? "-j #{rule.action.is_a?(Symbol) ? rule.action.upcase : rule.action}" : ''
            comment = "-m comment --comment=\"#{rule.description.gsub('"', '\'')}\""
            s << "-A #{col 32, chain.name.to_s.upcase} #{col 33, rule.rule} #{col 35, action} #{col 36, comment}"
          end
        end

        s << "COMMIT"
        timestamp = @options[:timestamp] == false ? '' : "on #{Time.now.strftime("%a %b %e %H:%M:%S %Y")}"
        s << "# Compiled by riptables #{timestamp}"
      end.join("\n")
    end

    def col(number, text)
      if @options[:color] == false
        text
      else
        "\e[#{number}m#{text}\e[0m"
      end
    end

  end
end
