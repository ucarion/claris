require_relative 'voice_activation'
require_relative 'wit'
require_relative 'wikipedia'
require_relative 'wolfram'
require_relative 'util'

require 'json'

MY_NAME = "yulees"

def do_wikipedia_search(top_hit)
  query = top_hit['entities']['wikipedia_search_query'][0]['value']

  Util.say "I am searching Wikipedia for information about #{query}."

  relevant_articles = Wikipedia.search_articles(query)
  summary = Wikipedia.article_summary(relevant_articles.first)

  Util.say "Here it is:"
  Util.say summary
end

def do_wolfram_search(top_hit)
  query = top_hit['entities']['wolfram_search_query'][0]['value']

  Util.say "I am searching Wolfram Alpha for information about #{query}."

  result = WolframUtil.calculate(query)
  if result
    Util.say "Here is is:"
    Util.say result.to_s
  else
    Util.say "I'm sorry, I couldn't find an answer to your question."
  end
end

Util.say "Jarvis is online and ready to go."

VoiceActivation.listen_for_keyword('are you there') do
  puts "--- New command detected ... ---"

  Util.say "Yes?"

  wit_response = Wit.get_intent_from_voice(Util.record_message)

  puts "Understood speech as: #{wit_response['_text'].inspect}"

  top_hit = wit_response['outcomes'].first
  top_hit_intent = top_hit['intent']

  case top_hit_intent
  when 'wikipedia_search'
    do_wikipedia_search(top_hit)
  when 'wolfram_search'
    do_wolfram_search(top_hit)
  end

  puts "--- Command execution completed. ---"
end
