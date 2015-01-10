require_relative 'util'

require 'pocketsphinx-ruby'

module VoiceActivation
  def self.listen_for_keyword(keyword, &block)
    Pocketsphinx.disable_logging

    message_path = Util.record_message
    recognizer = Pocketsphinx::AudioFileSpeechRecognizer.new

    recognizer.recognize(message_path) do |speech|
      if speech == keyword
        block.call
      else
        listen_for_keyword(keyword, &block)
      end
    end
  end
end
