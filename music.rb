require 'shellwords'

module Music
  def self.queue_song(song_name)
    results = `mpc search any #{song_name.shellescape}`.split("\n")
    song_id = results.find { |entry| entry.include?('track') }

    `mpc add "#{song_id.shellescape}"`

    # Get the name of the song just added
    `mpc playlist`.split("\n").last
  end

  def self.unpause
    `mpc play`
  end
end
