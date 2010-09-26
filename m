From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs-utils: add missing error check on nilfs_sb_write
Date: Sun, 26 Sep 2010 22:48:01 +0900
Message-ID: <1285508881-6138-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_sb_write() function does not see the return value of write()
system call, thus it may incur silent failure problem.

This fixes the issue and kills the following warning.

sb.c: In function =A1=C6nilfs_sb_write=A1=C7:
sb.c:206: warning: ignoring return value of =A1=C6write=A1=C7, declared=
 with attribute warn_unused_result

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/sb.c                     |   15 +++++++++++----
 sbin/nilfs-tune/nilfs-tune.c |   10 +++++++---
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/lib/sb.c b/lib/sb.c
index 293cd6f..d93504c 100644
--- a/lib/sb.c
+++ b/lib/sb.c
@@ -171,7 +171,8 @@ int nilfs_sb_write(int devfd, struct nilfs_super_bl=
ock *sbp, int mask)
 {
 	__u64 offsets[2];
 	struct nilfs_super_block *sbps[2];
-	int i;
+	ssize_t count;
+	int i, ret;
 	__u32 crc;
=20
 	assert(devfd >=3D 0);
@@ -182,6 +183,7 @@ int nilfs_sb_write(int devfd, struct nilfs_super_bl=
ock *sbp, int mask)
 	if (__nilfs_sb_read(devfd, sbps, offsets))
 		return -1;
=20
+	ret =3D 0;
 	for (i =3D 0; i < 2; i++) {
 		if (!sbps[i])
 			continue;
@@ -202,12 +204,17 @@ int nilfs_sb_write(int devfd, struct nilfs_super_=
block *sbp, int mask)
=20
 		crc =3D nilfs_sb_check_sum(sbps[i]);
 		sbps[i]->s_sum =3D cpu_to_le32(crc);
-		if (lseek(devfd, offsets[i], SEEK_SET) > 0)
-			write(devfd, sbps[i], NILFS_MAX_SB_SIZE);
+		if (lseek(devfd, offsets[i], SEEK_SET) > 0) {
+			count =3D write(devfd, sbps[i], NILFS_MAX_SB_SIZE);
+			if (count < NILFS_MAX_SB_SIZE) {
+				ret =3D -1;
+				break;
+			}
+		}
 	}
=20
 	free(sbps[0]);
 	free(sbps[1]);
=20
-	return 0;
+	return ret;
 }
diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.=
c
index f9e46a1..f5d5d83 100644
--- a/sbin/nilfs-tune/nilfs-tune.c
+++ b/sbin/nilfs-tune/nilfs-tune.c
@@ -434,9 +434,13 @@ int modify_nilfs(char *device, struct nilfs_tune_o=
ptions *opts)
 	if (opts->mask & NILFS_SB_BLOCK_MAX)
 		sbp->s_c_block_max =3D cpu_to_le32(opts->c_block_max);
=20
-	if (opts->mask)
-		nilfs_sb_write(devfd, sbp, opts->mask);
-
+	if (opts->mask) {
+		if (nilfs_sb_write(devfd, sbp, opts->mask) < 0) {
+			fprintf(stderr, "%s: cannot write super blocks\n",
+				device);
+			ret =3D EXIT_FAILURE;
+		}
+	}
 	if (opts->display)
 		show_nilfs_sb(sbp);
=20
--=20
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
