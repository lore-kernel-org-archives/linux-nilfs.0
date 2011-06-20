From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Cleancache [2]
Date: Tue, 21 Jun 2011 03:16:55 +0900 (JST)
Message-ID: <20110621.031655.263948090.ryusuke@osrg.net>
References: <20110613.234048.21322431.ryusuke@osrg.net>
	<201106132004.41118.dexen.devries@gmail.com>
	<BANLkTikdQLrp3EMGq=BV83BQKKkN1Emdcw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikdQLrp3EMGq=BV83BQKKkN1Emdcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi dexen,
On Wed, 15 Jun 2011 01:17:28 +0900, Ryusuke Konishi wrote:
> 2011/6/14 dexen deVries wrote:
> > On Monday 13 June 2011 16:40:48 you wrote:
> >> Is it reproducible without zcache?
> >
> > I don't know how to check cleancache without zcache; cleancache itself doesn't
> > do anything unless it has some backend configured, and zcache is the only
> > backend I know of and can use.
> >
> >
> > To enable zcache you need to have one `zcache' argument in kernel's command
> > line.
> >
> >
> > There's an outstanding bug in zcache's build system:
> > http://code.google.com/p/compcache/issues/detail?id=91
> >
> > In short, core part of zcache may end up not being compiled at all ;-(
> >
> > To build zcache in 3.0-rc2, you need to hack it a bit with the attach'd patch.
> > Basically it renames the `zcache.c' to `zcache-core.c' and updates Makefile.
> >
> >
> > To verify zcache is enabled, look through dmesg for two lines like:
> >> zcache: cleancache enabled using kernel transcendent memory and compression
> > buddies
> >>zcache: created ephemeral tmem pool, id=0
> 
> Thanks a lot, dexen.
> 
> The oops has not been reproduced yet, but I could see
> /sys/kernel/mm/cleancache/* change.
> 
> I will try to catch the issue again this weekend.
> 
> Thanks,
> Ryusuke Konishi

I could find the cause of the oops - The following patch will fix it.

Anyhow, I noticed that cleancache may go wrong for nilfs2 since it
assumes each inode has only one pagecache but nilfs2 has actually two
pagecaches, data pages and btree node pages.

This can cause interference of pages between these two types of
caches.

I have no good idea to handle this problem.  Maybe, it needs some
change against the cleancache.


Also, I think this fix and your cleancache activation patch should be
sent to the next merge window instead of 3.0 because the current nilfs
does not enable cleancache so the issue never happens on the current
code base.


Regards,
Ryusuke Konishi

---
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: fix oops in nilfs_encode_fh after cleancache was enabled

Cleancache may call encode_fh() method even for inodes that never
appears on the namespace.  For the current nilfs, it is true of inodes
for metadata files and gccache.

For these inodes, nilfs_encode_bh should return an error code because
they are not exportable.  This fixes the issue and the kernel oops
caused by exporting such internal inodes.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/namei.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 546849b..e92800c 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -532,6 +532,9 @@ static int nilfs_encode_fh(struct dentry *dentry, __u32 *fh, int *lenp,
 	struct nilfs_root *root = NILFS_I(inode)->i_root;
 	int type;
 
+	if (!root || NILFS_MDT_INODE(inode->i_sb, inode->i_ino))
+		return -EINVAL; /* unexportable inode (needed by cleancache) */
+
 	if (*lenp < NILFS_FID_SIZE_NON_CONNECTABLE ||
 	    (connectable && *lenp < NILFS_FID_SIZE_CONNECTABLE))
 		return 255;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
