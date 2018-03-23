require "netease_sms/version"
require "erb"
require 'base64'
require 'cgi'
require 'openssl'
require 'date'
require 'net/http'
require 'uri'
require 'json'
require 'securerandom'
require 'digest'

module NeteaseSms
  class Client
    attr_reader :access_key_id, :access_key_secret

    def initialize(access_key_id, access_key_secret)
      @access_key_id = access_key_id
      @access_key_secret = access_key_secret
    end
  end

  def send_sms(template_id, cellphones, params)
    http_post({
      templateid: template_id, 
      mobiles: cellphones.to_json, 
      params: params.to_json
    })
  end

  def http_post(data)
    host = 'https://api.netease.im/sms/sendtemplate.action'
    uri = URI.parse(host)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.path, initheader = headers)
    puts headers
    puts data
    req.set_form_data(data)
    resp = https.request(req)
    puts JSON.parse resp.body
  end

  def headers
    nonce = SecureRandom.uuid
    cur_time = Time.now.to_i
    checksum = Digest::SHA1.hexdigest(self.access_key_secret + nonce + "#{cur_time}")

    headers = {
      "nonce"=> nonce,
      "AppKey"=> self.access_key_id,
      "CurTime"=> "#{cur_time}",
      "CheckSum"=> checksum,
      "Content-Type"=> "application/x-www-form-urlencoded;charset=utf-8"
    }
  end
end
