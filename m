From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Recommended partition scheme for nilfs2
Date: Wed, 06 Jul 2011 13:35:58 +0900 (JST)
Message-ID: <20110706.133558.186520806.ryusuke@osrg.net>
References: <4c09eb01174eecf704c751d7bf1b4bb2.squirrel@linuxbsdos.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4c09eb01174eecf704c751d7bf1b4bb2.squirrel-aEpbUQpJQqXlKS8GlytQkw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: finid-aEpbUQpJQqXlKS8GlytQkw@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 4 Jul 2011 13:28:39 -0600, "LinuxBSDos.com" wrote:
> 
> Hi,
> 
> A couple of Linux distributions now have nilfs2 as an optional file system
> during installation and I just want to find out what the minimum number of
> partitions required for a nilfs2-based installation is.
> 
> Is it necessary to create separate partitions for the major file systems,
> or does nilfs2 require just one root file system directory? Is /home on a
> separate partition necessary?

nilfs2 can be used as a root filesystem and it is bootable from recent
grub2.  I'm using nilfs2 for the root filesystem on my ubuntu-natty
laptop.

One restriction is that nilfs2 does not support swap file, so users
need at least two partitions, swap and root.

/home is not necessary to be a separate partition.

> Lastly, can I encrypt a nilfs2 partition?

nilfs2 itself does not support encryption.  Instead, it can be used
together with ecryptfs or dm-crypt.

Thanks,
Ryusuke Konishi

> Thanks,
> 
> --
> Fini D.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
