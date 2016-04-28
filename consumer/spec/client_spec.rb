require 'spec_helper'
require 'client'

describe Client do

  let(:json_data) do
    {
      "test" => "NO",
      "date" => "2013-08-16T15:31:20+10:00",
      "count" => 100
    }
  end
  let(:response) { double('Response', :success? => true, :body => json_data.to_json) }

  it 'can process the json payload from the provider' do
    allow(HTTParty).to receive(:get).and_return(response)
    expect(subject.process_data).to eql([1, Time.parse(json_data['date'])])
  end

  describe 'Pact with our provider', :pact => true do

    subject { Client.new('localhost:1234') }

    let(:date) { Time.now.httpdate }

    describe "get json data" do

      before do
        our_provider.given("data count is > 0").
          upon_receiving("a request for json data").
          with(method: :get, path: '/provider.json', query: URI::encode('valid_date=' + date)).
          will_respond_with(
            status: 200,
            headers: {'Content-Type' => 'application/json'},
            body: json_data )
      end

      it "can process the json payload from the provider" do
        expect(subject.process_data).to eql([1, Time.parse(json_data['date'])])
      end

    end

  end

end