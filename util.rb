require 'tempfile'
require 'shellwords'
require 'httparty'
require 'digest/sha1'

module Util
  def self.record_message
    output_path = Tempfile.new(['jarvis', '.wav']).path

    silence_effect = 'silence 1 0.1 0.5% 1 3.0 0.5%'
    pad_effect = 'pad 1 1'

    `rec #{output_path} #{silence_effect} #{pad_effect}`

    output_path
  end

  SENTENCE_REGEX = /[\.\-]/

  def self.say(text)
    puts text

    sentences = text.split(SENTENCE_REGEX)
    synthesized_chunks = sentences.map { |chunk| synthesize_chunk(chunk) }

    output_path = sha_path(text)

    if text =~ SENTENCE_REGEX
      `sox #{synthesized_chunks.join(" ")} #{output_path}`
    end

    `play -q #{output_path}`
  end

  def self.beep_high
    `play -q assets/beep_hi.wav`
  end

  def self.beep_low
    `play -q assets/beep_lo.wav`
  end

  private

  def self.synthesize_chunk(chunk)
    output_path = sha_path(chunk)

    unless File.exist?(output_path)
      response = HTTParty.get('http://translate.google.com/translate_tts',
                              query: { tl: :en_GB, q: chunk })

      File.write(output_path, response)
    end

    output_path
  end

  def self.sha_path(text)
    "spoken_expressions/#{Digest::SHA1.hexdigest(text)}.mp3"
  end
end
