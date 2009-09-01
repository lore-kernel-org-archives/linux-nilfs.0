From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Problem while backing up
Date: Wed, 02 Sep 2009 03:49:00 +0900 (JST)
Message-ID: <20090902.034900.43737698.ryusuke@osrg.net>
References: <debc30fc0909010702n44a961f5jc768cabaecbd5435@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0909010702n44a961f5jc768cabaecbd5435-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi!
On Tue, 1 Sep 2009 10:02:12 -0400, J=E9r=F4me Poulin wrote:
> I had some trouble again with NilFS yesterday, it's probably
> unrelated to my last one which I never had the problem again. I
> started a rdiff-backup of my / to my backup server, went to sleep
> and when I woke up rdiff-backup was stopped with a segfault and the
> computer wasn't responding, I switched console and could login as
> root, it seems most processes using /home (where NilFS is in use)
> were in D state. So I dumped as much information as I could, sync'ed
> (sync Deadlocked too) and finally rebooted the hard way.
> =

> Here are the logs I gathered.

Thank you for reporting the problem.

According to the log, a btree of a regular file or a directory looks
corrupted in the partition.

There are a few undesirable uses of BUG_ON() assertions in
btree-lookup routines, and these BUG_ON()s cause hang when the
routines meet a corrupted node block.

The following patch will replace them with safer sanity checks.

However, I feel the true cause of this problem is an FS-corruption in
nilfs.  Actually, I was trailing the problem during the past few days,
but not yet done.

If I can make a progress for this, I will ask for your help to obtain
confirmation.

Cheers,
Ryusuke Konishi

--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: convert BUG_ON in btree lookup routines to KERN_CR=
IT error

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 6b37a27..00a2d0c 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -468,6 +468,19 @@ nilfs_btree_get_node(const struct nilfs_btree *btree,
 		nilfs_btree_get_nonroot_node(btree, path, level);
 }
 =

+static inline int
+nilfs_btree_bad_node(const struct nilfs_btree *btree,
+		     struct nilfs_btree_node *node, int level)
+{
+	if (unlikely(nilfs_btree_node_get_level(btree, node) !=3D level)) {
+		dump_stack();
+		printk(KERN_CRIT "NILFS: btree level mismatch: %d !=3D %d\n",
+		       nilfs_btree_node_get_level(btree, node), level);
+		return 1;
+	}
+	return 0;
+}
+
 static int nilfs_btree_do_lookup(const struct nilfs_btree *btree,
 				 struct nilfs_btree_path *path,
 				 __u64 key, __u64 *ptrp, int minlevel)
@@ -493,7 +506,8 @@ static int nilfs_btree_do_lookup(const struct nilfs_btr=
ee *btree,
 		if (ret < 0)
 			return ret;
 		node =3D nilfs_btree_get_nonroot_node(btree, path, level);
-		BUG_ON(level !=3D nilfs_btree_node_get_level(btree, node));
+		if (nilfs_btree_bad_node(btree, node, level))
+			return -EINVAL;
 		if (!found)
 			found =3D nilfs_btree_node_lookup(btree, node, key,
 							&index);
@@ -540,7 +554,8 @@ static int nilfs_btree_do_lookup_last(const struct nilf=
s_btree *btree,
 		if (ret < 0)
 			return ret;
 		node =3D nilfs_btree_get_nonroot_node(btree, path, level);
-		BUG_ON(level !=3D nilfs_btree_node_get_level(btree, node));
+		if (nilfs_btree_bad_node(btree, node, level))
+			return -EINVAL;
 		index =3D nilfs_btree_node_get_nchildren(btree, node) - 1;
 		ptr =3D nilfs_btree_node_get_ptr(btree, node, index);
 		path[level].bp_index =3D index;
