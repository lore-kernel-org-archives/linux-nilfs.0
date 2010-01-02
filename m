From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS2 on an Intel X25-M SSD
Date: Sun, 03 Jan 2010 02:24:25 +0900 (JST)
Message-ID: <20100103.022425.52166650.ryusuke@osrg.net>
References: <4B3A5D1F.9010002@gmail.com>
	<20091231.034629.85391956.ryusuke@osrg.net>
	<4B3C7326.4010002@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4B3C7326.4010002-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: crmafra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Thu, 31 Dec 2009 10:47:18 +0100, "Carlos R. Mafra" wrote:
> Am 30.12.2009 19:46, schrieb Ryusuke Konishi:
> > On Tue, 29 Dec 2009 20:48:47 +0100, "Carlos R. Mafra" wrote:
> >> Is there any specific tweak in NILFS2 to use with an SSD? Would you
> >> reccomend using NILFS2 on a SSD right now?
> >>
> >> Is the issue mentioned here
> >>
> >> https://www.nilfs.org/pipermail/users/2009-March/000514.html
> >>
> >> about excessive writing in the GC already fixed?
> >> That is the most pressing fear I have about NILFS2 for the SSD.
> > 
> > Not yet, sorry.  I'm working on some performance optimization for high
> > speed drives espacially for SSD.  Revising GC is another priority, but
> > it would need some time.
> > 
> > The massive I/O by the current garbage collector may shorten the life
> > of SSD.  So, I don't recommend yet.
> 
> Hmm, then I won't use NILFS2 on the SSD for now.
> 
> I am testing it in an external HD for the last two days to get a feeling,
> and so far everything looks good and stable. It is a pity that the 
> massive I/O problem kind of prevents putting it on the SSD.

Definitely yes.

NILFS2 is pretty stable, but this issue is spoiling the goodness
especially for netbook users.
 
> Naively I would think that the GC will always create some I/O that
> other filesystems don't have, by its very definition. Can you
> quantify by how much the current GC is writing in excess and what would
> be the acceptable numbers?

The overhead is roughly measured as the number of copied (moved)
blocks per reclaimed segment.  The following patch will print the
ratio (number of copied blocks / cleaned blocks) into syslog.

A NILFS2 root of my laptop constantly marks 70~99%.

This is because the current GC regularly frees segments from older
ones without any attempt to minimize the above ratio; it doesn't
select target segments that way, and it doesn't delay reclamation even
when the partition has enough free space.

I don't know how much is acceptable, but at least, I think the GC
frequency should be suppressed to 0 while the partition has enough
free space, and the selection algorithm should be improved to give
priority to free segments containing less in-use blocks.


Regards,
Ryusuke Konishi
--
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index f36dfce..6a35f15 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -921,6 +921,8 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 {
 	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
 	ssize_t n, ret = -1;
+	size_t nr_vblocks, nr_pblocks, nr_live_vblocks, nr_live_pblocks;
+	size_t nr_blocks, nr_live_blocks;
 	int i;
 
 	if (nsegs == 0)
@@ -953,10 +955,14 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 	if (ret < 0)
 		goto out_lock;
 
+	nr_vblocks = nilfs_vector_get_size(vdescv);
+
 	ret = nilfs_cleanerd_toss_vdescs(cleanerd, vdescv, periodv, vblocknrv);
 	if (ret < 0)
 		goto out_lock;
 
+	nr_live_vblocks = nilfs_vector_get_size(vdescv);
+
 	nilfs_vector_sort(vdescv, nilfs_comp_vdesc_blocknr);
 	nilfs_cleanerd_unify_period(cleanerd, periodv);
 
@@ -964,10 +970,17 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 	if (ret < 0)
 		goto out_lock;
 
+	nr_pblocks = nilfs_vector_get_size(bdescv);
+
 	ret = nilfs_cleanerd_toss_bdescs(cleanerd, bdescv);
 	if (ret < 0)
 		goto out_lock;
 
+	nr_live_pblocks = nilfs_vector_get_size(bdescv);
+
+	nr_blocks = nr_vblocks + nr_pblocks;
+	nr_live_blocks = nr_live_vblocks + nr_live_pblocks;
+
 	ret = nilfs_clean_segments(cleanerd->c_nilfs,
 				   nilfs_vector_get_data(vdescv),
 				   nilfs_vector_get_size(vdescv),
@@ -983,8 +996,13 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 	} else {
 		if (n > 0) {
 			for (i = 0; i < n; i++)
-				syslog(LOG_DEBUG, "segment %llu cleaned",
+				syslog(LOG_INFO, "segment %llu cleaned",
 				       (unsigned long long)segnums[i]);
+			syslog(LOG_INFO,
+			       "copied blocks / total blocks : %zu / %zu "
+			       "(%3.1f%%)",
+			       nr_live_blocks, nr_blocks,
+			       nr_live_blocks * 100.0 / nr_blocks);
 		} else {
 			syslog(LOG_DEBUG, "no segments cleaned");
 		}
