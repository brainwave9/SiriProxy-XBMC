require 'httparty'
require 'active_support/core_ext'

class XBMCLibrary
  # Error class for indicating trouble with authentication against the XBMC Api
  class UnauthorizedError < StandardError; end;
  
  include HTTParty

  def initialize(serverlist, appname)
    @xbmc = serverlist
    @appname = appname
  end

  def set_xbmc_config(location="default")
    if (!@xbmc.has_key?(location) || !@xbmc[location].has_key?("host") || !@xbmc[location]["host"] == "")
      puts "[#{@appname}] No host configured for #{location}."
      return false
    end

    self.class.base_uri "http://#{@xbmc[location]["host"]}:#{@xbmc[location]["port"]}"
    self.class.basic_auth @xbmc[location]["username"], @xbmc[location]["password"]

    return true
  end


  # API interaction: Invokes the given method with given params, parses the JSON response body, maps it to
  # a HashWithIndifferentAccess and returns the :result subcollection
  def xbmc(method, params={})
    JSON.parse(invoke_json_method(method, params).body).with_indifferent_access[:result]
  end
    
  # Raw API interaction: Invoke the given JSON RPC Api call and return the raw response (which is an instance of
  # HTTParty::Response)
  def invoke_json_method(method, params={})
    response = self.class.post('/jsonrpc', :body => {"jsonrpc" => "2.0", "params" => params, "id" => "1", "method" => method}.to_json)
    raise XBMCLibrary::UnauthorizedError, "Could not authorize with XBMC. Did you set up the correct user name and password ?" if response.response.class == Net::HTTPUnauthorized
    response
      
    # Capture connection errors and send them out with a custom message
    rescue Errno::ECONNREFUSED, SocketError, HTTParty::UnsupportedURIScheme => err
    raise err.class, err.message + ". Did you configure the url and port for XBMC properly using Xbmc.base_uri 'http://localhost:1234'?"
  end


  def test()
    return xbmc('VideoLibrary.GetRecentlyAddedMovies')
  end


  def connect(location)
    puts "[#{@appname}] Connecting to the XBMC interface (#{location})"
    $apiLoaded = false
    begin
      if (set_xbmc_config(location))
        $apiVersion = ""
        $apiVersion = xbmc('JSONRPC.version')

        if ($apiVersion["version"] == 2)
          puts "[#{@appname}] XBMC API Version #{$apiVersion["version"]} - Dharma"
        else
          puts "[#{@appname}] XBMC API Version #{$apiVersion["version"]} - Eden"
        end
        $apiLoaded = true
      end
    rescue
      puts "[#{@appname}] An error occurred: #{$!}"
    end
    return $apiLoaded
  end

  def get_video_player()
    puts "[#{@appname}] Get active video player (API version #{$apiVersion["version"]})"
    result = ""
    if ($apiVersion["version"] == 2)
      players = xbmc('Player.GetActivePlayers')
      result = players
    else
      players = xbmc('Player.GetActivePlayers')
      players.each { |player|
        if (player["type"] == "video")
          result = player["playerid"]
        end
      }
    end
    return result
  end

  def find_movie(title)
    puts "[#{@appname}] Finding movie (API version #{$apiVersion["version"]})"
    result = ""
    title = title.downcase.gsub(/[^0-9A-Za-z]/, '')
    if ($apiVersion["version"] == 2)
      movies = xbmc('VideoLibrary.GetMovies', { :fields => ["file", "genre", "director", "title", "originaltitle", "runtime", "year", "playcount", "rating", "lastplayed"] })["movies"]
    else
      movies = xbmc('VideoLibrary.GetMovies', { :properties => ["file", "genre", "director", "title", "originaltitle", "runtime", "year", "playcount", "rating", "lastplayed"] })["movies"]
    end
    movies.each { |movie|

      movietitle = movie["label"].downcase.gsub(/[^0-9A-Za-z]/, '')

      if movietitle.match(title)
        return movie
      end
    }
    return result
  end

  def find_show(title)
    puts "[#{@appname}] Finding TV show (API version #{$apiVersion["version"]})"
    result = ""
    title = title.downcase.gsub(/[^0-9A-Za-z]/, '')
    if ($apiVersion["version"] == 2)
      tvshows = xbmc('VideoLibrary.GetTVShows')["tvshows"]
    else
      tvshows = xbmc('VideoLibrary.GetTVShows')["tvshows"]
    end
    tvshows.each { |tvshow|

      tvshowtitle = tvshow["label"].downcase.gsub(/[^0-9A-Za-z]/, '')

      if tvshowtitle.match(title)
        return tvshow
      end
    }
    return result
  end
  
  def find_first_unwatched_episode(tvshowid)
    puts "[#{@appname}] Looking up first unwatched episode (API version #{$apiVersion["version"]})"
    result = ""
	if ($apiVersion["version"] == 2)
      episodes = xbmc('VideoLibrary.GetEpisodes', { :tvshowid => tvshowid, :fields => ["title", "showtitle", "season", "episode", "runtime", "playcount", "rating", "file"] } )["episodes"]
	else  
      episodes = xbmc('VideoLibrary.GetEpisodes', { :tvshowid => tvshowid, :properties => ["title", "showtitle", "season", "episode", "runtime", "playcount", "rating", "file"] } )["episodes"]
    end
    episodes.each { |episode|

      if (episode["playcount"] == 0)
        return episode
      end         
    }
        return result
  end

  def play(file)
    puts "[#{@appname}] Playing file (API version #{$apiVersion["version"]})"
    begin
      if ($apiVersion["version"] == 2)
        xbmc('VideoPlaylist.Clear')
        xbmc('VideoPlaylist.Add', file)
        xbmc('VideoPlaylist.Play')
      else
        playItem = Hash[:file => file]
        xbmc('Player.Open', { :item => playItem })
      end
    rescue
      puts "[#{@appname}] An error occurred: #{$!}"
    end
  end


  def stop()
    player = get_video_player()
    if (player != "")
      if ($apiVersion["version"] == 2)
        xbmc('VideoPlayer.Stop')
        return true
      else
        xbmc('Player.Stop', { :playerid => player })
        return true
      end
    end
    return false
  end

  def pause()
    player = get_video_player()
    if (player != "")
      if ($apiVersion["version"] == 2)
        xbmc('VideoPlayer.PlayPause')
        return true
      else
        xbmc('Player.PlayPause', { :playerid => player })
        return true
      end
    end
    return false
  end

end

