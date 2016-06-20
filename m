From: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCHv3] fs/nilfs2: Fix potential underflow in call to crc32_le
Date: Mon, 20 Jun 2016 09:01:06 +0200
Message-ID: <576794B2.3090000@secunet.com>
References: <5763AF95.7050302@secunet.com>
 <20160618.032507.1597365191396955107.konishi.ryusuke@lab.ntt.co.jp>
 <57677408.1@secunet.com>
 <CAKFNMo=6A9Ns3EDe8PFL+LMX769WdGT39yo-p+Oi7gzPLG3-9w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKFNMo=6A9Ns3EDe8PFL+LMX769WdGT39yo-p+Oi7gzPLG3-9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

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

Signed-off-by: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Tested-by: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 69bd801..37e49cb 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -443,7 +443,7 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp)
 	if (!sbp || le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC)
 		return 0;
 	bytes = le16_to_cpu(sbp->s_bytes);
-	if (bytes > BLOCK_SIZE)
+	if (bytes < sumoff + 4 || bytes > BLOCK_SIZE)
 		return 0;
 	crc = crc32_le(le32_to_cpu(sbp->s_crc_seed), (unsigned char *)sbp,
 		       sumoff);
-- 
2.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
