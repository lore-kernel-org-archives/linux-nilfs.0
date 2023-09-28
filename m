From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 01/87] fs: new accessor methods for atime and mtime
Date: Thu, 28 Sep 2023 07:03:00 -0400
Message-ID: <20230928110300.32891-2-jlayton@kernel.org>
References: <20230928110300.32891-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf+bounces-11035-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695899012;
	bh=2HU082C0O+wshN8razE9iX9Rxehg6mRJCvsU5n9rFmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgJqBVdgRTRGPcB9AYO9nuxbQNU/aRFlsoq2/9IfdhTUxto7jaIgTs2iK3Hh6VNmI
	 PQNGXum64iBmE5gmxTB5fzhsNqjzKt2sLpABU1iY4QR3sLG/3TAi2tRkz3bK5NdR2Q
	 5J/x2S1ciuMIVP8CxOGFxyla+hxGROy5UoKNIuzR78QFdYK0UlmPcZ7xnSW65TY0z1
	 d09jqnFZdRWx08/ZfFzae3DcpVgwGYgcj94ylvD+5VeIqKKaZOw2/kkGfhLURz1SoJ
	 LecijjrtKtsZor5I1BxBnr+8zBdASh0oRnrtfNreKI0opyGPJWi1hjF5WHyNrggNrR
	 Xz99F3TmopI2w==
In-Reply-To: <20230928110300.32891-1-jlayton@kernel.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-rdma@vger.kernel.org, linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-efi@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, gfs2@lists.linux.dev, linux-um@lists.infradead.org, linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, linux-karma-devel@lists.sourceforge.net, devel@lists.

Recently, we converted the ctime accesses in the kernel to use new
accessor functions. Linus recently pointed out though that if we add
accessors for the atime and mtime, then that would allow us to
seamlessly change how these timestamps are stored in the inode.

Add new accessor functions for the atime and mtime that mirror the
accessors for the ctime.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/libfs.c         | 13 +++++++++++++
 include/linux/fs.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index 37f2d34ee090..f5cdc7f7f5b5 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1912,3 +1912,16 @@ ssize_t direct_write_fallback(struct kiocb *iocb, struct iov_iter *iter,
 	return direct_written + buffered_written;
 }
 EXPORT_SYMBOL_GPL(direct_write_fallback);
+
+/**
+ * simple_inode_init_ts - initialize the timestamps for a new inode
+ * @inode: inode to be initialized
+ *
+ * When a new inode is created, most filesystems set the timestamps to the
+ * current time. Add a helper to do this.
+ */
+struct timespec64 simple_inode_init_ts(struct inode *inode);
+{
+	return inode->i_atime = inode->i_mtime = inode_set_ctime_current(inode);
+}
+EXPORT_SYMBOL(simple_inode_init_ts);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b528f063e8ff..12d247b82aa0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1553,6 +1553,48 @@ static inline struct timespec64 inode_set_ctime(struct inode *inode,
 	return inode_set_ctime_to_ts(inode, ts);
 }
 
+static inline struct timespec64 inode_get_atime(const struct inode *inode)
+{
+	return inode->i_atime;
+}
+
+static inline struct timespec64 inode_set_atime_to_ts(struct inode *inode,
+						      struct timespec64 ts)
+{
+	inode->i_atime = ts;
+	return ts;
+}
+
+static inline struct timespec64 inode_set_atime(struct inode *inode,
+						time64_t sec, long nsec)
+{
+	struct timespec64 ts = { .tv_sec  = sec,
+				 .tv_nsec = nsec };
+	return inode_set_atime_to_ts(inode, ts);
+}
+
+static inline struct timespec64 inode_get_mtime(const struct inode *inode)
+{
+	return inode->i_mtime;
+}
+
+static inline struct timespec64 inode_set_mtime_to_ts(struct inode *inode,
+						      struct timespec64 ts)
+{
+	inode->i_mtime = ts;
+	return ts;
+}
+
+static inline struct timespec64 inode_set_mtime(struct inode *inode,
+						time64_t sec, long nsec)
+{
+	struct timespec64 ts = { .tv_sec  = sec,
+				 .tv_nsec = nsec };
+	return inode_set_mtime_to_ts(inode, ts);
+}
+
+struct timespec64 simple_inode_init_ts(struct inode *inode);
+
 /*
  * Snapshotting support.
  */
-- 
2.41.0


