From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_sufile_do_cancel_free: segment 0 must be clean
Date: Mon, 22 Mar 2010 15:34:46 +0900 (JST)
Message-ID: <20100322.153446.180039371.ryusuke@osrg.net>
References: <4BA54677.3090902@abeckmann.de>
	<20100322.150420.179960388.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100322.150420.179960388.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: debian-qVUaBahCJu5n68oJJulU0Q@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Mon, 22 Mar 2010 15:04:20 +0900 (JST), Ryusuke Konishi wrote:
> Hi,
> On Sat, 20 Mar 2010 23:04:39 +0100, Andreas Beckmann wrote:
> > Hi,
> > 
> > I just tried to benchmark nilfs and then the file system and benchmark
> > process got stuck. dmesg output is attached. The problems start with
> > 
> > nilfs_sufile_do_cancel_free: segment 0 must be clean
> > nilfs_sufile_do_cancel_free: segment 1 must be clean
> > NILFS warning (device sdb1): nilfs_clean_segments: segment construction
> > failed. (err=-28)
> > 
> > I'm using
> > 
> > Kernel 2.6.33 (Debian 2.6.33-1~experimental.2)
> > nilfs-tools 2.0.16 (Debian 2.0.16-1)
> > 
> > The processes are unkillable and the file system cannot be unmounted.
> > The machine will be reset when I get back in physical range on Wednesday
> > and the stuck file system will be removed. If there is anything I can do
> > remotely to help you debug that problem before the file system is gone,
> > let me know.
> > 
> > The file system got into this state after writing several times the
> > capacity of the file system, creating a single file until the file
> > cannot be extended any more.
> > 
> > # df -k /dev/sdb1
> > Filesystem           1K-blocks      Used Available Use% Mounted on
> > /dev/sdb1            136716284 136372220         0 100% /stxxl/sdb
> > 
> > Can't do a ls on the file systen, gets stuck as well.
> > 
> > 
> > Please keep me CCed, I'm not on the list.
> > 
> > 
> > Andreas
> 
> Thank you for the detail report!
> 
> I could reproduce the both problems (i.e. the warnings on
> "nilfs_sufile_do_cancel_free" and the hang of cleaner process) by a
> manual fault injection test.
> 
> Will look into these issues.
> 
> Ryusuke Konishi

The following patch would fix the warnings (Still the hang-up may
occur).

Ryusuke Konishi

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 69576a9..b622123 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1510,6 +1510,12 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 		if (mode != SC_LSEG_SR || sci->sc_stage.scnt < NILFS_ST_CPFILE)
 			break;
 
+		nilfs_clear_logs(&sci->sc_segbufs);
+
+		err = nilfs_segctor_extend_segments(sci, nilfs, nadd);
+		if (unlikely(err))
+			return err;
+
 		if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
 			err = nilfs_sufile_cancel_freev(nilfs->ns_sufile,
 							sci->sc_freesegs,
@@ -1517,12 +1523,6 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 							NULL);
 			WARN_ON(err); /* do not happen */
 		}
-		nilfs_clear_logs(&sci->sc_segbufs);
-
-		err = nilfs_segctor_extend_segments(sci, nilfs, nadd);
-		if (unlikely(err))
-			return err;
-
 		nadd = min_t(int, nadd << 1, SC_MAX_SEGDELTA);
 		sci->sc_stage = prev_stage;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
