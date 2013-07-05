From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: [RFC] simplifying the "is it mounted" checks for nilfs2
Date: Fri, 5 Jul 2013 23:03:09 +0100
Message-ID: <20130705220309.GU4165@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Do you see any problems with just giving nilfs ->drop_inode() instance
like this:
int nilfs2_drop_inode(struct inode *inode)
{
	if (unlikely(inode->i_ino == NILFS_ROOT_INO))
		return true;
	return generic_drop_inode(inode);
}
Then nilfs_root will live exactly until we unmount the damn thing, giving us
int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
{
        struct the_nilfs *nilfs = sb->s_fs_info;

        if (cno < 0 || cno > nilfs->ns_cno)
                return false;

        if (cno >= nilfs_last_cno(nilfs))
                return true;    /* protect recent checkpoints */

        return nilfs_lookup_root(nilfs, cno) != NULL;
}
while the logics in nilfs_mount becoming simply
	busy = d_count(s->s_root) > 1;
and we don't need to bother with nilfs_try_to_shrink_tree() at all.

I might be missing something, but it looks like that would work...
Comments?
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
