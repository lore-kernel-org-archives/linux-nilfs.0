From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 14/22] nilfs2: use little-endian bitops
Date: Thu, 21 Oct 2010 23:41:09 +0900
Message-ID: <1287672077-5797-15-git-send-email-akinobu.mita@gmail.com>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:from:to:cc:subject:date
         :message-id:x-mailer:in-reply-to:references;
        bh=4VninYjU5kAjdqSUOpgl0RBdNursUXCCJrrd2RW+41I=;
        b=LvAYL88gYkMjgNOGMyhEAP1iyc6bK4T5FaxWGKPoqfI9/aoQBqX3NGjaB93FDXgFyK
         j6Yu0JTJsyY98zMX/SdFLMgalLtWS6semzTdyFdWzCQqZYK19syEjVkWEGLO4cMb1r/+
         rrtKEh8mIdPnYTO8SLeYUgoqwcRvjefX6knQ4=
In-Reply-To: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h. This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org
---
No change from previous submission

 fs/nilfs2/alloc.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 9af34a7..a2463e2 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -74,7 +74,8 @@ int nilfs_palloc_freev(struct inode *, __u64 *, size_t);
 
 #define nilfs_set_bit_atomic		ext2_set_bit_atomic
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
-#define nilfs_find_next_zero_bit	ext2_find_next_zero_bit
+#define nilfs_find_next_zero_bit(addr, size, off)	\
+	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
 
 /*
  * persistent object allocator cache
-- 
1.7.1.231.gd0b16
