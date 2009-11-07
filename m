From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [SPAM] Re: [SPAM] Re: urgent help need! disk
 partition info lost
Date: Sun, 08 Nov 2009 04:28:39 +0900 (JST)
Message-ID: <20091108.042839.107755482.ryusuke@osrg.net>
References: <856033f20911051002x79461f91o60e07f651a24f7c4@mail.gmail.com>
	<ee5afd760911051211n788e4f36g7f60d06e691817d8@mail.gmail.com>
	<c4a7c9420911070428s3983d570nc15ab02a7e1b10be@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <c4a7c9420911070428s3983d570nc15ab02a7e1b10be-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Sat, 7 Nov 2009 21:28:03 +0900, Ryusuke Konishi wrote:
> 2009/11/6 Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > At the same time I pick up from "the_nilfs.c :: load_nilfs that even if=
 a
> > partition is mounted read-only
> > perhaps certain things do get written
> > this is the code I refer to:
> > -------------------------
> > =A0=A0=A0 if (!valid_fs && (s_flags & MS_RDONLY)) {
> > =A0=A0=A0 =A0=A0=A0 printk(KERN_INFO "NILFS: INFO: recovery "
> > =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0 "required for readonly filesyste=
m.\n");
> > =A0=A0=A0 =A0=A0=A0 if (really_read_only) {
> > =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 printk(KERN_ERR "NILFS: write access "
> > =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0 "unavailable, cannot p=
roceed.\n");
> > =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D -EROFS;
> > =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto failed;
> > =A0=A0=A0 =A0=A0=A0 }
> > =A0=A0=A0 =A0=A0=A0 printk(KERN_INFO "NILFS: write access will "
> > =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0 "be enabled during recovery.\n");
> > =A0=A0=A0 =A0=A0=A0 sbi->s_super->s_flags &=3D ~MS_RDONLY;
> > =A0=A0=A0 }
> > ------------------------
> > So how do we proceed mounting this filesystem completely read-only to s=
ee
> > if perhaps some data can be recovered. (Provided that the partition tab=
le
> > now
> > points to a more or less valid nilfs partition.)
> =

> Yes, nilfs does recovery if needed even for a read-only mount.
> =

> Ok, you have a point.  I will consider adding a mount option to
> disable this action.
> =

> Regards,
> Ryusuke Konishi

Here is a patch to disable write access during recovery on mount.

A new mount option "-o norepair" is added instead of disabling write
access for read-only mount by default.  This is because the repair
action is needed especially for the root filesystem; the root
filesystem is first mounted with a read-only option and remounted
read/write later on.

If the write access is not allowed by default, mounting the root
filesystem after unexpected reboot will always fail.  The same issue
is actually present in journaling filesystems like ext3.

So, I think this is a practical solution.
How does this look like ?

This patch was made for the out-of-tree kernel module, and moreover,
is not divided properly.  So, if you OK, I will reorganize the patch
and queue it for the next merge window.

Regards,
Ryusuke Konishi
--

diff --git a/fs/nilfs2_fs.h b/fs/nilfs2_fs.h
index 79fec6a..3b15f19 100644
--- a/fs/nilfs2_fs.h
+++ b/fs/nilfs2_fs.h
@@ -151,6 +151,8 @@ struct nilfs_super_root {
 #define NILFS_MOUNT_BARRIER		0x1000  /* Use block barriers */
 #define NILFS_MOUNT_STRICT_ORDER	0x2000  /* Apply strict in-order
 						   semantics also for data */
+#define NILFS_MOUNT_NOREPAIR		0x4000  /* Disable write access during
+						   mount-time recovery */
 =

 =

 /**
diff --git a/fs/super.c b/fs/super.c
index c9acc9a..097e3fb 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -513,6 +513,11 @@ static int nilfs_mark_recovery_complete(struct nilfs_s=
b_info *sbi)
 	down_write(&nilfs->ns_sem);
 	if (!(nilfs->ns_mount_state & NILFS_VALID_FS)) {
 		nilfs->ns_mount_state |=3D NILFS_VALID_FS;
+		if (sbi->s_super->s_flags & MS_RDONLY) {
+			struct nilfs_super_block *sbp =3D nilfs->ns_sbp[0];
+
+			sbp->s_state |=3D cpu_to_le16(NILFS_VALID_FS);
+		}
 		err =3D nilfs_commit_super(sbi, 1);
 		if (likely(!err))
 			printk(KERN_INFO "NILFS: recovery complete.\n");
@@ -649,7 +654,7 @@ static struct export_operations nilfs_export_ops =3D {
 =

 enum {
 	Opt_err_cont, Opt_err_panic, Opt_err_ro,
-	Opt_barrier, Opt_snapshot, Opt_order,
+	Opt_barrier, Opt_snapshot, Opt_order, Opt_norepair,
 	Opt_err,
 };
 =

@@ -660,6 +665,7 @@ static match_table_t tokens =3D {
 	{Opt_barrier, "barrier=3D%s"},
 	{Opt_snapshot, "cp=3D%u"},
 	{Opt_order, "order=3D%s"},
+	{Opt_norepair, "norepair"},
 	{Opt_err, NULL}
 };
 =

@@ -728,6 +734,15 @@ static int parse_options(char *options, struct super_b=
lock *sb)
 			sbi->s_snapshot_cno =3D option;
 			nilfs_set_opt(sbi, SNAPSHOT);
 			break;
+		case Opt_norepair:
+			if (!(sb->s_flags & MS_RDONLY))
+				return 0;
+			/*
+			 * Turning off repair action (allowed only for
+			 * read only mounts or snapshots).
+			 */
+			nilfs_set_opt(sbi, NOREPAIR);
+			break;
 		default:
 			printk(KERN_ERR
 			       "NILFS: Unrecognized mount option \"%s\"\n", p);
@@ -946,10 +961,12 @@ nilfs_fill_super(struct super_block *sb, void *data, =
int silent,
 		up_write(&nilfs->ns_sem);
 	}
 =

-	err =3D nilfs_mark_recovery_complete(sbi);
-	if (unlikely(err)) {
-		printk(KERN_ERR "NILFS: recovery failed.\n");
-		goto failed_root;
+	if (!nilfs_test_opt(sbi, NOREPAIR)) {
+		err =3D nilfs_mark_recovery_complete(sbi);
+		if (unlikely(err)) {
+			printk(KERN_ERR "NILFS: recovery failed.\n");
+			goto failed_root;
+		}
 	}
 =

 	down_write(&nilfs->ns_super_sem);
@@ -1051,6 +1068,14 @@ static int nilfs_remount(struct super_block *sb, int=
 *flags, char *data)
 			err =3D -EINVAL;
 			goto restore_opts;
 		}
+		if (!(nilfs->ns_mount_state & NILFS_VALID_FS)) {
+			printk(KERN_WARNING "NILFS (device %s): couldn't "
+			       "remount because the filesystem is in an "
+			       "incomplete recovery state.\n",
+			       sb->s_id);
+			err =3D -EINVAL;
+			goto restore_opts;
+		}
 		sb->s_flags &=3D ~MS_RDONLY;
 		nilfs_clear_opt(sbi, SNAPSHOT);
 		sbi->s_snapshot_cno =3D 0;
diff --git a/fs/the_nilfs.c b/fs/the_nilfs.c
index 365971b..084bbeb 100644
--- a/fs/the_nilfs.c
+++ b/fs/the_nilfs.c
@@ -303,19 +303,9 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_s=
b_info *sbi)
 	valid_fs =3D (nilfs->ns_mount_state & NILFS_VALID_FS);
 	up_write(&nilfs->ns_sem);
 =

-	if (!valid_fs && (s_flags & MS_RDONLY)) {
+	if (!valid_fs && (s_flags & MS_RDONLY))
 		printk(KERN_INFO "NILFS: INFO: recovery "
 		       "required for readonly filesystem.\n");
-		if (really_read_only) {
-			printk(KERN_ERR "NILFS: write access "
-			       "unavailable, cannot proceed.\n");
-			err =3D -EROFS;
-			goto failed;
-		}
-		printk(KERN_INFO "NILFS: write access will "
-		       "be enabled during recovery.\n");
-		sbi->s_super->s_flags &=3D ~MS_RDONLY;
-	}
 =

 	err =3D nilfs_search_super_root(nilfs, sbi, &ri);
 	if (unlikely(err)) {
@@ -329,18 +319,38 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_=
sb_info *sbi)
 		goto failed;
 	}
 =

-	if (!valid_fs) {
-		err =3D nilfs_recover_logical_segments(nilfs, sbi, &ri);
-		if (unlikely(err)) {
-			nilfs_mdt_destroy(nilfs->ns_cpfile);
-			nilfs_mdt_destroy(nilfs->ns_sufile);
-			nilfs_mdt_destroy(nilfs->ns_dat);
+	if (valid_fs)
+		goto skip_rollforward;
+
+	if (s_flags & MS_RDONLY) {
+		if (nilfs_test_opt(sbi, NOREPAIR)) {
+			printk(KERN_INFO "NILFS: roll-forward recovery will "
+			       "be skipped because of the norepair option\n");
+			goto skip_rollforward;
+		}
+		if (really_read_only) {
+			printk(KERN_ERR "NILFS: write access unavailable, "
+			       "cannot proceed.\n");
+			err =3D -EROFS;
 			goto failed;
 		}
-		if (ri.ri_need_recovery =3D=3D NILFS_RECOVERY_SR_UPDATED)
-			sbi->s_super->s_dirt =3D 1;
+		printk(KERN_INFO "NILFS: write access will be enabled "
+		       "during recovery.\n");
+		sbi->s_super->s_flags &=3D ~MS_RDONLY;
 	}
 =

+	err =3D nilfs_recover_logical_segments(nilfs, sbi, &ri);
+	if (unlikely(err)) {
+		nilfs_mdt_destroy(nilfs->ns_cpfile);
+		nilfs_mdt_destroy(nilfs->ns_sufile);
+		nilfs_mdt_destroy(nilfs->ns_dat);
+		goto failed;
+	}
+
+ skip_rollforward:
+	if (ri.ri_need_recovery =3D=3D NILFS_RECOVERY_SR_UPDATED)
+		sbi->s_super->s_dirt =3D 1;
+
 	set_nilfs_loaded(nilfs);
 =

  failed:
diff --git a/nilfs2.txt b/nilfs2.txt
index dbbda00..f7af22a 100644
--- a/nilfs2.txt
+++ b/nilfs2.txt
@@ -71,6 +71,10 @@ order=3Dstrict		Apply strict in-order semantics that pre=
serves sequence
 			blocks.  That means, it is guaranteed that no
 			overtaking of events occurs in the recovered file
 			system after a crash.
+norepair		Disable repair action of filesystem on mount. This
+			option is allowed only for readonly mount or snapshots.
+			This disables all write access to disk including the
+			mount-time recovery.
 =

 NILFS2 usage
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
