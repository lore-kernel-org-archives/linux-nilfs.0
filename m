Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19DC325731;
	Thu, 18 Dec 2025 11:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766058506; cv=none; b=A7A5EH8CKZ/+FlPf2m0hI/r9IbIhNVsQwUNFHGp+GdU+CBt1jW4EZjhPqG99hsJxGxqGgLiEmvF30H2vhvldDNJIIO1BTF26HLktcAeylDwsc6ERPMvGCGwQEArhIjxrfeZHc3H/2LwHOzuUUczfjv4m2qS/buU0ZlBNkEtAgXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766058506; c=relaxed/simple;
	bh=t8qlL365LSQ1+zj+dlSAxFDR4N5xm4Cz6wSkfwYuoew=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=DNw6aQbExMzByAgxQ1UwQl+kxjmsw64fN/1hLwdbCYRFNv6faKTJaIjz5V1vYGYvBbE7mu/qs37QJmsfXFUgHzQHyveidbGLAcXoF3XAZK4ypJY6zs9ammpBT1lxe2uYaYt7SNAoUDu2uICMv/uQZaaPj009wjTHlvlF5NrnaAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=WKp1MUxh; arc=none smtp.client-ip=203.205.221.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="WKp1MUxh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766058499; bh=+LZtWvKrka5rCT3szD0AzdM97HzCHLDy+n0zBrpmQDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKp1MUxhhbUIgeVQpkoL7TQlPdgWyRkNE4j+n8RM3tVwHxgVo+ox2BAEDj7JmY6ud
	 N0FtjJMKpTqxD2RLMZQBn86CDCNlTBKhKxWHNSeymLy0e/hiSUpTTS+0UUE6cCrfsm
	 /F0XkQmGeX6wCsDZxrHA9oDOQmkMPEoO8HgSuut4=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id C110F45C; Thu, 18 Dec 2025 19:48:17 +0800
X-QQ-mid: xmsmtpt1766058497thq9mhj28
Message-ID: <tencent_DD9A67C7C6F012DAC64B49AF6EF0EED98C06@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJ8TvO/XAwawREVgKaqMga1LpqtZCVD/yo0dCTINlf/zkqrw4ke7
	 sGKVuX+kJCAZV+CFboejF+04pJ7eH3/33pJVY90q/7m65h8ux1z/eKb97fW2yIkbtxMKHs77bcDN
	 1+Smiiimla1ZA1RX0aHYmemCOrOhY50ESLTr4suxHjC3Fc3iKiaUIa1OBYIx1d5Hq8hEgIBtcW3Q
	 LRZvV0Euyqgd7ODxfw+kmFPc1WODDPFtE45f1kSp7mw3iPpT19Q72UbGG7JzbbLCw+QBB9jKcVWD
	 UM1BMo56B4/veIh/OIAq2Jzh2yk3/+ViM4YnQhGnVaY295yg5VIhxu/L9mGxGd0LOzQczhUKLQdq
	 Tls9D7BJhxZOwYtAeQxVYMprznihwQgB91GS6j9MR+wWr0wD22Z0IW2J7Jr+PRFrwV2oy1Q5+wsv
	 9jNtv1o7Rl7y/oVBoiMoxgxNWNxq18g1Ng0Nit8Rnzr4M1nuQ+lXI4ag59N0VcYN9Z4JS9ju0b/f
	 GumxPfigWkYCo5PDhS8CNG1XVgVaPy/fkpxcAjJS1aSfoEk+vlibEbExOahKckZKd6Mn05C2b1Nq
	 hl12SuhHUQ/X6O1z/soznM8kQEJXxQbkK7MycSu3g6/p+nzusur1moiexxxzL9X1bWis89PmXPE1
	 9SRrZcLHmkvzkienlHLIeDG+JVM/uo1iiO8mGfsbsOZj7tu7ibG9Hv3zfX9ZUZkeNa2Md9iC3I0m
	 fvk/Rq64J41JI5d+ry8eQ4Q/I2PktsG6W4NL+hXgUEmhBgpdgh9YXOrWplDGg4A4NX9Cg38dokkv
	 pHCLB0usljre4tgh+Y5fWcl6pfHZefyvrjdB4ZX9Ve8KmI3SHzwOI/IhewPBcFcGtFWafRSyGXu5
	 gpQTvF+Yero+SYo8Jdgag+Z2fi2kbLgpv8juVSCdebE0RVndlSyLccZOocjozGzYbS4WiG+TaP20
	 2MW/leQ+MJ692SwRJlmGbjjEbpcNZYESmoigUhGMomIXm/AzjVe5O/jeGMcXdaOjXbrNoprgZxYq
	 23wH5q7YryLcDSP0jLye9q51uFMPaZ0peUWd5xoA==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Edward Adam Davis <eadavis@qq.com>
To: konishi.ryusuke@gmail.com
Cc: axboe@kernel.dk,
	eadavis@qq.com,
	kristian@klausen.dk,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v4] nilfs2: Fix potential block overflow that cause system hang
Date: Thu, 18 Dec 2025 19:48:17 +0800
X-OQ-MSGID: <20251218114816.89612-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAKFNMomckE-AKyZE5jJvKPn9-fWSEncqMPX=PP+cr3j6y==yDg@mail.gmail.com>
References: <CAKFNMomckE-AKyZE5jJvKPn9-fWSEncqMPX=PP+cr3j6y==yDg@mail.gmail.com>
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
v3 -> v4: check end block and first data block
v2 -> v3: change to segment end check and update comments
v1 -> v2: continue do discard and comments

 fs/nilfs2/sufile.c | 3 ++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 83f93337c01b..5d7cbd26a910 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1093,6 +1093,9 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 	else
 		end_block = start_block + len - 1;
 
+	if (end_block < nilfs->ns_first_data_block)
+		return 0;
+
 	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
 	segnum_end = nilfs_get_segnum_of_block(nilfs, end_block);
 
-- 
2.43.0

