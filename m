From: bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org
Subject: Nilfs_cleanerd err=-17
Date: Tue, 19 Oct 2010 09:18:29 +1100
Message-ID: <1287440309.2849.5.camel@Nokia-N900-02-8>
Reply-To: bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-ID: <1287440309.2849.4.camel@Nokia-N900-02-8>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I've been using nilfs (built as a module for linux kernel version 2.6.28 on an arm device) for the last few days, however I started to run out of disk space, and hence noticed that nilfs_cleanerd wasn't running.

I tried running it manually and everytime I tried I got this error in dmesg:

 nilfs_ioctl_move_inode_block: conflicting data buffer: ino=62127, cno=784, offset=1115, blocknr=739299, vblocknr=477050
 NILFS: GC failed during preparation: cannot read source blocks: err=-17

and nilfs_cleanerd stopped running.

As the partition was rapidly approaching full, it meant the partition was unusable...

Is this a known error that can be dealt with?

For now I've just made a backup of the partition and created a new nilfs partition to copy all its data into to try and sidestep the issue.
 

This issue was with nilfs(-utils) version 2.0.20 built locally only a few days ago.
Its running on a Nokia n900 if that makes a difference.

This issue also occurred if I tried to run nilfs_cleanerd on my x86 laptop on the same partition as well.

Is this a known issue at all? (I tried searching for it but didn't find
anything useful)

And is there anything I can try and do to avoid it in the future? Or to help deal with it?

Cheers

Bryce

--
Sent from my Nokia N900 using Nokia Messaging

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
