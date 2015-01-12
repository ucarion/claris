require 'json'
require 'httparty'

WIT_ACCESS_TOKEN = ENV['WIT_ACCESS_TOKEN']

module Wit
  def self.get_intent_from_voice(recording_path)
    response = HTTParty.post('https://api.wit.ai/speech?v=20150101', headers: {
      'Authorization' => "Bearer #{WIT_ACCESS_TOKEN}",
      'Content-Type' => 'audio/wav'
    }, body: File.new(recording_path, 'rb').read)

    JSON.parse(response.body)
  end
end
