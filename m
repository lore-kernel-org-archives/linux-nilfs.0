Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234638462;
	Thu, 18 Dec 2025 04:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766031816; cv=none; b=prcM5trK7ejCkUUAo+9ATnsg/sivUGneZlSDw9+eefjeoxffsvu/AZh2eskyhs/WbZMwZyRKwlPxJc27ITE2zyaI6BOR8RgvyS255o8PDP5R5RROzSPPGRXBW1MFVhHKQP4B0tUDd28kaALRDkJCmbdsI+Ost2UjwJsSac3GaCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766031816; c=relaxed/simple;
	bh=o2fwWRUvLCyCJY23fWPB/x4IXUbkZKr7xCSanTtsivA=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=AvnBHBoYbVt1Wt3tZoY9qE2GOaym+4UFNVxq9hTbHoo7ThIJ0MRHJ04E1xTy3t1y25IrSNh5sSAhMmy2iR18WlEtItyXY43VZgiSJcx+vX7qs3pm8grVxblwgDcWCaxPACwQZxN84h+jUNQVgcXLR1yWlCXpPUHdCJBQ0ZlqvVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=kg2uLeyR; arc=none smtp.client-ip=43.163.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="kg2uLeyR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766031805; bh=NuBc5/FdQhIFDLowtPYoDAi02uriL6V614ktstHcl34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kg2uLeyRfByCr73uVn9QjpVtg4up0UEhAqcGTDeC8Lt0QK4PLcPPodybfK5kvjyF8
	 WInwA7IzT1uzBf8PTh6QheL98KyHewc/BcUnOx6U3wqzcQe2eAqpw67UpIX3Re5cwR
	 XWLc1qTUhAVuBEm/bxUVf4gZJvCIT0Hfm+/4XyJ0=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 58F29A4A; Thu, 18 Dec 2025 12:22:15 +0800
X-QQ-mid: xmsmtpt1766031735tncda9oyw
Message-ID: <tencent_62C5D2DF8647899D2EE26EECCC8CA7C44606@qq.com>
X-QQ-XMAILINFO: NPOVshKHDIuieQs4cyVosILCaY2ckeq/hIvInBBEVbgMvTaaAvA6lGhnNtBuD9
	 2Vwc025yezjYi/mQIF2L2jz9rtoneFvKpgAdjl1nSvFLZgLwiPqqug9P7N3omKe3DZxr7ifv64+7
	 HOXlmwaGjTJSxhPcd3Djm/kEn8J69Mc+x/BEsHzfmAJOdnzCFNboYnoKR6VLlI4Je/bZv5PUlr9y
	 jXNuW5mDKGtKL+f4JuwOU03+aYhKLLg+FjcuI0fA/4+k+Uq3EuS7+M8thBE+K9RSZ7X/pg6v5p53
	 uXLhrDvvGyFfEFGKjw4xZw9bm7UJWA1irqVCZrLEAOmYqqKbVyjhi0KSe2sH4FW/Ruujk7e7ahSH
	 Gle9tYbGWBauFKx+8rhQo/ArfMkKj+uEcEjjCoAIrErd+A82knCmgDFVVz1dNHtD3HEzq8t6b7Zu
	 XGe5W/AD1mY7TEasc3IChPnYNiQ5JJ4yz14/ZuUeEimkldX8n+1iH3qvoW/NP9ky8v5QIoQsdaCK
	 RpkgepgicW8Ohp75znmgs7BDIJasdKPncU6vnlz+9wvT9KitG8YGnVgdrmGYSg+IhoiWXb7NNzmT
	 iWOId9WO46zFCD67qYCYZNDF982QnAqxVjR6bhbMGISbtdwUbKmECqW+4JMExJPZWKrkwyAGgJGM
	 mkFYcqL0H4lAXNnPsIOHXQdeHvTFgFGChffqwXmpw0VBK35uHTY267SPoXgmeSD/RuQ+kIdDthi3
	 Btv5C6fZbMAw8xILJNlZVMvph6O4WJGIeL94EpIuhxcmWoE9qkAMbYw+zTQwTa/cVNLC4XA3WqEX
	 8fQwcNbEOnq7ymFMR0hRTsXjDUiDeBqIlAP2Q4xPEkqFGQKHZOUfp2eEfApLLP+f06qeP50U2LFY
	 60vx2/ZPcQKZUAIQuWgu/9x86zScqM76i72BuBYF5fQyZOhrGROpXiMhP5vDr0jEZlaXV/8j+r9g
	 9XYwJNdCBi6/lkejGGIX+2vs71kWWmmi6lbTwFq1ClZygcDeqmnc5Msk3F3FUcD/mD/uBor3e0Ig
	 bM6GeY38MgGMs0xriEiAqQsesnFfuyck2qLKmScxMLiORuzjKh
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Edward Adam Davis <eadavis@qq.com>
To: eadavis@qq.com
Cc: axboe@kernel.dk,
	konishi.ryusuke@gmail.com,
	kristian@klausen.dk,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v3] nilfs2: Fix potential block overflow that cause system hang
Date: Thu, 18 Dec 2025 12:22:15 +0800
X-OQ-MSGID: <20251218042214.73641-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tencent_84D71B07255DBA68BBE733F89E1F1B344B08@qq.com>
References: <tencent_84D71B07255DBA68BBE733F89E1F1B344B08@qq.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a user executes the FITRIM command, an underflow can occur when
calculating nblocks if end_block is too small. Since nblocks is of
type sector_t, which is u64, a negative nblocks value will become a
very large positive integer. This ultimately leads to the block layer
function __blkdev_issue_discard() taking an excessively long time to
process the bio chain, and the ns_segctor_sem lock remains held for a
long period. This prevents other tasks from acquiring the ns_segctor_sem
lock, resulting in the hang reported by syzbot in [1].

If the ending block is too small, for example, smaller than first data
block, this poses a risk of corrupting the filesystem's superblock.
Here, I check if the segment's ending block number is 0 to determine
if the previously calculated ending block is too small.

Although the start and len values in the user input range are too small,
a conservative strategy is adopted here to safely ignore them, which is
equivalent to a no-op; it will not perform any trimming and will not
throw an error.

[1]
task:segctord state:D stack:28968 pid:6093 tgid:6093  ppid:2 task_flags:0x200040 flags:0x00080000
Call Trace:
 rwbase_write_lock+0x3dd/0x750 kernel/locking/rwbase_rt.c:272
 nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2569 [inline]
 nilfs_segctor_thread+0x6ec/0xe00 fs/nilfs2/segment.c:2684

Fixes: 82e11e857be3 ("nilfs2: add nilfs_sufile_trim_fs to trim clean segs")
Reported-by: syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7eedce5eb281acd832f0
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
v2 -> v3: change to segment end check and update comments
v1 -> v2: continue do discard and comments

 fs/nilfs2/sufile.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 83f93337c01b..fa612d5ec726 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1095,6 +1095,8 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 
 	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
 	segnum_end = nilfs_get_segnum_of_block(nilfs, end_block);
+	if (!segnum_end)
+		return 0;
 
 	down_read(&NILFS_MDT(sufile)->mi_sem);
 
-- 
2.43.0

