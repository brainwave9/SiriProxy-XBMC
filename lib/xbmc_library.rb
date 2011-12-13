require 'xbmc-client'

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
      puts "[#{@appname}] XBMC API Version ",$apiVersion["version"]
      $apiLoaded = true
    rescue
      puts "[#{@appname}] An error occurred: ",$!
      $apiLoaded = false
    end
    return $apiLoaded
  end


  def find_show(title)
    result = ""
    title = title.downcase.gsub(/[^0-9A-Za-z]/, '')
    tvshows = Xbmc::VideoLibrary.get_tv_shows
    tvshows.each { |tvshow|

      tvshowtitle = tvshow["label"].downcase.gsub(/[^0-9A-Za-z]/, '')

      if tvshowtitle.match(title)
        return tvshow
      end
    }
    return result
  end
  
  def find_first_unwatched_episode(tvshowid)
    result = ""
	if ($apiVersion["version"] == "2")
      episodes = Xbmc::VideoLibrary.get_episodes( :tvshowid => tvshowid, :fields => ["title", "showtitle", "duration", "season", "episode", "runtime", "playcount", "rating"] )
	else  
      episodes = Xbmc::VideoLibrary.get_episodes( :tvshowid => tvshowid, :fields => ["title", "showtitle", "duration", "season", "episode", "runtime", "playcount", "rating"] )
    end
    episodes.each { |episode|

      if (episode["playcount"] == 0)
        return episode
      end         
    }
        return result
  end

  def play(file)
    Xbmc::VideoPlaylist.clear
    Xbmc::VideoPlaylist.add(file)
    Xbmc::VideoPlaylist.play
  end

end

