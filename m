From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Tue, 13 Nov 2012 17:41:41 +0400
Message-ID: <1352814101.2443.9.camel@slavad-ubuntu>
References: <50A159BC.9060600@li.ru> <1352787218.2042.9.camel@slavad-ubuntu>
	 <50A24564.7000704@li.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=qBKonxvv6mTlBY68yWp8v5XcPMrNAebq5LVPYciNcjo=;
	b=fnTm/CiR/jg8Tb62K+18+bRgPHJkqCoBKJ1ckYcRItCPz/f5uh9NFxEi7J1iIy/9U5vao4yieE17EblxMZaS5KzfSS3XFmk8RUFAoAAi/accFJr9cDEa5XC2zuBHZ1os;
In-Reply-To: <50A24564.7000704-3TRaYzfGuuI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 2012-11-13 at 17:04 +0400, fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org wrote:
> > From one point of view, you
> > said that filesystem generates I/O activity but as a result you haven't
> > disk activity.
> Yes, iotop shows activity on flush process about 5-15 GB/S - but my HDD 
> does not write anything at this time.
> 
> 
>  > Does it means that you create any files but you haven't
> > it on partition after umount?
> 
> No, there is no problems with data loss or corruption. High IO activity 
> on flush process happens when I do not modify anything. Most often it 
> happens in 1-2 minutes after OS boot. I found, that frequency of 
> described behaviour somehow related to my access to files on that 
> filesystem: when I read or, write files, the frequency of described 
> behaviour increasing, but when system is idle - flush process stops it's 
> wierd IO activity after some time.
> 
> > Could you share more details about your configuration and situation?
> Sorry, I don't have access to my PC right now, but i've captured "ps ax" 
> command output when flush processes are working. Also, I'll try to 
> reproduce this strange behavior on quemu virtual machine. Maybe there is 
> something wrong with my configuration...
> 
> this processes are related to devices, that run nilfs2 filesystem:
> 474  ?        R      0:09 [flush-253:0]
> 2388 ?        R      1:30 [flush-253:5]
> 
> 
>    PID TTY      STAT   TIME COMMAND
>      1 ?        Ss     0:01 /sbin/init
>      2 ?        S      0:00 [kthreadd]
>      3 ?        S      0:00 [ksoftirqd/0]
>      4 ?        S      0:00 [kworker/0:0]
>      5 ?        S<     0:00 [kworker/0:0H]
>      6 ?        S      0:00 [kworker/u:0]
>      7 ?        S<     0:00 [kworker/u:0H]
>      8 ?        S      0:00 [migration/0]
>      9 ?        S      0:00 [rcuc/0]
>     10 ?        S      0:00 [rcun/0]
>     11 ?        S      0:00 [rcub/0]
>     12 ?        S      0:00 [rcun/1]
>     13 ?        S      0:00 [rcub/1]
>     14 ?        S      0:00 [watchdog/0]
>     15 ?        S      0:00 [migration/1]
>     16 ?        S      0:00 [kworker/1:0]
>     17 ?        S<     0:00 [kworker/1:0H]
>     18 ?        S      0:00 [rcuc/1]
>     19 ?        S      0:00 [ksoftirqd/1]
>     20 ?        S      0:00 [watchdog/1]
>     21 ?        S      0:00 [migration/2]
>     22 ?        S      0:00 [kworker/2:0]
>     23 ?        S<     0:00 [kworker/2:0H]
>     24 ?        S      0:00 [rcuc/2]
>     25 ?        S      0:00 [ksoftirqd/2]
>     26 ?        S      0:00 [watchdog/2]
>     27 ?        S      0:00 [migration/3]
>     28 ?        S      0:00 [kworker/3:0]
>     29 ?        S<     0:00 [kworker/3:0H]
>     30 ?        S      0:00 [rcuc/3]
>     31 ?        S      0:00 [ksoftirqd/3]
>     32 ?        S      0:00 [watchdog/3]
>     33 ?        S<     0:00 [cpuset]
>     34 ?        S<     0:00 [khelper]
>     35 ?        S      0:00 [kdevtmpfs]
>     36 ?        S<     0:00 [netns]
>     37 ?        S      0:00 [bdi-default]
>     38 ?        S<     0:00 [kintegrityd]
>     39 ?        S<     0:00 [kblockd]
>     40 ?        S<     0:00 [ata_sff]
>     41 ?        S      0:00 [khubd]
>     42 ?        S<     0:00 [md]
>     43 ?        S      0:00 [kworker/0:1]
>     44 ?        S      0:00 [kworker/2:1]
>     45 ?        S      0:00 [khungtaskd]
>     46 ?        S      0:00 [kswapd0]
>     47 ?        SN     0:00 [ksmd]
>     48 ?        SN     0:00 [khugepaged]
>     49 ?        S      0:00 [fsnotify_mark]
>     50 ?        S<     0:00 [crypto]
>     55 ?        S<     0:00 [kthrotld]
>     56 ?        S      0:00 [scsi_eh_0]
>     57 ?        S      0:00 [scsi_eh_1]
>     58 ?        S      0:00 [scsi_eh_2]
>     59 ?        S      0:00 [scsi_eh_3]
>     60 ?        S      0:00 [scsi_eh_4]
>     61 ?        S      0:00 [scsi_eh_5]
>     62 ?        S      0:00 [kworker/u:1]
>     63 ?        S      0:00 [kworker/u:2]
>     64 ?        S      0:00 [kworker/u:3]
>     65 ?        S      0:00 [kworker/u:4]
>     66 ?        S      0:00 [kworker/u:5]
>     67 ?        S      0:00 [kworker/u:6]
>     68 ?        S<     0:00 [kpsmoused]
>     69 ?        S<     0:00 [deferwq]
>     70 ?        S      0:00 [kworker/u:7]
>     71 ?        S      0:00 [kworker/3:1]
>     72 ?        S      0:00 [kworker/u:8]
>     73 ?        S<     0:00 [kworker/0:1H]
>     76 ?        S      0:00 [kworker/1:1]
>    106 ?        S      0:00 [scsi_eh_6]
>    107 ?        S      0:00 [scsi_eh_7]
>    130 ?        S<     0:00 [xfsalloc]
>    131 ?        S<     0:00 [xfs_mru_cache]
>    132 ?        S<     0:00 [xfslogd]
>    147 ?        S<     0:00 [kmpath_rdacd]
>    303 ?        S<     0:00 [kworker/2:1H]
>    306 ?        S      0:00 [md0_raid1]
>    405 ?        S<     0:00 [kdmflush]
>    406 ?        S<     0:00 [kcryptd_io]
>    409 ?        S<     0:00 [kcryptd]
>    437 ?        S      0:00 [segctord]
>    438 ?        S<     0:00 [kworker/3:1H]
>    447 ?        S      0:01 [kworker/0:2]
>    474 ?        R      0:09 [flush-253:0]
>    488 ?        S      0:00 [kauditd]
>    489 ?        Ss     0:00 /lib/systemd/systemd-stdout-syslog-bridge
>    490 ?        S      0:00 [kworker/2:2]
>    497 ?        Ss     0:00 /sbin/udevd
>    512 ?        S      0:00 [kworker/3:2]
>    520 ?        S<     0:00 [kworker/1:1H]
>    532 ?        S      0:00 [kworker/1:2]
>    716 ?        S<     0:00 [kvm-irqfd-clean]
>    733 ?        S      0:00 [irq/42-mei]
>    751 ?        S<     0:00 [hd-audio0]
>    860 ?        S      0:00 [md200_raid1]
>    865 ?        S      0:00 [md250_raid1]
>    878 ?        S<     0:00 [kdmflush]
>    879 ?        S<     0:00 [kcryptd_io]
>    880 ?        S<     0:00 [kcryptd]
>    882 ?        S<     0:00 [kdmflush]
>    885 ?        S<     0:00 [kcryptd_io]
>    886 ?        S<     0:00 [kcryptd]
>    931 ?        S<     0:00 [kdmflush]
>    933 ?        S<     0:00 [kcryptd_io]
>    934 ?        S<     0:00 [kcryptd]
>    938 ?        S<     0:00 [kdmflush]
>    939 ?        S<     0:00 [kcryptd_io]
>    940 ?        S<     0:00 [kcryptd]
>    952 ?        S<     0:00 [xfs-data/dm-4]
>    953 ?        S<     0:00 [xfs-conv/dm-4]
>    954 ?        S<     0:00 [xfs-cil/dm-4]
>    955 ?        S      0:00 [xfsaild/dm-4]
>    972 ?        S<     0:00 [kdmflush]
>    973 ?        S<     0:00 [kcryptd_io]
>    974 ?        S<     0:00 [kcryptd]
>    982 ?        S<     0:00 [xfs-data/dm-3]
>    983 ?        S<     0:00 [xfs-conv/dm-3]
>    984 ?        S<     0:00 [xfs-cil/dm-3]
>    985 ?        S      0:00 [xfsaild/dm-3]
>   1010 ?        S      0:00 [kjournald]
>   1019 ?        S      0:00 [segctord]
>   1020 ?        Ss     0:00 /sbin/nilfs_cleanerd -n /dev/mapper/raid_new 
> /mnt/raid

