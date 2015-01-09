require 'tempfile'
require 'shellwords'
require 'httparty'
require 'digest/sha1'

module Util
  def self.say(text)
    puts text

    output_path = "spoken_expressions/#{Digest::SHA1.hexdigest(text)}.mp3"
    if File.exist?(output_path)
      puts "Using from cache: #{output_path}"
    else
      puts "Fetching ..."

      response = HTTParty.get('http://translate.google.com/translate_tts',
                              query: { tl: :en_GB, q: text })

      File.write(output_path, response)
    end

    `play #{output_path}`
  end

  def self.record_message
    output_path = Tempfile.new(['jarvis', '.wav']).path

    output_config = '-d -b 16 -c 1 -r 16k'
    silence_effect = 'silence 1 0.1 0.5% 1 3.0 0.5%'
    pad_effect = 'pad 1 1'

    `sox #{output_config} #{output_path} #{silence_effect} #{pad_effect}`

    output_path
  end
end
