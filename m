From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mkfs: check sizes of important structs at build time
Date: Sat,  4 Jan 2014 22:29:31 +0900
Message-ID: <1388842171-16105-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=fKA4EvSg1MCzkUnivjCNuzFOV2tS2WyKJnDJUbNt5/U=;
        b=UkkKt3swLfQ9cy4q5tP+0WpO/RwZVc/0rxyZDP9KxAuDKYWpYe4K261AGzbRFocDRr
         OLmnxv7zssp42SupWVXwHEteMTsHrMeaZMQcogkvQfO5zr3ICFnvi6/SqT8SVJ9HaGHH
         jyr3qUrsHfkN6heImffSckyfhx4MAqHnDu3Avs64h/yaW2LJVGZ5fqB6xK8FJnJL00m0
         ejIaseHcvwK81mwZh3mwS3OJWIB1xxk8uqj27XgkKp5g7nWBF1cBF4UyzwV5JWX4WOOo
         Qg/je9adr/DUA0a3xQDkMFec5NEfNvAF9vFCRHsfnCBF82acqvEsr4UsuXEv+LuPXpNO
         deqQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Current nilfs_check_ondisk_sizes() checks sizes of important structs
at run time. The checking should be done at build time. This patch
adds a new macro, BUILD_BUG_ON(), for this purpose. It is similar to
static_assert() of C++11. If an argument is true, the macro causes a
bulid error.

Below is an example of BUILD_BUG_ON(). When the checked conditions are
true like below:

/* intentional change for testing BUILD_BUG_ON() */

static __attribute__((used)) void nilfs_check_ondisk_sizes(void)
{
	BUILD_BUG_ON(sizeof(struct nilfs_inode) > NILFS_MIN_BLOCKSIZE);
...

build process of mkfs.o causes errors like this:

gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I../..  -I../../include  -Wall -g -O2 -MT mkfs.o -MD -MP -MF .deps/mkfs.Tpo -c -o mkfs.o mkfs.c
mkfs.c: In function 'nilfs_check_ondisk_sizes':
mkfs.c:429:2: error: negative width in bit-field '<anonymous>'
mkfs.c:430:2: error: negative width in bit-field '<anonymous>'
mkfs.c:431:2: error: negative width in bit-field '<anonymous>'
mkfs.c:432:2: error: negative width in bit-field '<anonymous>'
mkfs.c:433:2: error: negative width in bit-field '<anonymous>'
mkfs.c:434:2: error: negative width in bit-field '<anonymous>'
mkfs.c:435:2: error: negative width in bit-field '<anonymous>'

Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mkfs/mkfs.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 4e153ce..8eb00bf 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -85,6 +85,9 @@
 typedef __u64  blocknr_t;
 
 #define BUG_ON(x)	   assert(!(x))
+/* Force a compilation error if the condition is true */
+#define BUILD_BUG_ON(condition) ((void)sizeof(struct { int: -!!(condition); }))
+
 #define ROUNDUP_DIV(n, m)	(((n) - 1) / (m) + 1)
 #define max_t(type, x, y) \
 	({ type __x = (x); type __y = (y); __x > __y ? __x : __y; })
@@ -417,16 +420,15 @@ static unsigned count_dat_blocks(unsigned nr_dat_entries)
 	return nblocks;
 }
 
-static void nilfs_check_ondisk_sizes(void)
+static __attribute__((used)) void nilfs_check_ondisk_sizes(void)
 {
-	if (sizeof(struct nilfs_inode) > NILFS_MIN_BLOCKSIZE ||
-	    sizeof(struct nilfs_sufile_header) > NILFS_MIN_BLOCKSIZE ||
-	    sizeof(struct nilfs_segment_usage) > NILFS_MIN_BLOCKSIZE ||
-	    sizeof(struct nilfs_cpfile_header) > NILFS_MIN_BLOCKSIZE ||
-	    sizeof(struct nilfs_checkpoint) > NILFS_MIN_BLOCKSIZE ||
-	    sizeof(struct nilfs_dat_entry) > NILFS_MIN_BLOCKSIZE ||
-	    sizeof(struct nilfs_super_root) > NILFS_MIN_BLOCKSIZE)
-		perr("Internal error: too large on-disk structure");
+	BUILD_BUG_ON(sizeof(struct nilfs_inode) > NILFS_MIN_BLOCKSIZE);
+	BUILD_BUG_ON(sizeof(struct nilfs_sufile_header) > NILFS_MIN_BLOCKSIZE);
+	BUILD_BUG_ON(sizeof(struct nilfs_segment_usage) > NILFS_MIN_BLOCKSIZE);
+	BUILD_BUG_ON(sizeof(struct nilfs_cpfile_header) > NILFS_MIN_BLOCKSIZE);
+	BUILD_BUG_ON(sizeof(struct nilfs_checkpoint) > NILFS_MIN_BLOCKSIZE);
+	BUILD_BUG_ON(sizeof(struct nilfs_dat_entry) > NILFS_MIN_BLOCKSIZE);
+	BUILD_BUG_ON(sizeof(struct nilfs_super_root) > NILFS_MIN_BLOCKSIZE);
 }
 
 static unsigned long
@@ -523,8 +525,6 @@ static void init_disk_layout(struct nilfs_disk_info *di, int fd,
 		     "or shorten segments with -B option.", dev_size,
 		     (unsigned long long)segment_size * min_nsegments);
 	di->nseginfo = 0;
-
-	nilfs_check_ondisk_sizes();
 }
 
 static struct nilfs_segment_info *new_segment(struct nilfs_disk_info *di)
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
