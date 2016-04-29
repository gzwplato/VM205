# VM205
Hacking the Velleman Raspberry Pi VM205 Oscilloscope Lazarus code to better suit my needs/environment

* Raspberry Pi 2
* 16GB SD Card (will migrate to a Sd-card-boot-to-HDD-system in time)
* Velleman VM205 Oscilloscope board (v1.2)
* Lilliput FA1011-NP/C 10.1" 1024x600 HDMI/USB touch screen (that I had kicking around)
* Sparkfun ATX Breakout board v1.1
* Lazarus v1.7

Part of the project will include boxing all of this up so that it's in a self-contained box with a PC ATX power supply, a Sparkfun ATX Breakout board and a few bits and pieces such that everything is powered from a single mains plug. I'd like to have a sturdy box with the screen on top, a BNC socket for a probe, some access to the logic analyser pins and access to the Sparkfun breakout banana sockets (so the box also acts as a bench power supply). No visible wires for the Pi or the display etc.


## Top level to-do
* re-arrange screen to best fit a 1024x600 touch screen (move most controls over to the right)
* option to save current settings upon exit (and auto-reload upon next startup)
* capture current trace and 'freeze it'
* save frozen trace as an image
* save period of time as an animation/movie file of some sort?
* save period of time as an array of values (possibly XML or CSV)
 

## Other useful links
[Configuring the Lilliput](https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=124591 "Raspberry Pi Forum page")

[Velleman VM205 Product Page](https://www.velleman.eu/products/view/?id=418968 "Velleman VM205 Product Page")

[Sparkfun ATX Breakout Board](https://www.sparkfun.com/products/12867 "Sparkfun ATX Breakout Board")
