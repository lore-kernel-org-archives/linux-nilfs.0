From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCHv4 2/2] nilfs2: sync super blocks in turns
Date: Mon, 28 Jun 2010 11:35:00 +0900 (JST)
Message-ID: <20100628.113500.37590626.ryusuke@osrg.net>
References: <87zkyi1izo.wl%jir@sekiba.com>
	<20100626.235108.163664714.ryusuke@osrg.net>
	<87sk49dur6.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87sk49dur6.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Sun, 27 Jun 2010 12:22:53 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> At Sat, 26 Jun 2010 23:51:08 +0900 (JST),
> Ryusuke Konishi wrote:
> > 
> > Hi,
> > On Sat, 26 Jun 2010 14:05:31 +0900, Jiro SEKIBA wrote:
> > > Hi, thank you for the comments.
> > > 
> > > At Fri, 25 Jun 2010 18:06:39 +0900 (JST),
> > > Ryusuke Konishi wrote:
> > > > 
> > > > > +			if (sbp &&
> > > > > +			    nilfs->ns_sbp[0]->s_last_cno < sbp->s_last_cno)
> > > > > +				sbp = nilfs->ns_sbp[0];
> > > > >  		}
> > 
> > Here, endian conversions are required for both s_last_cno references.
> > 
> > We can apply some bit operations without endian conversion (e.g. OR,
> > AND, XOR, and so on), but it's not true for arithmetic operations like
> > addition, subtraction and comparison.
> > 
> > And, the above code seems to never update ns_prot_seq when
> > NILFS_SB_COMMIT is specified.
> 
> Grr, those are really careless bugs...
> Thank you for the comments.  I'll revise it

I found another issue on the patch.

It occasionally makes the filesystem unclean after unmount or
read-only remount.  I found it's because the "clean" flag is left
unset for one of two super blocks even if both super blocks point to
the same checkpoint.

Here is a patch to fix it.  I will later squash this into your patch
and post the revised one.

Regards,
Ryusuke Konishi

---
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: sync super blocks in turns fix

The patch "nilfs2: sync super blocks in turns" alternately writes back
super blocks to allow fallback when mount from the primary super block
failed.  But, it occasionally makes the filesystem unclean after
unmount or read-only remount.

This turned out because the "clean" flag of filesystem
(i.e. NILFS_VALID_FS) may not be restored to the primary super block
even if both super blocks point to the same checkpoint.

This may happen if the filesystem was unmounted without any change, or
if one of the two super blocks was destroyed on memory and the data
was copied back from the spare super block.

This fixes the issue by restoring the "clean" flag to both super
blocks if they point to the same checkpoint.  To share the same
cleanup work, a routine named "nilfs_cleanup_super" is added.

Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/nilfs.h     |    1 +
 fs/nilfs2/super.c     |   52 ++++++++++++++++++++++++++++++++-----------------
 fs/nilfs2/the_nilfs.c |   12 +---------
 3 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 63c8fd4..36998ea 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -283,6 +283,7 @@ extern void nilfs_set_log_cursor(struct nilfs_super_block *,
 extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *,
 						      int flip);
 extern int nilfs_commit_super(struct nilfs_sb_info *, int);
+extern int nilfs_cleanup_super(struct nilfs_sb_info *);
 extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
 extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 393bf89..8942baa 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -320,11 +320,42 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int flag)
 	return nilfs_sync_super(sbi, flag);
 }
 
+/**
+ * nilfs_cleanup_super() - write filesystem state for cleanup
+ * @sbi: nilfs_sb_info to be unmounted or degraded to read-only
+ *
+ * This function restores state flags in the on-disk super block.
+ * This will set "clean" flag (i.e. NILFS_VALID_FS) unless the
+ * filesystem was not clean previously.
+ */
+int nilfs_cleanup_super(struct nilfs_sb_info *sbi)
+{
+	struct nilfs_super_block **sbp;
+	int flag = NILFS_SB_COMMIT;
+	int ret = -EIO;
+
+	sbp = nilfs_prepare_super(sbi, 0);
+	if (sbp) {
+		sbp[0]->s_state = cpu_to_le16(sbi->s_nilfs->ns_mount_state);
+		nilfs_set_log_cursor(sbp[0], sbi->s_nilfs);
+		if (sbp[1] && sbp[0]->s_last_cno == sbp[1]->s_last_cno) {
+			/*
+			 * make the "clean" flag also to the opposite
+			 * super block if both super blocks point to
+			 * the same checkpoint.
+			 */
+			sbp[1]->s_state = sbp[0]->s_state;
+			flag = NILFS_SB_COMMIT_ALL;
+		}
+		ret = nilfs_commit_super(sbi, flag);
+	}
+	return ret;
+}
+
 static void nilfs_put_super(struct super_block *sb)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
-	struct nilfs_super_block **sbp;
 
 	lock_kernel();
 
@@ -332,13 +363,7 @@ static void nilfs_put_super(struct super_block *sb)
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_write(&nilfs->ns_sem);
-		sbp = nilfs_prepare_super(sbi, 0);
-		if (likely(sbp)) {
-			/* set state only for newer super block */
-			sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
-			nilfs_set_log_cursor(sbp[0], nilfs);
-			nilfs_commit_super(sbi, NILFS_SB_COMMIT);
-		}
+		nilfs_cleanup_super(sbi);
 		up_write(&nilfs->ns_sem);
 	}
 	down_write(&nilfs->ns_super_sem);
@@ -883,7 +908,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct nilfs_super_block **sbp;
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	unsigned long old_sb_flags;
 	struct nilfs_mount_options old_opts;
@@ -944,15 +968,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * the RDONLY flag and then mark the partition as valid again.
 		 */
 		down_write(&nilfs->ns_sem);
-		sbp = nilfs_prepare_super(sbi, 0);
-		if (likely(sbp)) {
-			if (!(sbp[0]->s_state & le16_to_cpu(NILFS_VALID_FS)) &&
-			    (nilfs->ns_mount_state & NILFS_VALID_FS))
-				sbp[0]->s_state =
-					cpu_to_le16(nilfs->ns_mount_state);
-			nilfs_set_log_cursor(sbp[0], nilfs);
-			nilfs_commit_super(sbi, NILFS_SB_COMMIT);
-		}
+		nilfs_cleanup_super(sbi);
 		up_write(&nilfs->ns_sem);
 	} else {
 		/*
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 33c5347..530d277 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -261,7 +261,6 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	unsigned int s_flags = sbi->s_super->s_flags;
 	int really_read_only = bdev_read_only(nilfs->ns_bdev);
 	int valid_fs = nilfs_valid_fs(nilfs);
-	struct nilfs_super_block **sbp;
 	int err;
 
 	if (nilfs_loaded(nilfs)) {
@@ -325,15 +324,8 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 		goto failed_unload;
 
 	down_write(&nilfs->ns_sem);
-	err = -EIO;
-	sbp = nilfs_prepare_super(sbi, 0);
-	if (likely(sbp)) {
-		nilfs->ns_mount_state |= NILFS_VALID_FS;
-		/* set the flag only for newer super block */
-		sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
-		nilfs_set_log_cursor(sbp[0], nilfs);
-		err = nilfs_commit_super(sbi, NILFS_SB_COMMIT);
-	}
+	nilfs->ns_mount_state |= NILFS_VALID_FS; /* set "clean" flag */
+	err = nilfs_cleanup_super(sbi);
 	up_write(&nilfs->ns_sem);
 
 	if (err) {
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
