---
layout: post
title: Setting up FreeBSD for Lenovo Thinkpad X220 (2011 year)
category: it
date: 2020-09-26 00:20
lang: en
comments: true
hidden:
  - related_posts
---

There are a bunch of tips and tricks about FreeBSD setup for Thinkpad
X220 in this little note. I wrote it to not forget non-obvious actions,
wchich should be done after system installation. Used Thinkpad came from
2011 year — from that times, when it used decent design from IBM with
blue Enter and 7-row keyboard.

This post based on information from the next pages:

- <https://cyber.dabamos.de/unix/x230/>
- <https://unrelenting.technology/articles/freebsd-on-the-thinkpad-x240>
- <https://github.com/grembo/xorg-udev-setup-check>
- <https://www.c0ffee.net/blog/freebsd-on-a-laptop/>
- <https://cooltrainer.org/a-freebsd-desktop-howto/>
- <https://wiki.archlinux.org/title/Lenovo_ThinkPad_X230>

## Show ~ for current directory path in bash prompt

In FreeBSD all users' home catalogs placed in `/usr/home/`. The `/home/`
is just a symbolic link to `/usr/home/`. So, thats why in command prompt
`\w` will be substituted to `/usr/home/catalog_name`, not to
`~/catalog_name`.

To fix that you need to set path to home catalog directly to
`/usr/home/user_catalog`, not to `/home/user_catalog`. Use
`sudo chsh username` for this.

## Minimal set of groups

`wheel`  
for sudo

`video`  
grants access to `/dev/dri/card*`

`webcamd`  
grants access to web-camera.

## Power control

`/etc/rc.conf` settings:

``` example
powerd_enable="YES"
powerd_flags="-a hiadaptive -b adaptive -M 2000"
performance_cx_lowest="Cmax"
economy_cx_lowest="Cmax"
```

`/boot/loader.conf` settings:

``` example
cpufreq_load="YES"
kern.hz=100
```

Thanks to these settings — notebook will become slowly but more
energy-saving.

## Sound

Need to load `snd_hda` module on system startup. Add this to
`/boot/loader.conf`:

``` example
snd_hda_load="YES"
```

To switch between speakers and earphone on the fly — add these lines to
`/boot/device.hints`:

``` example
hint.hdaa.0.nid20.config="as=1 seq=0 device=Speaker"
hint.hdaa.0.nid21.config="as=1 seq=15 device=Headphones"
```

## Brightness control

Add these lines to `/boot/loader.conf`:

``` example
acpi_ibm_load="YES"
acpi_video_load="YES"
```

First line loads kernel module to operate with Thinkpad peripherals —
multimedia-keys, brightness-control keys, etc. Second line loads kernel
module to control screen brightness via sysctl (use
`hw.acpi.video.lcd0.brightness` setup).

## Multimedia keys

First, module `acpi_ibm` should be already loaded in system.

The next strings should be added to `/etc/devd.conf`, with them devd
could process Fn+Fkey keypresses and send it to our script:

``` example
notify 10 {
    match "system" "ACPI";
    match "subsystem" "IBM";
    action "/etc/acpi_thinkpad.sh $notify";
};
```

Script content (incomplete):

``` bash
#!/bin/sh

ACPI_EVENT="$1"

case "$ACPI_EVENT" in
    '0x04')
        /usr/sbin/zzz
        ;;
esac
```

To watch key scan-codes just stop devd and launch it from root with `-d`
argument.

## Touchpad and trackpoint

First, enable Synaptics touchpad and trackpoint support in
`/boot/loader.conf`:

``` example
hw.psm.synaptics_support=1
hw.psm.trackpoint_support=1
```

Package `xf86-input-synaptics` should be replaced with
`xf86-input-evdev`. With these changes — touchpad, trackpoint and middle
mouse button above of touchpad will be working. Also, scrolling with
middle button and trackpoint will work.

I'd like sensitive trackpoint — so I add the next lines to
`/etc/systcl.conf`:

``` example
hw.psm.trackpoint.sensitivity=150
hw.psm.trackpoint.upper_plateau=125
```

## Web-camera

Make next changes in next files:

`/boot/loader.conf`  
``` example
cuse_load="YES"
```

`/etc/rc.conf`  
``` example
webcamd_enable="YES"
```

`/etc/sysctl.conf`  
``` example
kern.evdev.rcpt_mask=12
```

After that add user to `webcamd` group:

``` example
sudo pw groupmod webcamd -m <username>
```

## Sleep

First, the module `acpi_ibm` should be loaded:

Then, we can go to sleep mode via `acpiconf -s 3` command. Or via `zzz`
command.

## Enable drm-kmod

Install the package `graphics/drm-kmod`. After, enable module
`i915kms.ko` — add next line to `/etc/rc.conf`:

``` example
kld_list="${kld_list} /boot/modules/i915kms.ko"
```

## Wi-Fi

Add next lines to `/boot/loader.conf`:

``` example
if_iwn_load="YES"
wlan_wep_load="YES"
wlan_ccmp_load="YES"
wlan_tkip_load="YES"
```

And these lines to `/etc/rc.conf` (select proper country code in last
line):

``` example
wlans_iwn0="wlan0"
ifconfig_wlan0="WPA DHCP powersave"
create_args_wlan0="country RU regdomain NONE"
```

Install package `wpa_supplicant` to operate with Wi-Fi networks from
user mode. And add next lines to the start of
`/etc/wpa_supplicant.conf`:

``` example
ctrl_interface=/var/run/wpa_supplicant
eapol_version=2
fast_reauth=1
```

## Miscellaneous

You can add next lines to `/boot/loader.conf`:

