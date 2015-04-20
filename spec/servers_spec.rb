require 'rubygems'
require 'its'
require 'scaleway'

describe Scaleway::Server do
  subject(:server) { described_class }

  before do
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/servers')      { |env| [200, {}, {:servers => [test_server]}] }
      stub.get('/servers/1234') { |env| [200, {}, {:server => test_server}] }
      stub.get('/servers/not_found') { |env| [404, {}, {:type => 'not_found', :message => 'not found'}] }
    end
    Scaleway.request = Faraday.new do |builder|
      builder.adapter :test, stubs
    end
  end

  describe "all" do
    let(:test_server)       { RecursiveOpenStruct.new({:name => 'hello', :id => '1234'}, :recurse_over_arrays => true) }

    its(:all)               { should eq [test_server] }
  end

  describe "item" do
    let(:test_server)       { RecursiveOpenStruct.new({:name => 'hello', :id => '1234'}, :recurse_over_arrays => true) }

    its(:find, '1234')      { should eq test_server }
  end

  describe "not found" do
    let(:test_server)       { RecursiveOpenStruct.new({:name => 'hello', :id => '1234'}, :recurse_over_arrays => true) }

    it { expect{Scaleway::Server.find('not_found')}.to raise_error(Scaleway::NotFound) }
  end

end


describe Scaleway::Server do
  subject(:server) { described_class }

  before do
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/servers?state=running') { |env| [200, {}, {:servers => []}] }
      stub.get('/servers?invalid_filter=42') { |env| [400, {}, {:type => 'invalid_filter', :message => 'invalid filter'}] }
    end
    Scaleway.request = Faraday.new do |builder|
      builder.adapter :test, stubs
    end
  end

  describe "filter" do
    its(:all, state: 'running') { should eq [] }
  end

  describe "invalid filter" do
    it { expect{Scaleway::Server.all(invalid_filter: 42)}.to raise_error(Scaleway::APIError) }
  end
end
