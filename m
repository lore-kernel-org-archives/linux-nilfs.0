From: Juan Barry Manuel Canham <Linux-pOR+BrglI3BO41XttqYhMtHuzzzSOjJt@public.gmane.org>
Subject: Corrupted a nilfs volume
Date: Sun, 20 Jan 2013 22:15:34 +0000
Message-ID: <6045199.GMMAmmf5QP@jcanhamlaptop>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2321128.fn4Ct8ov0B"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.

--nextPart2321128.fn4Ct8ov0B
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi and thanks for the great fs.

I managed to corrupt a volume (my /var)

to do this I was running an upgrade and when I ran out of space I ran
	while true; do sudo nilfs-clean -v -S 10/1 -p 1  /dev/sda4; df -h /var/ | tail -n 1 ; sleep 1 ; done

I'm running 
	Linux JCanhamLaptop 3.3.0-rc4 #1 SMP Fri Feb 24 19:12:32 GMT 2012 x86_64 x86_64 x86_64 GNU/Linux

I know it's an RC but I never got round to upgrading, hope this doesn't invalidate my bug

I've attached what I think are the relevant dmesg and syslog but they are a bit long,

I can make the system be remounted read-only by running apt-get autoclean

Jan 20 22:08:15 localhost kernel: [129306.872119] NILFS: bad btree node (blocknr=185027): level = 0, flags = 0x0, nchildren = 768
Jan 20 22:08:15 localhost kernel: [129306.872127] NILFS error (device sda4): nilfs_bmap_last_key: broken bmap (inode number=11540)
Jan 20 22:08:15 localhost kernel: [129306.872129] 
Jan 20 22:08:15 localhost kernel: [129306.872131] Remounting filesystem read-only
Jan 20 22:08:15 localhost kernel: [129306.872135] NILFS warning (device sda4): nilfs_truncate_bmap: failed to truncate bmap (ino=11540, err=-5)

Remounting rw works until I run autoclean
Jan 20 22:08:44 localhost kernel: [129335.576471] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
Jan 20 22:08:44 localhost kernel: [129335.576483] NILFS warning: mounting fs with errors
Jan 20 22:08:44 localhost nilfs_cleanerd[16781]: start
Jan 20 22:08:44 localhost nilfs_cleanerd[16781]: pause (clean check)
Jan 20 22:08:45 localhost nilfs_cleanerd[16786]: start
Jan 20 22:08:45 localhost nilfs_cleanerd[16786]: pause (clean check)

Thanks for any help and I hope I can help track down this bug

Juan
--nextPart2321128.fn4Ct8ov0B
Content-Disposition: attachment; filename="syslog-tail.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="syslog-tail.log"

