require 'riptables/condition'
require 'riptables/rule'

module Riptables
  class RulePermutation

    def initialize(rule, description, options = {})
      @rule = rule
      @description = description
      @options = options
      @conditions = Condition.conditions.dup - @rule.conditions
    end

    attr_reader :rule
    attr_reader :description
    attr_reader :options
    attr_reader :conditions

    def version
      self.options[:v] ||
      self.options[:version] ||
      (has_ipv4_ip_address? ? 4 : nil) ||
      (has_ipv6_ip_address? ? 6 : nil)
    end

    #
    # Does this permutation include an IPv6 address option?
    #
    def has_ipv4_ip_address?
      self.options[:ip].is_a?(String) && self.options[:ip] =~ /\A\d+\.\d+\.\d+\.\d+/
    end

    #
    # Does this permutation include an IPv6 address option?
    #
    def has_ipv6_ip_address?
      self.options[:ip].is_a?(String) && self.options[:ip].include?(':')
    end

    #
    # Does this permutation include a host group?
    #
    def has_host_group?
      self.options[:ip].is_a?(Symbol)
    end

    #
    # Convert this permutation into a full rule in its own right
    #
    def to_rules
      Array.new.tap do |rules|
        new_rule = Rule.new(rule.chain)
        new_rule.description = "#{rule.description} (#{self.description})"
        new_rule.rule = rule.rule.gsub(/\{\{(\w+)\}\}/) do
          if value = self.options[$1.to_sym]
            value
          else
            "{{#{$1}}}"
          end
        end
        new_rule.action = rule.action
        new_rule.conditions = rule.conditions | self.conditions
        if self.version
          new_rule.versions = [self.version]
        end

        if has_host_group?
          host_group = @rule.chain.table.base.host_groups[self.options[:ip]]
          host_group.hosts.each do |key, host|
            host.ips.each do |v, ip|
              hg_rule = new_rule.dup
              hg_rule.description += " (#{host.name} via #{host_group.name})"
              hg_rule.rule.gsub!(host_group.name.to_s, ip)
              hg_rule.versions = [v]
              rules << hg_rule
            end
          end
        else
          rules << new_rule
        end
      end
    end

  end
end
