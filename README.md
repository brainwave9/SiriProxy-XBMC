SiriProxy-XBMC
==============

About
-----
SiriProxy-XBMC is a [Siri Proxy](https://github.com/plamoni/SiriProxy) plugin that allows you to send commands to [XBMC](http://www.xbmc.org).

SiriProxy-XBMC was created by brainwave9.
You are free to use, modify, and redistribute this gem as long as you give proper credit to the original author.

*Note: I haven't coded in ruby before, so feel free to point out mistakes/corrections, etc, etc.


Credits
-------
This project uses [xbmc-client](https://github.com/colszowka/xbmc-client), created by [Christoph Olszowka](https://github.com/colszowka)


Usage
-----
The currently implemented commands are:

    xbmc

This command can be used to test the plugin is working.
Siri will respond with "The XBMC interface is up and running"

    play <title>

This command will look in your TV show library and play the first unwatched episode.

Please note that title matching is very basic at the moment.
Sometimes Siri is not correctly interpreting the name of the TV show, so you may not get a match.
For instance the show 'two and a half men' is interpreted by Siri as '2 1/2 men', which does not match the title in the TV library.
However 'knight rider' is interpreted as 'night rider', which partially matches the name, so SiriProxy-XBMC will find it.
I'm open to suggestions on how to improve this further.



Installation
------------

To install SiriProxy-XBMC, add the following to your Siri Proxy config.yml file (~/.siriproxy/config.yml):

    - name: 'XBMC'
      git: 'git://github.com/brainwave9/SiriProxy-XBMC.git'

Stop Siri Proxy (CTRL-C or `killall siriproxy`)

Update Siri Proxy (`siriproxy update`)
          
Start Siri Proxy (`siriproxy server`)

The SiriProxy-XBMC plugin should now be ready for use.


