# Riptables

Riptables (pronounced ri-pee-tables) is a Ruby DSL for generating configuration
for IP tables. The following design goals were employed for development:

* Must support IPv4 and IPv6 rules
* Must allow a single file to contain configuration for multiple environments
  based on a given `role` and `zone`.
* Must support any type of table or chain.
* Must support any rule or action without limitation.
* Must include a command line tool for exporting configuration.
* Should be simple to understand the configuration syntax.
* Should be well documentated.

## `FirewallFile` Syntax

Riptables works with `FirewallFile` which contains the complete configuration for
all servers where this configuration will be distributed. In this example, we're
just going to configure a single rule to drop everything except SSH.

```ruby
# Using the `table` method we define a new table. In this case, we'll be
# configuring a simple firewall.
table :filter do

  # Set some default actions for the three main chains in the filter table.
  # The action you enter will simply be passed to iptables. If it is a symbol
  # it will be uppercased otherwise it will be passed through un-touched.
  default_action :input,    :drop
  default_action :forward,  :accept
  default_action :output,   :accept

  # In it's most basic form, you can add rules by simply calling the name of the
  # chain and a description.
  input "Allow SSH" do
    # Set the conditions for the rule you want to apply. This is passed unfettered
    # to iptables so you can write anything you would normally before the -j flag.
    rule "-p tcp --dport 22"
    # Set the action to take if the rule is matched. If this is a symbol it will
    # be uppercased automatically. If it's a string, it will be passed stright
    # through after a -j flag.
    action :accept
  end

end
```

### Permutations

If you have rules which are always similar to other rules (for example a set of
IP ranges which must all be permitted) you can use permutations.

```ruby
input "Allow web access" do
  rule "-p tcp --dport {{port}}"
  action :accept
  permutation "Insecure", :port => "80"
  permutation "Secure",   :port => "443"
end
```

Each permutation will be applied as its own rule using the base rule as a template.
Using the variable interpolation, you can insert any variable you wish in each
permutation. The final `:v => 4` option sets that this should only apply to the
IPv4 firewall - it can be set to 6 to only apply them to IPv6 firewalls.

### Zones & Roles

If you have different types of servers and want to apply different rules based
on what and where a machine is, you can do so. You can either limit whole rules
or just permutations within a rule.

```ruby
# Any rules which are defined within this role block will only be included when
# you generate an iptables config for the `vpn` role.
role :vpn do

  input "Allow management access" do
    rule "-s {{ip}}"
    action :accept
    permutation "Allow Internal",   :ip => '10.0.0.0/16',           :v => 4
    permutation "Allow IPv6",       :ip => '2a00:67a0:a:123::/64',  :v => 6

    # Any permutations within this block will only be included when you generate
    # an iptavles config for any `eu-east` zone or 'us-west-4'.
    zone /eu\-east\-(\d+)/, "us-west-4" do
      permutation "aTech Media",    :ip => "185.22.208.0/25",     :v => 4
    end
  end

end
```

### IPv4 vs. IPv6

By default, any rule you configure will apply to both your IPv4 firewall and your
IPv6 firewall. However, you can define rule or permutations to only use one or
the other.

```ruby
input "Block nasty IPv6 person" do
  rule "-s 2a00:67a0:abc::1234/128"
  action :drop
  # Add the `version` option to restrict this rule to the IPv6 firewall only.
  # You can also use `4` for the IPv4 firewall.
  version 6
end
```

You'll see in the previous example, you can pass the `:v` option to permutations
to restrict which firewall they belong to. Default rules will always apply to
both and cannot currently be different depending on IP version.

When using the `:ip` option on a permutation, riptables will automatically detect
v4 or v6 addresses and will add the permutation to the rule as appropriate.

```ruby
permutation "Allow IPv4",   :ip => '10.0.0.0/16'
permutation "Allow IPv6",   :ip => '2a00:67a0::/32'
```

### Host Groups

You can configure groups of IP addresses which can be used to automatically create
permutations.

```ruby
# Create a host group containing all the hosts you want. You don't need to specify
# both IPv4 and v6 addresses.
host_group :web_servers do
  host 'web01', 4 => "123.123.123.101", 6 => "2a00:67a0:b:1::101"
  host 'web02', 4 => "123.123.123.102", 6 => "2a00:67a0:b:1::102"
  host 'web03', 4 => "123.123.123.103", 6 => "2a00:67a0:b:1::103"
end

# Create a rule with a permutation with the option :ip with a symbol relating to
# the host group you want to allow. This will then add a rule for each host in the
# host group.
forward "Allow traffic to web servers" do
  rule "-p tcp --dport {{port}} -d {{ip}}"
  permutation "Insecure", :port => 80, :ip => :web_servers
  permutation "Secure", :port => 443, :ip => :web_servers
end
```

## Command Line

The `riptables` command is used to generate your iptables-save files. These can
then be used with `iptables-restore`.

### Installing

* Ensure you have Ruby 2.0 or higher installed.
* Ensure you have RubyGems install.

```text
gem install riptables
```

### Usage

```text
$ riptables
```

The following options are supported and can be used interchagably:

* `-4` - return the IPv4 configuration (default)
* `-6` - return the IPv6 configuration (defaults to v4)
* `-f [PATH]` - path to your FirewallFile (defaults to ./FirewallFile)
* `--zone [ZONE]` - set the zone to export configuration for
* `--role [ROLE]` - set the role to export configuration for
* `--color` - return a [colorized output](http://s.adamcooke.io/14/Vmzd2.png) (useful for debugging)
* `--no-timestamp` - do not include the timestamp in the generated output
