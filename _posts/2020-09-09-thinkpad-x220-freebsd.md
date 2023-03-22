---
layout: post
title: Настройка FreeBSD на Lenovo Thinkpad X220 (2011 года)
category: it
date: 2020-09-26 00:20
comments: true
hidden:
  - related_posts
---

Эта небольшая заметка кратко описывает настройку FreeBSD 12.1 для работы
на Lenovo ThinkPad X220 — чтобы не забыть неочевидные действия,
выполняемые после установки системы. Используемый ThinkPad из 2011 года
— из тех времён, когда ещё использовался приличный дизайн от IBM – с
синим Enter и семирядной клавиатурой.

В заметке используются материалы из следующих мест:

- <https://cyber.dabamos.de/unix/x230/>
- <https://unrelenting.technology/articles/freebsd-on-the-thinkpad-x240>
- <https://github.com/grembo/xorg-udev-setup-check>
- <https://www.c0ffee.net/blog/freebsd-on-a-laptop/>
- <https://cooltrainer.org/a-freebsd-desktop-howto/>
- <https://wiki.archlinux.org/title/Lenovo_ThinkPad_X230>

## Корректное отображение ~ в пути, в приглашении bash

Поскольку все домашние каталоги пользователей расположены по пути
`/usr/home/`, а `/home/` лишь символическая ссылка на вышеуказанный
каталог – в приглашении командной строки `\w` будет заменяться не на
`~/catalog_name`, а на `/usr/home/catalog_name`.

Чтобы путь к каталогу внутри домашнего каталога имел в своём начале `~`,
нужно установить в качестве домашнего каталога пользователя прямой путь
к нему — `/usr/home/`, а не символическую ссылку — `/home/`. Делается
это через `sudo
chsh username`.

## Минимальный набор групп для доступа к устройствам ноутбука

- wheel — нужен для sudo;
- video – для доступа к `/dev/dri/card*`;
- webcamd — для доступа к веб-камере.

## Управление питанием

Настройки для `/etc/rc.conf`:

``` example
powerd_enable="YES"
powerd_flags="-a hiadaptive -b adaptive -M 2000"
performance_cx_lowest="C2"
economy_cx_lowest="C3"
```

В `/boot/loader.conf` добавить:

``` example
cpufreq_load="YES"
kern.hz=100
```

Благодаря этим настройкам ноутбук станет более медленным, но
энергосберегающим при работе от батареи. И наоборот — при работе от
сети.

## Звук

Нужно загружать модуль `snd_hda` при старте системы — для этого
добавляем в `/boot/loader.conf`:

``` example
snd_hda_load="YES"
```

Для переключения между динамиками и наушниками нужно добавить в
`/boot/device.hints`:

``` example
hint.hdaa.0.nid20.config="as=1 seq=0 device=Speaker"
hint.hdaa.0.nid21.config="as=1 seq=15 device=Headphones"
```

## Управление яркостью

В `/boot/loader.conf` надо добавить это:

``` example
acpi_ibm_load="YES"
acpi_video_load="YES"
```

Первая строка загружает модуль ядра, который обеспечивает взаимодействие
с разной полезной периферией на Thinkpad'ах — вроде мультимедиа-клавиш,
кнопок контроля яркости и т.п.

Вторая строка загружает модуль с помощью которого можно управлять
яркостью экрана через sysctl, обращаясь к
`hw.acpi.video.lcd0.brightness`.

## Мультимедиа-клавиши

Сначала надо проверить, что модуль `acpi_ibm` уже загружен в системе.

После этого нужно добавить в `/etc/devd.conf` следующие строки, чтобы
devd научился ловить нажатия на Fn кнопки и отсылать их в наш скрипт:

``` example
notify 10 {
    match "system" "ACPI";
    match "subsystem" "IBM";
    action "/etc/acpi_thinkpad.sh $notify";
};
```

Неполное содержимое скрипта `/etc/acpi_thinkpad.sh`:

``` bash
#!/bin/sh

ACPI_EVENT="$1"

case "$ACPI_EVENT" in
    '0x04')
        /usr/sbin/zzz
        ;;
esac
```

Посмотреть скан-коды клавиш можно остановив devd и запустив его из
консоли от рута с ключом `-d`.

## Тачпад и трекпойнт

Для начала надо включить поддержку Synaptics touchpad и трекпойнта в
`/boot/loader.conf`:

``` example
hw.psm.synaptics_support=1
hw.psm.trackpoint_support=1
```

Пакет `xf86-input-synaptics` должен быть удалён — вместо него должен
быть установлен пакет `xf86-input-evdev`.

Этого достаточно для работы тачпада и трекпойнта и средней кнопки над
тачпадом. Заодно будет работать и прокрутка при нажатии на среднюю
кнопку.

Мне удобен весьма чуствительный трекпойнт и для этого в
`/etc/systcl.conf` должны быть следующие строки:

``` example
hw.psm.trackpoint.sensitivity=255
hw.psm.trackpoint.upper_plateau=125
```

## Веб-камера

Нужно произвести следующие изменения в следующих файлах:

`/boot/loader.conf`:

``` example
cuse_load="YES"
```

`/etc/rc.conf`:

``` example
webcamd_enable="YES"
```

`/etc/sysctl.conf`:

``` example
kern.evdev.rcpt_mask=12
```

После, добавить пользователя в группу `webcamd`:

``` example
sudo pw groupmod webcamd -m <username>
```

## Сон

Для начала должен быть загружен модуль `acpi_ibm`.

Переход в режим сна делается командой: `acpiconf -s 3` от рута. Либо же,
можно использовать команду `zzz`.

## Включение drm-kmod

Нужно установить пакет `graphics/drm-kmod`. Затем, надо включить
загрузку модуля `i915kms.ko` добавлением следующей строки в
`/etc/rc.conf`:

``` example
kld_list="${kld_list} /boot/modules/i915kms.ko"
```

## Wi-Fi

Нужно добавить в `/boot/loader.conf`:

``` example
if_iwn_load="YES"
wlan_wep_load="YES"
wlan_ccmp_load="YES"
wlan_tkip_load="YES"
```

Потом, добавить в `/etc/rc.conf`:

``` example
wlans_iwn0="wlan0"
ifconfig_wlan0="WPA DHCP powersave"
create_args_wlan0="country RU regdomain NONE"
```

Для работы с WiFi-сетями нужно установить пакет wpa<sub>supplicant</sub>
и добавить в начало `/etc/wpa_supplicant.conf`:

``` example
ctrl_interface=/var/run/wpa_supplicant
eapol_version=2
fast_reauth=1
```

## Разное

Можно добавить в `/boot/loader.conf`:

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

Это включит поддержку температурных сенсоров в системе, сделает задержку
в две секунды перед загрузкой системы загрузчиком — чтобы долго не ждать
— и так далее.

Чтобы при загрузке системы DHCP client не тормозил весь процесс — можно
внести в `/etc/rc.conf` следующую строку:

``` example
background_dhclient="YES"
```

Для монтирования разделов вручную пользователем, отключения системного
динамика и т.п. — можно добавить в `/etc/sysctl.conf` следующее:

``` example
vfs.read_max=128
vfs.usermount=1
hw.syscons.bell=0
kern.vt.enable_bell=0
```
