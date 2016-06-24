From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/1] fs/nilfs2: Fix potential underflow in call to crc32_le
Date: Fri, 24 Jun 2016 23:29:47 +0900
Message-ID: <1466778587-5184-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1466778587-5184-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=UlMWZemh/Fhc35uj1mgs5ayHHTF5rYjeZ4eJ0K3+Lzg=;
        b=K/163riFH5Kq0hWmTjXqcnfPDJ1QgbTKwRcYpUzdiTaK8i/2A7/xJxUfWFcYeUekvc
         86tB0AB7dotoO2lcokLts0s6bSlLgertme2917GfoJ1LfGf/tRx72M39YIembHzwq1C0
         7gtoFJLIJcXBBHu0m/fqCA5a5c6Q9SHwGDmzexSLcg5upBJUWGgXlXXkTZgargdEjhHX
         /ZDWmPpiYItp/DKZQ2RP2dFsJG0EUMRkWYTp5JDlT1XhjuwRKY6eO5Swz98k0/U3qeLZ
         K0RvyrHGSFAGQYOQN4Uk6qvYC7liyZmu4uq2XFOndGk4WICFN1vcXRQia+DUtZYbhyw2
         EaVw==
In-Reply-To: <1466778587-5184-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Torsten Hilbrich <torsten.hilbrich@secunet.com>

From: Torsten Hilbrich <torsten.hilbrich@secunet.com>

The value bytes comes from the filesystem which is about to be
mounted. We cannot trust that the value is always in the range
we expect it to be.

Check its value before using it to calculate the length for the
crc32_le call. It value must be larger (or equal) sumoff + 4.

This fixes a kernel bug when accidentially mounting an image file
which had the nilfs2 magic value 0x3434 at the right offset 0x406 by
chance. The bytes 0x01 0x00 were stored at 0x408 and were interpreted
as a s_bytes value of 1. This caused an underflow when substracting
sumoff + 4 (20) in the call to crc32_le.

[201699.185465] BUG: unable to handle kernel paging request at
ffff88021e600000
[201699.186111] IP: [<ffffffff814083c6>] crc32_le+0x36/0x100
...
[201699.206202] Call Trace:
[201699.206982]  [<ffffffffc0907492>] nilfs_valid_sb.part.5+0x52/0x60
[nilfs2]
[201699.207773]  [<ffffffffc09075e2>] nilfs_load_super_block+0x142/0x300
[nilfs2]
[201699.208564]  [<ffffffff812479fd>] ? set_blocksize+0x9d/0xd0
[201699.209355]  [<ffffffffc0908020>] init_nilfs+0x60/0x390 [nilfs2]
[201699.210160]  [<ffffffffc08fc962>] nilfs_mount+0x302/0x520 [nilfs2]
[201699.210930]  [<ffffffff811b16a5>] ? pcpu_alloc+0x385/0x670
[201699.211685]  [<ffffffff81210c58>] mount_fs+0x38/0x160
[201699.212413]  [<ffffffff811b19c5>] ? __alloc_percpu+0x15/0x20
[201699.213151]  [<ffffffff8122cbe7>] vfs_kern_mount+0x67/0x110
[201699.213898]  [<ffffffff8122f3b9>] do_mount+0x269/0xe00
[201699.214671]  [<ffffffff8122d5a4>] ? mntput+0x24/0x40
[201699.215432]  [<ffffffff811ef064>] ? __kmalloc_track_caller+0x1b4/0x250
[201699.216207]  [<ffffffff8120eaf0>] ? __fput+0x190/0x220
[201699.216987]  [<ffffffff811ac0e2>] ? memdup_user+0x42/0x70
[201699.217777]  [<ffffffff8123027f>] SyS_mount+0x9f/0x100
[201699.218595]  [<ffffffff81825bf2>] entry_SYSCALL_64_fastpath+0x16/0x71

Signed-off-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Tested-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: stable@vger.kernel.org
---
 fs/nilfs2/the_nilfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 809bd2d..e9fd241 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -439,7 +439,7 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp)
 	if (!sbp || le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC)
 		return 0;
 	bytes = le16_to_cpu(sbp->s_bytes);
-	if (bytes > BLOCK_SIZE)
+	if (bytes < sumoff + 4 || bytes > BLOCK_SIZE)
 		return 0;
 	crc = crc32_le(le32_to_cpu(sbp->s_crc_seed), (unsigned char *)sbp,
 		       sumoff);
-- 
1.8.3.1

