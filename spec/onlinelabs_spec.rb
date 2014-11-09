require 'rubygems'
require 'its'
require 'onlinelabs'

describe OnlineLabs do
  subject(:OnlineLabs) { described_class }

  before do
    OnlineLabs.organization = organization
    OnlineLabs.token = token
  end

  describe "defaults" do
    let(:organization)   { nil }
    let(:token)          { nil }

    its(:compute_endpoint) { should eq "https://api.cloud.online.net" }
    its(:account_endpoint) { should eq "https://account.cloud.online.net" }
    its(:token)            { should eq "token_required" }
    its(:organization)     { should eq "organization_required" }

    it { expect(OnlineLabs::VERSION).to eq "0.1.0" }
  end

  describe "test token and organization" do
    let(:organization)   { "organization_id" }
    let(:token)          { "token_id" }

    its(:organization)   { should eq "organization_id" }
    its(:token)          { should eq "token_id" }
  end
end
