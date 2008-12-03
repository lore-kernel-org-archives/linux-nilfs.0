From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Wed, 03 Dec 2008 12:00:21 +0900 (JST)
Message-ID: <20081203.120021.27010822.ryusuke@osrg.net>
References: <20081201171411.99215829D@blinkenlights.ch>
	<20081202.142225.78011419.ryusuke@osrg.net>
	<20081202064345.31DB4802A@blinkenlights.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081202064345.31DB4802A-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

On Tue, 2 Dec 2008 07:44:09 +0100, Adrian Ulrich wrote:
> Debug output:
> 
> NILFS nilfs_fill_super: start(silent=0)
> NILFS: INFO: recovery required for readonly filesystem.
> NILFS: write access will be enabled during recovery.
> NILFS(recovery) nilfs_search_super_root: looking segment (seg_start=174272512, seg_end=174274559, segnum=85094, seg_seq=181656)
> NILFS(recovery) load_segment_summary: checking segment (pseg_start=174272512, full_check=1)
> NILFS(recovery) load_segment_summary: done (ret=4)
> NILFS(recovery) nilfs_search_super_root: strayed: scan_newer=0, ret=4
> NILFS warning: Sequence number mismatch
> NILFS: error searching super root.
> NILFS nilfs_fill_super: aborted
> NILFS put_nilfs: the_nilfs on bdev sdb5 was freed

According to this log, there is actually a sequence number mismatch
between superblock and the segment pointed by the superblock.  The
recovery function seems to work normally.

> 
> Do you also need the output with your first patch applied?

Instead of the previous patch, could you try the following patch?

It forces to mount a filesystem from the segment pointed by the
superblock if there is no other failure.

If it succeeds, copy filesystem contents (just to be safe) and
unmount it.  Then reinstall the original module. 

If successful, it may be able to re-mount as if nothing had happened.

Regards,
Ryusuke Konishi

--
diff --git a/fs/recovery.c b/fs/recovery.c
index bd8e175..874f855 100644
--- a/fs/recovery.c
+++ b/fs/recovery.c
@@ -240,10 +240,12 @@ load_segment_summary(struct nilfs_sb_info *sbi, sector_t pseg_start,
 		goto failed;
 	}
 	store_segsum_info(ssi, sum, sbi->s_super->s_blocksize);
+#if 0
 	if (seg_seq != ssi->seg_seq) {
 		ret = NILFS_SEG_FAIL_SEQ;
 		goto failed;
 	}
+#endif
 	if (full_check) {
 		offset = sizeof(sum->ss_datasum);
 		check_bytes =
@@ -960,6 +962,8 @@ int nilfs_search_super_root(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi,
 		nilfs->ns_cno = cno;  /* nilfs->ns_cno = ri->ri_cno + 1 */
 		nilfs->ns_ctime = ssi.ctime;
 		nilfs->ns_nextnum = nextnum;
+		ri->ri_need_recovery = NILFS_RECOVERY_SR_UPDATED;
+		goto super_root_found;
 
 		if (scan_newer)
 			ri->ri_need_recovery = NILFS_RECOVERY_SR_UPDATED;
