From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [RFC] simplifying the "is it mounted" checks for nilfs2
Date: Sat, 06 Jul 2013 17:56:21 +0900 (JST)
Message-ID: <20130706.175621.55858015.konishi.ryusuke@lab.ntt.co.jp>
References: <20130705220309.GU4165@ZenIV.linux.org.uk>
	<20130705233335.GV4165@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130705233335.GV4165@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sat, 6 Jul 2013 00:33:35 +0100, Al Viro wrote:
> On Fri, Jul 05, 2013 at 11:03:09PM +0100, Al Viro wrote:
>> Do you see any problems with just giving nilfs ->drop_inode() instance
>> like this:
>> int nilfs2_drop_inode(struct inode *inode)
>> {
>> 	if (unlikely(inode->i_ino == NILFS_ROOT_INO))
>> 		return true;
>> 	return generic_drop_inode(inode);
>> }
>> Then nilfs_root will live exactly until we unmount the damn thing, giving us
> 
> ... except that it won't be enough ;-/  Nothing to kick dentries out
> on such ummount of a secondary.  Oh, well...  I still doubt that
> have_submounts() makes any sense there, but...

Yes, the test with nilfs_lookup_root() is not enough because the root
dentry of a secondary mount is not shrunk when its mountpoint is
unmounted.

Thus the current nilfs_checkpoint_is_mounted() implementation needs to
test whether the root dentry of the specified checkpoint is busy
(mounted) or not.

Is there any good way to shrink dentries of such subvolumes at the
time of their unmount ?


Regards,
Ryusuke Konishi