Jan 20 20:04:19 localhost NetworkManager[1278]: <info> ((null)): writing resolv.conf to /sbin/resolvconf
Jan 20 20:04:19 localhost dnsmasq[3662]: setting upstream servers from DBus
Jan 20 20:04:19 localhost dnsmasq[3662]: using nameserver 194.168.8.100#53
Jan 20 20:04:19 localhost dnsmasq[3662]: using nameserver 194.168.4.100#53
Jan 20 20:04:20 localhost NetworkManager[1278]: <info> Policy set 'virginmedia9165620' (wlan0) as default for IPv4 routing and DNS.
Jan 20 20:04:20 localhost NetworkManager[1278]: <info> Activation (wlan0) successful, device activated.
Jan 20 20:04:20 localhost NetworkManager[1278]: <info> Activation (wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Jan 20 20:04:20 localhost dbus[1170]: [system] Activating service name='org.freedesktop.nm_dispatcher' (using servicehelper)
Jan 20 20:04:20 localhost dbus[1170]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Jan 20 20:04:29 localhost ntpdate[21721]: step time server 91.189.94.4 offset 1.449971 sec
Jan 20 20:05:53 localhost dbus[1170]: [system] Activating service name='org.freedesktop.PackageKit' (using servicehelper)
Jan 20 20:05:53 localhost dbus[1170]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Jan 20 20:09:01 localhost CRON[22116]: (root) CMD (  [ -x /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find /var/lib/php5/ -depth -mindepth 1 -maxdepth 1 -type f -ignore_readdir_race -cmin +$(/usr/lib/php5/maxlifetime) ! -execdir fuser -s {} 2>/dev/null \; -delete)
Jan 20 20:11:25 localhost kernel: [123888.632239] btrfs: use ssd allocation scheme
Jan 20 20:11:28 localhost dbus[1170]: [system] Reloaded configuration
Jan 20 20:12:30  dbus[1170]: last message repeated 4 times
Jan 20 20:13:55  dbus[1170]: last message repeated 3 times
Jan 20 20:17:02 localhost CRON[24198]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Jan 20 20:19:00 localhost dbus[1170]: [system] Reloaded configuration
Jan 20 20:20:26  dbus[1170]: last message repeated 5 times
Jan 20 20:23:25 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:23:27 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:23:38 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:24:34 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:24:45 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:24:45 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:24:46 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:24:46 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:24:47 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:24:48 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:24:49 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:24:49 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:24:50 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:24:50 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:24:52 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:24:52 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:24:53 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:24:53 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:24:54 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:24:54 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:24:55 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:24:59 localhost dbus[1170]: [system] Reloaded configuration
Jan 20 20:26:04  dbus[1170]: last message repeated 13 times
Jan 20 20:26:05 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:26:06 localhost dbus[1170]: [system] Reloaded configuration
Jan 20 20:27:26  dbus[1170]: last message repeated 6 times
Jan 20 20:28:25 localhost laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Jan 20 20:28:26 localhost laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Jan 20 20:28:27 localhost dbus[1170]: [system] Activating service name='org.kde.powerdevil.backlighthelper' (using servicehelper)
Jan 20 20:28:28 localhost org.kde.powerdevil.backlighthelper: QDBusConnection: system D-Bus connection created before QCoreApplication. Application may misbehave.
Jan 20 20:28:28 localhost dbus[1170]: [system] Successfully activated service 'org.kde.powerdevil.backlighthelper'
Jan 20 20:28:51 localhost laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Jan 20 20:28:51 localhost dbus[1170]: [system] Activating service name='org.kde.powerdevil.backlighthelper' (using servicehelper)
Jan 20 20:28:51 localhost org.kde.powerdevil.backlighthelper: QDBusConnection: system D-Bus connection created before QCoreApplication. Application may misbehave.
Jan 20 20:28:51 localhost dbus[1170]: [system] Successfully activated service 'org.kde.powerdevil.backlighthelper'
Jan 20 20:28:51 localhost anacron[27332]: Anacron 2.3 started on 2013-01-20
Jan 20 20:28:51 localhost anacron[27332]: Normal exit (0 jobs run)
Jan 20 20:28:57 localhost laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Jan 20 20:32:36 localhost dbus[1170]: [system] Reloaded configuration
Jan 20 20:32:37 localhost dbus[1170]: [system] Reloaded configuration
Jan 20 20:33:03 localhost nilfs_cleanerd[442]: resume (clean check)
Jan 20 20:33:05 localhost nilfs_cleanerd[14360]: resume (clean check)
Jan 20 20:33:27 localhost dbus[1170]: [system] Reloaded configuration
Jan 20 20:35:05 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:06 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:06 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:08 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:08 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:09 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:09 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:10 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:11 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:12 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:13 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:14 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:14 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:15 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:15 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:16 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:16 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:18 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:18 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:19 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:19 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:20 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:20 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:21 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:21 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:22 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:23 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:24 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:25 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:26 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:26 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:27 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:28 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:29 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:29 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:31 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:31 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:32 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:33 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:33 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:34 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:35 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:35 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:36 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:36 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:37 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:38 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:38 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:39 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:39 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:35:40 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:35:41 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:41 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:42 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:42 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:44 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:44 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:45 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:45 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:46 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:46 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:47 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:48 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:49 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:49 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:51 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:51 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:52 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:52 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:53 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:53 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:54 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:54 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:55 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:55 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:57 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:57 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:58 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:35:58 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:35:59 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:36:00 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:36:01 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:01 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:03 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:03 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:04 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:04 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:05 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:05 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:06 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:06 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:07 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:07 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:09 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:09 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:20 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:36:20 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:21 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:23 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:23 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:25 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:25 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:26 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:26 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:26 localhost dbus[1170]: [system] Reloaded configuration
Jan 20 20:36:27 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:27 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:28 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:28 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:29 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:29 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:30 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:30 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:41 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:41 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:42 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:42 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:43 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:43 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:43 localhost dbus[1170]: [system] Reloaded configuration
Jan 20 20:36:44 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:44 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:46 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:46 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:47 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:49 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:49 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:51 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:36:54 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:36:54 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:01 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:01 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:02 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:02 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:03 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:03 localhost dbus[1170]: [system] Reloaded configuration
Jan 20 20:37:03 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:04 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:05 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:06 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:37:06 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:37:07 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:37:08 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:37:08 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:37:15 localhost laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Jan 20 20:37:19 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:37:20 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:37:20 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:37:22 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:37:39 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:37:40 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:40 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:41 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:41 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:51 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:52 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:52 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:53 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:53 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:54 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:55 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:55 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:55 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:56 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:37:57 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:37:58 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:02 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:02 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:03 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:03 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:08 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:08 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:09 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:09 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:10 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:10 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:11 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:11 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:12 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:12 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:23 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:23 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:25 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:25 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:26 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:26 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:27 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:27 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:28 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:28 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:29 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:29 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:30 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:30 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:31 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:31 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:35 localhost kernel: [125516.673358] use_block_rsv: 74 callbacks suppressed
Jan 20 20:38:35 localhost kernel: [125516.673363] btrfs: block rsv returned -28
Jan 20 20:38:35 localhost kernel: [125516.673374] ------------[ cut here ]------------
Jan 20 20:38:35 localhost kernel: [125516.673382] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x374/0x380()
Jan 20 20:38:35 localhost kernel: [125516.673395] Hardware name: Studio 1558
Jan 20 20:38:35 localhost kernel: [125516.673397] Modules linked in: joydev mousedev parport_pc ppdev parport arc4 binfmt_misc iwlwifi snd_hda_codec_hdmi uvcvideo radeon videobuf2_core snd_hda_codec_idt videodev v4l2_compat_ioctl32 videobuf2_vmalloc snd_hda_intel videobuf2_memops ttm mac80211 snd_hda_codec psmouse drm_kms_helper dell_wmi dell_laptop sparse_keymap dcdbas snd_hwdep cfg80211 serio_raw drm snd_pcm snd_timer snd_page_alloc wmi video evdev i2c_algo_bit sbs sbshc coretemp firewire_ohci ahci r8169 libahci firewire_core sdhci_pci crc_itu_t sdhci
Jan 20 20:38:35 localhost kernel: [125516.673590] Pid: 32024, comm: btrfs-endio-wri Tainted: G        W    3.3.0-rc4 #1
Jan 20 20:38:35 localhost kernel: [125516.673593] Call Trace:
Jan 20 20:38:35 localhost kernel: [125516.673604]  [<ffffffff8105850f>] warn_slowpath_common+0x7f/0xc0
Jan 20 20:38:35 localhost kernel: [125516.673616]  [<ffffffff8105856a>] warn_slowpath_null+0x1a/0x20
Jan 20 20:38:35 localhost kernel: [125516.673621]  [<ffffffff812b54c4>] btrfs_alloc_free_block+0x374/0x380
Jan 20 20:38:35 localhost kernel: [125516.673636]  [<ffffffff812e50ea>] ? read_extent_buffer+0xea/0x180
Jan 20 20:38:35 localhost kernel: [125516.673642]  [<ffffffff812a377f>] __btrfs_cow_block+0x12f/0x440
Jan 20 20:38:35 localhost kernel: [125516.673647]  [<ffffffff812a3b86>] btrfs_cow_block+0xf6/0x220
Jan 20 20:38:35 localhost kernel: [125516.673653]  [<ffffffff812a7919>] btrfs_search_slot+0x409/0x8a0
Jan 20 20:38:35 localhost kernel: [125516.673657]  [<ffffffff812a5ade>] ? btrfs_leaf_free_space+0x5e/0xb0
Jan 20 20:38:35 localhost kernel: [125516.673675]  [<ffffffff812b9984>] btrfs_lookup_csum+0x74/0x170
Jan 20 20:38:35 localhost kernel: [125516.673693]  [<ffffffff8116a21c>] ? kmem_cache_alloc+0x10c/0x140
Jan 20 20:38:35 localhost kernel: [125516.673702]  [<ffffffff812ba994>] btrfs_csum_file_blocks+0xb4/0x650
Jan 20 20:38:35 localhost kernel: [125516.673721]  [<ffffffff812c7485>] add_pending_csums.isra.38+0x45/0x60
Jan 20 20:38:35 localhost kernel: [125516.673739]  [<ffffffff812cad72>] btrfs_finish_ordered_io+0x242/0x320
Jan 20 20:38:35 localhost kernel: [125516.673748]  [<ffffffff812cae9d>] btrfs_writepage_end_io_hook+0x4d/0xc0
Jan 20 20:38:35 localhost kernel: [125516.673766]  [<ffffffff812e0319>] end_bio_extent_writepage+0x129/0x180
Jan 20 20:38:35 localhost kernel: [125516.673776]  [<ffffffff811b193d>] bio_endio+0x1d/0x40
Jan 20 20:38:35 localhost kernel: [125516.673792]  [<ffffffff812bdba8>] end_workqueue_fn+0x58/0x140
Jan 20 20:38:35 localhost kernel: [125516.673801]  [<ffffffff812ef01f>] worker_loop+0x16f/0x5d0
Jan 20 20:38:35 localhost kernel: [125516.673810]  [<ffffffff812eeeb0>] ? btrfs_queue_worker+0x310/0x310
Jan 20 20:38:35 localhost kernel: [125516.673838]  [<ffffffff8107b653>] kthread+0x93/0xa0
Jan 20 20:38:35 localhost kernel: [125516.673844]  [<ffffffff81604464>] kernel_thread_helper+0x4/0x10
Jan 20 20:38:35 localhost kernel: [125516.673849]  [<ffffffff8107b5c0>] ? kthread_freezable_should_stop+0x70/0x70
Jan 20 20:38:35 localhost kernel: [125516.673853]  [<ffffffff81604460>] ? gs_change+0x13/0x13
Jan 20 20:38:35 localhost kernel: [125516.673856] ---[ end trace b9e4d482b4ad4980 ]---
Jan 20 20:38:35 localhost kernel: [125516.673910] btrfs: block rsv returned -28
Jan 20 20:38:35 localhost kernel: [125516.673914] ------------[ cut here ]------------
Jan 20 20:38:35 localhost kernel: [125516.673923] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x374/0x380()
Jan 20 20:38:35 localhost kernel: [125516.673928] Hardware name: Studio 1558
Jan 20 20:38:35 localhost kernel: [125516.673931] Modules linked in: joydev mousedev parport_pc ppdev parport arc4 binfmt_misc iwlwifi snd_hda_codec_hdmi uvcvideo radeon videobuf2_core snd_hda_codec_idt videodev v4l2_compat_ioctl32 videobuf2_vmalloc snd_hda_intel videobuf2_memops ttm mac80211 snd_hda_codec psmouse drm_kms_helper dell_wmi dell_laptop sparse_keymap dcdbas snd_hwdep cfg80211 serio_raw drm snd_pcm snd_timer snd_page_alloc wmi video evdev i2c_algo_bit sbs sbshc coretemp firewire_ohci ahci r8169 libahci firewire_core sdhci_pci crc_itu_t sdhci
Jan 20 20:38:35 localhost kernel: [125516.674055] Pid: 1215, comm: btrfs-endio-wri Tainted: G        W    3.3.0-rc4 #1
Jan 20 20:38:35 localhost kernel: [125516.674061] Call Trace:
Jan 20 20:38:35 localhost kernel: [125516.674075]  [<ffffffff8105850f>] warn_slowpath_common+0x7f/0xc0
Jan 20 20:38:35 localhost kernel: [125516.674089]  [<ffffffff8105856a>] warn_slowpath_null+0x1a/0x20
Jan 20 20:38:35 localhost kernel: [125516.674106]  [<ffffffff812b54c4>] btrfs_alloc_free_block+0x374/0x380
Jan 20 20:38:35 localhost kernel: [125516.674117]  [<ffffffff812e50ea>] ? read_extent_buffer+0xea/0x180
Jan 20 20:38:35 localhost kernel: [125516.674127]  [<ffffffff812a377f>] __btrfs_cow_block+0x12f/0x440
Jan 20 20:38:35 localhost kernel: [125516.674141]  [<ffffffff812a3b86>] btrfs_cow_block+0xf6/0x220
Jan 20 20:38:35 localhost kernel: [125516.674151]  [<ffffffff812a7919>] btrfs_search_slot+0x409/0x8a0
Jan 20 20:38:35 localhost kernel: [125516.674160]  [<ffffffff812a5ade>] ? btrfs_leaf_free_space+0x5e/0xb0
Jan 20 20:38:35 localhost kernel: [125516.674169]  [<ffffffff812b9984>] btrfs_lookup_csum+0x74/0x170
Jan 20 20:38:35 localhost kernel: [125516.674178]  [<ffffffff8116a21c>] ? kmem_cache_alloc+0x10c/0x140
Jan 20 20:38:35 localhost kernel: [125516.674188]  [<ffffffff812ba994>] btrfs_csum_file_blocks+0xb4/0x650
Jan 20 20:38:35 localhost kernel: [125516.674204]  [<ffffffff812c7485>] add_pending_csums.isra.38+0x45/0x60
Jan 20 20:38:35 localhost kernel: [125516.674214]  [<ffffffff812cad72>] btrfs_finish_ordered_io+0x242/0x320
Jan 20 20:38:35 localhost kernel: [125516.674225]  [<ffffffff812cae9d>] btrfs_writepage_end_io_hook+0x4d/0xc0
Jan 20 20:38:35 localhost kernel: [125516.674234]  [<ffffffff812e0319>] end_bio_extent_writepage+0x129/0x180
Jan 20 20:38:35 localhost kernel: [125516.674244]  [<ffffffff811b193d>] bio_endio+0x1d/0x40
Jan 20 20:38:35 localhost kernel: [125516.674253]  [<ffffffff812bdba8>] end_workqueue_fn+0x58/0x140
Jan 20 20:38:35 localhost kernel: [125516.674262]  [<ffffffff812ef01f>] worker_loop+0x16f/0x5d0
Jan 20 20:38:35 localhost kernel: [125516.674272]  [<ffffffff81083dd8>] ? __wake_up_common+0x58/0x90
Jan 20 20:38:35 localhost kernel: [125516.674286]  [<ffffffff812eeeb0>] ? btrfs_queue_worker+0x310/0x310
Jan 20 20:38:35 localhost kernel: [125516.674299]  [<ffffffff8107b653>] kthread+0x93/0xa0
Jan 20 20:38:35 localhost kernel: [125516.674312]  [<ffffffff81604464>] kernel_thread_helper+0x4/0x10
Jan 20 20:38:35 localhost kernel: [125516.674322]  [<ffffffff8107b5c0>] ? kthread_freezable_should_stop+0x70/0x70
Jan 20 20:38:35 localhost kernel: [125516.674334]  [<ffffffff81604460>] ? gs_change+0x13/0x13
Jan 20 20:38:35 localhost kernel: [125516.674340] ---[ end trace b9e4d482b4ad4981 ]---
Jan 20 20:38:42 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:42 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:44 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:44 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:45 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:38:45 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:45 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:38:47 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:48 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:48 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:49 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:49 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:50 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:50 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:51 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:51 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:52 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:38:53 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:38:56 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:38:56 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:01 localhost CRON[1450]: (root) CMD (  [ -x /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find /var/lib/php5/ -depth -mindepth 1 -maxdepth 1 -type f -ignore_readdir_race -cmin +$(/usr/lib/php5/maxlifetime) ! -execdir fuser -s {} 2>/dev/null \; -delete)
Jan 20 20:39:03 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:03 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:07 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:07 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:09 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:09 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:16 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:16 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:17 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:17 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:18 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:18 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:19 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:19 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:20 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:20 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:22 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:22 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:23 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:23 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:24 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:24 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:25 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:25 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:28 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:28 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:30 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:30 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:49 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:49 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:50 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:50 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:51 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:51 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:52 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:52 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:53 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:53 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:54 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:54 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:55 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:39:56 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:39:57 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:39:57 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:39:58 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:39:59 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:00 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:40:00 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:40:01 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:40:01 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:40:02 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:03 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:03 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:04 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:05 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:06 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:06 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:07 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:07 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:08 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:08 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:09 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:09 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:10 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:10 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:14 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:40:14 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:15 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:16 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:16 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:17 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:17 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:19 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:19 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:20 localhost kernel: [125621.389383] ata1.00: exception Emask 0x10 SAct 0x3f SErr 0x4090000 action 0xe frozen
Jan 20 20:40:20 localhost kernel: [125621.389391] ata1.00: irq_stat 0x00400040, connection status changed
Jan 20 20:40:20 localhost kernel: [125621.389398] ata1: SError: { PHYRdyChg 10B8B DevExch }
Jan 20 20:40:20 localhost kernel: [125621.389405] ata1.00: failed command: WRITE FPDMA QUEUED
Jan 20 20:40:20 localhost kernel: [125621.389417] ata1.00: cmd 61/00:00:00:ec:31/04:00:01:00:00/40 tag 0 ncq 524288 out
Jan 20 20:40:20 localhost kernel: [125621.389420]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
Jan 20 20:40:20 localhost kernel: [125621.389426] ata1.00: status: { DRDY }
Jan 20 20:40:20 localhost kernel: [125621.389431] ata1.00: failed command: WRITE FPDMA QUEUED
Jan 20 20:40:20 localhost kernel: [125621.389442] ata1.00: cmd 61/00:08:00:f0:31/04:00:01:00:00/40 tag 1 ncq 524288 out
Jan 20 20:40:20 localhost kernel: [125621.389445]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
Jan 20 20:40:20 localhost kernel: [125621.389451] ata1.00: status: { DRDY }
Jan 20 20:40:20 localhost kernel: [125621.389456] ata1.00: failed command: WRITE FPDMA QUEUED
Jan 20 20:40:20 localhost kernel: [125621.389467] ata1.00: cmd 61/00:10:00:d8:31/04:00:01:00:00/40 tag 2 ncq 524288 out
Jan 20 20:40:20 localhost kernel: [125621.389469]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
Jan 20 20:40:20 localhost kernel: [125621.389475] ata1.00: status: { DRDY }
Jan 20 20:40:20 localhost kernel: [125621.389480] ata1.00: failed command: WRITE FPDMA QUEUED
Jan 20 20:40:20 localhost kernel: [125621.389491] ata1.00: cmd 61/00:18:00:dc:31/04:00:01:00:00/40 tag 3 ncq 524288 out
Jan 20 20:40:20 localhost kernel: [125621.389494]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
Jan 20 20:40:20 localhost kernel: [125621.389499] ata1.00: status: { DRDY }
Jan 20 20:40:20 localhost kernel: [125621.389504] ata1.00: failed command: WRITE FPDMA QUEUED
Jan 20 20:40:20 localhost kernel: [125621.389515] ata1.00: cmd 61/00:20:00:e0:31/04:00:01:00:00/40 tag 4 ncq 524288 out
Jan 20 20:40:20 localhost kernel: [125621.389518]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
Jan 20 20:40:20 localhost kernel: [125621.389524] ata1.00: status: { DRDY }
Jan 20 20:40:20 localhost kernel: [125621.389529] ata1.00: failed command: WRITE FPDMA QUEUED
Jan 20 20:40:20 localhost kernel: [125621.389540] ata1.00: cmd 61/00:28:00:e8:31/04:00:01:00:00/40 tag 5 ncq 524288 out
Jan 20 20:40:20 localhost kernel: [125621.389542]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
Jan 20 20:40:20 localhost kernel: [125621.389548] ata1.00: status: { DRDY }
Jan 20 20:40:20 localhost kernel: [125621.389556] ata1: hard resetting link
Jan 20 20:40:21 localhost kernel: [125622.110242] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jan 20 20:40:21 localhost kernel: [125622.132038] ata1.00: configured for UDMA/133
Jan 20 20:40:21 localhost kernel: [125622.146251] ata1: EH complete
Jan 20 20:40:21 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:21 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:22 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:22 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:23 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:23 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:24 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:24 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:25 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:25 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:26 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:26 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:27 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:28 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:29 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:40:29 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:40:30 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:31 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:31 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:32 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:33 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:40:33 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:33 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:40:33 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:40:34 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:34 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:35 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:40:35 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:40:36 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:40:36 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:40:37 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:40:37 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:41:47 localhost acpid: client 31967[0:0] has disconnected
Jan 20 20:41:47 localhost acpid: client connected from 31967[0:0]
Jan 20 20:41:47 localhost acpid: 1 client rule loaded
Jan 20 20:41:52 localhost acpid: client 31967[0:0] has disconnected
Jan 20 20:41:52 localhost acpid: client connected from 2927[0:0]
Jan 20 20:41:52 localhost acpid: 1 client rule loaded
Jan 20 20:42:23 localhost kdm: :0[2940]: Abnormal termination of greeter for display :0, code 127, signal 0
Jan 20 20:42:24 localhost acpid: client 2927[0:0] has disconnected
Jan 20 20:42:24 localhost acpid: client connected from 3141[0:0]
Jan 20 20:42:24 localhost acpid: 1 client rule loaded
Jan 20 20:42:28 localhost acpid: client 3141[0:0] has disconnected
Jan 20 20:42:28 localhost laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Jan 20 20:42:31 localhost acpid: client connected from 3141[0:0]
Jan 20 20:42:31 localhost acpid: 1 client rule loaded
Jan 20 20:42:33 localhost laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Jan 20 20:42:33 localhost dbus[1170]: [system] Activating service name='org.kde.powerdevil.backlighthelper' (using servicehelper)
Jan 20 20:42:33 localhost org.kde.powerdevil.backlighthelper: QDBusConnection: system D-Bus connection created before QCoreApplication. Application may misbehave.
Jan 20 20:42:33 localhost dbus[1170]: [system] Successfully activated service 'org.kde.powerdevil.backlighthelper'
Jan 20 20:42:45 localhost hp-systray: hp-systray[3827]: warning: No hp: or hpfax: devices found in any installed CUPS queue. Exiting.
Jan 20 20:42:54 localhost laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Jan 20 20:43:36 localhost nilfs_cleanerd[442]: resume (clean check)
Jan 20 20:43:37 localhost nilfs_cleanerd[14360]: resume (clean check)
Jan 20 20:45:52 localhost kernel: [125953.743053] nilfs_sufile_do_cancel_free: segment 83 must be clean
Jan 20 20:45:57 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:45:58 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:46:04 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:46:05 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:46:18 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:46:18 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:46:26 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:46:36 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:46:37 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:46:38 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:46:45 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:46:46 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:46:46 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:46:47 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:46:48 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:46:57 localhost acpid: client 3141[0:0] has disconnected
Jan 20 20:46:57 localhost acpid: client connected from 6054[0:0]
Jan 20 20:46:57 localhost acpid: 1 client rule loaded
Jan 20 20:46:58 localhost kernel: [126019.570303] akonadi_agent_l[6079]: segfault at 48 ip 00007f3dc1726550 sp 00007fff955d3d98 error 4 in libQtDBus.so.4.8.3[7f3dc16f7000+79000]
Jan 20 20:46:58 localhost laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Jan 20 20:46:58 localhost kernel: [126019.598744] akonadi_agent_l[6087]: segfault at 48 ip 00007f6d81769550 sp 00007fff4e2b2a78 error 4 in libQtDBus.so.4.8.3[7f6d8173a000+79000]
Jan 20 20:47:00 localhost dbus[1170]: [system] Activating service name='org.kde.powerdevil.backlighthelper' (using servicehelper)
Jan 20 20:47:00 localhost org.kde.powerdevil.backlighthelper: QDBusConnection: system D-Bus connection created before QCoreApplication. Application may misbehave.
Jan 20 20:47:00 localhost dbus[1170]: [system] Successfully activated service 'org.kde.powerdevil.backlighthelper'
Jan 20 20:47:14 localhost hp-systray: hp-systray[6646]: warning: No hp: or hpfax: devices found in any installed CUPS queue. Exiting.
Jan 20 20:47:14 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:47:26 localhost laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Jan 20 20:47:48 localhost nilfs_cleanerd[14360]: resume (clean check)
Jan 20 20:48:14 localhost nilfs_cleanerd[442]: resume (clean check)
Jan 20 20:48:34 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:48:36 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:37 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:37 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:48:38 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:39 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:39 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:48:40 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:40 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:41 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:48:42 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:43 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:43 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:48:44 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:44 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:45 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:48:46 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:46 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:47 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:47 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:48 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:50 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:48:50 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:51 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:52 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:52 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:53 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:53 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:54 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:54 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:57  nilfs_cleanerd[442]: last message repeated 2 times
Jan 20 20:48:57 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:48:57 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:48:57 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:48:58 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:48:58 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:48:58 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:48:59 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:48:59 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:00 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:00 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:01 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:01 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:02 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:04 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:05 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:05 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:06 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:06 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:07 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:08 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:08 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:09 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:10 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:10 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:11 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:13 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:13 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:13 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:14 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:14 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:15 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:17 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:17 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:18 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:19 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:19 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:20 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:20 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:20 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:21 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:21 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:22 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:22 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:23 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:23 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:24 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:24 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:25 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:26 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:28 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:28 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:29 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:30 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:30 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:31 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:32 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:32 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:33 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:33 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:34 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:35 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:35 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:36 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:37 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:37 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:38 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:40 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:40 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:40 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:41 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:41 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:42 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:43 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:44 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:44 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:46 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:46 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:47 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:48 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:48 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:49 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:50 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:50 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:51 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:52 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:52 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:53 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:53 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:54 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:54 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:55 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:57 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:49:57 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:58 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:59 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:49:59 localhost nilfs_cleanerd[442]: manual run completed
Jan 20 20:49:59 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:49:59 localhost nilfs_cleanerd[14360]: manual run completed
Jan 20 20:50:00 localhost nilfs_cleanerd[442]: run (manual)
Jan 20 20:50:01 localhost kernel: [126201.739932] NILFS: bad btree node (blocknr=184875): level = 0, flags = 0x69, nchildren = 1807
Jan 20 20:50:01 localhost kernel: [126201.739939] NILFS error (device sda4): nilfs_bmap_last_key: broken bmap (inode number=11533)
Jan 20 20:50:01 localhost kernel: [126201.739941] 
Jan 20 20:50:01 localhost kernel: [126201.740836] Remounting filesystem read-only
Jan 20 20:50:01 localhost kernel: [126201.740841] NILFS warning (device sda4): nilfs_truncate_bmap: failed to truncate bmap (ino=11533, err=-5)
Jan 20 20:50:01 localhost nilfs_cleanerd[14360]: run (manual)
Jan 20 20:50:01 localhost nilfs_cleanerd[14360]: cannot clean segments: Read-only file system
Jan 20 20:50:01 localhost nilfs_cleanerd[14360]: shutdown
Jan 20 20:50:01 localhost nilfs_cleanerd[442]: cannot clean segments: Read-only file system
Jan 20 20:50:01 localhost nilfs_cleanerd[442]: shutdown
Jan 20 20:54:26 localhost kernel: [126466.718675] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
Jan 20 20:54:26 localhost kernel: [126466.718685] NILFS warning: mounting fs with errors
Jan 20 20:54:26 localhost nilfs_cleanerd[10029]: start
Jan 20 20:54:26 localhost nilfs_cleanerd[10029]: pause (clean check)
Jan 20 20:54:40 localhost nilfs_cleanerd[10141]: start
Jan 20 20:54:40 localhost nilfs_cleanerd[10141]: pause (clean check)
Jan 20 20:56:04 localhost acpid: client 6054[0:0] has disconnected
Jan 20 20:56:04 localhost acpid: client connected from 6054[0:0]
Jan 20 20:56:04 localhost acpid: 1 client rule loaded
Jan 20 21:09:01 localhost CRON[12307]: (root) CMD (  [ -x /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find /var/lib/php5/ -depth -mindepth 1 -maxdepth 1 -type f -ignore_readdir_race -cmin +$(/usr/lib/php5/maxlifetime) ! -execdir fuser -s {} 2>/dev/null \; -delete)
Jan 20 21:14:47 localhost nilfs_cleanerd[13171]: start
Jan 20 21:14:47 localhost nilfs_cleanerd[13171]: pause (clean check)
Jan 20 21:15:12 localhost kernel: [127711.989047] NILFS: bad btree node (blocknr=184891): level = 172, flags = 0x10, nchildren = 21699
Jan 20 21:15:12 localhost kernel: [127711.989060] NILFS error (device sda4): nilfs_bmap_last_key: broken bmap (inode number=11536)
Jan 20 21:15:12 localhost kernel: [127711.989061] 
Jan 20 21:15:12 localhost kernel: [127711.989064] Remounting filesystem read-only
Jan 20 21:15:12 localhost kernel: [127711.989067] NILFS warning (device sda4): nilfs_truncate_bmap: failed to truncate bmap (ino=11536, err=-5)
Jan 20 21:17:01 localhost CRON[13393]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Jan 20 21:26:11 localhost nilfs_cleanerd[14329]: start
Jan 20 21:26:11 localhost kernel: [128370.187840] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
Jan 20 21:26:11 localhost kernel: [128370.187850] NILFS warning: mounting fs with errors
Jan 20 21:26:11 localhost nilfs_cleanerd[14329]: pause (clean check)
Jan 20 21:26:15 localhost nilfs_cleanerd[14334]: start
Jan 20 21:26:15 localhost nilfs_cleanerd[14334]: pause (clean check)
Jan 20 21:26:18 localhost nilfs_cleanerd[14340]: start
Jan 20 21:26:18 localhost nilfs_cleanerd[14340]: pause (clean check)
Jan 20 21:30:47 localhost kernel: [128645.627623] mmc0: card 59b4 removed

--nextPart2321128.fn4Ct8ov0B
Content-Disposition: attachment; filename="dmesg-tail.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="dmesg-tail.log"

[123450.292829] restoring control 00000000-0000-0000-0000-000000000101/4/8
[123450.292833] restoring control 00000000-0000-0000-0000-000000000101/5/9
[123450.292836] restoring control 00000000-0000-0000-0000-000000000101/6/10
[123450.292840] restoring control 00000000-0000-0000-0000-000000000101/8/1
[123450.292844] restoring control 00000000-0000-0000-0000-000000000101/9/4
[123450.292848] restoring control 00000000-0000-0000-0000-000000000101/10/5
[123450.292852] restoring control 00000000-0000-0000-0000-000000000101/12/11
[123450.358114] sdhci-pci 0000:07:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[123450.358144] sdhci-pci 0000:07:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[123450.410061] firewire_core: rediscovered device fw0
[123450.537897] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[123451.952454] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[123451.971647] ata2.00: configured for UDMA/133
[123451.984663] sd 1:0:0:0: [sdb] Starting disk
[123452.166131] ata1.00: configured for UDMA/133
[123452.180680] sd 0:0:0:0: [sda] Starting disk
[123452.198260] PM: resume of devices complete after 2343.600 msecs
[123452.198333] PM: resume devices took 2.344 seconds
[123452.198351] PM: Finishing wakeup.
[123452.198353] Restarting tasks ... done.
[123452.241531] video LNXVIDEO:00: Restoring backlight state
[123452.399557] mmc0: new SDHC card at address 59b4
[123452.539571] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
[123452.546459] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
[123452.723040] r8169 0000:09:00.0: eth0: link down
[123459.223397] wlan0: authenticate with 00:8e:f2:bf:20:5f (try 1)
[123459.225719] wlan0: authenticated
[123459.226995] wlan0: associate with 00:8e:f2:bf:20:5f (try 1)
[123459.236247] wlan0: RX AssocResp from 00:8e:f2:bf:20:5f (capab=0x411 status=0 aid=6)
[123459.236256] wlan0: associated
[123459.236265] wlan0: moving STA 00:8e:f2:bf:20:5f to state 1
[123459.236271] wlan0: moving STA 00:8e:f2:bf:20:5f to state 2
[123459.274153] wlan0: moving STA 00:8e:f2:bf:20:5f to state 3
[123888.632239] btrfs: use ssd allocation scheme
[125516.673358] use_block_rsv: 74 callbacks suppressed
[125516.673363] btrfs: block rsv returned -28
[125516.673374] ------------[ cut here ]------------
[125516.673382] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x374/0x380()
[125516.673395] Hardware name: Studio 1558
[125516.673397] Modules linked in: joydev mousedev parport_pc ppdev parport arc4 binfmt_misc iwlwifi snd_hda_codec_hdmi uvcvideo radeon videobuf2_core snd_hda_codec_idt videodev v4l2_compat_ioctl32 videobuf2_vmalloc snd_hda_intel videobuf2_memops ttm mac80211 snd_hda_codec psmouse drm_kms_helper dell_wmi dell_laptop sparse_keymap dcdbas snd_hwdep cfg80211 serio_raw drm snd_pcm snd_timer snd_page_alloc wmi video evdev i2c_algo_bit sbs sbshc coretemp firewire_ohci ahci r8169 libahci firewire_core sdhci_pci crc_itu_t sdhci
[125516.673590] Pid: 32024, comm: btrfs-endio-wri Tainted: G        W    3.3.0-rc4 #1
[125516.673593] Call Trace:
[125516.673604]  [<ffffffff8105850f>] warn_slowpath_common+0x7f/0xc0
[125516.673616]  [<ffffffff8105856a>] warn_slowpath_null+0x1a/0x20
[125516.673621]  [<ffffffff812b54c4>] btrfs_alloc_free_block+0x374/0x380
[125516.673636]  [<ffffffff812e50ea>] ? read_extent_buffer+0xea/0x180
[125516.673642]  [<ffffffff812a377f>] __btrfs_cow_block+0x12f/0x440
[125516.673647]  [<ffffffff812a3b86>] btrfs_cow_block+0xf6/0x220
[125516.673653]  [<ffffffff812a7919>] btrfs_search_slot+0x409/0x8a0
[125516.673657]  [<ffffffff812a5ade>] ? btrfs_leaf_free_space+0x5e/0xb0
[125516.673675]  [<ffffffff812b9984>] btrfs_lookup_csum+0x74/0x170
[125516.673693]  [<ffffffff8116a21c>] ? kmem_cache_alloc+0x10c/0x140
[125516.673702]  [<ffffffff812ba994>] btrfs_csum_file_blocks+0xb4/0x650
[125516.673721]  [<ffffffff812c7485>] add_pending_csums.isra.38+0x45/0x60
[125516.673739]  [<ffffffff812cad72>] btrfs_finish_ordered_io+0x242/0x320
[125516.673748]  [<ffffffff812cae9d>] btrfs_writepage_end_io_hook+0x4d/0xc0
[125516.673766]  [<ffffffff812e0319>] end_bio_extent_writepage+0x129/0x180
[125516.673776]  [<ffffffff811b193d>] bio_endio+0x1d/0x40
[125516.673792]  [<ffffffff812bdba8>] end_workqueue_fn+0x58/0x140
[125516.673801]  [<ffffffff812ef01f>] worker_loop+0x16f/0x5d0
[125516.673810]  [<ffffffff812eeeb0>] ? btrfs_queue_worker+0x310/0x310
[125516.673838]  [<ffffffff8107b653>] kthread+0x93/0xa0
[125516.673844]  [<ffffffff81604464>] kernel_thread_helper+0x4/0x10
[125516.673849]  [<ffffffff8107b5c0>] ? kthread_freezable_should_stop+0x70/0x70
[125516.673853]  [<ffffffff81604460>] ? gs_change+0x13/0x13
[125516.673856] ---[ end trace b9e4d482b4ad4980 ]---
[125516.673910] btrfs: block rsv returned -28
[125516.673914] ------------[ cut here ]------------
[125516.673923] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x374/0x380()
[125516.673928] Hardware name: Studio 1558
[125516.673931] Modules linked in: joydev mousedev parport_pc ppdev parport arc4 binfmt_misc iwlwifi snd_hda_codec_hdmi uvcvideo radeon videobuf2_core snd_hda_codec_idt videodev v4l2_compat_ioctl32 videobuf2_vmalloc snd_hda_intel videobuf2_memops ttm mac80211 snd_hda_codec psmouse drm_kms_helper dell_wmi dell_laptop sparse_keymap dcdbas snd_hwdep cfg80211 serio_raw drm snd_pcm snd_timer snd_page_alloc wmi video evdev i2c_algo_bit sbs sbshc coretemp firewire_ohci ahci r8169 libahci firewire_core sdhci_pci crc_itu_t sdhci
[125516.674055] Pid: 1215, comm: btrfs-endio-wri Tainted: G        W    3.3.0-rc4 #1
[125516.674061] Call Trace:
[125516.674075]  [<ffffffff8105850f>] warn_slowpath_common+0x7f/0xc0
[125516.674089]  [<ffffffff8105856a>] warn_slowpath_null+0x1a/0x20
[125516.674106]  [<ffffffff812b54c4>] btrfs_alloc_free_block+0x374/0x380
[125516.674117]  [<ffffffff812e50ea>] ? read_extent_buffer+0xea/0x180
[125516.674127]  [<ffffffff812a377f>] __btrfs_cow_block+0x12f/0x440
[125516.674141]  [<ffffffff812a3b86>] btrfs_cow_block+0xf6/0x220
[125516.674151]  [<ffffffff812a7919>] btrfs_search_slot+0x409/0x8a0
[125516.674160]  [<ffffffff812a5ade>] ? btrfs_leaf_free_space+0x5e/0xb0
[125516.674169]  [<ffffffff812b9984>] btrfs_lookup_csum+0x74/0x170
[125516.674178]  [<ffffffff8116a21c>] ? kmem_cache_alloc+0x10c/0x140
[125516.674188]  [<ffffffff812ba994>] btrfs_csum_file_blocks+0xb4/0x650
[125516.674204]  [<ffffffff812c7485>] add_pending_csums.isra.38+0x45/0x60
[125516.674214]  [<ffffffff812cad72>] btrfs_finish_ordered_io+0x242/0x320
[125516.674225]  [<ffffffff812cae9d>] btrfs_writepage_end_io_hook+0x4d/0xc0
[125516.674234]  [<ffffffff812e0319>] end_bio_extent_writepage+0x129/0x180
[125516.674244]  [<ffffffff811b193d>] bio_endio+0x1d/0x40
[125516.674253]  [<ffffffff812bdba8>] end_workqueue_fn+0x58/0x140
[125516.674262]  [<ffffffff812ef01f>] worker_loop+0x16f/0x5d0
[125516.674272]  [<ffffffff81083dd8>] ? __wake_up_common+0x58/0x90
[125516.674286]  [<ffffffff812eeeb0>] ? btrfs_queue_worker+0x310/0x310
[125516.674299]  [<ffffffff8107b653>] kthread+0x93/0xa0
[125516.674312]  [<ffffffff81604464>] kernel_thread_helper+0x4/0x10
[125516.674322]  [<ffffffff8107b5c0>] ? kthread_freezable_should_stop+0x70/0x70
[125516.674334]  [<ffffffff81604460>] ? gs_change+0x13/0x13
[125516.674340] ---[ end trace b9e4d482b4ad4981 ]---
[125621.389383] ata1.00: exception Emask 0x10 SAct 0x3f SErr 0x4090000 action 0xe frozen
[125621.389391] ata1.00: irq_stat 0x00400040, connection status changed
[125621.389398] ata1: SError: { PHYRdyChg 10B8B DevExch }
[125621.389405] ata1.00: failed command: WRITE FPDMA QUEUED
[125621.389417] ata1.00: cmd 61/00:00:00:ec:31/04:00:01:00:00/40 tag 0 ncq 524288 out
[125621.389420]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
[125621.389426] ata1.00: status: { DRDY }
[125621.389431] ata1.00: failed command: WRITE FPDMA QUEUED
[125621.389442] ata1.00: cmd 61/00:08:00:f0:31/04:00:01:00:00/40 tag 1 ncq 524288 out
[125621.389445]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
[125621.389451] ata1.00: status: { DRDY }
[125621.389456] ata1.00: failed command: WRITE FPDMA QUEUED
[125621.389467] ata1.00: cmd 61/00:10:00:d8:31/04:00:01:00:00/40 tag 2 ncq 524288 out
[125621.389469]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
[125621.389475] ata1.00: status: { DRDY }
[125621.389480] ata1.00: failed command: WRITE FPDMA QUEUED
[125621.389491] ata1.00: cmd 61/00:18:00:dc:31/04:00:01:00:00/40 tag 3 ncq 524288 out
[125621.389494]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
[125621.389499] ata1.00: status: { DRDY }
[125621.389504] ata1.00: failed command: WRITE FPDMA QUEUED
[125621.389515] ata1.00: cmd 61/00:20:00:e0:31/04:00:01:00:00/40 tag 4 ncq 524288 out
[125621.389518]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
[125621.389524] ata1.00: status: { DRDY }
[125621.389529] ata1.00: failed command: WRITE FPDMA QUEUED
[125621.389540] ata1.00: cmd 61/00:28:00:e8:31/04:00:01:00:00/40 tag 5 ncq 524288 out
[125621.389542]          res 40/00:10:00:d8:31/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
[125621.389548] ata1.00: status: { DRDY }
[125621.389556] ata1: hard resetting link
[125622.110242] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[125622.132038] ata1.00: configured for UDMA/133
[125622.146251] ata1: EH complete
[125953.220899] nilfs_sufile_do_cancel_free: segment 72 must be clean
[125953.220903] nilfs_sufile_do_cancel_free: segment 74 must be clean
[125953.228355] nilfs_sufile_do_free: segment 72 is already clean
[125953.228359] nilfs_sufile_do_free: segment 74 is already clean
[125953.743053] nilfs_sufile_do_cancel_free: segment 83 must be clean
[126019.570303] akonadi_agent_l[6079]: segfault at 48 ip 00007f3dc1726550 sp 00007fff955d3d98 error 4 in libQtDBus.so.4.8.3[7f3dc16f7000+79000]
[126019.598744] akonadi_agent_l[6087]: segfault at 48 ip 00007f6d81769550 sp 00007fff4e2b2a78 error 4 in libQtDBus.so.4.8.3[7f6d8173a000+79000]
[126201.739932] NILFS: bad btree node (blocknr=184875): level = 0, flags = 0x69, nchildren = 1807
[126201.739939] NILFS error (device sda4): nilfs_bmap_last_key: broken bmap (inode number=11533)
[126201.739941] 
[126201.740836] Remounting filesystem read-only
[126201.740841] NILFS warning (device sda4): nilfs_truncate_bmap: failed to truncate bmap (ino=11533, err=-5)
[126466.718675] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[126466.718685] NILFS warning: mounting fs with errors
[127711.989047] NILFS: bad btree node (blocknr=184891): level = 172, flags = 0x10, nchildren = 21699
[127711.989060] NILFS error (device sda4): nilfs_bmap_last_key: broken bmap (inode number=11536)
[127711.989061] 
[127711.989064] Remounting filesystem read-only
[127711.989067] NILFS warning (device sda4): nilfs_truncate_bmap: failed to truncate bmap (ino=11536, err=-5)
[128370.187840] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[128370.187850] NILFS warning: mounting fs with errors

--nextPart2321128.fn4Ct8ov0B--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
