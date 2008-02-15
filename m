From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: some notes on a memory leak
Date: Fri, 15 Feb 2008 15:07:09 +0900 (JST)
Message-ID: <20080215.150709.13051610.ryusuke@osrg.net>
References: <20080214010258.76494d68@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080214010258.76494d68@vosztok>
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
Content-Type: Text/Plain; charset="iso-8859-1"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org


From: Gergely G=E1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [NILFS users] some notes on a memory leak
Date: Thu, 14 Feb 2008 01:02:58 +0100

> Hello Ryusuke, and other nilfs developers, and users!
> =

> I have left my computer working, testing nilfs. I have found that aft=
er
> a log period of time, most of the memory in the computer vas allocate=
d as
> cache (according to vmstat) and even aftel killing all processes that=
 held
> files open, the amount (~430 megabytes) did not decrease significantl=
y.
> I have unmounted the filesystem, and most cache was freed up, and aft=
er
> remounting nilfs, the system was fast as lightning again (the module =
was not
> needed to be removed to reclaim the memory).

I'd like to append a note.

NILFS has two different things about the cache usage than ordinary
filesystems:

(1) Since the cleaner clowls over a partition, it adds new pages into a=
 cache
    of the block device one after another during it operates on the bac=
kground.

(2) Some blocks, for example the blocks to store header information of =
each
    segment, are allocated incrementally into the cache of the block de=
vice. =

    So, bursty writes or frequent sync writes may bloat it.
    Conversely, the turnover of buffers for files or meta data should n=
ot be =

    higher than usual fs because a same buffer serves for a same file o=
ffset
    even when its physical disk address changes.

I made a patch to minimize the bloat of bdev cache due to the second
difference.
If you are bothered with that, please test the following patch.
From=20my local tests, it didn't make no remarkable difference.

Best regards,
-- =

Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/

Index: fs/kern_feature.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- fs.orig/kern_feature.h	2008-02-14 15:28:15.000000000 +0900
+++ fs/kern_feature.h	2008-02-14 15:35:53.000000000 +0900
@@ -187,6 +187,13 @@
 	(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))
 #endif
 /*
+ * invalidate_mapping_pages() got exported in linux-2.6.21.
+ */
+#ifndef HAVE_EXPORTED_INVALIDATE_MAPPING_PAGES
+# define HAVE_EXPORTED_INVALIDATE_MAPPING_PAGES \
+	(LINUX_VERSION_CODE > KERNEL_VERSION(2,6,20) || NILFS_BUILT_INTERNAL)=

+#endif
+/*
  * clear_page_dirty() and test_clear_page_dirty() were removed
  * in linux-2.6.20
  */
Index: fs/segment.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- fs.orig/segment.c	2008-02-14 15:36:57.000000000 +0900
+++ fs/segment.c	2008-02-14 16:17:43.000000000 +0900
@@ -1615,11 +1615,19 @@
 =

 static int nilfs_segctor_terminate_segment(struct nilfs_sc_info *sci,
 					   struct nilfs_segment_buffer *segbuf,
-					   struct inode *sufile)
+					   struct the_nilfs *nilfs)
 {
 	struct nilfs_segment_entry *ent =3D segbuf->sb_segent;
+	struct inode *sufile =3D nilfs->ns_sufile;
 	int err;
+#if HAVE_EXPORTED_INVALIDATE_MAPPING_PAGES
+	struct address_space *mapping =3D nilfs->ns_bdev->bd_inode->i_mapping=
;
+	int nshiftbits =3D PAGE_SHIFT - nilfs->ns_blocksize_bits;
+	pgoff_t start =3D segbuf->sb_fseg_start >> nshiftbits;
+	pgoff_t end =3D segbuf->sb_fseg_end >> nshiftbits;
 =

+	invalidate_mapping_pages(mapping, start, end);
+#endif
 	err =3D nilfs_open_segment_entry(ent, sufile);
 	if (unlikely(err))
 		return err;
@@ -1669,7 +1677,7 @@
 		return err;
 =

 	if (segbuf->sb_rest_blocks < NILFS_PSEG_MIN_BLOCKS) {
-		err =3D nilfs_segctor_terminate_segment(sci, segbuf, sufile);
+		err =3D nilfs_segctor_terminate_segment(sci, segbuf, nilfs);
 		if (unlikely(err))
 			return err;
 =
