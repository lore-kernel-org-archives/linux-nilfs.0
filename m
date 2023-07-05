From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 92/92] fs: rename i_ctime field to __i_ctime
Date: Wed,  5 Jul 2023 14:58:12 -0400
Message-ID: <20230705185812.579118-4-jlayton__2976.37979253835$1688583604$gmane$org@kernel.org>
References: <20230705185812.579118-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688583567;
        bh=upDmKDv+6xjSiy7POdUF+8WFopDSBgqOL9aHcGqhK2Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lcNGsVlnIbVft2o9WVSu7oStzcC7UruKn4c1DTBWmjGO00DNBCt3+ZZxjK6miMMj/
         GBdLPvZ/RE2acwmtA26p1q8MtPtZ6AFXE1afuhwSlwu52+nzTrcPM9ox138DUXq3pP
         a+auUEyCQ5+EySj5vT4AGLwnwLHJre6WjBG5uo1Fk/D4NwBI39aiCvuIo2r0b4YzkK
         eGFkZHIr8aozqfMt+EZCLKVtueQinWQYpN5V9F3hby1Tiu5AXVWEdS37dhPfamlHdD
         XsiVC3GdeisubCKxKkTGzRJBTmma2JIDfH5g8iF/7cOUhrr8m/tq4qK4hAP5wOyo8R
         g+tGtW7J9HY7Q==
In-Reply-To: <20230705185812.579118-1-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, christophe.leroy-2tlSp11Fh4xulxpn9UvDqw@public.gmane.org, hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bwarrum-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, rituagar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, ericvh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org, asmadeus-9aU+PIKW3UvdtAWm4Da02A@public.gmane.org, linux_oss-kKOvUW9iAPtl57MIdRCFDg@public.gmane.org, dsterba-IBi9RG/b67k@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, marc.dionne-hRzEac23uH1Wk0Htik3J/w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org, luisbg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, salah.triki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aivazian.tigran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, kees

Now that everything in-tree is converted to use the accessor functions,
rename the i_ctime field in the inode to discourage direct access.

Signed-off-by: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/fs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 14e38bd900f1..b66442f91835 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -642,7 +642,7 @@ struct inode {
 	loff_t			i_size;
 	struct timespec64	i_atime;
 	struct timespec64	i_mtime;
-	struct timespec64	i_ctime;
+	struct timespec64	__i_ctime; /* use inode_*_ctime accessors! */
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
 	unsigned short          i_bytes;
 	u8			i_blkbits;
@@ -1485,7 +1485,7 @@ struct timespec64 inode_set_ctime_current(struct inode *inode);
  */
 static inline struct timespec64 inode_get_ctime(const struct inode *inode)
 {
-	return inode->i_ctime;
+	return inode->__i_ctime;
 }
 
 /**
@@ -1498,7 +1498,7 @@ static inline struct timespec64 inode_get_ctime(const struct inode *inode)
 static inline struct timespec64 inode_set_ctime_to_ts(struct inode *inode,
 						      struct timespec64 ts)
 {
-	inode->i_ctime = ts;
+	inode->__i_ctime = ts;
 	return ts;
 }
 
-- 
2.41.0

