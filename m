From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [RFC] simplifying the "is it mounted" checks for nilfs2
Date: Sat, 6 Jul 2013 00:33:35 +0100
Message-ID: <20130705233335.GV4165@ZenIV.linux.org.uk>
References: <20130705220309.GU4165@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130705220309.GU4165-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 05, 2013 at 11:03:09PM +0100, Al Viro wrote:
> Do you see any problems with just giving nilfs ->drop_inode() instance
> like this:
> int nilfs2_drop_inode(struct inode *inode)
> {
> 	if (unlikely(inode->i_ino == NILFS_ROOT_INO))
> 		return true;
> 	return generic_drop_inode(inode);
> }
> Then nilfs_root will live exactly until we unmount the damn thing, giving us

... except that it won't be enough ;-/  Nothing to kick dentries out
on such ummount of a secondary.  Oh, well...  I still doubt that
have_submounts() makes any sense there, but...
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
