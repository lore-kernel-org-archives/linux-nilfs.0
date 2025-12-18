Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996322FBE0F;
	Thu, 18 Dec 2025 02:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766024952; cv=none; b=Pt8hrr+xCOv6V5fVpb4ECAL43Vl64fW4eFSjG3WE8hnW0YkRt2nHQS9NqVy6FLVU+nxksbHCRBTmBWXvzI5UbehjXXM5Z3Eth0RQ2mkXK5PCsHHQC96Cpjfeo/jUxYYMKXE8CTpjG7+KTsXkjaB2Ze+eyvHKU83ONIIgAcBznwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766024952; c=relaxed/simple;
	bh=8wzudRzvcracNTXKkVRRPozHxlDLdopSzFPGhTcGacU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=ZbD96O22tPfz7isUJNpi9nJWT/xWmjoACcHyuJQmUe0oxB3Y7yb0uW1J+M0lfllSQIAMSrDiGkI4uOhYTW4tegxNnORu77CSDU5pYp0apR1khb+YyQET/Im0nhjXg/UeY6mpxaCIVHUmUebYA8vWpk54u4fVOWqIA4FMo+fCEms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=lgWLJNBy; arc=none smtp.client-ip=203.205.221.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="lgWLJNBy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766024938; bh=n2VX52k9KCBD2veu+dnqec7qKp7MoJnpLIYbHPUYV70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgWLJNByxsN8NOuq6up3hHJryfvAd/z8RjB5KVwQm9M4s521F+l5bBY6xYGStYXLv
	 nTaaoSWzh4ksEu3P8+gCyrFOdWsfSt9HeyPDCyx8LFG8cyAkMJ69ev4GWqAYcyw8Ij
	 LGQkcBv0pINEF0xgrZ/vI7dollGSJa4cLN9UZfTU=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id 7380CA61; Thu, 18 Dec 2025 10:28:56 +0800
X-QQ-mid: xmsmtpt1766024936tw6qb4p1i
Message-ID: <tencent_84D71B07255DBA68BBE733F89E1F1B344B08@qq.com>
X-QQ-XMAILINFO: OOyEews/EdUgYkExGHG+DoNmLMV7U6EfMgGiQ2PAfFa6SJaRNDTZifRvEuTHE7
	 zGRBU0C9L3F48pn8l4mORmBFlY+pFl583w/vAm8ixY0gnzC5X0KUocP0tOx8Mw6fV92HWK6oGEZu
	 Qd7dPpJ6zXNA9u7FvXMW/WNUtNkr4nN1K2SOSTQZMzna7HP2TtrWQE7UQLerTX1VIYiFA0oHVIqn
	 irMIKTPDMR02GU0bi6X1KpS47NhyoCVZK8bknDGGW/sRCdUtlVhzeUxUooqAbzAnI/9QiOjYRXvH
	 MDe+8xXG4vVuxtcQSW355odUFGjza6qUrDqQIBxGrO7IYQSQ0I+rlDCer/eKa7Q5bcFG7HjdO3/B
	 7l9ARPPJ9xN9CQDTT/UCkHy0XZdNhpyC8+BFo9+95FWxUn4/aDC0ve+wM5xZBtLsgwVpEeY12FF4
	 iK3xViVWniKFBc/u5TC7QhuRUHFreiFASGMioU8aY2KAN1MWvXq8fWbpqEh77qH7zc6LmXKpP+m9
	 6MeXNK8RoXzpULWCAc/uQmSRGujWo21J7lPaCdYNXnkBmS57TDweHOeSacEyVYopKHOTt873OTJP
	 at0U+B7cXtpx6qjeeITH8Px7+R65depNTRHIewVGKQ8gqgRXAFX1fdoXAI68tApxc/1MqB7yqldS
	 2ulAYDz+DZXFHcs9lCMyOebuqBgkHEJsVSpGazssRl5JjPm6uf8OQqJXn3KlAwqxHPTJ6J3kQYri
	 Y+lHXa31uOk/bBQyIFL5aestlMBqni+lnpwg6RtRpzi6XQHSowGbVVoKCnbyqgwQtA03yoIx//jZ
	 lcGQ4BrwfKHUrllAKPDBkkW/Q81g8kO1IE24sgm0Odjhj3iGsf2c8X3P226BEqlU+GnIKbZqC+VV
	 XHqRIOPeU4Wos6A3+WDyLGbOXN902qLNzuNUeYJGthhqdLezQ5hyTKdt5l40AwkUVuG60RHRiFiO
	 AKJnVGHFbljynwuNWAEH24xaJX4l9cOZSYM4yE3ugyefMy29MicN59BAJukcGpqsJfL8Vo2mPpwm
	 L2DQoEZQPCIIOklW6R
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
From: Edward Adam Davis <eadavis@qq.com>
To: konishi.ryusuke@gmail.com
Cc: axboe@kernel.dk,
	eadavis@qq.com,
	kristian@klausen.dk,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v2] nilfs2: Fix potential block overflow that cause system hang
Date: Thu, 18 Dec 2025 10:28:56 +0800
X-OQ-MSGID: <20251218022855.67333-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAKFNMokBCsjR-QvQCAHcAoSfC5yFAGU+xpiA2CUnGPhi7f-uFA@mail.gmail.com>
References: <CAKFNMokBCsjR-QvQCAHcAoSfC5yFAGU+xpiA2CUnGPhi7f-uFA@mail.gmail.com>
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

Before recalculating nblocks, add checks for the end and start block.

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
v1 -> v2: continue do discard and comments

 fs/nilfs2/sufile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 83f93337c01b..75ca318b5763 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1175,7 +1175,7 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 			nblocks -= start_block - start;
 			start = start_block;
 		}
-		if (start + nblocks > end_block + 1)
+		if (start + nblocks > end_block + 1 && end_block > start)
 			nblocks = end_block - start + 1;
 
 		if (nblocks >= minlen) {
-- 
2.43.0

