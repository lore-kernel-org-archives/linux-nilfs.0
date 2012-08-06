From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 not garbage collecting
Date: Mon, 06 Aug 2012 09:54:38 +0400
Message-ID: <1344232478.1912.9.camel@slavad-ubuntu-11>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com>
	 <CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ@mail.gmail.com>
	 <F7DFCB7F-9015-4051-9A60-5056EAB81E4D@dubeyko.com>
	 <CANku=ghdeeSLP6QsJh9jvs5fJwEYuTTV7w8iigE1nZoT74NYgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=9mliBvKNaRkskruWNnsIOEsggx6if2jzitK5V5+GOx4=;
	b=G9g2iq9MvHL7As/SP3SXOmPXvl8EIHN4BOEHKcKN0zbMTG5E3gavH66ISdxBCkb5sL5AolJN64uFrGzR+CD2MKMbkE1WFSe2/62bSphnmATwjjGRAfQ857SPcaImbVGw;
In-Reply-To: <CANku=ghdeeSLP6QsJh9jvs5fJwEYuTTV7w8iigE1nZoT74NYgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Paolo,

On Sun, 2012-08-05 at 16:42 +0200, Paolo Giangrandi wrote:
> 1. Usually I'm mounting it with default options: `mount /dev/sda2 /mnt/sda2`.
> 
> 2. At the moment the configuration is like this:
> protection_period       10
> min_clean_segments      0%
> max_clean_segments      20%
> clean_check_interval    10
> selection_policy        timestamp       # timestamp in ascend order
> nsegments_per_clean     2
> mc_nsegments_per_clean  4
> cleaning_interval       5
> mc_cleaning_interval    1
> retry_interval          60
> use_mmap
> log_priority            debug
> 
> Yesterday night I played a lot with those options though.
> 
> 3. Upon mounting the filesystem, `dmesg` only shows:
> [16171.516443] segctord starting. Construction interval = 5 seconds,
> CP frequency < 30 seconds
> 
> Files in /var/log doesn't seem to contain much information either.
> Upon mounting:
> Aug  5 14:32:39 localhost kernel: [16234.023168] segctord starting.
> Construction interval = 5 seconds, CP frequency < 30 seconds
> Aug  5 14:32:39 localhost nilfs_cleanerd[1630]: start
> Aug  5 14:32:39 localhost nilfs_cleanerd[1630]: ncleansegs = 48
> Aug  5 14:32:39 localhost nilfs_cleanerd[1630]: 0 segment selected to be cleaned
> Aug  5 14:32:39 localhost nilfs_cleanerd[1630]: wait 10.000000
> 
> Then every 10 seconds (or when I call the garbage collector using
> `nilfs-clean`):
> Aug  5 14:35:28 localhost nilfs_cleanerd[1630]: wake up
> Aug  5 14:35:28 localhost nilfs_cleanerd[1630]: wait 10.000000
> 
> 4. # ps ax | grep -i nilfs
>  1630 ?        Ss     0:00 /sbin/nilfs_cleanerd -n /dev/sda2 /mnt/sda2
> 
> 5. # cat /proc/partitions
> major minor  #blocks  name
> 
>    8        0    7880544 sda
>    8        1      32098 sda1
>    8        2    7847752 sda2
>    8       16    1034879 sdb
>    8       17     393216 sdb1
>    7        0     100176 loop0
>    7        1     675840 loop1
>    7        2     675840 loop2
>    7        3      34436 loop3
>    7        4      94208 loop4
>    7        5      94208 loop5
>    7        6      61736 loop6
>    7        7     465920 loop7
>  254        0     675840 dm-0
>  254        1      94208 dm-1
>    7        8     465920 loop8
>  254        2     465920 dm-2
> 
> 6. # df -h
> Filesystem                        Size  Used Avail Use% Mounted on
> rootfs                            658M  318M  341M  49% /
> dev                               492M     0  492M   0% /dev
> run                               499M   16M  484M   4% /run
> /dev/sdb                          384M  384M     0 100% /run/archiso/bootmnt
> cowspace                          749M  8.4M  740M   2% /run/archiso/cowspace
> /dev/loop0                         98M   98M     0 100%
> /run/archiso/sfs/root-image
> /dev/mapper/arch_root-image       658M  318M  341M  49% /
> /dev/loop3                         34M   34M     0 100%
> /run/archiso/sfs/usr-lib-modules
> /dev/mapper/arch_usr-lib-modules   91M   41M   50M  46% /usr/lib/modules
> /dev/loop6                         61M   61M     0 100%
> /run/archiso/sfs/usr-share
> /dev/mapper/arch_usr-share        452M  184M  269M  41% /usr/share
> shm                               499M  4.0K  499M   1% /dev/shm
> tmpfs                             499M     0  499M   0% /tmp
> /dev/sda2                         7.5G  7.2G     0 100% /mnt/sda2
> 

Could you share full output of mount utility? I feel that I haven't full
picture without this output.

Moreover, it needs to more details about nilfs_cleanerd activity. Could
you try to kill started by default nilfs_cleanerd and try to start
nilfs_cleanerd manually with strace utility? Then it will be very
interesting to see output of strace. 

With the best regards,
Vyacheslav Dubeyko.


> The running system is an USB Live of ArchLinux 32bit. The nilfs
> programs installed are the ones shipped with the package nilfs-utils
> 2.1.4: http://www.archlinux.org/packages/core/i686/nilfs-utils/
> 
> On Sun, Aug 5, 2012 at 3:54 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> > Hi Paolo,
> >
> > On Aug 5, 2012, at 3:00 PM, Paolo Giangrandi wrote:
> >
> >> Hello,
> >>
> >> I'm using NILFS2 as the root filesystem of an ArchLinux on my EeePC
> >> 900A. The filesystem has been created last November.
> >> At the moment there's no more space left, `lscp` shows that there are
> >> 2648 checkpoints, but nilfs_cleanerd is in idle.
> >> I tried to tweak nilfs_cleanerd configuration, but couldn't achieve anything.
> >>
> >> Is it possible to know why nilfs_cleanerd isn't collecting the
> >> checkpoints, or force it to collect them?
> >
> > Could you share more details about your issue?
> >
> > It is interested to know:
> > 1. mount output.
> > 2. nilfs_cleanerd configuration.
> > 3. system log content related to NILFS2 or nilfs_cleanerd.
> > 4. ps ax output.
> > 5. cat /proc/partitions.
> > 6. df -h
> >
> > I think that these info can be starting point for analysis of your issue.
> >
> > With the best regards,
> > Vyacheslav Dubeyko.
> >
> >>
> >> Thanks,
> >> Paolo
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
