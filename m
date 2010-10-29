From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Nilfs_cleanerd err=-17
Date: Fri, 29 Oct 2010 15:51:51 +0900 (JST)
Message-ID: <20101029.155151.179792055.ryusuke@osrg.net>
References: <1287440309.2849.5.camel@Nokia-N900-02-8>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287440309.2849.5.camel@Nokia-N900-02-8>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 19 Oct 2010 09:18:29 +1100, bryce wrote:
> Hi,
> 
> I've been using nilfs (built as a module for linux kernel version 2.6.28 on an arm device) for the last few days, however I started to run out of disk space, and hence noticed that nilfs_cleanerd wasn't running.
> 
> I tried running it manually and everytime I tried I got this error in dmesg:
> 
>  nilfs_ioctl_move_inode_block: conflicting data buffer: ino=62127, cno=784, offset=1115, blocknr=739299, vblocknr=477050
>  NILFS: GC failed during preparation: cannot read source blocks: err=-17
> 
> and nilfs_cleanerd stopped running.
> 
> As the partition was rapidly approaching full, it meant the partition was unusable...
> 
> Is this a known error that can be dealt with?
> 
> For now I've just made a backup of the partition and created a new nilfs partition to copy all its data into to try and sidestep the issue.

Sorry for my late reply.  I was so busy this month, and couldn't look
into the problem.

According to your log, some sort of inconsistent state seems to happen
in the log that GC tried to reclaim.

Could you try to get the detail information by changing
/etc/nilfs_cleanerd.conf as follows?

 -log_priority		info
 +log_priority		debug

After reloading the conf file by doing umount/mount or sending a HUP
signal to the GC process, nilfs_cleanerd would print messages like
follows into /var/log/messages or /var/log/syslog:

Oct 29 15:31:04 host nilfs_cleanerd[7952]: segment 1869 cleaned
Oct 29 15:31:04 host nilfs_cleanerd[7952]: segment 1870 cleaned
Oct 29 15:31:04 host nilfs_cleanerd[7952]: adjust interval
Oct 29 15:31:04 host nilfs_cleanerd[7952]: ncleansegs = 9498
Oct 29 15:31:04 host nilfs_cleanerd[7952]: 2 segments selected to be cleaned
Oct 29 15:31:04 host nilfs_cleanerd[7952]: wait 4.998359000

If you succeeded to get the segment numbers causing the error, try
"dumpseg" command to get log header information.

# for segnum in 1869 1870; do dumpseg /dev/xxx $segnum; done

 where "/dev/xxx" should be replaced with your device and
 "1869 1870" are the segment numbers in question.

> This issue was with nilfs(-utils) version 2.0.20 built locally only a few days ago.
> Its running on a Nokia n900 if that makes a difference.
> 
> This issue also occurred if I tried to run nilfs_cleanerd on my x86 laptop on the same partition as well.
> 
> Is this a known issue at all? (I tried searching for it but didn't find
> anything useful)

Seems to be a new issue.  Some more information is needed to narrow
down the problem.

Thanks in advance,
Ryusuke Konishi

> And is there anything I can try and do to avoid it in the future? Or to help deal with it?
> 
> Cheers
> 
> Bryce
> 
> --
> Sent from my Nokia N900 using Nokia Messaging
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
