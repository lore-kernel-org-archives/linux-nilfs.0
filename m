From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Mon, 21 Jan 2008 14:01:29 +0900 (JST)
Message-ID: <20080121.140129.01311807.ryusuke@osrg.net>
References: <20080117183302.275d051d@vosztok>
	<1200628693.2931.54.camel@localhost.localdomain>
	<1200651072.2931.112.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1200651072.2931.112.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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

Hello, G=E1bor

On Fri, 2008-01-18 at 19:11 +0900, Ryusuke Konishi wrote:
> Your log actually gave me a great hint!
> =

> The following part of the log indicates that =

> the device mapper faced starvation of a memory pool,

I found another possible cause for the starvation of a memory
pool.  It is not a DM-related problem but a defection of a write
routine of NILFS.
And now I suspect that it's the true cause of your trouble.

Here I attach a test patch to fix the problem.
Could you try the patch ?

The patch can be applied as follows,

 $ cd nilfs-2.0.0-testing-8
 $ patch -p0 < patch_file


So, if rtorrent (or something else) hang again, then
send me a copy of /proc/slabinfo, please.

Thanks in advance,
-- =

Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/


Index: fs/segbuf.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- fs.orig/segbuf.c	2008-01-21 11:01:52.000000000 +0900
+++ fs/segbuf.c	2008-01-21 11:02:38.000000000 +0900
@@ -367,10 +367,10 @@
 {
 	struct bio *bio;
 =

-	bio =3D bio_alloc(GFP_NOIO, nr_vecs);
+	bio =3D bio_alloc(GFP_NOWAIT, nr_vecs);
 	if (bio =3D=3D NULL && (current->flags & PF_MEMALLOC)) {
 		while (!bio && (nr_vecs >>=3D 1))
-			bio =3D bio_alloc(GFP_NOIO, nr_vecs);
+			bio =3D bio_alloc(GFP_NOWAIT, nr_vecs);
 	}
 	if (likely(bio)) {
 		bio->bi_bdev =3D sb->s_bdev;
Index: fs/kern_feature.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- fs.orig/kern_feature.h	2008-01-21 11:02:02.000000000 +0900
+++ fs/kern_feature.h	2008-01-21 11:09:33.000000000 +0900
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
