require 'rubygems'
require 'its'
require 'scaleway'

describe Scaleway do
  subject(:Scaleway) { described_class }

  before do
    Scaleway.organization = organization
    Scaleway.token = token
  end

  describe "defaults" do
    let(:organization)   { nil }
    let(:token)          { nil }

    its(:compute_endpoint) { should eq "https://api.scaleway.com" }
    its(:account_endpoint) { should eq "https://account.scaleway.com" }
    its(:token)            { should eq "token_required" }
    its(:organization)     { should eq "organization_required" }

    it { expect(Scaleway::VERSION).to eq "0.1.2" }
  end

  describe "test token and organization" do
    let(:organization)   { "organization_id" }
    let(:token)          { "token_id" }

    its(:organization)   { should eq "organization_id" }
    its(:token)          { should eq "token_id" }
  end
end
