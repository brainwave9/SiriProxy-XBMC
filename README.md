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
This project uses parts of [xbmc-client](https://github.com/colszowka/xbmc-client), created by [Christoph Olszowka](https://github.com/colszowka)


Installation
------------
To install SiriProxy-XBMC, add the following to your Siri Proxy config.yml file (~/.siriproxy/config.yml):

    - name: 'XBMC'
      git: 'git://github.com/brainwave9/SiriProxy-XBMC.git'
      xbmc_host: '192.168.1.4' #Internal IP address of your computer running XBMC.
      xbmc_port: 8080          #Port that the XBMC interface listens to.
      xbmc_username: 'xbmc'    #Username as specified in XBMC
      xbmc_password: 'xbmc'    #password as specified in XBMC

Stop Siri Proxy (CTRL-C if it's running in the foreground or `killall siriproxy` if it's running in the background)

Update Siri Proxy (`siriproxy update`)
          
Start Siri Proxy (`siriproxy server`)

The SiriProxy-XBMC plugin should now be ready for use.


Multiroom configuration
-----------------------
If you have multiple XBMC systems in your house you can configure SiriProxy-XBMC to control them.
To do so, create a configuration file called xbmc_rooms.yml and put in the same folder as config.yml
Here is an example of the rooms file:

    living room:
      host: '1.2.3.4'
      port: 8080
      username: 'xbmc'
      password: 'xbmc'
    game room:
      host: '1.2.3.5'
      port: 8080
      username: 'xbmc'
      password: 'xbmc'

The names 'living room' and 'game room' is what you use as room name when talking to Siri.
Use lowercase letters only for the room names, that is what SiriProxy-XBMC expects.
When you create the file xbmc_rooms.yml, the settings in config.yml are no longer used.


Usage
-----
The currently implemented commands are:

    xbmc [room]

This command can be used to test the plugin is working.
Siri will respond with "XBMC is online"
Optionally you can specify a room name if you have configured the plugin for multiple rooms.

    I'm in the <room name>
    Use the <room name>
    Control the <room name>

These commands set the active room.
All commands will be sent to this room, until you specify another room of course.

    play <title> [in the <room name>]

This command will first look in your TV show library and play the first unwatched episode.
If no TV show is found, it will look in your movie library and play the first matching movie.
If you specify a room name, it will be played in that room and the active room will be updated.

    pause

This command pauses the video player

    resume
    unpause
    continue

These command resume the video player

    stop

This command stops the video player


Notes
-----
Title matching is very basic at the moment.
Sometimes Siri is not correctly interpreting the name of the TV show, so you may not get a match.
For instance the show 'two and a half men' is interpreted by Siri as '2 1/2 men', which does not match the title in the TV library.
However 'knight rider' is interpreted as 'night rider', which partially matches the name, so SiriProxy-XBMC will find it.
I'm open to suggestions on how to improve this further.

The plugin is currently not able to handle multiple users controlling multiple rooms at the same time.
It can currently only keep track of the last active room.
I hope to find a way of identifying seperate users so I can keep track of active rooms per user.


