require 'xbmc_client_v3'

class XBMCLibrary
  def initialize(host, port, username, password, appname)
    @xbmc_host = host
    @xbmc_port = port
    @xbmc_username = username
    @xbmc_password = password
    @appname = appname
    Xbmc.base_uri "http://#{@xbmc_host}:#{@xbmc_port}"
    Xbmc.basic_auth @xbmc_username, @xbmc_password
  end

  def load_api()
    puts "[#{@appname}] Connecting to the XBMC interface"
    begin
      Xbmc.load_api! # This will call JSONRPC.Introspect and create all subclasses and methods dynamically
      $apiVersion = ""
      $apiVersion = Xbmc::JSONRPC.version
      if ($apiVersion["version"] == 2)
        puts "[#{@appname}] XBMC API Version #{$apiVersion["version"]} - Dharma"
      else
        puts "[#{@appname}] XBMC API Version #{$apiVersion["version"]} - Eden"
      end
      $apiLoaded = true
    rescue
      puts "[#{@appname}] An error occurred: #{$!}"
      $apiLoaded = false
    end
    return $apiLoaded
  end


  def find_show(title)
    puts "[#{@appname}] Finding TV show (API version #{$apiVersion["version"]})"
    result = ""
    title = title.downcase.gsub(/[^0-9A-Za-z]/, '')
    if ($apiVersion["version"] == 2)
      tvshows = Xbmc::VideoLibrary.get_tv_shows
    else
      tvshows = Xbmc::VideoLibrary.get_tv_shows
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
      episodes = Xbmc::VideoLibrary.get_episodes( :tvshowid => tvshowid, :fields => ["title", "showtitle", "season", "episode", "runtime", "playcount", "rating", "file"] )
	else  
      episodes = Xbmc::VideoLibrary.get_episodes( :tvshowid => tvshowid, :properties => ["title", "showtitle", "season", "episode", "runtime", "playcount", "rating", "file"] )
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
        Xbmc::VideoPlaylist.clear
        Xbmc::VideoPlaylist.add(file)
        Xbmc::VideoPlaylist.play
      else
        playItem = Hash[:file => file]
        Xbmc::Player.open(:item => playItem)
      end
    rescue
      puts "[#{@appname}] An error occurred: #{$!}"
    end
  end

end

