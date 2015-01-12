require_relative 'voice_activation'
require_relative 'wit'
require_relative 'wikipedia'
require_relative 'wolfram'
require_relative 'music'
require_relative 'util'

require 'json'

MY_NAME = "yulees"

def main_loop
  loop do
    VoiceActivation.listen_for_keyword('are you there') do
      puts "--- New command detected ... ---"

      Util.beep_high
      message_path = Util.record_message
      Util.beep_low

      wit_response = Wit.get_intent_from_voice(message_path)

      puts "Understood speech as: #{wit_response['_text'].inspect}"

      top_hit = wit_response['outcomes'].first
      entities = top_hit['entities']

      case top_hit['intent']
      when 'search'
        search_provider = entities['search_provider'][0]['value']
        search_query = entities['search_query'][0]['value']

        do_search(search_provider, search_query)

      when 'play_song'
        song_query = top_hit['entities']['search_query'][0]['value']

        do_play_song(song_query)
      end

      puts "--- Command execution completed. ---"
    end
  end
end

def do_search(provider, query)
  case provider
  when 'Wikipedia'
    do_wikipedia_search(query)
  when 'Wolfram Alpha'
    do_wolfram_search(query)
  end
end

def do_wikipedia_search(query)
  Util.say "I am searching Wikipedia for information about #{query}."

  relevant_articles = Wikipedia.search_articles(query)
  summary = Wikipedia.article_summary(relevant_articles.first)

  Util.say "Here it is:"
  Util.say summary
end

def do_wolfram_search(query)
  Util.say "I am searching Wolfram Alpha for information about #{query}."

  result = WolframUtil.calculate(query)
  if result
    Util.say "Here is is:"
    Util.say result.to_s
  else
    Util.say "I'm sorry, I couldn't find an answer to your question."
  end
end

def do_play_song(song)
  song_name = Music.queue_song(song)
  Util.say "Now playing: #{song_name}"
  Music.unpause
end

Util.say "Claris is online and ready to go."
main_loop
