From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 0/9] exprimental API to extract changes between two
 checkpoints
Date: Wed, 18 May 2011 18:16:12 +0900 (JST)
Message-ID: <20110518.181612.220056360.ryusuke@osrg.net>
References: <1305536722-1311-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<87ei3wcsa9.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87ei3wcsa9.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 18 May 2011 17:43:58 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> At Mon, 16 May 2011 18:05:13 +0900,
> Ryusuke Konishi wrote:
> > 
> > This is an experimental patchset which adds new ioctl commands for
> > finding differences between two checkpoints (snapshots) efficiently.
> > 
> > One of the commands is NILFS_IOCTL_COMPARE_CHECKPOINTS and another is
> > NILFS_IOCTL_INO_LOOKUP.
> > 
> > The NILFS_IOCTL_COMPARE_CHECKPOINT command enumerates changed inodes
> > between two checkpoints.  It compares two versions of b-trees managing
> > blocks of "ifile" instead of traversing namespace and comparing all
> > pairs of inodes.
> > 
> > It gathers up inode numbers of changed inodes, but it's not efficient
> > to find a pathname of inode at userspace from its inode number.  So,
> > the NILFS_IOCTL_INO_LOOKUP command is included to make it faster and
> > easier -- it makes up a pathname of an inode in the past filesystem
> > tree searching directories bottom up.
> > 
> > 
> > With this api, users or tools can know which inodes were changed,
> > created, or deleted and how they were modified.  This is intended to
> > be used for online backup, realtime remote replication, or quickly
> > rebuilding search index against numerous versions of a filesystem
> > provided by nilfs.  Kernel already has some notification mechanisms
> > for these purposes, but they don't suit for extract changes later on.
> > 
> > 
> > A utility program for examining these ioctl commands is available on
> > "diff" branch of the following git tree:
> > 
> >   http://git.nilfs.org/nilfs2-utils-devel.git
> 
> I can't find "diff" branch from the repository nor retrieve the branch.
> Is something wrong with my local or the remote repository?

Thank you for letting me know this issue.

git-fsck seems to have fixed it.

Can you please check on it ?


Ryusuke Konishi

 
> $ git remote -v
> devel				    http://git.nilfs.org/nilfs2-utils-devel.git
> origin				    http://git.nilfs.org/nilfs2-utils.git
> $ git branch -r
>   devel/fixes
>   devel/fsck0
>   devel/fsck0-2010-05-16
>   devel/master
>   devel/next
>   origin/HEAD
>   origin/master
> $ git fetch http://git.nilfs.org/nilfs2-utils-devel.git diff:diff
> fatal: Couldn't find remote ref diff
> 
> 
> thanks,
> 
> regards
> 
> > It experimentally adds "nilfs-diff" program to nilfs-utils.  The usage
> > of this program is as follows:
> > 
> > 
> >   # nilfs-diff [option] [device] cno1..cno2
> > 
> > "nilfs-diff" displays appended files or directories as below:
> > 
> >    + /aaa/bbb
> >    + /aaa/bbb/ccc
> > 
> > Deleted files are displayed like:
> > 
> >    - /aaa/xxx
> > 
> > Modified or moved files are:
> > 
> >    M /aaa/bbb/file-000.txt
> >    R /aaa/bbb/file-123.txt -> /aaa/file-123.txt
> > 
> > 
> > Unfortunately, the NILFS_IOCTL_INO_LOOKUP command needs disk format
> > change since it has to keep parent inode numbers for each on-disk
> > inode.
> > 
> > This patchset uses an unused pad field in disk inode, so this feature
> > is only available for new filesystems created with updated mkfs.nilfs2
> > tool.
> > 
> > In addition, this patchset has a few important limitations and does
> > not suit for practical use.  First, hard links are not supported (only
> > one parent inode number is recorded in an inode).  And, inode number
> > of parent inodes are truncated to 32-bit width from the original
> > 64-bit value when being stored to disk.
> > 
> > So, this is very experimetal, and I have no plan to send them upstream
> > at this moment.
> > 
> > To make it practical, parent inode number should be recorded in disk
> > more nicely.  I guess a disk format change would be necessary for
> > that.
> > 
> > If anyone have comments, please let me know.
> > 
> > 
> > Thanks,
> > Ryusuke Konishi
> > --
> > Ryusuke Konishi (9):
> >       nilfs2: add separable lookup routines to direct/btree mappings
> >       nilfs2: add comparison function of two block mappings
> >       nilfs2: add helper functions to get type of blocks on ifile
> >       nilfs2: add ifile method to find and get modified inodes
> >       nilfs2: add ioctl to compare two checkpoints and get their changes
> >       nilfs2: store parent inode number in disk inode
> >       nilfs2: add routine to find directory entry from inode number
> >       nilfs2: add pathname lookup routine from inode number
> >       nilfs2: add ioctl to lookup pathname of inode
> > 
> >  fs/nilfs2/alloc.c         |   35 ++++++++-
> >  fs/nilfs2/alloc.h         |   10 +++
> >  fs/nilfs2/bmap.c          |  154 +++++++++++++++++++++++++++++++++++++
> >  fs/nilfs2/bmap.h          |   20 +++++
> >  fs/nilfs2/btree.c         |  134 ++++++++++++++++++++++++++++++++
> >  fs/nilfs2/dir.c           |   60 +++++++++++++++
> >  fs/nilfs2/direct.c        |   49 ++++++++++++
> >  fs/nilfs2/ifile.c         |  184 +++++++++++++++++++++++++++++++++++++++++++++
> >  fs/nilfs2/ifile.h         |   20 +++++
> >  fs/nilfs2/inode.c         |  131 +++++++++++++++++++++++++++++++-
> >  fs/nilfs2/ioctl.c         |  135 +++++++++++++++++++++++++++++++++
> >  fs/nilfs2/namei.c         |   97 ++++++++++++++++++++++++
> >  fs/nilfs2/nilfs.h         |   14 ++++
> >  fs/nilfs2/super.c         |   49 ++++++++++++
> >  include/linux/nilfs2_fs.h |   64 +++++++++++++++-
> >  15 files changed, 1148 insertions(+), 8 deletions(-)
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> > 
> 
> 
> -- 
> Jiro SEKIBA <jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
