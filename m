Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF31335BD5;
	Wed, 17 Dec 2025 08:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765961024; cv=none; b=TrjaOTXgtR+knmmfag5K7F/Rm/5caG4XAiyyoBrTN7rRG+5gKZ/D79NVu/uQGInZucHa8UD7fxysLiXJQKuO5C2G2JPzVvB1aBIte2Bq/bKO1LO+jd/L5+QhI5d+Maq2zqkKz096PrLRVWsQzfI/G5CT33xemGZcMJ16uIVBYYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765961024; c=relaxed/simple;
	bh=maAAEFs+iip+5ax/0hov5jaUJyGLBG76106Q3Hi0Xgg=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=oshWByOMjM+x2fpHi/NhmVf4JQYO3ixiXRubTT++HYvEef585HrD35qykcl9i7L1JcOoViuIRW41r+Q0xaxGnTS676MnooFTMwpNO+PCRieNJ9t51HW04Xs6ObeJ7+oOl3tzfqlpW2sIQn9exBpbnzndreCeY4pcHi3b4NohXCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=YESviPX9; arc=none smtp.client-ip=203.205.221.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="YESviPX9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765961018; bh=WxOHD86HkGBnO7zRKWTj+1LKXx4v1ckRiBonkrWtILc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YESviPX9rwBlFIHuFxV/fvg/Po7IrDmwsSqngjgh4bBrpsepcRib0J0IhlUt1qLja
	 NzcwCFBzfUKtP8KipyvP9LTlXSTUeTeQUIjy8YWJnYRoSja7bxTUsWJW8taDmu/jfp
	 0EDQQdJHo+z+d/htfohzSf24X4B4GXVWu3hmXT9Y=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id AE2A3CF6; Wed, 17 Dec 2025 16:43:34 +0800
X-QQ-mid: xmsmtpt1765961014tglpc23ao
Message-ID: <tencent_9DB079AA6FCC2CB56C2494E0EB32EC26CF0A@qq.com>
X-QQ-XMAILINFO: MJf32pulH481sYFU+dROQ9gJnW/xIQdzI4tJKSeixkr5uu7aP4TiDGDKTsB2K+
	 gwK8yCqJoxyn8cJU1PETYr/jPP8UtwkMiMW96JbBq+936Z5CQKLRK5I1us3OErZMbKJWgMw++HWf
	 yK4sATcboOo759XdAFuLsSKnvZeO2Nc0Vq7zwGDLe4Mmx6QPRhIz64URfhx08veT0c8u8VGNHOGG
	 u3I/aml1iM53w1Rng9JfJ6g5pS9uxwhDiSlnwH+aUCk/odqrottYVS/4wumDylyPERgEqawJS/ah
	 gYS/8ZvP41AVAk3ImmVSXVXyn1Ch6VuBRMzCjQBwGnggGYi5J5BPRMQV90UNQG823vI6fJCFYmhq
	 QcxKS4PligwI7RSrjjglIFxlxBGNzNdSGOiWT2i+XXKccT4WvaJF8GHOgkT4HUgX5/i5lyHDor/t
	 VT3oiw5SFPZr0ZQz8PYZPGMXpg8lXrKfu8x3j1VZUgvtSvdxElaQjjWCqsYD4Du+nwhj3kLZE8Pa
	 byOdPdcbYb660WP0z2f+rdgvZTWgZLPzZKB+MWaNm4CDyT1haf5W6Rj5333pITFMHedefj1P9Bit
	 9LFbsLV+sHbpPT0+BbBMrKH8WgBx2u3zQKJUWzd979RPxDLJf9v0WMn8KRrOoAjvKd/BXesGZEOP
	 tQoTWMoP1FufxyEyOCh9+888kl8kVk5RPjRPkq/KO64Diz8Fw0hqIBJ5fTe/b8M6RYN8Tq659AZR
	 +Jt79XYXOpbcWovRLVGmG1mm0hy2Z3OWhVRxA+zO5cOnM9A7KW8w0PXsD2H6YElKDr6ttujd/E8U
	 jKQh0w7IroLZddQXLiyLSYOwOdFogONTiexxid+XL2q0TQZuk0ltYyMzCd/ESWVS2Ma0NsjJ73fW
	 r/MVppcWrvepNAByhkih58fnPGYVkgOi97GMswT2lS8o/fK7cdKYy/siEAeVgDqwhZEXDpcB1YCl
	 0dBXya6UrVwhU28laPy/EYEwsUie1/ZPdVPakGRZhEGKi9pyKAAtZY9SH3kdIgbd0JmzoJaCLDFl
	 S+2NJ61A==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com
Cc: axboe@kernel.dk,
	konishi.ryusuke@gmail.com,
	kristian@klausen.dk,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: fix potential block overflow that cause system hang
Date: Wed, 17 Dec 2025 16:43:34 +0800
X-OQ-MSGID: <20251217084333.52678-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6941fd62.a70a0220.207337.0022.GAE@google.com>
References: <6941fd62.a70a0220.207337.0022.GAE@google.com>
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

The fix involves adding a check for the end block: if it equals the
start block, the trim operation is exited and -EINVAL is returned.

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
 fs/nilfs2/sufile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 83f93337c01b..63a1f0b29066 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1093,6 +1093,9 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 	else
 		end_block = start_block + len - 1;
 
+	if (start_block == end_block)
+		return -EINVAL;
+
 	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
 	segnum_end = nilfs_get_segnum_of_block(nilfs, end_block);
 
-- 
2.43.0

