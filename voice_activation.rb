require_relative 'util'

require 'pocketsphinx-ruby'

module VoiceActivation
  def self.listen_for_keyword(keyword, &block)
    Pocketsphinx.disable_logging

    config = Pocketsphinx::Configuration::KeywordSpotting.new(keyword)
    Pocketsphinx::LiveSpeechRecognizer.new(config).recognize(&block)
  end
end
