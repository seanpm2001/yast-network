#! /usr/bin/env rspec

require_relative "test_helper"

require "yast"

Yast.import "LanItems"

module Yast
  describe LanItems do
    let(:netconfig_items) do
      {
        "eth"  => {
          "eth1" => { "BOOTPROTO" => "none" },
          "eth2" => { "BOOTPROTO" => "none" },
          "eth4" => { "BOOTPROTO" => "none" },
          "eth5" => { "BOOTPROTO" => "none" },
          "eth6" => { "BOOTPROTO" => "dhcp" }
        },
        "bond" => {
          "bond0" => {
            "BOOTPROTO"      => "static",
            "BONDING_MASTER" => "yes",
            "BONDING_SLAVE0" => "eth1",
            "BONDING_SLAVE1" => "eth2"
          },
          "bond1" => {
            "BOOTPROTO"      => "static",
            "BONDING_MASTER" => "yes"
          }
        }
      }
    end
    let(:hwinfo_items) do
      [
        { "dev_name" => "eth11" },
        { "dev_name" => "eth12" }
      ]
    end

    before(:each) do
      allow(NetworkInterfaces).to receive(:FilterDevices).with("netcard") { netconfig_items }

      allow(LanItems).to receive(:ReadHardware) { hwinfo_items }
      LanItems.Read
    end

    describe "#GetBondableInterfaces" do
      let(:expected_bondable) { ["eth4", "eth5", "eth11", "eth12"] }

      context "on common architectures" do
        before(:each) do
          expect(Arch).to receive(:s390).at_least(:once).and_return false
          # FindAndSelect initializes internal state of LanItems it
          # is used internally by some helpers
          LanItems.FindAndSelect("bond1")
        end

        it "returns list of slave candidates" do
          expect(
            LanItems
              .GetBondableInterfaces(LanItems.GetCurrentName)
              .map { |i| LanItems.GetDeviceName(i) }
          ).to match_array expected_bondable
        end
      end

      context "on s390" do
        before(:each) do
          expect(Arch).to receive(:s390).at_least(:once).and_return true
        end

        it "returns list of slave candidates" do
          expect(LanItems).to receive(:s390_ReadQethConfig).with("eth4")
            .and_return("QETH_LAYER2" => "yes")
          expect(LanItems).to receive(:s390_ReadQethConfig).with(::String)
            .at_least(:once).and_return("QETH_LAYER2" => "no")

          expect(
            LanItems
              .GetBondableInterfaces(LanItems.GetCurrentName)
              .map { |i| LanItems.GetDeviceName(i) }
          ).to match_array ["eth4"]
        end
      end
    end

    describe "#GetBondSlaves" do
      it "returns list of slaves if bond device has some" do
        expect(LanItems.GetBondSlaves("bond0")).to match_array ["eth1", "eth2"]
      end

      it "returns empty list if bond device doesn't have slaves assigned" do
        expect(LanItems.GetBondSlaves("bond1")).to be_empty
      end
    end

    describe "#BuildBondIndex" do
      let(:expected_mapping) { { "eth1" => "bond0", "eth2" => "bond0" } }

      it "creates mapping of device names to corresponding bond master" do
        expect(LanItems.BuildBondIndex).to match(expected_mapping)
      end
    end

    describe "#setup_bonding" do
      let(:bonding_map) { { "BONDING_SLAVE0" => "eth0", "BONDING_SLAVE1" => "enp0s3" } }

      it "sets BONDING_MASTER and BONDING_MODULE_OPTS" do
        option = "bonding_option"
        expected_map = { "BONDING_MASTER" => "yes", "BONDING_MODULE_OPTS" => option }

        ret = LanItems.setup_bonding({}, [], option)

        expect(ret.select { |k, _| k !~ /BONDING_SLAVE/ }).to match(expected_map)
      end

      it "sets BONDING_SLAVEx options according to given list" do
        expected_map = bonding_map

        ret = LanItems.setup_bonding({}, ["eth0", "enp0s3"], nil)

        expect(ret.select { |k, v| k =~ /BONDING_SLAVE/ && !v.nil? }).to match expected_map
      end

      it "clears BONDING_SLAVEx which are not needed anymore" do
        expected_map = { "BONDING_SLAVE0" => "enp0s3" }

        ret = LanItems.setup_bonding(bonding_map, ["enp0s3"], nil)

        expect(ret.select { |k, v| k =~ /BONDING_SLAVE/ && !v.nil? }).to match expected_map
        # Following is required to get unneeded BONDING_SLAVEx deleted
        # during write
        expect(ret).to have_key("BONDING_SLAVE1")
        expect(ret["BONDING_SLAVE1"]).to be nil
      end
    end
  end
end
