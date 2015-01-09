require 'pocketsphinx-ruby'

module VoiceActivation
  def self.listen_for_keyword(keyword, &block)
    Pocketsphinx.disable_logging

    configuration = Pocketsphinx::Configuration::KeywordSpotting.new(keyword)
    recognizer = Pocketsphinx::LiveSpeechRecognizer.new(configuration)

    recognizer.recognize(&block)
  end
end
