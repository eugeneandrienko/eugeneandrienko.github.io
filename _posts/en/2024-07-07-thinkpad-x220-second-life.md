---
layout: post
title: Thinkpad X220 second life
category: it
date: 2024-07-07 17:31
lang: en
comments: true
hidden:
  - related_posts
banner:
  image: /assets/static/header-make-thinkpad-cool-again.jpg
  opacity: 0.6
---

Lenovo Thinkpad X220 is one of my favorite laptop models (the other one
is Panasonic Toughbook CF-19). It has a beautiful seven-row keyboard
with space for all the necessary buttons — there are even separate
buttons for `Home`, `End`, `Pause`[^1] and `Insert`! Rugged magnesium
alloy case covered with some kind of rubber for better grip. A memorable
appearance — an angular black rectangle that looks austere and at the
same time quite retro-futuristic. And relatively powerful hardware,
which can be used to this day.

Ah, if it was made not by Lenovo but by IBM; had a keyboard and
modularity like the [IBM Thinkpad
760XD](https://chaos.social/@xtaran/112084915245772102), and a
mechanical keyboard; and a trackball like the one on the Thinkpad 220 —
it would be priceless!

![](/assets/static/thinkpad220.jpg) *Author: Matthew S. Smith /
Lifewire*

The Thinkpad X220 has appealed to me since my university days.
Unfortunately, in those old days such a laptop for an unemployed student
was not much different in price from a Boeing wing. But the years went
by and at one point I was able to treat myself and bought this laptop,
with that canonical keyboard with blue Enter, to close the gestalt, so
to speak.

Thankfully, at 2019, the prices for a used Thinkpad X220 are no longer
the barrier and I found a used laptop from Europe quite quickly for
about 19000 rubles (about \$300). It was a machine with a 2.7 GHz
quad-core Intel Core i7, 8 Gb of RAM and with an SSD. Fortunately, its
previous owner was careful and the laptop had only a few light spots on
the display[^2] from accidental bumps and microscopic scuffs on the
corners of the lid.

Perfect things don't exist in this world — otherwise this article
wouldn't have appeared and engineers would have died of boredom. I've
been using my laptop in 4 years and I've encountered a number of
inconveniences:

- The aforementioned smudges on the screen. This is cured, obviously, by
  replacing the display with a new one.
- The screen resolution is 1366x768 — it's **hard** to process photos on
  it because you can see the pixels! At the same time, I've seen people
  calmly processing photos on a MacBook with a slightly larger screen
  diagonal — because it has a resolution of 2560×1600 and the photos
  look clear enough.
- Whitelist in the BIOS — prevents you from plugging in "non
  manufacturer approved" WiFi cards and other internal peripherals that
  may be even better than what was "approved".
- The keyboard has a [United Kingdom
  layout](https://en.wikipedia.org/wiki/British_and_American_keyboards),
  whereas I'm used to the United States one.

And, of course, I couldn't rest a thorn in the side. Modifying a laptop,
so popular among techies, is like installing mods on Skyrim — you can
always add something interesting.

In today's boring world, when in response to the above challenges most
people just shrug their shoulders and buy a new laptop, shaped like a
flat bar of soap and indistinguishable from its counterparts on the
store shelf — all with the same glossy screen, the same non-removable
battery, a flat island keyboard that doesn't give a pleasant typing
experience, and a MacBook-like touchpad — someone has to keep doing fun
things, right?

![](/assets/static/d71f964b-c3d0-d724-a205-dfe2fcbe9d5a-en.jpg)

## Installing a new 2K screen

Of course, I started with the thing that bothered me the most — the
display. I wanted my X220 to have a matte display with a resolution like
a MacBook's display. Matte screen will not glare and fingerprints on it
will be less noticeable. Before, I had Asus F6E with glossy display —
all reflections from windows, ceiling lamps and other light sources were
mine. But when you get used to it — it seems as if everything is
comfortable and there are no problems: "just turn the brightness up a
bit more now and that's it" 🤡.

I knew that someone
[nitrocaster](https://nitrocaster.me/store/x220-x230-fhd-mod-kit.html)
made HD mod for Thinkpad X220 — but it is now out of stock in his store.
Also, some Chinese guy made motherboards for X220 case with modern
hardware and 30-pin LVDS connector, which is suitable for connecting
modern displays without a soldering iron. But, as I read on Reddit, he
got tired and temporarily stopped taking orders.

Luckily, I found on the AliExpress [Thinkpad expansion
boards](https://aliexpress.ru/item/1005004222503527.html) that add a
FHD, 2K or 4K screen support. The installation instructions for these
boards are no better than Chinese datasheets for electronic components
translated to Russian. But that didn't stop me — I immediately bought a
2K-modification board, a cable for the display and the display itself
(from another seller). Lucky, focusing solely on reviews of the kind: "I
bought this display for the 2K modification of my ThinkPad, everything
works, thank you" — I'm find the Sharp LQ125T1JW02 display that suited
me.

Due to the lack of good documentation, I had to look at the Chinese
manual with one eye, the [nitrocaster
PDF](https://nitrocaster.me/files/x220.x230_fhd_mod_rev5_v0.2.pdf) with
the other, and use the common sense and university skills with the third
eye.

The easiest part is disassembling the laptop — it can be disassembled
almost blindly, using only a screwdriver and [a
manual](https://download.lenovo.com/ibmdl/pub/pc/pccbbs/mobiles_pdf/0a60739_04.pdf).
And then comes the most interesting part…

I removed resistor R318 and soldered *one* copper wire each to
capacitors C137 and C584 — these wires will be soldered to the
modification board later. It turned out that it is **very important** to
use only one thin wire — even several wires soldered together will
easily tear off the contact pad along with the capacitor itself. In my
first attempt to modify the X220, this is exactly what happened — and I
had the need to solder **only one** wire to the via hole where the track
from the C137 capacitor went:

![](/assets/static/soldered_via.jpg) *Torn off capacitor and
soldering to the via hole*

Fortunately, this capacitor was not really needed, because the track
from it went to the Display Port connector of the docking station, whose
lines are already occupied by the 2K modification board:

![](/assets/static/dock_dp_schematic.jpg)

Next I begin to work with the Chinese board. My board required a little
treatment with a file and wire cutters, because it was carelessly bitten
out of the board panel after etching the tracks. I also soldered two
contact pads (marked with arrows on the photo), where the wires,
described above, will be soldered:

![](/assets/static/2K_mod_board.jpg) *Chinese 2K modification
board for Thinkpad X220*

After that I carefully installed the expansion board onto the
motherboard, checking that the pins from the dock connector fall into
the correct holes:

![](/assets/static/dock_interface_contacts.jpg)

And began to solder. It's easy to understand what exactly to solder —
the corresponding holes have gold plating. For the small round holes, I
had to use the thinnest and sharpest soldering tip to reach the pins of
the dock connector and heat the solder around them.

Since 2011, because everyone who manufactures consumer electronics had
already switched to lead-free solder — naturally nothing heated up and
soldered. I had to increase the temperature of the soldering iron a
little and add normal, i.e. lead solder to the soldering points so that
the tin began to melt. Only after that I got something. Of course, I
used a flux suitable for microelectronics (not rosin and not acidic) —
without it nothing would have worked at all.

![](/assets/static/soldered_2k_board.jpg) *Soldered
2K-modification board*

As you can see, here I peeled the film from the soldering area, soldered
the 2K mod board, and then covered everything with the film again,
cutting a window for the LVDS connector. This way, accidentally spilled
water will not get on any of the boards and will easily go down the
drain, as IBM engineers intended.

![](/assets/static/covered_2k_board.jpg) *2K-modification board
installed and covered with protective film*

Of course, the 2K screen didn't work the first time. At first the
external display didn't even turn on and was absent in the `xrandr`
output. But after I tapped the expansion board with a plastic stick it
suddenly appeared in the utility output. Further tapping on the board
caused the image on the new display to blink and show multicolored
stripes — like with a damaged video cable. Since "electronics is the
science of contacts" — it's obvious that one of the tiny round holes
didn't connect to the connector's pin on the motherboard. Or perhaps the
soldering was bad and cracked from the impacts. I had to disconnect the
motherboard from the peripherals again and solder the 2K mod board once
more. In the process, it turned out that the soldering iron wasn't hot
enough the first time — sometimes it stuck to the tin of the newly
soldered hole — but I didn't pay attention to that the first time.

After re-soldering the contacts, the new display worked immediately and
did not respond in any way to tapping on the expansion board:

![](/assets/static/2K_display.jpg)

However, multicolored stripes on the screen are not the only sign of
contacts problems. I've had the new display sometimes not turn on and
was recognized by `xrandr` as having a resolution of 640x480. Also,
after turning off both displays to save power — the main display would
turn on, but the new one would only turn on the backlight, but no image
would appear. All these problems were also solved by re-soldering the
round contacts on the expansion board.

But my adventures with a soldering iron didn't end there — I
accidentally burned the motherboard…

For the first time in all the time I had this laptop, I installed
Windows on it. After such a sacrilege[^3] it froze intentionally — so
much so that it didn't even respond to a long press of the power button.
I rashly removed the battery from the working laptop — and then it
didn't even turn on, just blinking once with the power button and that's
all…

If I left the board to lie on the workbench for half a day so that the
electronic gnomes could rest without voltage connected, it still turned
on. But for about half an hour, after which the symptoms of freezing
were repeated, alas, in any operating system. In my attempts to fix
everything, I reached the power control chip for laptops (`U59`) — I
managed to check that all power lines approaching this chip really
supply the power — 3.3V, 5V, 17V, and 20V.

![](/assets/static/u59.jpg)

There will be no happy end. When I started to check what's on the signal
inputs, my hand shook and the 17V power line was shorted to one of the
signal lines. After that, something burned out either in the circuitry
coming from the charging/external power connector or somewhere around
the 3.3/5V DC-DC converters. It was already the seventh day of digging
into the non-working board (at first I thought that the problem was in
the BIOS and experimented with it), all this bored me a lot — and I just
did as per Lenovo service manual — threw the broken board in the corner
and put a known working board on the place. I was lucky to find an
original working board with Core i7 on Avito (Russian analog of OLX),
from a person who was selling his old laptop.

Since my hand was already trained, I soldered everything on the second
motherboard without regaining consciousness and the 2K modification
worked from the first time. So I can say that this is not the most
difficult stage of laptop modification, the main thing is not to hurry
and solder carefully.

### Flashing the coreboot

Unfortunately, the new display didn't work in BIOS or GRUB — only in
Linux:

![](/assets/static/no_bios.jpg)

Setting `Config->Display` in the BIOS didn't help, and the Chinese
vendor had a huge delay in answering questions, so I had to manage on my
own. I noticed that the display turns on when Linux switches the output
mode from text to framebuffer. And assumed that if the BIOS also did the
same switching, the problem would be solved.

Of course, the official BIOS can't do that. But in half of the stories
about Thinkpad X220 modding I've seen mention of coreboot. And just now,
in the wiki of this project there was a mention of some libgfxinit,
which can set another video mode besides text mode.

Fortunately, flashing coreboot turned out to be much easier than
flashing the original BIOS. In the case of the latter, you need to find
Windows somewhere, install it on the laptop or make a bootable flash
drive (`dd` will not help here), connect the battery, and make sure it
is charged — otherwise the finicky BIOS update program will refuse to do
anything.

![](/assets/static/flashing_original_bios.jpg) *Updating BIOS on
the ThinkPad*

And for coreboot, you only need the following:

- Physical access to the BIOS chip (in the lower left corner of the
  board, next to the PCI-Express card enclosure)
- A programmer for flash memory chips with SPI interface, e.g. CH341.

![](/assets/static/bios_chip.jpg) *According to the labeling, I
have a Macronix MX25L6406E chip*

The procedure of coreboot flashing is as simple as possible and familiar
to the embedded systems developers — the board is disconnected from
power supply and peripherals and a binary with firmware is written into
it from a computer via a programmer. All this is done through `flashrom`
utility, which doesn't care has laptop the connected battery, how
charged it is and what phase of the moon it is.

The first time I used a clip for the SOP-8 case — all the guides
recommended using it "for convenience" so you didn't have to solder
anything:

![](/assets/static/connected_ch341.jpg) *Clip, connected to the
flash-memory chip*

But with all that advices: "how to do everything without a soldering
iron" — it turned out to be a road to hell. The second motherboard had a
Winbond W25Q64CV chip installed — which, judging by reports from people
who also tried to upload coreboot to it, is very demanding to the
quality of signal lines, unlike the Macronix chip. It requires the
shortest possible lines of the same length and reliable contact with the
chip legs — so, in the end, I still had to solder to the flash memory
chip. Fortunately, all I had to do was to solder to the SPI legs and to
the chip power supply.

![](/assets/static/connected_ch341_2.jpg) *Programmer cable
soldered to the chip*

With a 30-centimeter wires from the clip, I read incomprehensible things
from the chip from Winbond, and the writing most often ended with
errors. Exactly so, the original BIOS from motherboard \#2 was lost
forever… I was "lucky" enough that in two readings of the dump from the
chip — the misread bits were in the same places.

``` example
$ cd bios/
$ sudo flashrom -p ch341a_spi -r bios_thinkpad_x220_original.rom -V
$ sudo flashrom -p ch341a_spi -r 02.rom -V
$ md5sum *.rom
8e7e07cf8cf2f1e8df5fe66cfd92dcb8  02.rom
8e7e07cf8cf2f1e8df5fe66cfd92dcb8  bios_thinkpad_x220_original.rom
```

Apparently, this is why after connecting the programmer, it is advised
to read the contents of the chip for comparsion at least three times,
not two.

My further actions were based on these posts:
[one](https://szclsya.me/posts/coreboot/x220/) and
[two](https://brycevandegrift.xyz/blog/corebooting-a-thinkpad-x220/).
After a few days of experimenting with the first board, before it burned
out, I found out the following:

- coreboot with Legacy video initialization and no Video BIOS does not
  display on the second (2K) monitor.

- coreboot with Legacy video initialization and with Video BIOS, which I
  downloaded from the person who built coreboot for Thinkpad X220 —
  gives green squares on the main display, the second display does not
  work in principle. After the green squares coreboot hangs
  intentionally.

- coreboot with libgfxinit — not shown on the second display. Also, it
  does not support booting the OS in text mode. For example, instead of
  the FreeBSD text installer, you can see a narrow bar with something
  like video interference[^4] at the top of the screen.

  ![](/assets/static/freebsd_n_corebootfb.jpg)

- Chinese BIOS, which is downgraded to 1.44 and patched with special
  Chinese patches just for my 2K modification board — also doesn't
  display on the second monitor.

After that I crawled into the coreboot sources, where I quickly found
out the following:

1.  The DP3 video output to which my 2K monitor is connected via the
    expansion board is described in both coreboot source code and
    libgfxinit source code.
2.  If I change the Ada code for libgfxinit to initialize DP3 at startup
    instead of system LVDS — my 2K display still shows nothing.
3.  If I download the datasheet for the display, write in the coreboot
    code the necessary timings in the video initialization code for
    Lenovo X220 platform and initialize DP3 at startup in legacy video
    mode — the display still doesn't show anything.

Here I either lacked understanding of the Ada language or documentation
about initialization of the built-in Intel GMA 3000 video core on my CPU
("thankfully" user documentation from Intel for this not the latest
video core can now be downloaded only in the darknet 🤡🤡🤡). In the end
my high-definition display still started only inside the OS.

However, the point of corebooting the Thinkpad X220 was still there.
First of all, I, as user, needed from the BIOS only two things:

- be able to run the boot loader from the hard disk
- swap the Ctrl and Fn keys — for me Ctrl is **necessarily** the lower
  left key on the keyboard.

Second, coreboot started up an order of magnitude faster than the
original BIOS. Even despite the added pause of two seconds to allow me
to select another disk for booting. In a situation when your display
starts showing something only at the moment of OS booting, you want to
skip the BIOS boot and the OS loader as fast as possible.

Preparing to build coreboot is quite simple with just one command that
saws the original BIOS dump into binary, proprietary blobs and disables
Intel ME:

``` bash
git clone --recursive https://review.coreboot.org/coreboot.git && \
    git clone https://github.com/corna/me_cleaner.git && \
    cd coreboot/util/ifdtool && make && sudo make install && \
    cd ../../../bios && \
    python ../me_cleaner/me_cleaner.py -s bios_thinkpad_x220_original.rom -O working_copy.rom && \
    ifdtool -x working_copy.rom && \
    mkdir -p ../coreboot/3rdparty/blobs/mainboard/lenovo/x220/ && \
    mv flashregion_0_flashdescriptor.bin ../coreboot/3rdparty/blobs/mainboard/lenovo/x220/descriptor.bin && \
    mv flashregion_2_intel_me.bin ../coreboot/3rdparty/blobs/mainboard/lenovo/x220/me.bin && \
    mv flashregion_3_gbe.bin ../coreboot/3rdparty/blobs/mainboard/lenovo/x220/gbe.bin && \
    rm flashregion*.bin working_copy.rom
```

Fortunately, I was lucky, and despite the fact that the original BIOS
from the second motherboard was read with errors due to the use of clip
and later, after the first reflashing to coreboot, was lost
irretrievably — the required areas in the received binary were not
affected.

I configured coreboot under ThinkPad X220 as follows:

``` example
CONFIG_VENDOR_LENOVO=y
CONFIG_LINEAR_FRAMEBUFFER_MAX_HEIGHT=768
CONFIG_LINEAR_FRAMEBUFFER_MAX_WIDTH=1366
CONFIG_CONSOLE_POST=y
CONFIG_SEABIOS_PS2_TIMEOUT=3000
CONFIG_HAVE_IFD_BIN=y
CONFIG_BOARD_LENOVO_X220=y
CONFIG_PCIEXP_L1_SUB_STATE=y
CONFIG_PCIEXP_CLK_PM=y
CONFIG_H8_SUPPORT_BT_ON_WIFI=y
CONFIG_H8_FN_CTRL_SWAP=y
CONFIG_HAVE_ME_BIN=y
CONFIG_CHECK_ME=y
CONFIG_HAVE_GBE_BIN=y
CONFIG_GENERIC_LINEAR_FRAMEBUFFER=y
CONFIG_DRIVERS_PS2_KEYBOARD=y
CONFIG_COREINFO_SECONDARY_PAYLOAD=y
CONFIG_MEMTEST_SECONDARY_PAYLOAD=y
```

And flashed the resulting binary into the motherboard \#2. And then,
**suddenly**, the time of miracles began! For some reason coreboot was
displayed on 2K display! I already used the same coreboot configuration
on the first board and there something was shown only on the original
display. Moreover, in the reviews on AliExpress one person also wrote
that coreboot was not displayed on the 2K screen.

Also, [in the coreboot mailing
list](https://mail.coreboot.org/pipermail/coreboot/2017-January/082956.html)
I saw a person with a similar problem. And the only solution he was
given was to either disassemble and patch the original Video BIOS so
that it outputs video to the right interface instead of LVDS. Or switch
to libgfxinit and edit its source code so that the right video output is
used at system startup.

Why everything suddenly worked on the second motherboard, which differs
from the first one only by the brand of the Flash-memory chip for BIOS,
and without any edits in the coreboot source code — I don't know 🤷‍♂️.

Probably, since the response to the above-mentioned letter in the
mailing list, the libgfxinit developer has already managed to implement
graphical output to all interfaces available on the board. And nothing
worked with my motherboard \#1 because of the same thing that eventually
caused it to die. Maybe when rebuilding coreboot from scratch again, I
enabled a couple options that I didn't seem to have before. To figure
out what happened — I need a bit more equipment than I have now, and a
few more motherboards and 2K-modification boards to test. I'm certainly
not ready to test my hypotheses on the only (out of two) working boards.

### Installing the new display

What remains is … to install the display in its rightful place.

![](/assets/static/monitor.jpg)

First, I disassembled the original display module according to the
service manual[^5] and took everything unnecessary out of there:

- Video cable to the old display (goes through the left hinge)
- The old display itself
- Wires to the antennas from the WWAN-module — blue and red (why I
  removed them — I wrote below, in the section about WiFi-module).
- The wire to the antenna from the WiFi card — black wire.

Also I took off the WWAN antennas and the one WiFi antenna, because we
won't need them where we're going.

![](/assets/static/dismantle_wifi_antenna.jpeg) *Peeling off
unwanted WiFi antennas*

I ended up with this:

![](/assets/static/notebook_lid.jpg)

The left hinge will carry the video cable for the new display. The right
hinge will still be used for the camera and LED-board cables, along with
the cable for the last remaining WiFi antenna.

In order to fit the new display in here, I did a little bit of
locksmithing. The bottom of my 2K display is a bit wider than the
original one and to fit everything inside the laptop lid, I have to cut
off the metal guides near the hinges.

![](/assets/static/lid_parts2mill.jpg) *These guides, next to
both hinges, need to be cut off*

All I had was a Dremel, metal cutting disks and abrasive sanding bits.
That was enough to remove the unwanted guides. But if you happen to have
a milling machine, it's easier to use it! I hear that the result will be
even better and more beautiful.

![](/assets/static/lid_parts_milled.jpg) *Cutted guides*

Also, the display frame needed a little tweaking with a file — I had to
remove the plastic near the hinges a bit so that it wouldn't rest on the
new display. I also bit off a couple of the plastic latches, the mating
pieces for which were just cut with a Dremel.

The new display itself, alas, didn't have any attachment points. It was
just a flat thin rectangle, arrived with a couple of strips of
double-sided tape. Naturally, I wasn't going to be like *modern* laptop
manufacturers and glue the display into the lid, so that I would have to
go through all sorts of pain when I needed to remove it — and I would
have to remove it for almost any actions with the antenna, camera,
keyboard light, etc.

And then my eyes fell on the removed original display — because it
"lies" in such a convenient metal frame, which already has lugs with
holes for screws that screw into the lid of the laptop:

![](/assets/static/back_of_original_display.jpg)

In addition, this frame made it easy to set the desired height of the
new display inside the cover — its face should be flush with the lugs,
similar to the original display:

![](/assets/static/old_display_height.jpg)

The old display was immediately disassembled into useful components — a
metal frame, from which were sawn off the mounts at the bottom for the
control board of the original display and the U-shaped bend in the
bottom "bar". And on a piece of clear plastic, which perfectly
complemented the height of the new display. All this was glued together
with transparent glue and double-sided tape — and as a result, a new 2K
display module was born. It can be removed with just a Phillips
screwdriver, without a soldering dryer and unnecessary suffering.

![](/assets/static/case_for_new_display.jpg) *Mount for 2K
display*

![](/assets/static/new_display.jpg) *New display installed*

The final touch was left. I tore off the Lenovo logo from the lid and
filled the recess under it with epoxy. It's not so easy with the logo
under the display — the white paint is all over the plastic in the frame
and you can't tear off or sand the logo — you can only glue it on. After
that, I ordered stickers with the IBM logo on matte paper from a
printing house, cut them with a knife to the size I needed and glued
them where necessary:

![](/assets/static/logos.webp)

Obviously, after all of Lenovo's "innovations" — when they destroyed the
beautiful 7-row keyboard, removed the separate trackpoint buttons for
some ThinkPad models, removed the ability to hook a docking station and
battery from the bottom of the laptop — that is, they diligently turn
the Thinkpad into a regular laptop "like everyone else's", justifying it
with "the future", "innovations" and the fact that old Thinkpad fans
should adapt (🤡) — I don't really like them.

![](/assets/static/whattheytookfromus.jpg)

![](/assets/static/peakperformance.jpg)

### New display and FreeBSD

Naturally, the new expansion board and the new display required certain
changes in the software as well. First, I adjusted the DPI according [to
the instructions](https://wiki.archlinux.org/title/HiDPI#X_Resources)
([like
this](https://github.com/eugeneandrienko/dotfiles/commit/67ae822f43067ce12f8a928c7b89935f973b7fb5))
so that I could work on the laptop without a magnifying glass.

To avoid typing `vbe on` in the bootloader every time and to see the
FreeBSD's boot log on the new display instead of a narrow strip of
“video noise” at the top of the screen, I added a couple lines to
`/boot/loader.conf`:

``` example
hw.vga.textmode="0"
vbe_max_resolution=2560x1440
```

To disable LVDS output at X-server startup — I used standard utilities
`xrandr` and `backlight`:

``` bash
xrandr --output LVDS-1 --off
xrandr --output DP-3 --primary
backlight 0
```

To change the brightness using the standard buttons on the Thinkpad
keyboard, I had to dig into the system a bit more. The Chinese
manufacturer made a very intricate brightness adjustment for the new
display — a short press on the power button cyclically changes the
brightness from minimum to maximum and back again. Drivers, which return
*normal* brightness adjustment by buttons on the keyboard — there are
only under Windows and they work only with Chinese, patched BIOS. In
Linux and \*BSD I'll have to do it myself (I can't turn to ChatGPT for
advice about *that* problem 😄…).

At first I had to wade through tons of silly advices from forums, where
users suggested to adjust the brightness of external (relative to LVDS
in the laptop) displays via `xbacklight`, `xgamma`, `redshift` and other
utilities that simply change the color gamma and do not touch the actual
physical backlight… Such "changing" the brightness will not affect the
battery drain rate of the laptop.

Then I found this very useful thread on the Thinkpad owners forum: [x220
x230 FHD WQHD 2K mSATA
USB3.0](https://forum.thinkpads.com/viewtopic.php?f=43&t=125030) (for
some reason they blocked access for users from the Russian Federation
🤡, so the link won't open just like that). The contents of this thread
pushed me in the direction of digging into the USB interface used by the
2K-modification board. Unfortunately, by this time I had already
assembled the laptop and really didn't want to disassemble it back, so I
didn't have access to the soldered 2K-modification board in order to
test the `CN15` connector lines going to the docking station.

But, I had something better — a photo of the docking port pins with the
expansion board soldered to them! I also had a burned-out motherboard #1
and a schematic diagram of the laptop. At first glance it seems that
there is nothing to catch here:

![](/assets/static/cn15.png) *CN15 connector to the docking
station*

And then I remember that I look at the board from the back side. I
mirror the drawing — and something similar to the truth already emerges:

![](/assets/static/cn15-mirrored.png) *Mirrored CN15 connector*

In the end, I was able to easily match the legs of the actual interface
and its symbol on the wiring diagram:

![](/assets/static/cn15-correspondence1.png)

![](/assets/static/cn15-correspondence2.png)

Now, from the picture of the 2K-expansion board, I can understand which
`CN15` lines the expansion board uses:

![](/assets/static/2K_board_lines.jpg)

Interesting lines:

- Display Port I2C interface lines to the 2K monitor:
  `DOCKB_DP_DDC_DATA`, `DOCKB_DP_DDC_CLK`.
- The lines from the USB interface to the 2K modification board:
  `USBP8-` и `USBP8+`. The other end goes to the Platform Controller Hub
  (PCH, `U14`).

There were some interesting lines in the `sudo usbconfig list` output:

``` example
ugen0.2: <vendor 0x8087 product 0x0024> at usbus0, cfg=0 md=HOST spd=HIGH (480Mbps) pwr=SAVE (0mA)
ugen2.2: <vendor 0x8087 product 0x0024> at usbus2, cfg=0 md=HOST spd=HIGH (480Mbps) pwr=SAVE (0mA)
ugen0.3: <AGAN X230> at usbus0, cfg=0 md=HOST spd=FULL (12Mbps) pwr=ON (64mA)
ugen2.3: <vendor 0x8087 product 0x0a2b> at usbus2, cfg=0 md=HOST spd=FULL (12Mbps) pwr=ON (100mA)
```

The first two lines and the last one turned out to be devices from Intel
(see [link](http://www.linux-usb.org/usb.ids)):

``` example
8087  Intel Corp.
    0020  Integrated Rate Matching Hub
    0024  Integrated Rate Matching Hub
    0a2b  Bluetooth wireless interface
```

But a search by `AGAN X230` words led to a Taiwanese guy's [GitHub
repository](https://github.com/xy-tech/agan_brightness_X230_X330) and
then to [his site](https://www.xyte.ch/mods/x230/) with detailed
information about modifying Thinkpads. From there I learned more details
about my 2K mod — it turns out that it was originally made by a Chinese
modder 阿甘, known to the world as *a.gain*. And from the GitHub
repository it became clear that I am on the right way and the brightness
of the 2K display can be changed via the USB interface of the board.

Unfortunately, the code from the aforementioned repository was not
perfect, so I wrote my program with one eye peeking at the
`xy-tech/agan_brightness_X230_X330` repository. What is inside my
program:

- Clean C code.
- Parsing command line options via libpopt (rather than manually via
  `atoi`; also the nice `--help` output is automatically generated).
- Autotools build.
- Man page.
- A rule for devd so that the utility can be used without elevating
  privileges to `root`.

The program is written for FreeBSD, but probably, if you have
[libusbhid](https://github.com/libusb/hidapi) library and its header
files installed, it will work under Linux as well. However, instead of a
rule for devd you will have to invent something of your own.

I tested it only under FreeBSD 14 — everything works on my machine 😊.
The source code can be downloaded here:
<https://github.com/eugeneandrienko/brightness_x220_agan2k>, the manual
is also there.

## Replacing the WiFi module

After that there was nothing to stop me. Having replaced the original
BIOS with coreboot, I realized that I could plug any suitable peripheral
inside my laptop without having to deal with whitelist.

I started with WiFi. The Thinkpad X220 originally had a 2.4 GHz card
with 300 Mbps speed (802.11b/g/n). Fortunately, after getting rid of the
whitelist (and the original BIOS) I can install [a completely different
WiFi module](https://aliexpress.ru/item/32853420688.html) (TL-8260D2W) —
with support for 2.4 and 5 GHz bands, with speed of about 800-900 Mbps
and with support of 802.11b/g/n/ac standards. The main thing is to close
with tape 51 pin, otherwise the built-in Bluetooth will not work.

Since a separate Bluetooth daughter card[^6] is no longer needed in the
laptop, I removed it and put [a BDC to USB
adapter](https://aliexpress.ru/item/1005002489857902.html) into the
vacated slot. And as a result I got another USB slot inside the laptop
to which I can connect something. What exactly — I haven't thought of it
yet. I don't need two WiFi modules, plugging in a flash drive is too
boring, and a GPS-dongle won't fit inside the whole case.

![](/assets/static/bdc2usb.jpg) *Internal USB connector*

To the left of the WiFi module I had a WWAN module installed. I wasn't
going to install a SIM card for it, so this module was also removed, and
its antennas were dismantled. Instead of it I installed a half-terabyte
SSD with mSATA interface.

Also, I removed one of the antennas for the WiFi module. This antenna
will be replaced with an external antenna. Although I don't do any
pentesting and I don't care much about the range of my laptop WiFi — but
a laptop with an external antenna will look awesome!

There is a place for the external antenna's connector right next to the
Kensington-lock:

![](/assets/static/kensington_lock.jpg)

There is a screw next to the intended hole, but if you drill according
to the drawing, that screw will not be in the way:

![](/assets/static/external_connector_drw_en.jpg) *Drawing of the
hole (⌀ 6 mm) for the RP-SMA connector*

A jumper inside the housing was milled to allow the connector to be
inserted into the hole:

![](/assets/static/drilled_hole_wifi.jpeg) *Drilled hole and
milled jumper inside the housing*

With a Dremel and a tremor, I didn't get a very neat result. But
everything will be covered with cables anyway, so I just grounded off
all the sharp corners with a file and insulated the exposed metal just
in case.

And then I managed to find an external antenna for 2.4 and 5 GHz in
Thinkpad colors and an 18 cm pigtail with RP-SMA on one side and
U.FL-connector on the other side.

![](/assets/static/wifi_connector1.jpg) *RP-SMA connector in
Thinkpad case (side view)*

![](/assets/static/wifi_connector2.jpg) *RP-SMA connector in
Thinkpad case (top view)*

The only tricky part here is to route the cables correctly after they
come out from under the keyboard bezel. Otherwise, the palmrest will not
snap all the way in and will get in the way of the cable in the water
drainage channel.

![](/assets/static/wifi_cables.jpg) *Here the cables are not yet
laid out properly*

The WiFi card itself and the builtin Bluetooth work like clockwork — at
least in Linux I didn't have to configure anything for it. In FreeBSD I
only had to install a wifibox. Unfortunately, the 802.11ac support for
Intel 8260 in FreeBSD's iwlwifi has not been released yet, so the new
card is not fully exposed it's features and I was forced to use wifibox.

![](/assets/static/wifi.jpg) *New WiFi card and external antenna*

## Replacing the keyboard

Originally, my laptop had a keyboard with a UK[^7] layout, which I
really dislike — I've always used keyboards with an US layout. Having to
constantly hit Enter with your finger when you want to enter a pipe
character is annoying.

Luckily the China manufactures still make keyboards for the X220 with
pyramid keys and a seventh row, otherwise this world would be maximally
cursed. No seriously, just read [this
article](https://vermaden.wordpress.com/2022/02/07/epitaph-to-laptops/)
or take a look at this hell:

![](/assets/static/cursed_kbd.webp)

While teens are writing on the keyboards from the photo above all sorts
of cringe about trackpoints in the vein of ["did anyone ever actually
use this
thing?"](https://twitter.com/erhannah/status/1387447191506198528) — the
rest of progressive humanity, who use ThinkPads for more than just
~~Twitter~~ X shitposting, are gaining **invaluable** experience in clit
mouse usage!

![](/assets/static/clitmouse.png)

Unfortunately, the Chinese keyboard for the X220 had one fatal flaw.
It's simply of poor quality:

1.  The plastic is not as thick and shiny as on older keyboards. To the
    touch, something else is used there — accordingly, the typing
    sensation will not be the same.
2.  Instead of the original trackpoint like a lump, a flat trackpoint is
    used.
3.  The characters on the `Enter`, `Backspace` and `Shift` keys are
    duplicated with text for some reason.
4.  Instead of calm blue color for icons of special functions, a
    brighter blue color is used.
5.  The power button is also mocked — instead of soft green light a
    bright green LED hits your eyes (thanks God it's not a super-bright
    blue LED).
6.  My copy in general was not notable for its quality — several buttons
    from the top row of the keyboard were hard to press, the metal cover
    on the back of the keyboard was bent.

Fortunately, I was lucky enough to find an original keyboard from a
laptop with a UK layout. Here is a photo for comparison (original
keyboard at the bottom, Chinese keyboard at the top):

![](/assets/static/kbd_comp.jpg)

There's not much to write about the keyboard replacement itself — you
simply remove the old keyboard and install the new one.

I also really wanted to swap the Ctrl and Fn keys on the new keyboard.
They were already swapped in coreboot, but the inscriptions on the keys
themselves kept me busy. Quite quickly it turned out that in ten years
no one had ever produced the necessary keycaps for the original
seven-row keyboard. I had to do it myself.

Luckily, the Fn key is the same size as the right Ctrl key, so it's easy
[to
remove](https://www.ifixit.com/Guide/Lenovo+Thinkpad+X220+Individual+Keys+Replacement/56264)
the right Ctrl key from the old keyboard and put it in place of the left
Fn key on the new one. This trick will not work with the left Ctrl, so I
removed the key and manually polished the inscription on it. At the same
time, I did the same with the Super key, on which the Windows logo was
drawn for some reason.

![](/assets/static/left_ctrl.jpg) *After this photo was
published, a nightmare ensued at the IBM office*

## Laptop power

Here I started by replacing the charger. In principle, the original
charger is excellent in its reliability and unbreakability and there is
no need to change it for something else. But I just came across GaN
chargers and batteries with support for [USB Power Delivery
protocol](https://en.wikipedia.org/wiki/USB_hardware#USB_Power_Delivery),
as well as a [special
cable](https://aliexpress.ru/item/4001268721004.html) for charging
ThinkPads…

This cable has a standard "barrel" from the ThinkPad's charger on one
end, and USB-C on the other. With it, you can charge your laptop with a
GaN charger or a USB-PD enabled battery pack. The main thing is that one
of their USB-C ports must be able to deliver 20V and **at least** 3.25A.

And then I got the idea that with all these innovations I could carry
*one* charger and *one* external battery and charge *everything* from
them: my laptop, my phone, my vape, etc. This idea was put to the test
after I bought a charger and battery, both 140W, from Baseus — indeed,
they charge both my laptop and my phone at the same time. And the latter
also in "turbo-charging mode" if I use the second USB-C port.

I also had an idea to replace the standard "barrel" with a USB-C
connector (like in the phone and other modern electronic devices). But
after looking [at the experience of other
people](https://www.xyte.ch/mods/x230/#x230-usb-c) who modified their
ThinkPads in this way, I gave up on this idea. Such a connector doesn't
look particularly reliable — I'd rather go for a traditional "barrel",
it looks more reliable for me.

### Battery recelling

I had two, time-affected batteries:

1.  Thinkpad Battery 29+ 6-cell battery — with it, the laptop lived for
    about 55 minutes.
2.  Thinkpad Battery 29++ with 9 cells — with it, the laptop lived for
    an hour and a half.

I didn't know how to replace dead cells in the battery, as well as about
"pitfalls" when performing such an operation. I only knew that it was
**dangerous** — if something short-circuited or overheated, the cell
could catch fire. That's why they can't be soldered — only spot welding
is allowed. Also, batteries lose a little capacity when heated with a
soldering iron. Also, the plastic safety valve located near the anode
may fail from heating. In short, **just don't** solder 18650 batteries,
no matter what saying in various blogposts on the Internet.

A search brought me to the following places with useful information:

- [This should be illegal… Battery Repair
  Blocking](https://www.youtube.com/watch?v=Mkum7G-0vWg) — here dudes
  rebuild a battery from a camera and in the process go through
  different things so I don't have to go through them.
- [X220 Battery
  Recelling](https://forum.thinkpads.com/viewtopic.php?t=135913) —
  there's a lot of useful tips from a laptop battery replacement wizard
  at the end of the thread.
- [Replacing Lenovo laptop lithium
  batteries](https://hackaday.io/page/247-replacing-lenovo-laptop-lithium-batteries)
  and [Project
  Details](https://hackaday.io/project/245-replacing-lenovo-laptop-lithium-batteries/details) —
  the author of these articles did not upgrade the battery from X220,
  but from his article I can get some useful ideas on how to replace the
  cells in the battery. Also, at the end of the second article he writes
  that cell capacity is apparently programmed in BMS[^8], so there is no
  sense to put cells with capacity higher than from the factory, if
  there is no programmer and corrected firmware for BMS.
- [Recalibrate
  batteries](https://www.coreboot.org/Board:lenovo/x220#Recalibrate_batteries) —
  this describes the command from the coreboot utility kit
  (`./ectool -w 0xb4 -z 0x06`) to calibrate the battery.

Armed with all this knowledge, I started to disassemble the Thinkpad
Battery 29+ — it's the least to be pitied. And it will probably burn
less than a big 9-cell battery 😊.

I had to figure out on my own how to carefully get to the battery's
insides — because in different YouTube videos, where dudes from
South-East Asia supposedly show how to disassemble the Thinkpad battery,
they actually barbarically dismantle the battery, leaving behind a
plastic case bent in all directions and nickel lines' shreds. I might
throw the battery into a rock crusher with the same result…

The top battery cover — the one with the "do not disassemble" label and
markings — is glued into the main case and is additionally held there by
plastic latches. I was lucky and was able to get into the gap between
the cover and the case, in the corner — where the seam goes from the top
of the battery, not from the side. At first, I separated the two parts
with a metal spatula, without going deep inside, for fear of shorting
out something and catching fire.

![](/assets/static/battery29plus_open1.jpg)

Then I sharpened a popsicle stick, took a toothpick and proceeded to
unglue the battery, using wooden tools if I needed to get somewhere
deep:

![](/assets/static/battery29plus_open2.jpg)

![](/assets/static/battery29plus_open3.jpg)

The seams on the side of the battery were a bit tricky to work out — I
didn't immediately understand how they there glued, so the battery lost
a bit of its appearance 😊. The seam that goes on the right side of the
connector had to be opened very carefully — inside the case there is an
insulated line, which definitely should not be damaged.

In the end, it all worked out for me:

![](/assets/static/battery29plus_opened.jpg) *3S2P battery with
BMS board connected*

In the photo above, there is a temperature sensor glued to the middle
bottom cell, overheating of which will cause the BMS to burn the fuse
(and possibly set some sort of Permanent Failure Flag internally) — and
eventually the battery will stop working altogether.

The orange battery cells in the photo are LGABC21865, 18650 form factor,
with a capacity of 2800 mAh each. Each battery delivers 3.7V normally,
max. 4.3V — these numbers are the ones you should be guided by. So you
don't inadvertently buy batteries designed for 4.2V, as one Reddit dude
did, when he inadvertently built a ThinkBomb instead of a ThinkPad.

Next is the hard part — you have to disconnect the old batteries from
the BMS so that it doesn't lock up. Alas, I could not find any
information on how to successfully replace cells in Thinkpad X220
battery on the Internet. Mostly there was only advice on other Thinkpad
models: [one man disconnecting the cells in the right
order](https://www.yousun.org/archives/1572), another just connected 12+
volts from a lab power supply to the BMS board terminals and the battery
controller didn't lock (it is not clear why — because the terminals for
controlling the voltage between the cells would then have 0V), and so
on.

I tried to figure it all out myself. I found the non-recoverable fuse
quickly — it is `F1` fuse:

![](/assets/static/bms_fuse.jpg) *Fuse 12AH3*

A search quickly gave me a datasheet with a useful picture:

![](/assets/static/bms_drawing.jpg)

Everything is obvious here — it is necessary to temporarily unsolder
pin 4 from the board to "neutralize" the fuse for the time of cell
replacement. Unfortunately, it is an SMD part with pins **under it**,
located too close to the battery cells to remove it with a soldering
dryer, so I gave up this idea.

There was nothing useful in the datasheet for the BMS chip that could
help me with: "how to start the battery after replacing the cells?"
Alas, the only thing left was to experiment *with the correct sequence
of disconnecting* the cells from the battery as described in one of the
links above.

For the test, I disconnected only the plus terminal (`V+`) of the
battery assembly and soldered it back on. After this operation, the
battery output was 0V, although the `F1` cell was still conductable. But
then I remembered battery "startup procedure" in one of the articles I
read. I have to short the plus terminal of the battery pack and the plus
terminal on the connector to the laptop for a while. I **pinged** and
soldered the first wire I found on the table to `V+` and applied it to
the correct pin for a second.

The battery output was still 0V. But then I decided to measure the
voltage between the end of the wire and the ground (`V-`) of the battery
pack. **Suddenly**, it was not 12.2V, but 4V! The wire turned out to be
made of a "known substance", it was immediately thrown out, and a
quality copper wire was soldered in its place. After repeating the trick
from above, the much desired 11+ volts appeared on the battery connector
outputs!

This is how a working method of disconnecting the battery was found:

1.  Get the temperature sensor away from the soldering iron.
2.  Unsolder the plus contact of the battery assembly: `V+`.
3.  Unsolder the next contact: `VH`.
4.  Unsolder another contact: `VL`.
5.  Unsolder the minus contact of the battery pack: `V-`.

Now the BMS board and the batteries are disconnected from each other and
you can replace the cells with fresh ones! After completing this action,
everything must be connected in reverse order:

1.  Solder in series, one after the other, the connectors from the
    battery assembly to the corresponding pins: `V-`, `VL`, `VH`, `V+`.
2.  Solder a good quality copper wire to `V+`.
3.  Short the other end of the wire and the plus contact on the battery
    connector (left-most contact) for a second.

Done, the BMS should start again and output voltage to the appropriate
battery connector pins.

Unfortunately, I can't say that this method is 100% working, because I
didn't have time to test it properly. It turned out that my "brilliant"
idea to clean the solder joint from flux with vodka (да-да, она самая),
for lack of anything more suitable at hand late at night — led to a
fatal failure. Alcohol evaporated, water remained and "suddenly" right
on the soldering mask near the soldering point — multimeter suddenly
started to show 4V instead of zero. Naturally, BMS didn't like this and
it stopped working — either it got locked or burned out and repeated
execution of the above written instructions didn't help…

In the end, having already spent a lot of time experimenting with this
battery, I decided to spend some time looking at China-manufactured
battery reviews and bought a ThinkPad Battery 29++ replica. I was lucky
and the battery I received was fine — it charged properly and provided
5-6 hours of battery life while surfing the web.

### Second battery for the laptop (unfinished)

For a long time, I've wanted to add a second battery to my laptop — the
[ThinkPad Battery
19+](https://www.thinkwiki.org/wiki/ThinkPad_Battery_19%2B). It's a big,
heavy, and reliable 6-cell battery that attaches from the bottom, to the
dock connector. As [Boris the
Blade](https://en.wikipedia.org/wiki/Snatch_(film)) used to say: "Heavy
is good, heavy is reliable".

![](/assets/static/ab95c10e2789777c99b9dd5b7b77a8590018c86a8910663dda47c1ac203a13de.jpg)

To put it mildly, I'm not a fan of the current trend of unrestrained
thickness reduction of wearable tech at any cost — at the cost of a
non-removable glued-in battery, identical flat keyboards, at the cost of
removing the Ethernet port and 3.5mm jack. Vice versa, I really like the
aesthetics of tech from 1980-1990 movies. It looks moderately thick, has
lots of useful buttons, indicators and ports:

![](/assets/static/old_school.webp)

Maybe when I become a 90-year old man, I will care about the extra 500
grams of weight and extra millimeters of thickness. But now, carrying
"extra" half a kilo of hardware in my backpack doesn't bother me — it's
more important that my laptop looks like a stylish brick from the 90s
and causes pleasant tactile sensations.

I didn't see any special problems with finding the above-mentioned
battery on the *secondary market*. But, **all of a sudden**, it turned
out that in reality such batteries can now be found only on the
inaccessible to me eBay. Even on AliExpress or Avito (Russian OLX) they
are not available.

So it's time to try to make such a battery myself!

I bought a [ThinkPad UltraBase Series
3](https://www.thinkwiki.org/wiki/ThinkPad_UltraBase_Series_3) docking
station for this purpose. I had an idea to connect a second 9-cell
battery *on the front* of the dock, like in the [Dell Latitude
D630](https://en.wikipedia.org/wiki/Dell_Latitude#/media/File:Dell_Latitude_D630_8064.jpg),
so that it would also work as a palmrest. The free space at the back of
the docking station, where the ThinkPad Battery 19+ apparently has a
6-cell battery, was already occupied by a board with various connectors.
I was not going to remove this board, because I wanted to have
connectors on the back of the laptop. In the end, it was going to be a
"stylish brick" in the style of the 90's, as I wanted.

First, I disassemble everything. I couldn't find manual for this docking
station, but I managed to find a [post about
disassembling](https://joes-tech-blog.blogspot.com/2017/09/whats-inside-lenovo-docking-station-for.html)
a similar one. It made it clearer what to expect inside.

I unscrewed **all** the screws, unclipped the plastic latches on the top
cover and removed it:

![](/assets/static/dock_screws.jpg) *15 screws on the top cover
of the docking station*

Inside, there's a main board with a docking connector and mechanics to
connect the dock with the laptop:

![](/assets/static/dock_internals.jpg) *Inside the UltraBase
Series 3 docking station*

Underneath the board is the mechanical part of the dock and *lots* of
grease:

![](/assets/static/dock_mechanics.jpg)

It remains to understand how to connect the second battery here. If we
take the main battery, the connector for its (`CN23`) on the circuit
diagram looks like this:

![](/assets/static/bat1_schematics.png)

You can see that there are 5 lines from the battery:

- Power: `M-BAT-PWR_IN`, aka `BAT_VCC` on the connector
- Ground
- SMBus interface lines: `I2C_CLK_BT0` and `I2C_DATA_BT0`
- `M_TEMP` signal from the `TEMP` pin on the `CN23` connector.

On the same schematic sheet, you can see the corresponding lines coming
from the docking connector:

- Power: `S_BAT_PWR_A`
- SMBus interface lines: `I2C_CLK_BT1` and `I2C_DATA_BT1`
- `S_TEMP` signal.

![](/assets/static/bat2_schematics.png)

The same lines on the sheet with the docking connector:

![](/assets/static/bat2_schematics2.png)

Unfortunately, I had to stop further exploration. It turned out that
there was only one place in the dock where I could fit the entire
battery — the space occupied by the board with USB and other plugs. I
didn't want to remove this board; the space on the left was occupied by
the mechanism for holding the ThinkPad in the docking station; the space
on the right — by the disk drive basket, which I also didn't want to
remove, because here I can insert Optibay and add a third hard disk to
the system if necessary.

And in the front, where I could insert the battery compartment (cut out
of the ThinkPad case) there was a drain for water. Naturally, it would
be dangerous to remove it and insert a battery into the place, because
any spilled water would go straight to the battery.

Someday I will think about the problem of embedding the battery into the
docking station, but not now….

## Additional connectors and buttons

However, I can still use the docking station to keep all sorts of
connectors behind the laptop — no wires to prevent me from putting a mug
of tea on the side of the laptop.

![](/assets/static/rejectmodernity.jpg)

But, once the 2K modification board is installed, I can't just plug the
docking station into my laptop anymore! As you can see in the
"<span class="spurious-link" target="* New display and FreeBSD">*New
display and FreeBSD*</span>" section, this board occupies the Display
Port interface lines and a USB lines. Therefore, I need to disconnect
the Display Port lines from the corresponding connector on the side of
the docking station. And at the same time, check to see if the USB hub
in the dock is using the same lines as the modification board.

Unfortunately, I couldn't find a schematic of the docking station on the
Internet, so I had to ping the circuitry from the docking connector. It
turned out rather quickly that the Display Port connector on my docking
station will remain functional — it uses `DOCKA_DP` lines, while the
2K-modification board uses separate `DOCKB_DP` lines.

But the `USBP8` lines, alas, are used. They go to Microchip's USB2514B
controller (`U13` chip), and it won't be possible to use 4 USB2.0 ports
at the back of the docking station. `USBP8` lines will have to be
disconnected from the connector.

![](/assets/static/dock_usb_controller.jpg) *USB-controller
Microchip USB2514B (U13)*

On the laptop diagram you can see that `USBP12` (`DOCK_USB`) lines are
also connected to the docking station connector — in idea, I can cut
`USBP8` lines directly on the docking station board and solder a twisted
pair with a screen to them, the other end of which will be soldered to
the contacts coming from `USBP12` line. And then USB ports on the back
of the docking station will work again. But I'll make this modification
some other time.

I was also going to add a toggle switch to the dock instead of the power
button, and a protective cover for the toggle switch. I have an
unhealthy interest in such protective covers — they click nicely and you
can feel the spring resistance when you flip the cover off.

Plus, every time I turn the laptop on, I feel like a starship pilot from
old sci-fi movies:

![](/assets/static/space_riders.jpg)

There is just the right place for the toggle switch and protective cover
on the left side of the docking station, opposite the lever for removing
the laptop:

![](/assets/static/tumbler_drawing.jpg) *Drawing of the toggle
switch hole*

I soldered the wires from the toggle switch to the connector that is
used to connect the standard power button. It wouldn't be possible to
solder directly to the docking connector, because its contacts are
located at the bottom of the board where the mechanical parts moving:

![](/assets/static/dock_tumbler_conn.jpg)

At the same time, as you can see, the cable running from the main board
to the button, to signal the disconnection event of docking station, has
been removed. I definitely won't be disconnecting one from the other
while laptop is turned on.

The protective cover was simply glued on with Poxipol and all ended up
with this design:

![](/assets/static/dock_tumbler.jpg)

![](/assets/static/tumbler.jpg)

![](/assets/static/tumbler_in_action.webm)

After connection of the already assembled docking station to the laptop,
it turned out that I had missed something — there were artifacts on the
screen, and the system, although successfully booted to the desktop,
soon restarted as if by watchdog. Since I had no desire to disassemble
the docking station again, and of course there was no documentation for
the proprietary docking connector, I took the broken motherboard from
shelf and started to ping the pins of his connector:

![](/assets/static/docking_connector_notebook.jpg) *Dock
connector (CN15), with dust cover removed*

I must admit that it was a real pain in the ass — the pins, which I know
the pinout of, are located on one side of the board, while the dock
connector pins are located on the other side, and they are extremely
small. My eyes broke trying to count the number of the first pin from
the `DOCKB_DP` bus. I had to cover the contacts to the left of the
"ringed" one pin with a piece of tape, photograph a part of the
connector on my phone, enlarge the photo and count the number of the
contact already on it.

After a couple of evenings of such "fun" I already knew which pins on
the connector belong to `DOCKB_DP` lines, and which to `USBP8`:

![](/assets/static/docking_connector1.jpg)

| Pin number | Signal name       |
|------------|-------------------|
| 22         | DOCKB_DP_DDC_CLK  |
| 23         | DOCKB_DP_DDC_DATA |
| 24         | DOCKB_HPD         |
| 27         | DOCKB_DP_0P       |
| 28         | DOCKB_DP_0N       |
| 30         | DOCKB_DP_1P       |
| 31         | DOCKB_DP_1N       |
| 33         | DOCKB_DP_2P       |
| 34         | DOCKB_DP_2N       |
| 36         | DOCKB_DP_3P       |
| 37         | DOCKB_DP_3N       |
| 39         | DOCKB_DP_AUXP     |
| 40         | DOCKB_DP_AUXN     |

![](/assets/static/docking_connector2.jpg)

| Pin number | Signal name |
|------------|-------------|
| 21         | USBP8+      |
| 22         | USBP8-      |

So I simply taped the `DOCKB_DP` and `USBP8` pins in the dock connector
with Kapton tape. As a result, glitches and system restarts disappeared.
Connectors on the back: charging port, Ethernet port and audio jack —
worked. The USB ports of course did not work anymore.

![](/assets/static/docking_connector3.jpg) *Taped pins in the
dock connector*

As a result, the vibe from working at the laptop after such modification
became exactly what I wanted. Opening the laptop, I feel that the
display lid is just a lid, and underneath is a large, reliable and heavy
main part with the keyboard, which you don't have to hold on to keep it
from coming off the table. Tactile sensations when turning on the laptop
through the toggle switch are also on top, as well as the sound
accompaniment of this action. Another unexpected consequence — due to
the fact that the laptop is now a bit taller and the keyboard is
slightly tilted towards the user, it has become a bit more comfortable
to work at it.

Toward the end, I added additional USB3.0 connectors to the laptop via
Express Card. First, I bought an FL 1100 card from the AliExpress — it
has three ports instead of two and did not require an additional power
cord like other similar cards.

![](/assets/static/fl1100.jpg)

![](/assets/static/fl1100_notebook.jpg)

Everything worked, but the card was heating like an iron, wouldn't snap
into the slot and shutdown after a few minutes after system booting:

``` example
ugen1.1: <(0x1b73) XHCI root HUB> at usbus1 (disconnected)
unknown: at usbus1, port 1, addr 1 (disconnected)
usbus1: detached
xhci0: Controller reset timeout.
xhci0: detached
pci2: detached
pcib2: Timed out waiting for Data Link Layer Active
```

In the end, I had to use ExpressCard BC398 with two USB3.0 ports and an
additional connector for external power supply from another USB
connector — in case I need to connect something power-hungry like a
portable hard disk.

![](/assets/static/bc398.jpg)

There were no more problems with this card — it successfully locked
inside the slot, didn't get warm and didn't turn off after ~10 minutes
in use.

![](/assets/static/bc398_notebook.jpg)

## Stitching a new case

With such a laptop you don't want to use an ordinary cloth case from
mass-market. And let's be honest, you can't find a case for such a
machine anymore — everything you can buy now is designed for modern thin
laptops.

Since I know how to work with leather — I just sewed a case myself. Few
months ago I bought half of a cattle hide to make all sorts of cases for
my equipment. It is black and vegetable tanned (so that it can be
molded).

I don't use patterns — I usually figure out what I want first by
sketching in a notebook:

> I hope, the drawings will be understandable itself, without
> translation. Anyway, there are just lines with the names of the parts
> of the case.
>
> If there are no some dimensions on the drawing — then you feel free to
> choose it by yourself, as you like.

![](/assets/static/leather_case_drawing1.webp)

Since I'm used to stuffing my laptop into my backpack sideways, it will
also be inserted same way into the case, tumbler side down. To prevent
the laptop from resting on the protective cover of the toggle switch
alone, there will be some foam on the bottom of the case. On top of this
there is a flap with a couple holster buttons, on which two straps will
be slipped.

At first, I wanted to make the front and back walls out of a single
piece of leather so I'd have less cutting to do. But then it suddenly
turned out that the rest of the purchased hide is too small and I can't
cut out of it a plate with a length of more than a meter. I had to
redraw the drawing and designed two separate parts for the front and
back walls, which would be sewn together.

![](/assets/static/leather_case_drawing2.webp)

And then I simply marked out the details of the cover on the skin,
carefully checking all the dimensions several times, and cut it. It
happens in much the same way as in locksmithing. It's even a little
easier, because the leather can be stretched a little if you made a
mistake of a couple of millimeters.

Some fun marking tips: a regular plate works well as a template for the
cutout on the front wall:

![](/assets/static/leather_case_pattern.jpg)

And for forming semicircular folds on the bottom and on the lid of the
case — two tall Dr. Pepper cans are perfect, rolled together with duct
tape. They are just about 60 mm in diameter, as I needed.

![](/assets/static/leather_case_folding.jpg)

The front and back walls are joined with a cross stitch as described [in
this video](https://www.youtube.com/watch?v=jxWiJ20esyo) (RU language).
The side panels are sewn using the same method described in Al
Stohlman's book "The art of hand sewing leather"[^9].

The inside of the cover should be covered with lining fabric. The
underside of a leather is abrasive and the laptop will simply wipe to
metal over time if underside is not covered. In a good way, I should
have sewn some sort of pouch to the dimensions of the inside of the
case. But to speed up the process, I just glued the lining fabric to the
underside of the corresponding parts.

In the end, after sewing all the parts together, polishing the edges and
installing the holster buttons, I got this case:

![](/assets/static/leather_case.jpg)

The notebook fits in it like a glove — obviously it couldn't be
otherwise, if everything was carefully measured and calculated
beforehand :-).

## Final result

![](/assets/static/notebook_before.jpg) *Laptop before all
modifications*

![](/assets/static/notebook_after.jpg) *Laptop after all
modifications*

|  | Before | After |
|----|----|----|
| Display | 1366x768 | 2560x1440 |
| WiFi | 2.4 GHz, 300 Mbps, 802.11b/g/n | 2.4 and 5 GHz, 800-900 Mbps, 802.11b/g/n/ac, and internal Bluetooth support |
| Hard drives | 180 GB SSD | 0.5 TB SSD and 180 GB SSD, the third disk can be connected via Optibay |
| USB ports | 1xUSB3.0, 2xUSB2.0 | 3xUSB3.0, 2xUSB2.0 |
| Keyboard | Original with UK layout and Cyrillic stickers | Original with US layout |
| Battery life | Near 1.5 hours | 5-6 hours. With external powerbank — up to 9 hours |

As a result, this machine will serve me for at least the next ten years.
The only bottleneck here is all sorts of JavaScript from websites — if
it starts eating up 8 GB per tab, it's going to be tough.

------------------------------------------------------------------------

## 17.07.2024 update

Unfortunately, the display died after a couple months of use. After the
laptop was turned on in the sunlight so that the sun was shining on the
bottom quarter of the lid — the image on the bottom 1/4 of the display
started to look as if it was hit with a sharp object.

I assume that uneven thermal expansion of the display basket and the
display itself played a role here. It is also possible that the display
was not delivered from China very carefully — the parcel with it was
lying unmoved for about 20 days in the Cainiao warehouse in St.
Petersburg and it is not known what happened to it there.

Before installing the new display, I modified a homemade display basket
to minimize the likelihood of repeated breakage:

- I drilled **a lot** of holes in the plexiglass behind the display so
  that there would be a normal heat exchange with the rest of the laptop
  cover.
- I glued the display to the basket only on two strips of tape on the
  sides of it, not as *securely* as it was before — so that the basket
  would bend during thermal expansion, not the matrix (and it bends, of
  course, better than the display itself).

At the moment the screen is stable again and is not going to break.

------------------------------------------------------------------------

## Notes

[^1]: I use the `Pause` button to pause applications that load the
    processor to 100% but I need it for something else. I also use it to
    save battery power — if Firefox is used once in a while, it is
    paused while I don't need it. [It works like
    this](https://vermaden.wordpress.com/2018/09/19/freebsd-desktop-part-16-configuration-pause-any-application/).

[^2]: This is a problem with the IPS matrices used in these Thinkpads —
    when you hit the cover hard, a spot appears on the screen. This spot
    glows slightly brighter than the surrounding screen:

    ![](/assets/static/ips_display_problem.jpg)

[^3]: In fact, the first motherboard had been dying for a long time, but
    since I used the laptop carefully, similar "symptoms" occurred only
    a couple of times. And tampering with the system with a soldering
    iron only accelerated the inevitable demise.

[^4]: [As I
    read](https://libreboot.org/docs/bsd/#freebsd-and-corebootfb),
    libgfxinit with initialized framebuffer and \*BSD installers don't
    working together. But I found a way to make them friends — during
    the boot process, when lines are already printed on the screen:

    ``` example
    Booting from Hard Disk ...
    /
    ```

    … you should actually see the bootloader screen in text mode. At
    this point, blindly press `<Esc>` and type `vbe on`. This will bring
    up the bootloader command prompt, and you can safely boot FreeBSD
    with the `boot` command.

[^5]: Section "2010 LCD front bezel" (page 88), "2050 LCD panel and LCD
    cable" (page 99), "2020 LED board" (page 89), "2040 Integrated
    camera" (page 98), and "2070 LCD rear cover and wireless antenna
    cables" (page 102).

[^6]: Refer to "2030 Bluetooth daughter card (BDC-2.1)" on page 91 in
    the service manual.

[^7]: Globally, there are two keyboard layouts. British — where the
    L-shaped `Enter`, short left `Shift` and there is an additional
    button with the symbols `<`, `>`, `\` to the left of the `z` button.
    And American, with elongated `Enter` and long `Shift` too.

[^8]: Battery Management System

[^9]: Section «Sewing a miter joint», page 22.