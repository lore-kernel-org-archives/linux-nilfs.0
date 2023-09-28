From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 85/87] fs: rename i_atime and i_mtime fields to __i_atime and __i_mtime
Date: Thu, 28 Sep 2023 07:05:52 -0400
Message-ID: <20230928110554.34758-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev+bounces-36763-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695899170;
	bh=AhfBjRw4Zieo7d/UWgS6g+DDX4jTgfxPdqjByEx9qhM=;
	h=From:To:Cc:Subject:Date:From;
	b=V+wOzFncXPhDXQFQdHny1CsSK9qUJSENwQ3KCibIzAaql9xTx9HnhDcijW4/7BOtC
	 kszW/YDyA0AMr7XQAUyJiZeb60fme2uDkyobxKoT8cY6VhZHy5eoMPnsaN6X7TtxCq
	 QTaef29MEouz7MkE+tPPdhmCepxFcMdSgkZxMJFkcJInXSuCSMx/JWDM3dr1kZYemo
	 enoSOcU6aqdkN9wSvXmqf6Z9xnaErzYq51O9jQbKnwkBY5wjm/kE01rgGkYxHItLa5
	 5cRJCieL6/r3mfMz8yZQYtWkWaXM39nIwleCYU584hrkq3VtvO021SVUVEZ1qpwd4S
	 nSI/tWahGoeXg==
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-rdma@vger.kernel.org, linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-efi@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, gfs2@lists.linux.dev, linux-um@lists.infradead.org, linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, linux-karma-devel@lists.sourceforge.net, devel@lists.

Make it clear that these fields are private now, and that the accessors
should be used instead.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/fs.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 12d247b82aa0..831657011036 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -671,9 +671,9 @@ struct inode {
 	};
 	dev_t			i_rdev;
 	loff_t			i_size;
-	struct timespec64	i_atime;
-	struct timespec64	i_mtime;
-	struct timespec64	__i_ctime; /* use inode_*_ctime accessors! */
+	struct timespec64	__i_atime; /* use inode_*_atime accessors */
+	struct timespec64	__i_mtime; /* use inode_*_mtime accessors */
+	struct timespec64	__i_ctime; /* use inode_*_ctime accessors */
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
 	unsigned short          i_bytes;
 	u8			i_blkbits;
@@ -1555,13 +1555,13 @@ static inline struct timespec64 inode_set_ctime(struct inode *inode,
 
 static inline struct timespec64 inode_get_atime(const struct inode *inode)
 {
-	return inode->i_atime;
+	return inode->__i_atime;
 }
 
 static inline struct timespec64 inode_set_atime_to_ts(struct inode *inode,
 						      struct timespec64 ts)
 {
-	inode->i_atime = ts;
+	inode->__i_atime = ts;
 	return ts;
 }
 
@@ -1575,13 +1575,13 @@ static inline struct timespec64 inode_set_atime(struct inode *inode,
 
 static inline struct timespec64 inode_get_mtime(const struct inode *inode)
 {
-	return inode->i_mtime;
+	return inode->__i_mtime;
 }
 
 static inline struct timespec64 inode_set_mtime_to_ts(struct inode *inode,
 						      struct timespec64 ts)
 {
-	inode->i_mtime = ts;
+	inode->__i_mtime = ts;
 	return ts;
 }
 
-- 
2.41.0


