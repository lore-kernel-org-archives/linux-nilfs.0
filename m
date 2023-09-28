From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 87/87] fs: move i_blocks up a few places in struct inode
Date: Thu, 28 Sep 2023 07:05:54 -0400
Message-ID: <20230928110554.34758-3-jlayton@kernel.org>
References: <20230928110554.34758-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf+bounces-11040-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695899200;
	bh=KcEb7Ur9VnfCswhdPaiHlW6A+8Un/231FkVSjN0vVmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIvJMQV9gV0uW8yl32NSd4yb2599TLMQSz3pZ7A8RvzTMK+/pPweiGT83QuRE6Ap1
	 RJ4tHrEtdELF24JEcAXBlbRxCLgD4fFKMvaVxDYJKFUi3JGR08fTlWqCpRUQLEU1eL
	 PLdctIni/gLihdwFGrq6SVBHRpLIcoURicUh3JGLAt4t51ztAQPhDNYHtf1HHGTOrp
	 XAB3XmZIrDME0ElXf57Dd8FtxB0Uiap7czp3ZlR45ObMUeHSnxd6fREH7G/U4RgfCh
	 xv1/nw1L9/w3ErqEe74BXlZqblyXh/mVR1R03Etd6mg/RnXyu8EBj+lRYoEkTAJg+R
	 yYzEQo7GNicAA==
In-Reply-To: <20230928110554.34758-1-jlayton@kernel.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-rdma@vger.kernel.org, linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-efi@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, gfs2@lists.linux.dev, linux-um@lists.infradead.org, linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, linux-karma-devel@lists.sourceforge.net, devel@lists.

The recent change to use discrete integers instead of struct timespec64
in struct inode shaved 8 bytes off of it, but it also moves the i_lock
into the previous cacheline, away from the fields that it protects.

Move i_blocks up above the i_lock, which moves the new 4 byte hole to
just after the timestamps, without changing the size of the structure.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index de902ff2938b..3e0fe0f52e7c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -677,11 +677,11 @@ struct inode {
 	u32			i_atime_nsec;
 	u32			i_mtime_nsec;
 	u32			i_ctime_nsec;
+	blkcnt_t		i_blocks;
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
 	unsigned short          i_bytes;
 	u8			i_blkbits;
 	u8			i_write_hint;
-	blkcnt_t		i_blocks;
 
 #ifdef __NEED_I_SIZE_ORDERED
 	seqcount_t		i_size_seqcount;
-- 
2.41.0


