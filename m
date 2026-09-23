Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB49556B89
	for <linux-nilfs@vger.kernel.org>; Wed, 23 Sep 2026 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790181836; cv=none; b=M6qLN6tYAUjIahCae6N6olAOLWhmnGXewtVDcN45zmhv/wT7VomeQAY/BSgMPIArtfje/PeCxEiSV9U16J1vJn92b2GpcVOD0r9g8gqLrG6FqDMEgEeXYW7eev7kDCsXFS2OjpappeNs1usG5sPlpfKtBIwj0knrp7b/ETBxh1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790181836; c=relaxed/simple;
	bh=U3sHigMCrX/n5NS47tTRaKkN8n2XUCVkkGrtu+Vz9Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D2J/ibo0qbrZU65cyCsHjAzqZaU3LSjSumWUxEGxcE0J110FPChaOUllEw88w9OWNOwt52+aUfKStcMKHILIhoEe9lu397XfPbuQqf1DJbseTcOupU4GWkGCMKeTtLt4E5NRFZNTlaHpfKeoTsrCbWdIIPL/aCR3lHUHxVfJI4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HsRMHVOo; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsRMHVOo"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2db18fe433fso6137925ad.2
        for <linux-nilfs@vger.kernel.org>; Wed, 23 Sep 2026 09:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790181829; x=1790786629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hOl6tPrOOHYH5O/IseABr/XrIgSZiBfl2TxmXjGm+SY=;
        b=HsRMHVOo0d6l+7zV1hzYqdlAQGf5RJhZ7bUaM3PIuqqwYGKZv5ZPr+7myPUeSVmJpu
         EfDaArLJE75yRMEWkpZUO7WIHl5n2uPyxuYsHY/6i7WkAua5USAZL6+FsNO+lkX8Z6DW
         kEFq+PkRAL9K0zh7Za1jaspgQm6I6ClbDRskCOfYfm0W29AjbXbCL0C1mz1svQ3R2khu
         ajf/ZBWbgpwllpcIM4XSYyCLUTGOIXAG0it77qB3Dl+lrNhixWwSPfodNEsKlcXCf0c8
         t2f4hZtSGDK1o/j6XiW5F4GWasWpPtp1r9F6+Y0XISA3WaShX2YbluNiyy3ljbiqL+2M
         AdEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790181829; x=1790786629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hOl6tPrOOHYH5O/IseABr/XrIgSZiBfl2TxmXjGm+SY=;
        b=0/NPg32XpCAHPRLf2bhlJ/wAiMt9HCInAR656EwdVEU6RqlkZIjNdbIBZEwUADmsFl
         qgjcOGgj3jdmcsxORzxKuRLoEkoYHCtRaUrAfNOKnn/iM1ZHRMCW9Qbfv+DEdrwv0TwZ
         6/gyuU9U52gCjSdi6LQk0BPPXN6ZZZak7PprIOk5XvTe/bY9rH7KLtuaIVgKfGZU6k9R
         89lbwIxKwwg7WMuHSNJ78Llz0gvOR1U7+0tyPSFYt5nNFeremhbAZ1imPgFF0A629QOb
         idwLZuDzbUdKwHhG3wxZzv9TCHeAO671dl5bgCaN6Dld3JQF2a9DKJUYS4nYvkZKLgIU
         0YFA==
X-Gm-Message-State: AFuF++kif/uqPHSe5Z4dxlFEmeKvQmsGKi4IdizC8SjbtpOeF355gGbZ
	8Y2VQZO2kCZY/qHAAx6nz8v3ePG5G1Y7C3wyAf4dw3NQqrRSuTOiIxf4
