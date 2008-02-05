From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Tue, 05 Feb 2008 18:28:29 +0900 (JST)
Message-ID: <20080205.182829.44149266.ryusuke@osrg.net>
References: <20080121.140129.01311807.ryusuke@osrg.net>
	<20080122000052.215084db@vosztok>
	<1200970920.2844.59.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1200970920.2844.59.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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

Hi G=E1bor,

From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [NILFS users] Deadlocks! help, please!
Date: Tue, 22 Jan 2008 12:02:00 +0900
> On Tue, 2008-01-22 at 00:00 +0100, Gergely G=E1bor wrote:
> > > Here I attach a test patch to fix the problem.
> > > Could you try the patch ?
> > > =

> > > So, if rtorrent (or something else) hang again, then
> > > send me a copy of /proc/slabinfo, please.
> > It hang again,
> =

> Ugh! OK, I'll continue to work on it.

Today I could reproduce the hang problem, and succeeded in capturing
a stack trace of the suspended cleaner process.

After short analysis, a suspicious bug was found in a write routine
of NILFS.  It seems to be the root cause of this problem.

I will attach a revised patch below.
Could you try the patch?

It is applicable to nilfs-2.0.0-testing-8 as usual,
(Ignore hunks, they are harmless)

 $ cd nilfs-2.0.0-testing-8
 $ patch -p0 < patch_file


Thanks in advance for your help.
-- =

Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/


Index: fs/segbuf.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /project/lfs/cvsroot/lfsv2/fs/segbuf.c,v
retrieving revision 1.14
retrieving revision 1.17
diff -u -p -I Id -r1.14 -r1.17
--- fs/segbuf.c	12 Dec 2007 04:15:33 -0000	1.14
+++ fs/segbuf.c	5 Feb 2008 05:26:33 -0000	1.17
@@ -309,7 +309,7 @@ static int nilfs_submit_seg_bio(struct n
 	struct bio *bio =3D wi->bio;
 	int err;
 =

-	if (bdi_write_congested(wi->bdi)) {
+	if (wi->nbio > 0 && bdi_write_congested(wi->bdi)) {
 		seg_debug(3, "waiting for a segment\n");
 		wait_for_completion(&wi->bio_event);
 		wi->nbio--;
@@ -367,10 +367,14 @@ static struct bio *nilfs_alloc_seg_bio(s
 {
 	struct bio *bio;
 =

-	bio =3D bio_alloc(GFP_NOIO, nr_vecs);
-	if (bio =3D=3D NULL && (current->flags & PF_MEMALLOC)) {
+	bio =3D bio_alloc(GFP_NOWAIT, nr_vecs);
+	if (bio =3D=3D NULL) {
+		seg_debug(1, "bio_alloc() failed. retrying (nr_vecs=3D%d)\n",
+			  nr_vecs);
 		while (!bio && (nr_vecs >>=3D 1))
-			bio =3D bio_alloc(GFP_NOIO, nr_vecs);
+			bio =3D bio_alloc(GFP_NOWAIT, nr_vecs);
+		seg_debug(1, "done retry (nr_vecs=3D%d, bio=3D%p)\n",
+			  nr_vecs, bio);
 	}
 	if (likely(bio)) {
 		bio->bi_bdev =3D sb->s_bdev;
Index: fs/kern_feature.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /project/lfs/cvsroot/lfsv2/fs/kern_feature.h,v
retrieving revision 1.45
retrieving revision 1.46
diff -u -p -I Id -r1.45 -r1.46
--- fs/kern_feature.h	10 Jan 2008 03:39:52 -0000	1.45
+++ fs/kern_feature.h	21 Jan 2008 05:07:13 -0000	1.46
@@ -339,6 +339,13 @@
 	(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,17))
 #endif
 /*
+ * GFP_NOWAIT flag was introduced at linux-2.6.17
+ */
+#ifndef NEED_GFP_NOWAIT
+# define NEED_GFP_NOWAIT	\
+	(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,17))
+#endif
+/*
  * mutex replaced semaphore since linux-2.6.16
  */
 #ifndef NEED_INODE_SEMAPHORE
@@ -440,6 +447,10 @@
 #define GFP_T gfp_t
 #endif
 =

+#if NEED_GFP_NOWAIT
+#define GFP_NOWAIT (GFP_ATOMIC & ~__GFP_HIGH)
+#endif
+
 #if NEED_KMEM_CACHE_S
 #define kmem_cache kmem_cache_s
 #endif
