Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0212D3DCDAB
	for <linux-nilfs@vger.kernel.org>; Mon, 20 Jul 2026 14:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557042; cv=none; b=cZtiIchGo23s5aDBtHUnuSkiq/pDyurZedfeuAifOMlzXeRusrensoVf1qegLKjqewfctyFx/iXRBxxJ6nL0BWUVBYY/kQ4OHq/ZqpT6bGbpulM0lTzAPQzhAzohgCLL125711qSnpYIOufC8qTPaqTcLURznif/nfJ44cLvozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557042; c=relaxed/simple;
	bh=1LTkvmZGmZwJt/B8VQrglyJCuBupUAzm+QAjG/yRD1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=STjMq72EousM30COUZow1jAFQyIhecYEarlxBGf1kUz+f0U8yczk1M2t5VyKtITNFo3qcFJj+ErO403V95SEAxbmtObU6QxWFahqNYbMOol44jeDaTnTwD5fjI194QJEJhVy+61qlTB9aFC/pYSRVuGArWXoP42WAVubrhWjiYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NZadcrQ/; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NZadcrQ/"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3811f512167so10015098a91.3
        for <linux-nilfs@vger.kernel.org>; Mon, 20 Jul 2026 07:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784557040; x=1785161840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uwzswtIIaxm5d4gI976jZ15OSTycJLbOOHw5koXtiWE=;
        b=NZadcrQ/glP0ngITv3A2LgwhVrYtcYJEwvQoakObpgj535gDrJw8clH54rCHWmx1D1
         apjRgdAIban6I+g+lghhDiZJVQQkcgJEq+fwys2sD7HneUp1G45WaSmVaK6UK/yDcUmD
         THPtsjXZgB/s2OtBpyGJkEOftNC14P+DiCyvgTnFTHio8H09M/DbZrGi8OiPrkfVlToM
         X2KkCY3ckE52YAoUCLwZIxFdISykZN+HhSpe+2dCe64cLWNRHVMfbzffzlurIn4dS+Pk
         3OTlzVAqPehi9ZHhGr1NMYdcMkuXCWoid+vc3QX5Aj+1owN7bRXVCUIzwGz5c21lSMG0
         WiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784557040; x=1785161840;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uwzswtIIaxm5d4gI976jZ15OSTycJLbOOHw5koXtiWE=;
        b=DAesn6cacvWmVaAbDwhy7QUgBH8FCz/+FDJ1uWwPtu8Xsz7UQwvRcGPszSrfSKjN14
         U+AoY2mUiOxIJymLxsqWm+Sbqh9QWbcVKwQ0NorhUv/7M/jDe9wYKZuT0fjp73PABbiQ
         jPa6QF1F8DWiRtgdGkKtXq6n9ngx5iwRMKqAPjq4szyXBJY1HChyRENmoPwPPcpNFf/J
         JP1cK6PLk/+drPvHhwK4cs/HceS+2qx9CTo0jIYlxn4Kq1KtfH+ZyoND6wIDFGTSEYXd
         6p/KQOdiILq2jYx+udwN/4B651HTAcEHIbEmLiqyixPlpPB9fVKLV9ucKtJIkT+QZjmN
         63IQ==
X-Gm-Message-State: AOJu0YxHi++B14oxiB0l240LYPaF5ZewbX1H7fIk2YYsVBxRqHRQscCM
	DjX7C7ZBZgTTTWUxhUIayTp0+U5Q0b2NbBO37N7tI72X+R/S2VDfHrkF
X-Gm-Gg: AR+sD105n6xOPLXVa97L/69WWS2kxNptekLN73hIeN/skWEaLOxBCzX6QFBN52cYAlJ
	YlN8CRe764FdZKJdT1lO1318SXOjz6aZWbgTjYaNL1EY7JnaWTx4A6On72yJq4LPJZZxwSc/nhU
	EOyCbW8jSdE4WbLAR1Sp34ZYUNYcwMJ7svIf+hF9P6NkfJcc9lp0TRX5aM0MsyzOPyNa1YWE70W
	WNJ40SzKahY9RQwMKQVK5xblz6ifUAvy1+kXSroraT18gCj3yU+ndRShhnx91RkyWz6C094yO/A
	umrIvUiqZeFqMVECZ1g2C5dMgt3/KCH757B6/Zhw5sh+3cbiHbZdoaXUWPOGA5b/5mjaRsW6ojh
	0e5miCwdq4Gxyyz+IXK+++U1K3NsjFN3JPPsJtPJd8vKDqyiRiYcypalzIPaXbzuDmxSCqOG8aD
	sY6ryXL1AQwTQg049p4kaPMApklBuVmeGTUjcS
X-Received: by 2002:a17:90a:d405:b0:38e:712a:bb38 with SMTP id 98e67ed59e1d1-38e712ac393mr7122237a91.24.1784557040181;
        Mon, 20 Jul 2026 07:17:20 -0700 (PDT)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e4b247f1bsm6076027a91.17.2026.07.20.07.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 07:17:19 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch
Date: Mon, 20 Jul 2026 23:16:52 +0900
Message-ID: <20260720141716.205384-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported a kernel BUG triggered within nilfs_copy_dirty_pages(),
which copies dirty DAT file folios/pages to its shadow page cache.  The
BUG occurs when a retrieved dirty folio/page unexpectedly loses its
'dirty' status.

This issue arises because, since the commit referenced below, the 'dirty'
flag of a folio/page can be cleared asynchronously after the filesystem
detects metadata corruption and transitions to read-only mode.

Resolve the issue by returning an -EROFS error if the filesystem has
transitioned to read-only mode.  Also change the behavior to issue a
kernel warning only once instead of triggering a kernel BUG when this
unexpected 'dirty' state is detected while the filesystem is not in
read-only mode.

Reported-by: syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8baf9a79a3ffc6271cb6
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Viacheslav, please apply this for the next cycle.

This fixes an issue reported by syzbot where a kernel BUG could be
triggered depending on timing after filesystem corruption is detected.

Thanks,
Ryusuke Konishi

 fs/nilfs2/page.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index a9d8aa65416f..1d00bce21c37 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -243,6 +243,7 @@ static void nilfs_copy_folio(struct folio *dst, struct folio *src,
 int nilfs_copy_dirty_pages(struct address_space *dmap,
 			   struct address_space *smap)
 {
+	struct inode *smap_inode = smap->host;
 	struct folio_batch fbatch;
 	unsigned int i;
 	pgoff_t index = 0;
@@ -258,8 +259,19 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 		struct folio *folio = fbatch.folios[i], *dfolio;
 
 		folio_lock(folio);
-		if (unlikely(!folio_test_dirty(folio)))
-			NILFS_FOLIO_BUG(folio, "inconsistent dirty state");
+		if (unlikely(!folio_test_dirty(folio))) {
+			if (WARN_ONCE(!sb_rdonly(smap_inode->i_sb),
+					"inconsistent dirty state\n"))
+				goto unlock_folio;
+
+			/*
+			 * If the filesystem has been forced to read-only
+			 * due to metadata corruption.
+			 */
+			folio_unlock(folio);
+			err = -EROFS;
+			break;
+		}
 
 		dfolio = filemap_grab_folio(dmap, folio->index);
 		if (IS_ERR(dfolio)) {
@@ -277,6 +289,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 
 		folio_unlock(dfolio);
 		folio_put(dfolio);
+unlock_folio:
 		folio_unlock(folio);
 	}
 	folio_batch_release(&fbatch);
-- 
2.43.0

