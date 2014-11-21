table :filter do

                 # Chain    # Action
  default_action :input,    :drop
  default_action :forward,  :accept
  default_action :output,   :accept

  #
  # These rules apply to all servers
  #

  input "Allow all ICMP traffic" do
    rule "-p ICMP"
    action :accept
  end

  input "Block nasty IPv6 person" do
    rule "-s 2a00:67a0:abc::1234/128"
    action :drop
    version 6
  end

  input "Allow all management traffic" do
    rule "-s {{ip}}"
    action :accept
    permutation "Viaduct Management",      :ip => '10.128.0.0/24',       :v => 4
    permutation "aTech Public Network",    :ip => '185.22.208.0/25',     :v => 4
    permutation "aTech Internal Network",  :ip => '10.0.0.0/16',         :v => 4
    permutation "aTech IPv6",              :ip => '2a00:67a0:a:1::/64',  :v => 6

    #
    # This permuation is only applicaable to hosts in the us-east-1 region and
    # and all zones on the west.
    #
    zone "us-east-1", /us\-west\-(\d+)/ do
      permutation "Allow hosting partner", :ip => '19.5.2.66/24',        :v => 4
    end
  end

  zone "eu-west-1" do
    role :vpn do
      input "Allow GRE" do
       rule "-p gre"
        action :accept
      end
    end
  end

  #
  # These rules only apply to hosts which have the 'PROXY' role.
  #
  role :proxy, :orchestra do

    input "Web Traffic" do
      rule "-p tcp --dport {{port}}"
      action :accept
      permutation "insecure",   :port => 80
      permutation "secure",     :port => 443
    end

  end

  #
  # These rules only apply to hosts which have the 'APP_HOSTS' role.
  #
  role :app_host do

    forward "Allow MySQL Servers" do
      rule "-p tcp --dport 3306 -d {{ip}}"
      action :accept

      #
      # These permutations only exist if the host is in the EU-WEST-1 zone
      #
      zone "eu-west-1" do
        permutation "database01.infra",        :ip => '10.128.0.28/32',     :v => 4
        permutation "database02.infra",        :ip => '10.128.0.30/32',     :v => 4
        permutation "database01.dev1",         :ip => '10.128.0.47/32',     :v => 4
        permutation "database01.dev2",         :ip => '10.128.0.53/32',     :v => 4
      end

      #
      # These permutations only exist if the host is in the US-EAST-1 zone
      #
      zone "us-east-1" do
        permutation "database01.infra",        :ip => '10.128.0.124/32',    :v => 4
        permutation "database02.infra",        :ip => '10.128.0.129/32',    :v => 4
      end
    end

    forward "Allow PostgreSQL Servers" do
      rule "-p tcp --dport 5432 -d {{ip}}"
      action :accept
      permutation "database01.infra",        :ip => '10.128.0.28/32',       :v => 4
      permutation "database02.infra",        :ip => '10.128.0.30/32',       :v => 4
      permutation "database01.dev1",         :ip => '10.128.0.47/32',       :v => 4
      permutation "database01.dev2",         :ip => '10.128.0.53/32',       :v => 4
    end

    forward "Drop all traffic to Viaduct management" do
      rule "-d 10.128.0.0/24"
      version 4
      action :drop
    end

  end

end