X-Gm-Gg: AYBFou0ex6Lf5RYQ0bdanmJYaDxNZHTRGf8+hF9FeL2dIQGxDmKxySQK7qrH1OB9Lej
	tEYlnNf8qdDk5qlH9Op0homaeaLNh7RSZSHcuDUzN0em/GBjPwyFN+zKg418FXBSoFXO9DKuBcV
	SPA71f0iUTGrpturjpDWmiWWWZgggL7ebI8u1PtucirKUwhjHiTNIgxX5sxu1W0vyGfXXEe3FGl
	UYt7+gAjSDzvUxXEhE7xMf4BVQbwanHOt8cYgJr77Jf2biCQTlcBQ9aDO1BFCX+1OrtDCMpyllY
	jIOnVHTzfWhW7TaVlczJfFhyeBCHqdUUaeguLoS6WztFQ1BkfFLbyB5pdU7u+6LB2JnhehOJe94
	tXMGObcGdcgUu0HTpzyB8Bukvp/jB+sjPMtpN5+kJJunA7sc8UzLYu5/3p5q5BhwRlcTOsPFsQ3
	UVryZn+PPY2MNUekBu2m24id7B2mr2pFNy8E0zXN1Vi/UmMs6HLD0Tu8PSptYbaOTE1aFcsPPku
	wAocwAy2q79fC3Xj48kOp1cYBleBM+IhV31DJzUYSo=
X-Received: by 2002:a17:903:8c3:b0:2dd:b6e7:ac1b with SMTP id d9443c01a7336-2df69d36537mr27542935ad.2.1790181828967;
        Wed, 23 Sep 2026 09:43:48 -0700 (PDT)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5f52dcsm14763745ad.69.2026.09.23.09.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 09:43:48 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: fix deadlock between nilfs_evict_inode() and find_inode()
Date: Thu, 24 Sep 2026 01:41:19 +0900
Message-ID: <20260923164345.18456-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported a deadlock between nilfs_evict_inode(), executed via
an asynchronous workqueue (kworker) as:

  process_one_work()
    process_scheduled_works()
      nilfs_iput_work_func()
        nilfs_dispose_list()
          iput()
            iput_final()
              evict()
                s_op->evict_inode()
                  nilfs_evict_inode()

and find_inode(), called via

  nilfs_mkdir()
    nilfs_new_inode()
      nilfs_insert_inode_locked()
        insert_inode_locked4()
          inode_insert5()
            find_inode()

When an inode is deleted (i_nlink == 0), nilfs_evict_inode() clears its
ifile bitmap entry and then synchronously triggers the log writer via
nilfs_transaction_commit() if IS_SYNC(inode) is true.

If a concurrent directory creation via nilfs_new_inode() attempts to
allocate the same newly freed inode number, however, find_inode() called
just before inserting it into the inode hash, blocks waiting for the old
inode's evict() to complete.

Meanwhile, the synchronous log writer invoked from nilfs_evict_inode()
tries to acquire a write lock on 'ns_segctor_sem' which is read locked
by the caller of nilfs_new_inode() (in this case, nilfs_mkdir()),
resulting in a deadlock.

The synchronous log writer invocation from nilfs_evict_inode() is a
legacy artifact; it is no longer necessary because the call itself
(triggered by iput()) is now handled asynchronously with a kworker
if i_nlink == 0.  It merely increases the risk of deadlock.

Fix this deadlock by removing the synchronous log writer trigger from
nilfs_evict_inode().

Reported-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6646318bbcf419411bc5
Fixes: 7ef3ff2fea8b ("nilfs2: fix deadlock of segment constructor over I_SYNC flag")
Tested-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please apply this bug fix.

This fixes a deadlock issue that had been reported by syzbot but
remained unresolved for over a year.

Thanks,
Ryusuke Konishi

 fs/nilfs2/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 64437aed8390..33490e8063eb 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -895,13 +895,7 @@ void nilfs_evict_inode(struct inode *inode)
 
 	nilfs_clear_inode(inode);
 
-	if (IS_SYNC(inode))
-		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	nilfs_transaction_commit(sb);
-	/*
-	 * May construct a logical segment and may fail in sync mode.
-	 * But delete_inode has no return value.
-	 */
 }
 
 int nilfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
-- 
2.53.0

