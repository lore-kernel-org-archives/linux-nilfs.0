From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_sufile_do_cancel_free: segment 0 must be clean
Date: Mon, 22 Mar 2010 22:48:07 +0900 (JST)
Message-ID: <20100322.224807.267714142.ryusuke@osrg.net>
References: <4BA54677.3090902@abeckmann.de>
	<20100322.150420.179960388.ryusuke@osrg.net>
	<20100322.153446.180039371.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100322.153446.180039371.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: debian-qVUaBahCJu5n68oJJulU0Q@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Mon, 22 Mar 2010 15:34:46 +0900 (JST), Ryusuke Konishi wrote:
> On Mon, 22 Mar 2010 15:04:20 +0900 (JST), Ryusuke Konishi wrote:
> > Hi,
> > On Sat, 20 Mar 2010 23:04:39 +0100, Andreas Beckmann wrote:
> > > Hi,
> > > 
> > > I just tried to benchmark nilfs and then the file system and benchmark
> > > process got stuck. dmesg output is attached. The problems start with
> > > 
> > > nilfs_sufile_do_cancel_free: segment 0 must be clean
> > > nilfs_sufile_do_cancel_free: segment 1 must be clean
> > > NILFS warning (device sdb1): nilfs_clean_segments: segment construction
> > > failed. (err=-28)
> > > 
> > > I'm using
> > > 
> > > Kernel 2.6.33 (Debian 2.6.33-1~experimental.2)
> > > nilfs-tools 2.0.16 (Debian 2.0.16-1)
> > > 
> > > The processes are unkillable and the file system cannot be unmounted.
> > > The machine will be reset when I get back in physical range on Wednesday
> > > and the stuck file system will be removed. If there is anything I can do
> > > remotely to help you debug that problem before the file system is gone,
> > > let me know.
>
> > Thank you for the detail report!
> > 
> > I could reproduce the both problems (i.e. the warnings on
> > "nilfs_sufile_do_cancel_free" and the hang of cleaner process) by a
> > manual fault injection test.
> > 
> > Will look into these issues.
> > 
> > Ryusuke Konishi

I've found the cause of the hang-up problem.  The following patch would
fix it.

However, please note that the current nilfs cleaner is designed to
keep every change within ``protection period''.  If you write a
massive amount of data in a short term, nilfs still would stop with a
disk full and reject new changes until cleaner will make some free
space.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix hang-up of cleaner after log writer returned with error

According to the report from Andreas Beckmann (Message-ID:
<4BA54677.3090902-qVUaBahCJu5n68oJJulU0Q@public.gmane.org>), nilfs in 2.6.33 kernel got stuck
after a disk full error.

This turned out to be a regression by log writer updates merged at
kernel 2.6.33.  nilfs_segctor_abort_construction, which is a cleanup
function for erroneous cases, was skipping writeback completion for
some logs.

This fixes the bug and would resolve the hang issue.

Reported-by: Andreas Beckmann <debian-qVUaBahCJu5n68oJJulU0Q@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index b622123..c161d89 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1897,8 +1897,7 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 
 	list_splice_tail_init(&sci->sc_write_logs, &logs);
 	ret = nilfs_wait_on_logs(&logs);
-	if (ret)
-		nilfs_abort_logs(&logs, NULL, sci->sc_super_root, ret);
+	nilfs_abort_logs(&logs, NULL, sci->sc_super_root, ret ? : err);
 
 	list_splice_tail_init(&sci->sc_segbufs, &logs);
 	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
