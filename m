From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cleanerd not started for mount with relative pathname
Date: Fri, 04 Mar 2011 02:32:04 +0900 (JST)
Message-ID: <20110304.023204.179943022.ryusuke@osrg.net>
References: <201103021812.31515.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103021812.31515.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2 Mar 2011 18:12:31 +0100, dexen deVries wrote:
> Hi,
> 
> 
> when testing my other patches, the following came up:
> 
> with absolute pathname:
> # mount /dev/sdb2 /mnt/x
> # ps ax | grep [n]ilfs_cleanerd
> 30408 ?        Ss     0:00 /sbin/nilfs_cleanerd -n /dev/sdb2 /mnt/x
> 
> 
> with relative mountpoint pathname:
> # umount /mnt/x
> # cd /mnt
> # mount /dev/sdb2 x
> # ps ax | grep [n]ilfs_cleanerd
> ((no such process))
> 
> with relative device pathname:
> # umount /mnt/x
> # cd /dev
> # mount sdb2 /mnt/x
> # ps ax | grep [n]ilfs_cleanerd
> ((no such process))
> 
> This is due to chdir(ROOTDIR) in daemonize(); currently daemonize is always 
> called with nochdir == 0. Should I hardcode it to nochdir == 1 or canonicalize 
> the `dev' and `dir' arguments with myrealpath()?

It sounds like cleanerd needs a fix.
I'll take a look and answer to you tomorrow.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