[snip]

>   1237 ?        Ss     0:00 /sbin/nilfs_cleanerd -c 
> /etc/nilfs_cleanerd_rootfs.conf /dev/mapper/system


I can see that you have two running nilfs_cleanerd deamons. Second one
(1237) is started with special configuration file. Moreover, I
understand that /dev/mapper/raid_new device is mounted to /mnt/raid. But
what is /dev/mapper/system device? And where did it mounted? What
content has /etc/nilfs_cleanerd_rootfs.conf? What difference
between /dev/mapper/raid_new and /dev/mapper/system?

With the best regards,
Vyacheslav Dubeyko.

>   1241 ?        S      0:00 /usr/bin/kdm
>   1243 ?        S      0:00 /usr/sbin/modem-manager
>   1261 ?        Ss     0:00 /usr/sbin/cron -n
>   1288 ?        Ss     0:00 /usr/sbin/cupsd -C /etc/cups/cupsd.conf
>   1323 ?        Ss     0:00 /usr/sbin/mcelog --daemon --pidfile 
> /var/run/mcelog.pid
>   1357 tty1     Ss+    0:00 /sbin/agetty tty1 38400
>   1434 ?        S      0:00 /sbin/dhclient -d -4 -sf 
> /usr/lib/nm-dhcp-client.action -pf /var/run/dhclient-eth0.pid -lf 
> /var/lib/dhcp/dhclient-aa5261fd-d435-41e1-ae57-64a820a9b479-eth0.lease 
> -cf /var/run/nm-dhclie
>   1497 tty7     Ss+    0:01 /usr/bin/Xorg -br :0 vt7 -nolisten tcp -auth 
> /var/lib/xdm/authdir/authfiles/A:0-tVZebb
>   1498 ?        Ssl    0:00 /usr/lib/vmware/bin/vmware-vmblock-fuse -o 
> subtype=vmware-vmblock,default_permissions,allow_other /var/run/vmblock-fuse
>   1509 ?        S      0:00 /sbin/udevd
>   1511 ?        S      0:00 /sbin/udevd
>   1552 ?        Ss     0:00 /usr/sbin/vmware-authdlauncher
>   1779 ?        S      0:00 -:0
>   1830 ?        Ssl    0:00 /usr/sbin/console-kit-daemon --no-daemon
>   1906 ?        Ss     0:00 /bin/sh /usr/bin/startkde
>   1993 ?        Ss     0:00 /usr/bin/gpg-agent --sh --daemon 
> --write-env-file /home/user/.gnupg/agent.info /usr/bin/ssh-agent 
> /etc/X11/xinit/xinitrc
>   1994 ?        Ss     0:00 /usr/bin/ssh-agent /etc/X11/xinit/xinitrc
>   2034 ?        S      0:00 dbus-launch --sh-syntax --exit-with-session
>   2035 ?        Ss     0:00 /bin/dbus-daemon --fork --print-pid 5 
> --print-address 7 --session
>   2042 ?        S      0:00 /usr/lib64/kde4/libexec/start_kdeinit 
> +kcminit_startup
>   2043 ?        Ss     0:00 kdeinit4: kdeinit4 Running...
>   2044 ?        S      0:00 kdeinit4: klauncher [kdeinit] --fd=9
>   2046 ?        Sl     0:00 kdeinit4: kded4 [kdeinit]
>   2053 ?        S      0:00 kdeinit4: kglobalaccel [kdeinit]
>   2057 ?        S      0:00 /usr/bin/kactivitymanagerd
>   2059 ?        Sl     0:00 /usr/lib/upower/upowerd
>   2062 ?        S      0:00 kwrapper4 ksmserver
>   2063 ?        Sl     0:00 kdeinit4: ksmserver [kdeinit]
>   2067 ?        S      0:00 kwin
>   2126 ?        Sl     0:00 /usr/bin/knotify4
>   2138 ?        Sl     0:00 /usr/lib/udisks/udisks-daemon
>   2140 ?        S      0:00 udisks-daemon: not polling any devices
>   2147 ?        Sl     0:03 kdeinit4: plasma-desktop [kdeinit]
>   2151 ?        S      0:00 /usr/bin/kuiserver
>   2153 ?        S      0:00 kdeinit4: kio_desktop [kdeinit] desktop 
> local:/tmp/ksocket-war
>   2159 ?        S      0:00 kdeinit4: kio_file [kdeinit] file 
> local:/tmp/ksocket-user
>   2171 ?        Sl     0:00 kdeinit4: krunner [kdeinit]
>   2196 ?        Sl     0:00 /usr/bin/pulseaudio --start --log-target=syslog
>   2198 ?        SNl    0:00 /usr/lib/rtkit/rtkit-daemon
>   2204 ?        Sl     0:00 /usr/lib/tracker-store
>   2205 ?        Sl     0:00 
> /usr/lib64/kde4/libexec/polkit-kde-authentication-agent-1
>   2207 ?        Sl     0:00 kdeinit4: kmix [kdeinit]
>   2213 ?        S      0:00 kdeinit4: klipper [kdeinit]
>   2216 ?        S      0:00 /usr/lib/pulse/gconf-helper
>   2218 ?        S      0:00 /usr/lib/GConf/2/gconfd-2
>   2223 ?        Ssl    0:03 /home/user/.dropbox-dist/dropbox
>   2240 ?        S      0:00 /usr/lib/gvfs/gvfsd
>   2245 ?        Ssl    0:00 /usr/lib/gvfs//gvfs-fuse-daemon /home/user/.gvfs
>   2295 ?        Rl     0:01 kdeinit4: konsole [kdeinit]
>   2298 pts/1    Ss     0:00 /bin/bash
>   2337 ?        Sl     0:00 kdeinit4: kio_trash [kdeinit] trash 
> local:/tmp/ksocket-user
>   2367 ?        Ssl    0:00 mpd
>   2388 ?        R      1:30 [flush-253:5]
>   2437 pts/1    R+     0:00 ps ax
> 
> 
> 
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
