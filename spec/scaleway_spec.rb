require 'rubygems'
require 'its'
require 'scaleway'

describe Scaleway do
  subject(:Scaleway) { described_class }

  before do
    Scaleway.organization = organization
    Scaleway.token = token
    Scaleway.zone = zone
  end

  describe "defaults" do
    let(:organization)   { nil }
    let(:token)          { nil }
    let(:zone)           { nil }

    its(:compute_endpoint) { should eq "https://cp-par1.scaleway.com" }
    its(:account_endpoint) { should eq "https://account.scaleway.com" }
    its(:token)            { should eq "token_required" }
    its(:organization)     { should eq "organization_required" }

    it { expect(Scaleway::VERSION).to eq "1.0.1" }
  end

  describe "test ams1" do
    let(:organization)   { nil }
    let(:token)          { nil }
    let(:zone)           { "ams1" }

    its(:compute_endpoint) { should eq "https://cp-ams1.scaleway.com" }
  end

  describe "test token and organization" do
    let(:organization)   { "organization_id" }
    let(:token)          { "token_id" }
    let(:zone)           { nil }

    its(:organization)   { should eq "organization_id" }
    its(:token)          { should eq "token_id" }
  end
end
