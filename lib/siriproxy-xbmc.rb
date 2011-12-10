# Copyright (C) 2011 by Rik Halfmouw <rik@iwg.nl>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'cora'
require 'siri_objects'
require 'xbmc-client'

#######
# This is plugin to control XBMC
# Remember to configure the host and port for your XBMC computer in config.yml in the SiriProxy dir
######

class SiriProxy::Plugin::XBMC < SiriProxy::Plugin
  def initialize(config)
    host = config["xbmc_host"]
    port = config["xbmc_port"]
    username = config["xbmc_username"]
    password = config["xbmc_password"]
    Xbmc.base_uri "http://#{host}:#{port}"
    Xbmc.basic_auth username, password
  end

  def load_api()
    puts "Loading XBMC interface"
    begin
      Xbmc.load_api! # This will call JSONRPC.Introspect and create all subclasses and methods dynamically
      $apiVersion = ""
      $apiVersion = Xbmc::JSONRPC.version
      $apiLoaded = true
    rescue
      $apiLoaded = false
    end
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
    episodes = Xbmc::VideoLibrary.get_episodes( :tvshowid => tvshowid, :fields => ["title", "showtitle", "duration", "season", "episode", "runtime", "playcount", "rating"] )
    episodes.each { |episode|

      if (episode["playcount"] == 0)
        return episode
      end	  
    }
	return result
  end

  #show plugin status
  listen_for /[xX] *[bB] *[mM] *[cC]/i do 
    load_api
    if ($apiLoaded)
      say "The XBMC interface is up and running"
    else 
      say "The XBMC interface is unavailable, please check the plugin configuration and check if XBMC is running"
    end
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  #play movie or episode (not working yet)
  listen_for /play (.*)/i do |title|
    load_api
    if ($apiLoaded)
      tvshow = find_show(title)
      if (tvshow == "")
        say "Title not found, please try again"
      else  
        episode = find_first_unwatched_episode(tvshow["tvshowid"])
        if (episode == "")
          say "No unwatched episode found for the \"#{tvshow["label"]}\""
        else    
          say "Now playing \"#{episode["title"]}\" (#{episode["showtitle"]}, Season #{episode["season"]}, Episode #{episode["episode"]})", spoken: "Now playing \"#{episode["title"]}\""
          Xbmc::VideoPlaylist.clear
          Xbmc::VideoPlaylist.add(episode["file"])
          Xbmc::VideoPlaylist.play
        end
      end
    else 
      say "The XBMC interface is unavailable, please check the plugin configuration or check if XBMC is running"
    end
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  
end
