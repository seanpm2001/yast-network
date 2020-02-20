# Copyright (c) [2020] SUSE LLC
#
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, contact SUSE LLC.
#
# To contact SUSE LLC about this file by physical or electronic mail, you may
# find current contact information at www.suse.com.

require "yast"
require "yaml"

Yast.import "Product"

module Y2Network
  # Represents an NTP server
  #
  # It includes basic information about NTP servers. It could be extended
  # in the future as needed.
  class NtpServer
    # @return [String] Server's hostname
    attr_reader :hostname
    # @return [String,nil] Country code where the server is located
    attr_reader :country
    # @return [String,nil] Server's location
    attr_reader :location

    class << self
      DEFAULT_SERVERS = 4
      DEFAULT_SUBDOMAIN = "pool.ntp.org".freeze

      private_constant :DEFAULT_SUBDOMAIN, :DEFAULT_SERVERS

      # Determines the default servers
      #
      # The content of this list depends on the base product.
      #
      # @param products [Array<Hash>] List of base products
      # @return [Array<NtpServer>] Default NTP servers
      def default_servers(products = nil)
        base_products = products || Yast::Product.FindBaseProducts

        host =
          if base_products.any? { |p| p["name"] =~ /openSUSE/i }
            "opensuse"
          else
            "suse"
          end

        (0..DEFAULT_SERVERS - 1).map { |i| new("#{i}.#{host}.#{DEFAULT_SUBDOMAIN}") }
      end
    end

    # Constructor
    #
    # @param hostname [String] Server's hostname
    # @param country  [String] Country code (e.g., "DE")
    # @param location [String] Server's location
    def initialize(hostname, country: nil, location: nil)
      @hostname = hostname
      @country = country
      @location = location
    end

    # Determines when two servers are the same
    #
    # @param other [NtpServer] Object to compare with
    # @return [Boolean] true if both objects contain the same information; false otherwise
    def ==(other)
      hostname == other.hostname && country == other.country && location == other.location
    end

    alias_method :eql?, :==
  end
end
