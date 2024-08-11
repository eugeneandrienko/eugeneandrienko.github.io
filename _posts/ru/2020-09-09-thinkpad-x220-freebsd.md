---
layout: post
title: Настройка FreeBSD на Lenovo Thinkpad X220 (2011 года)
category: it
date: 2020-09-26 00:20
lang: ru
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
performance_cx_lowest="Cmax"
economy_cx_lowest="Cmax"
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
hw.psm.trackpoint.sensitivity=150
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

Для работы с WiFi-сетями нужно установить пакет `wpa_supplicant` и
добавить в начало `/etc/wpa_supplicant.conf`:

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

## Обновление 2024-04-28

На данный момент в моем Thinkpad'е используется coreboot вместо BIOS, к
материнской плате припаяна плата AGAN X230 для 2K-дисплея, а в качестве
ОС используется FreeBSD 14.0. В связи со всем этим, я добавил обновление
к статье:

### Корректная работа режима сна

Из коробки, режим сна работал странно. Команда `sudo zzz` успешно
уводила ноутбук в сон, потом он просыпался и даже успевал показать экран
с i3wm, но потом *что-то* вызывало команду `shutdown -h now` и ноутбук
выключался обычным образом. Перешерстив кучу постов на форуме FreeBSD я
нашёл тему, где у человека ноутбук от HP в принципе не уходил в режим
сна, но советы оттуда внезапно помогли и мне.

В `/etc/sysctl.conf` надо было добавить следующие строки:

``` example
hw.pci.do_power_suspend=0
hw.pci.do_power_nodriver=1
```

А в `/boot/loader.conf` вот эти:

``` example
hint.p4tcc.0.disabled="1"
hint.acpi_throttle.0.disabled="1"
```

После перезагрузки система вновь начала корректно выходить из режима
сна, не выключаясь сразу после него.

Чтобы ноутбук засыпал при закрытии крышки, как и раньше, в
`/etc/sysctl.conf` понадобилось добавить ещё одну строчку:

``` example
hw.acpi.lid_switch_state=S3
```

### Вывод лога загрузки на «второй» 2K-монитор

Coreboot с SeaBIOS payload и загрузчик FreeBSD дружат очень плохо.
Настолько плохо, что на экране сверху будет отображаться узкая полоска
чего-то вроде видеопомех, вместо интерфейса загрузчика и лога загрузки.

К счастью, поправить это достаточно просто. Сначала, надо вслепую, после
запуска загрузчика, нажать на Esc, а потом ввести команду `vbe on` и
нажать на Enter. После этого, загрузчик переключит видеорежим и на
экране отобразится его консоль.

Дальше, уже можно спокойно загрузиться в систему командой `boot` и надо
будет добавить следующие настройки в `/boot/loader.conf`:

``` example
hw.vga.textmode="0"
kern.vty=vt
i915kms_load="YES"
vbe_max_resolution=2560x1440
```

### Уменьшение количества сообщений при загрузке

В `/boot/loader.conf` добавить:

``` example
boot_mute="YES"
```

А в `/etc/rc.conf`:

``` example
rc_startmsgs="NO"
```

### Энергосбережение для видеокарты

В `/boot/loader.conf` добавить строки:

``` example
drm.i915.enable_rc6="7"
drm.i915.semaphores="1"
drm.i915.intel_iommu_enabled="1"
```

### Intel 8260

В ноутбуке теперь стоит аналог WiFi-карты Intel 8260 и настраивать его
надо через `iwlwifi`, а не через `iwn`, который в основном для старых
карт.

Настройка WiFi весьма проста. Ничего в `/boot/loader.conf` прописывать
не надо. А в `/etc/rc.conf` надо прописать лишь несколько строк:

``` example
kld_list="${kld_list} if_iwlwifi"
wlans_iwlwifi0="wlan0"
ifconfig_wlan0="WPA DHCP mode 11g"
ifconfig_wlan0_ipv6="inet6 accept_rtadv"
create_args_wlan0="wlanmode sta regdomain none country RU"
```

### Звук и coreboot

После замены оригинального BIOS на coreboot поменялись nID для звуковой
карты и совет выше, из раздела <span class="spurious-link"
target="* Звук">*Звук*</span>, перестал работать. Как и аудио в
наушниках, подключенных через 3.5 мм джек.

Список доступных nID можно увидеть в выводе команды:

``` bash
dmesg | grep pcm
```

В итоге, звук в наушниках появился, после добавления таких строк в
`/boot/device.hints`:

``` example
hint.hdaa.0.nid31.config="as=1 seq=0 device=Speaker"
hint.hdaa.0.nid35.config="as=1 seq=15 device=Headphones"
```

### Глитчи в GUI

Спустя какое-то время работы у меня возникали чёрные квадраты и
(изредка) полосы на экране. Как оказалось, надо установить драйвер от
Intel:

``` example
sudo pkg install xf86-video-intel
```

И [создать
файл](https://forums.freebsd.org/threads/pixel-artifacts-and-kernel-crash-with-intel-hd-3000-and-i915kms-driver.87585/)
`/usr/local/etc/X11/xorg.conf.d/10-intel.conf` со следующим содержимым:

``` example
Section "Device"
        Identifier  "Card0"
        Driver      "intel"
        BusID       "PCI:0:2:0"
        Option      "Accel"                 "true"
        Option      "AccelMethod"           "SNA"
        Option      "VSync"                 "false"
        Option      "PageFlip"              "false"
        Option      "TripleBuffer"          "false"
EndSection
```

### Разное (2)

Для большей отзывчивости десктопа под высокой нагрузкой, я добавил в
`/etc/sysctl.conf`:

``` example
kern.sched.preempt_thresh=224
```

Настройки, связанные с производительностью сетевого стека в
`/boot/loader.conf`:

``` example
net.link.ifqmaxlen="2048"
cc_htcp_load="YES"
```

Поддержка дока:

``` example
acpi_dock_load="YES"
```

Зависимости для Strongswan:

1.  Пакет `openssl`
2.  Загруженный модуль ядра `ipsec`

Зависимости для l2tpd:

1.  Загруженный модуль ядра `ng_l2tp`
