Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913F232D7C8;
	Thu, 18 Dec 2025 12:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766059876; cv=none; b=JzM6D3tOFVzZkAOaVUmO0Ub1Q8alFhcoeUiteyn93MLL0iYifQuPQQqIvh8BrC2Idgz2fbE/wEskeV/wkDkaUmQqWfQycUhAgvFJu+aGPHd9vgddu1NRGLR3aYfbMLQAKHRihXQqrt/G4m07whbMGeazJbOOf9vsc4wbKewc1EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766059876; c=relaxed/simple;
	bh=e9nQvR2qnYdYTzR/qGk/zKuTBmCRgvLYu+WP4LWLYIU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=B7+2DkLIEbEm3MWKfH1a4PoplB6R7q+i7exaP1fiJ0/7nkSRWKeQok9xD1xIhwdHDS9aYQrM6V204zEYi4XYWyIM46Wf0ZoKoo/zjUcqqn1/okuIQqsipiIt6rcSFbyxrPpUaPDKfKah+N0NxmE2GxN1mjhjcnW2V1CFCOiAv8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=NMddZS5f; arc=none smtp.client-ip=203.205.221.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="NMddZS5f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766059859; bh=GLf99UCsuDUEsTYQTlKmGcPLJ5eXAraOWdpYvNhVsWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMddZS5f9oo10v2fPGt+HV6yyGMxD2n1qz+T7qZcd+2nlMDqWXLhcOELWazH07SVi
	 ds3fX4/pxRLbGXuI1CurmjD+RRjYxFMxDCerbjHz2vk1MQiCck2wVYtBbJWv0e27PV
	 Mz6/XGTBlUHfMq1saWoMkDnyYTY3gKEaBpum+cJo=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 2B906833; Thu, 18 Dec 2025 20:10:57 +0800
X-QQ-mid: xmsmtpt1766059857t8xbqmzo6
Message-ID: <tencent_B46C5094A8EAD2EEAECDEC7B126EF42D010A@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb5h5/O3+IulX9rp5m50BXGB0g9FGRLMSxi17Wnfy30LYUX7Xcy3Z
	 Qt8taY58xDZzOzyB4c1duhfTPldGwRJkX+Z4p7YPEAaLNwPiYSfhhh6flcqaW21mtp1JN+/bcLQx
	 yNBVQEyAJP6lfMZaUF5RP3L4ffZ6ZwJbzOlrvvoBJ9y20TmBTzeNljJgn0hoK+2zsUC+IWT6rQFf
	 5kwNkZHXcd/xj8znVT9vboGItgt11f6SKR7QwBNVbSuPFMTmA42jhcj2WHPdy9rUN9Fs9iVCafv3
	 GApRJEwyd2qLxyrm0nMyWawUu9De6VME3AmfwjY/lEcByNfu0wyjInkNwMcgY+IXRqfFH0kYOjrU
	 V/kCiasfjCAs99laUni8bCwaWr72OFl9jWdhh0lctDh2b4bMbY0WBhRauuz/C0Ap2cj8F4ZE9KR8
	 OeAZFZ0ghQyHVqFYWk4junyO9tqVIIQkVmpVHWbZevqoeSDVaODg2NkhGXd1jIqdrVZadGte2giL
	 WjbfTPyggjoBvjteUTlh5dYXZwCCq227CLt5YrF++Tka4AacQsBhHiWoKKfv5Ecpm6tCm14FblD0
	 g46S7g7NKabOxXWylSJ5+iTDhsanyYHsj015mo+/GBic5zusg52Nv1CRTWeu27HYYicHHnFVwxfz
	 zzJOEnuSAOiTOAVokHaa8slngISBWIabMkpxnFaxsfCygLXIAgIp47T8HJOcwR6ow2kUxbpCEZk/
	 GMWww/Xi9O9EBKFGrkIfDRhpZ/K8e8/NKXA8YG2gSLFc0DEFgfKBvJTja0hAq4ReTNJWWFZ70mwI
	 0I639F1MHjlagF3D3IaYW3gwX0QU51MbHssx9GnQQiwY4FOPATa2FgAcfkLWmk1u2tO8WerN2LX3
	 4rYgIZVa83E+9BV8P6FIunv5ryWxUtX+mFBFI5PUgA2dmrGwJhuLR+SdRnv394bJQgeoB4wzq3BW
	 j54+YQZxJUVwTsqMYqpiuGGQgPoBfOIc37TXfZ/3O46fDYOxLKAvGncvLxa2M25fJ0FO9xiRDB8J
	 vtQNxCUwov6hXBW/zNacWyO6knyPVBM2g2EeKSl4A/R6sQSe3rhsLIrt//pRqo3pnLW2fBbciJrj
	 EdwEc73+uNTGPwAWA=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
From: Edward Adam Davis <eadavis@qq.com>
To: konishi.ryusuke@gmail.com
Cc: axboe@kernel.dk,
	eadavis@qq.com,
	kristian@klausen.dk,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v5] nilfs2: Fix potential block overflow that cause system hang
Date: Thu, 18 Dec 2025 20:10:57 +0800
X-OQ-MSGID: <20251218121056.91051-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAKFNMo=602x-hdCCQtPdZ7PxX5FezeUERLEcrT17OjYxif=RMw@mail.gmail.com>
References: <CAKFNMo=602x-hdCCQtPdZ7PxX5FezeUERLEcrT17OjYxif=RMw@mail.gmail.com>
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
Exiting successfully and assign the discarded size (0 in this case)
to range->len.

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
v4 -> v5: assign discarded size to range->len
v3 -> v4: check end block and first data block
v2 -> v3: change to segment end check and update comments
v1 -> v2: continue do discard and comments

 fs/nilfs2/sufile.c | 3 ++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 83f93337c01b..eceedca02697 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1093,6 +1093,9 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 	else
 		end_block = start_block + len - 1;
 
+	if (end_block < nilfs->ns_first_data_block)
+		goto out;
+
 	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
 	segnum_end = nilfs_get_segnum_of_block(nilfs, end_block);
 
@@ -1191,6 +1194,7 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 out_sem:
 	up_read(&NILFS_MDT(sufile)->mi_sem);
 
+out:
 	range->len = ndiscarded << nilfs->ns_blocksize_bits;
 	return ret;
 }
-- 
2.43.0

