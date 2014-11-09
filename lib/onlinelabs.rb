require 'faraday'
require 'faraday_middleware'
require 'recursive-open-struct'
require 'onlinelabs/version'

module OnlineLabs

  extend self

  def compute_endpoint
    "https://api.cloud.online.net"
  end

  def account_endpoint
    "https://account.cloud.online.net"
  end

  def token=(token)
    @token = token
    setup!
    @token
  end

  def token
    return @token if @token
    "token_required"
  end

  def organization=(organization)
    @organization = organization
    setup!
    @organization
  end

  def organization
    return @organization if @organization
    "organization_required"
  end

  DEFINITIONS = {
    "Image" => {
      :all => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/images",
        :default_params => {
          :organization => Proc.new { OnlineLabs.organization }
        }
      },
      :marketplace => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/images",
        :default_params => {
          :public => true
        }
      },
      :find => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/images/%s",
      },
      :find_by_name => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/images",
        :filters => [
          Proc.new { |item, params| item.name.include? params.first }
        ],
        :transform => Proc.new { |item, params| item.first },
      },
      :create => {
        :method => :post,
        :endpoint => "#{OnlineLabs.compute_endpoint}/images",
        :default_params => {
          :name => 'default',
          :root_volume => 'required',
          :organization => Proc.new { OnlineLabs.organization },
        }
      },
      :edit => {
        :method => :put,
        :endpoint => "#{OnlineLabs.compute_endpoint}/images/%s",
      },
      :destroy => {
        :method => :delete,
        :endpoint => "#{OnlineLabs.compute_endpoint}/images/%s",
      },
    },
    "Volume" => {
      :all => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/volumes",
      },
      :find => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/volumes/%s",
      },
      :edit => {
        :method => :put,
        :endpoint => "#{OnlineLabs.compute_endpoint}/volumes/%s",
      },
      :destroy => {
        :method => :delete,
        :endpoint => "#{OnlineLabs.compute_endpoint}/volumes/%s",
      },
      :create => {
        :method => :post,
        :endpoint => "#{OnlineLabs.compute_endpoint}/volumes",
        :default_params => {
          :name => 'default',
          :size => 20 * 10**9,
          :volume_type => 'l_hdd',
          :organization => Proc.new { OnlineLabs.organization },
        }
      },
    },
    "Ip" => {
      :all => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/ips",
      },
      :find => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/ips/%s",
      },
      :edit => {
        :method => :put,
        :endpoint => "#{OnlineLabs.compute_endpoint}/ips/%s",
      },
      :destroy => {
        :method => :delete,
        :endpoint => "#{OnlineLabs.compute_endpoint}/ips/%s",
      },
      :reserve => {
        :method => :post,
        :endpoint => "#{OnlineLabs.compute_endpoint}/ips",
        :default_params => {
          :organization => Proc.new { OnlineLabs.organization },
        }
      },
      :create => {
        :method => :post,
        :endpoint => "#{OnlineLabs.compute_endpoint}/ips",
        :default_params => {
          :organization => Proc.new { OnlineLabs.organization },
        }
      },
    },
    "Snapshot" => {
      :all => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/snapshots",
      },
      :find => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/snapshots/%s",
      },
      :edit => {
        :method => :put,
        :endpoint => "#{OnlineLabs.compute_endpoint}/snapshots/%s",
      },
      :destroy => {
        :method => :delete,
        :endpoint => "#{OnlineLabs.compute_endpoint}/snapshots/%s",
      },
      :create => {
        :method => :post,
        :endpoint => "#{OnlineLabs.compute_endpoint}/snapshots",
        :default_params => {
          :name => 'default',
          :volume_id => 'required',
          :organization => Proc.new { OnlineLabs.organization },
        }
      },
    },
    "Server" => {
      :all => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/servers",
      },
      :power_on => {
        :method => :post,
        :endpoint => "#{OnlineLabs.compute_endpoint}/servers/%s/action",
        :default_params => {
          :action => :poweron
        }
      },
      :power_off => {
        :method => :post,
        :endpoint => "#{OnlineLabs.compute_endpoint}/servers/%s/action",
        :default_params => {
          :action => :poweroff
        }
      },
      :terminate => {
        :method => :post,
        :endpoint => "#{OnlineLabs.compute_endpoint}/servers/%s/action",
        :default_params => {
          :action => :terminate
        }
      },
      :find => {
        :method => :get,
        :endpoint => "#{OnlineLabs.compute_endpoint}/servers/%s",
      },
      :edit => {
        :method => :put,
        :endpoint => "#{OnlineLabs.compute_endpoint}/servers/%s",
      },
      :destroy => {
        :method => :delete,
        :endpoint => "#{OnlineLabs.compute_endpoint}/servers/%s",
      },
      :create => {
        :method => :post,
        :endpoint => "#{OnlineLabs.compute_endpoint}/servers",
        :default_params => {
          :name => 'default',
          :image => Proc.new { OnlineLabs::Image.find_by_name('Ubuntu').id },
          :volumes => {},
          :organization => Proc.new { OnlineLabs.organization },
        }
      }
    },
  }

  DEFINITIONS.each do |resource|
    resource_name = resource[0]

    resource_class = Class.new(Object) do
      singleton = class << self; self end

      DEFINITIONS[resource_name].each do |method_name, query|
        singleton.send :define_method, method_name do |*args|
          OnlineLabs.request_and_respond(query, *args)
        end
      end
    end

    OnlineLabs.const_set(resource_name, resource_class)
  end

  def request=(request)
    @request = request
  end

  def request
    @request
  end

  def request_and_respond(query, *params)
    body = {}
    body.merge! query[:default_params] || {}
    endpoint = query[:endpoint]

    params.each do |param|
      if param.is_a? Hash or param.is_a? RecursiveOpenStruct
        body.merge! param
      elsif not param.nil?
        endpoint = endpoint % param
      end
    end

    body = Hash[body.map { |k, v|
      if v.respond_to? :call then [k, v.call()] else [k, v] end
    }]

    resp = OnlineLabs.request.send(query[:method], endpoint, body)
    body = resp.body
    if resp.status == 204
      return
    end

    if resp.status == 404
      raise OnlineLabs::NotFound, resp
    elsif resp.status >= 300
      raise OnlineLabs::APIError, resp
    end

    hash = RecursiveOpenStruct.new(body, :recurse_over_arrays => true)

    if body.length == 1
      hash = hash.send(body.keys.first)
    end

    if query[:filters]
      filters = query[:filters]
      hash = hash.find_all do |item|
        filters.all? do |filter|
          filter.call(item, params)
        end
      end
    end

    if query[:transform]
      hash = query[:transform].call(hash, params)
    end

    hash
  end

  class APIError < Exception
    def initialize(response)
      self.status = response.status
      self.body = RecursiveOpenStruct.new(response.body, :recurse_over_arrays => true)
      self.type = self.body.type
      self.error_message = self.body.message
    end

    def to_s
      "<status:#{status}, type:#{type}, message:\'#{error_message}\'>"
    end

    def message
      "#{self}"
    end

    attr_accessor :status
    attr_accessor :type
    attr_accessor :error_message
    attr_accessor :body
  end

  class NotFound < OnlineLabs::APIError
  end



  private

  def setup!
    options = {
      :headers => {
        'x-auth-token' => OnlineLabs.token,
        'content-type' => 'application/json',
      }
    }

    OnlineLabs.request = ::Faraday::Connection.new(options) do |builder|
      builder.use     ::FaradayMiddleware::EncodeJson
      builder.use     ::FaradayMiddleware::ParseJson
      builder.use     ::FaradayMiddleware::FollowRedirects
      builder.adapter ::Faraday.default_adapter
    end
  end
end
