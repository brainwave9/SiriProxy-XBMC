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
require 'xbmc_library'

#######
# This is plugin to control XBMC
# Remember to configure the host and port for your XBMC computer in config.yml in the SiriProxy dir
######

class SiriProxy::Plugin::XBMC < SiriProxy::Plugin
  def initialize(config)
    appname = "SiriProxy-XBMC"
    host = config["xbmc_host"]
    port = config["xbmc_port"]
    username = config["xbmc_username"]
    password = config["xbmc_password"]
    @xbmc_library = XBMCLibrary.new(host, port, username, password, appname)
  end

  #show plugin status
  listen_for /[xX] *[bB] *[mM] *[cC]/i do 
    if (@xbmc_library.load_api)
      say "The XBMC interface is up and running"
    else 
      say "The XBMC interface is unavailable, please check the plugin configuration and check if XBMC is running"
    end
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  #play movie or episode (not working yet)
  listen_for /play (.*)/i do |title|
    if (@xbmc_library.load_api)
      tvshow = @xbmc_library.find_show(title)
      if (tvshow == "")
        say "Title not found, please try again"
      else  
        episode = @xbmc_library.find_first_unwatched_episode(tvshow["tvshowid"])
        if (episode == "")
          say "No unwatched episode found for the \"#{tvshow["label"]}\""
        else    
          say "Now playing \"#{episode["title"]}\" (#{episode["showtitle"]}, Season #{episode["season"]}, Episode #{episode["episode"]})", spoken: "Now playing \"#{episode["title"]}\""
          @xbmc_library.play(episode["file"])
        end
      end
    else 
      say "The XBMC interface is unavailable, please check the plugin configuration or check if XBMC is running"
    end
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  
end
