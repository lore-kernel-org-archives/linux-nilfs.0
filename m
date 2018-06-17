From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 02/74] radix tree test suite: Enable ubsan
Date: Sat, 16 Jun 2018 18:59:40 -0700
Message-ID: <20180617020052.4759-3-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nEu/iSteNkAMtQpngBIONZNFiPmqdnQM7MosSEs/KsA=; b=kODSpXqayiCTcEDvEYp/du24p
        sHIETX/XLFNJ2x1FtUmzvI+5AhfyICUN1P1iIrKcZZq4YS2bTVrtulRcevE++kOxNSgE9liMK3r6y
        B9W1fyERkDG3EG57hLYrOLC9W9mM/T7XuEPCz5XHayZU28oZAyZy7s45OyHux0Y21ru2/DpO/Jhnr
        g88/XZN1qYipFNG/U74ZdF/zfrUkcn4xC3+So1vXqrCuTT1sbApIxqGcXNvJG+Ue1lPgZGfVkkbGy
        kWfqitaQrO3YxVqhDCbghShp5VcdY/qCIG3Cux4b4pP7GOw9uWh5m4qlogtT4/tkCou/hCmpF0b8C
    
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

Add support for the undefined behaviour sanitizer and fix the bugs
that ubsan pointed out.  Nothing major, and all in the test suite,
not the code.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 tools/testing/radix-tree/Makefile |  5 +++--
 tools/testing/radix-tree/main.c   | 20 +++++++++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/tools/testing/radix-tree/Makefile b/tools/testing/radix-tree/Makefile
index db66f8a0d4be..da030a65d6d6 100644
--- a/tools/testing/radix-tree/Makefile
+++ b/tools/testing/radix-tree/Makefile
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address
-LDFLAGS += -fsanitize=address
+CFLAGS += -I. -I../../include -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address \
+	  -fsanitize=undefined
+LDFLAGS += -fsanitize=address -fsanitize=undefined
 LDLIBS+= -lpthread -lurcu
 TARGETS = main idr-test multiorder
 CORE_OFILES := radix-tree.o idr.o linux.o test.o find_bit.o
diff --git a/tools/testing/radix-tree/main.c b/tools/testing/radix-tree/main.c
index 257f3f8aacaa..584a8732f5ce 100644
--- a/tools/testing/radix-tree/main.c
+++ b/tools/testing/radix-tree/main.c
@@ -27,20 +27,22 @@ void __gang_check(unsigned long middle, long down, long up, int chunk, int hop)
 		item_check_present(&tree, middle + idx);
 	item_check_absent(&tree, middle + up);
 
-	item_gang_check_present(&tree, middle - down,
-			up + down, chunk, hop);
-	item_full_scan(&tree, middle - down, down + up, chunk);
+	if (chunk > 0) {
+		item_gang_check_present(&tree, middle - down, up + down,
+				chunk, hop);
+		item_full_scan(&tree, middle - down, down + up, chunk);
+	}
 	item_kill_tree(&tree);
 }
 
 void gang_check(void)
 {
-	__gang_check(1 << 30, 128, 128, 35, 2);
-	__gang_check(1 << 31, 128, 128, 32, 32);
-	__gang_check(1 << 31, 128, 128, 32, 100);
-	__gang_check(1 << 31, 128, 128, 17, 7);
-	__gang_check(0xffff0000, 0, 65536, 17, 7);
-	__gang_check(0xfffffffe, 1, 1, 17, 7);
+	__gang_check(1UL << 30, 128, 128, 35, 2);
+	__gang_check(1UL << 31, 128, 128, 32, 32);
+	__gang_check(1UL << 31, 128, 128, 32, 100);
+	__gang_check(1UL << 31, 128, 128, 17, 7);
+	__gang_check(0xffff0000UL, 0, 65536, 17, 7);
+	__gang_check(0xfffffffeUL, 1, 1, 17, 7);
 }
 
 void __big_gang_check(void)
-- 
2.17.1

