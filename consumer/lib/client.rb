require 'httparty'
require 'uri'
require 'json'

class Client

  def load_provider_json
    response = HTTParty.get(URI::encode('http://localhost:9292/provider.json?valid_date=' + Time.now.httpdate))
    if response.success?
      JSON.parse(response.body)
    end
  end

end