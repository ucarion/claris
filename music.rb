require 'shellwords'

module Music
  def self.queue_song(song_name)
    song_id = `mpc search any #{song_name.shellescape}`.split("\n").first
    `mpc clear`
    `mpc add "#{song_id.shellescape}"`
    `mpc playlist --format="%title%"`
  end

  def self.unpause
    `mpc play`
  end
end
