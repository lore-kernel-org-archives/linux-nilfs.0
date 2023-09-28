From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete integers
Date: Thu, 28 Sep 2023 07:05:53 -0400
Message-ID: <20230928110554.34758-2-jlayton@kernel.org>
References: <20230928110554.34758-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev+bounces-36764-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695899185;
	bh=EREGf1zcL5EA1z4Sr1OlKcRcr7XPDG3rng7QCUAKDtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFxyq+wI82J/WQ/3LWfsBekhh8OiaT2wYsSAjrDQk/NrGOURDgw5PWuMWCgk6npZ6
	 gYLI9nWuVeVxeze31PlhCET+PdMZY70Xy9a1ckPrunnaxH93RrMhwAf8QKEfxBAiMW
	 A3cOqQLFufYccE9l6906MspLgdIVzFHYGgIdgAYxkIU2uPLpvYnElaoBbxLu/GOElz
	 nfJ0kqX0lpMPX7fozYTYh3xQ6uUVAew7yxgjGjuRy8Oehoifs61PNFQPPpZBViM2G3
	 Q4xpsOM8kKsqE0iTJbEpoU+nreDJHiQfBK4Xqt/1AbCybTiYxp8gYPp3ucvOuJLoxK
	 YlW0JpzEkcqqQ==
In-Reply-To: <20230928110554.34758-1-jlayton@kernel.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-rdma@vger.kernel.org, linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-efi@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, gfs2@lists.linux.dev, linux-um@lists.infradead.org, linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, linux-karma-devel@lists.sourceforge.net, devel@lists.

This shaves 8 bytes off struct inode, according to pahole.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/fs.h | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 831657011036..de902ff2938b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -671,9 +671,12 @@ struct inode {
 	};
 	dev_t			i_rdev;
 	loff_t			i_size;
-	struct timespec64	__i_atime; /* use inode_*_atime accessors */
-	struct timespec64	__i_mtime; /* use inode_*_mtime accessors */
-	struct timespec64	__i_ctime; /* use inode_*_ctime accessors */
+	time64_t		i_atime_sec;
+	time64_t		i_mtime_sec;
+	time64_t		i_ctime_sec;
+	u32			i_atime_nsec;
+	u32			i_mtime_nsec;
+	u32			i_ctime_nsec;
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
 	unsigned short          i_bytes;
 	u8			i_blkbits;
@@ -1519,7 +1522,9 @@ struct timespec64 inode_set_ctime_current(struct inode *inode);
  */
 static inline struct timespec64 inode_get_ctime(const struct inode *inode)
 {
-	return inode->__i_ctime;
+	struct timespec64 ts = { .tv_sec  = inode->i_ctime_sec,
+				 .tv_nsec = inode->i_ctime_nsec };
+	return ts;
 }
 
 /**
@@ -1532,7 +1537,8 @@ static inline struct timespec64 inode_get_ctime(const struct inode *inode)
 static inline struct timespec64 inode_set_ctime_to_ts(struct inode *inode,
 						      struct timespec64 ts)
 {
-	inode->__i_ctime = ts;
+	inode->i_ctime_sec = ts.tv_sec;
+	inode->i_ctime_nsec = ts.tv_sec;
 	return ts;
 }
 
@@ -1555,13 +1561,17 @@ static inline struct timespec64 inode_set_ctime(struct inode *inode,
 
 static inline struct timespec64 inode_get_atime(const struct inode *inode)
 {
-	return inode->__i_atime;
+	struct timespec64 ts = { .tv_sec  = inode->i_atime_sec,
+				 .tv_nsec = inode->i_atime_nsec };
+
+	return ts;
 }
 
 static inline struct timespec64 inode_set_atime_to_ts(struct inode *inode,
 						      struct timespec64 ts)
 {
-	inode->__i_atime = ts;
+	inode->i_atime_sec = ts.tv_sec;
+	inode->i_atime_nsec = ts.tv_sec;
 	return ts;
 }
 
@@ -1575,13 +1585,17 @@ static inline struct timespec64 inode_set_atime(struct inode *inode,
 
 static inline struct timespec64 inode_get_mtime(const struct inode *inode)
 {
-	return inode->__i_mtime;
+	struct timespec64 ts = { .tv_sec  = inode->i_mtime_sec,
+				 .tv_nsec = inode->i_mtime_nsec };
+
+	return ts;
 }
 
 static inline struct timespec64 inode_set_mtime_to_ts(struct inode *inode,
 						      struct timespec64 ts)
 {
-	inode->__i_mtime = ts;
+	inode->i_atime_sec = ts.tv_sec;
+	inode->i_atime_nsec = ts.tv_sec;
 	return ts;
 }
 
-- 
2.41.0