``` example
autoboot_delay="2"
kern.maxproc="100000"
kern.ipc.shmseg="1024"
kern.ipc.shmmni="1024"
cpuctl_load="YES"
coretemp_load="YES"
libiconv_load="YES"
libmchain_load="YES"
cd9660_iconv_load="YES"
msdosfs_iconv_load="YES"
```

These lines enable support of temperature sensors in system, will reduce
delay to two seconds before the system boots and so on.

To load DHCP client in background on system startup and reduce system
boot time — add next line to `/etc/rc.conf`:

``` example
background_dhclient="YES"
```

To mount filesystems without root privileges, to disable system beeper
and so on — add next lines to `/etc/sysctl.conf`:

``` example
vfs.read_max=128
vfs.usermount=1
hw.syscons.bell=0
kern.vt.enable_bell=0
```

## 2024-04-28 update

Now, I am using coreboot instead of BIOS on my Thinkpad. Also, I
soldered expansion board AGAN X230 to my motherboard to use nice and
shiny 2K-display. As operation system I use FreeBSD 14.0. Thats why I
wrote this update:

### Working sleep mode (S3)

Out of the box, the sleep mode is working incorrectly. Command
`sudo zzz` nice switches laptop to sleep mode. **But**, after wakeup I
can see screen with i3wm for seconds and after that system behaves like
I have entered `sudo shutdown -h
now` command. But I didn't enter it either!

After digging on FreeBSD forum, I found a topic, where a man with HP
laptop describing his issues with non-working sleep mode. Suddenly, but
advice from this topic helped me a lot.

There are should be the next lines in `/etc/sysctl.conf`:

``` example
hw.pci.do_power_suspend=0
hw.pci.do_power_nodriver=1
```

And next in `/boot/loader.conf`:

``` example
hint.p4tcc.0.disabled="1"
hint.acpi_throttle.0.disabled="1"
```

After restart, sleep mode finally works well as before! Without strange
shutdown after wake up.

To enable sleeping after closing the lid, I've added one more line to
`/etc/sysctl.conf`:

``` example
hw.acpi.lid_switch_state=S3
```

### Output boot-log to «secondary» 2K-display

Coreboot with SeaBIOS payload FreeBSD bootloader don't works very well
together. If you try to boot FreeBSD on the machine with coreboot,
you'll see a thin line of something like video interference on the top
of the screen.

To fix that, you should blindly press Esc in the bootloader. After that,
still *blindly* enter command `vbe on` and press Enter. Now, bootloader
switch the video mode and it's interface will be displayed on the
screen.

Boot to the system with the `boot` command and add next lines to
`/boot/loader.conf`:

``` example
hw.vga.textmode="0"
kern.vty=vt
i915kms_load="YES"
vbe_max_resolution=2560x1440
```

### Reduce count of messages from system when booting

Add to `/boot/loader.conf`:

``` example
boot_mute="YES"
```

To `/etc/rc.conf`:

``` example
rc_startmsgs="NO"
```

### Powersaving for videocard

Add next lines to `/boot/loader.conf`:

``` example
drm.i915.enable_rc6="7"
drm.i915.semaphores="1"
drm.i915.intel_iommu_enabled="1"
```

### Intel 8260

Because now I'm using WiFi-card Intel 8260 — it should be configured via
[wifibox](https://man.freebsd.org/cgi/man.cgi?query=wifibox&apropos=0&sektion=8&manpath=freebsd-ports&format=html)
to use full power of WiFi. Wifibox configuration is simple, takes near 5
minutes and described in these two articles:

- <https://jrgsystems.com/posts/2022-04-20-802.11ac-on-freebsd-with-wifibox/>
- <https://xyinn.org/md/freebsd/wifibox>

### Sound and coreboot

Some system internals (nIDs) changed after installation of coreboot
instead of BIOS. As a result: there is no sound in headphones, connected
via 3.5mm jack. Instruction from <span class="spurious-link"
target="* Sound">*Sound*</span> section became unapplicable.

To see, which nID I shoule use, there is the next command:

``` bash
dmesg | grep pcm
```

As a result, I got my headphones working after adding next lines to
`/boot/device.hints`:

``` example
hint.hdaa.0.nid31.config="as=1 seq=0 device=Speaker"
hint.hdaa.0.nid35.config="as=1 seq=15 device=Headphones"
```

### GUI glitches

After some time of working, there are black squares and (rarely) lines
appears on the screen. Maybe there are because of coreboot. When I
switch from `intel` to `modesetting` driver — it won't help.

![](/assets/static/freebsd_intel_glitches.jpg) *Glitches on the
laptop screen*

But, thanks to [this FreeBSD forum
message](https://forums.freebsd.org/threads/intel-video-and-screentearing.72085/)
and `picom` usage with `--no-vsync` option, I managed to noticeably
decrease frequency of glithes appearance.

As a result, my `/usr/local/etc/X11/xorg.conf.d/10-intel.conf` has the
next contents:

``` example
Section "Device"
    Identifier  "Card0"
    Driver      "intel"
    BusID       "PCI:0:2:0"
    Option      "Accel"         "true"
    Option      "AccelMethod"           "SNA"
    Option      "DRI"                   "3"
    Option      "TearFree"          "true"
EndSection
```

And I add next option to `/boot/loader.conf`:

``` example
drm.i915.enable_fbc="1"
```

### Miscellaneous (2)

To decrease desktop latency under the high load, add next lines to
`/etc/sysctl.conf`:

``` example
kern.sched.preempt_thresh=224
```

Settings for network stack performance in `/boot/loader.conf`:

``` example
net.link.ifqmaxlen="2048"
cc_htcp_load="YES"
```

Dock-station support;

``` example
acpi_dock_load="YES"
```
