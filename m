Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6113F075B
	for <linux-nilfs@vger.kernel.org>; Mon,  6 Jul 2026 11:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783336095; cv=none; b=l9fOKWt0+HggcFMREmcjIcykMfhuFgELoxCXOwQLaWqRXc2sz7/2YQgM62L4n3aKzSjtkq+uDxV/so7HgTWH541TvxGKu4riYJxh9qqcG1YURz556eUM427ogtyQZi+Cx4XC770X9IOl/JXNzuUW1fI/zdpKbGcdf+NSdzuQ1Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783336095; c=relaxed/simple;
	bh=vpa89zqJRQ9fSGMVcwJznhT3rLkKb/H+YNZTERWaYC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pehNysKjty30WQQxnUR/azd5yNC7aGrGF4J9/wE3ScZLb8wvx+T1sMqlkemMi0wTN9P2EVJvgzkhsBn6P5xdOEn4pkfIsUi9G1Ciyxs2cptyPSgPkJRMk0p4RfmRy5G3sDXx4acT68cI6UCl03nh0RmJ82LVnFrPmuF3kzasc54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e5aXNFTH; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e5aXNFTH"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aeb89359a3so2275762e87.3
        for <linux-nilfs@vger.kernel.org>; Mon, 06 Jul 2026 04:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783336091; x=1783940891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vtUwtg812qYxWb4tbGZyGStRjOL012fzxVYjSpjnYjQ=;
        b=e5aXNFTHoYy/h7j3C84HNhaebC2kit362uddQx0aMgMll3mXztldwl8deoRDXnx+wC
         u/gzODpeV1+QXXzokEiFjDs7JdJSymYbzqzsSV2Wk2qm+VNAgsVKjN3Ifd7tvolLHyN+
         Mu5iU6HEf8Kt0S2F4TmEPU7XAthnKZnpPXGz/aPkELLxpPXLHqLGwA0Mp9og+UWg6lat
         OpicZ9NJolZYCUSwMnFGnH3E+ghyL4Clum/fRnpS6GCVz8QSKkIEHN/N51ZOAtj51rGK
         jDqpis91qD8k+lW4OVJpxVT7o/ZYU6Us6G6xmsRdYTSyxPdqZ1d/kd1LFnqffRbaiBKv
         Xauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783336091; x=1783940891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vtUwtg812qYxWb4tbGZyGStRjOL012fzxVYjSpjnYjQ=;
        b=mkc6B7QARALeQfD6UbshKvOQqiYSwWwP32jwoxFKOZKxeq2AGvoDz7fxIZzF51L/Wl
         i44v979TQzQgDlEbLknLc53h1Isa1fbS2B2ExpDubDQAKjVa8vtzpelcwYu9zXPeviJg
         3lxMXCQU5GSSrnuHLCDK+0OzE/QJo847xNHM30kD0liIFEzalqyCJXQ50l74BONb7jM4
         rTj6abwFS1y0rLohkTpOjM9RRwZwgiYpV18TVjolObf6v1khDMkqRWVN2dzjtx6DLNyD
         WlptnL82R9B3KGF7rg0qpwNmJd609G4/Zew8CsDCALpuvB4OQDzhkbKun48ra7k1eLk6
         2ilw==
X-Gm-Message-State: AOJu0YyN6qbxiwCictIW0QuezTWHpRa8rRpc36GhLN5Vsgc3q4068gnK
	7ymGT69DfV/ygXjvs5SqJ94YHb+5iweuOYQegVvemZzsNFj2PV1VSqQ1
X-Gm-Gg: AfdE7cnYuFF9wY3aaNSwuT7DkS3uSwVfpBC9IaiBVuwXWlRiOyGkXH5OeZ+8Bear210
	UAw28ThPo2nZVUTNJaPH0YpW+K7TWdv3PrtVp9YNrqb0Vhuxi/QY8wAUzL6KixgYa61R32tdtNT
	yUQh21klHuk3uLeh2iQXTJUCralcEArafL3DhbSm0td3pPRWmzl1gY0bfLswtbdCDuhIFBEZBDm
	dv5v0pfh3kLFtY7DzKXqcHe30qfGeqz1AYPtG7cnvRfoHf93QMkodvb9pBwkeOCXFsTLLQxwgIy
	lY8L+pcsoKXDOYKqdR2nGjjmwnXbUg6LQwkIK5YHlWvS5k07YnUhsg9HdNeAbcn3tuRark9hEER
	uTNErJFDZEjAhCHNCp0QJ/0ExVzcSfQg9SznkEjvfjJZZLJMP1V6XdqUDiu+YoJB3THLUMiNrkC
	jojeldJIP6ellP8H5HPVSiiJDwwOvwLKM5Onm6GCrG0Lw8xBnKR3lXcwU8dkhjvdeRUnjG9VTUv
	N09YTc=
X-Received: by 2002:a05:6512:620d:b0:5ae:b880:d4a8 with SMTP id 2adb3069b0e04-5aed50b6680mr1649603e87.57.1783336091255;
        Mon, 06 Jul 2026 04:08:11 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aed13bfd1fsm2706666e87.55.2026.07.06.04.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 04:08:10 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>,
	syzbot+79b815da3aec0a6a4d02@syzkaller.appspotmail.com
Subject: [PATCH] nilfs2: handle corrupted checkpoint count gracefully during deletion
Date: Mon,  6 Jul 2026 14:08:07 +0300
Message-ID: <20260706110807.2835-1-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzkaller reported a kernel warning in nilfs_cpfile_delete_checkpoints()
due to a corrupted checkpoint count on the storage medium where
le32_to_cpu(cp->cp_checkpoints_count) is less than the number of
checkpoints being deleted.
Triggering a WARN_ON() for disk image corruption is suboptimal. Fix
this by returning -EIO and reporting a filesystem error via
nilfs_error() instead of interrupting execution with a kernel warning.

Reported-by: syzbot+79b815da3aec0a6a4d02@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=79b815da3aec0a6a4d02
Signed-off-by: Igor Putko <igorpetindev@gmail.com>
---
 fs/nilfs2/cpfile.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 4bbdc832d..d3349fa58 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -81,18 +81,26 @@ nilfs_cpfile_block_add_valid_checkpoints(const struct inode *cpfile,
 	return count;
 }
 
-static unsigned int
+static int
 nilfs_cpfile_block_sub_valid_checkpoints(const struct inode *cpfile,
 					 struct buffer_head *bh,
 					 unsigned int n)
 {
 	struct nilfs_checkpoint *cp;
-	unsigned int count;
+	unsigned int checkpoints_count;
+	int count;
 
 	cp = kmap_local_folio(bh->b_folio,
 			      offset_in_folio(bh->b_folio, bh->b_data));
-	WARN_ON(le32_to_cpu(cp->cp_checkpoints_count) < n);
-	count = le32_to_cpu(cp->cp_checkpoints_count) - n;
+	checkpoints_count = le32_to_cpu(cp->cp_checkpoints_count);
+	if (unlikely(checkpoints_count < n)) {
+		nilfs_error(cpfile->i_sb,
+			    "deleted checkpoints count %u exceeds block count %u",
+			    n, checkpoints_count);
+		kunmap_local(cp);
+		return -EIO;
+	}
+	count = checkpoints_count - n;
 	cp->cp_checkpoints_count = cpu_to_le32(count);
 	kunmap_local(cp);
 	return count;
@@ -522,6 +530,10 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 		count = nilfs_cpfile_block_sub_valid_checkpoints(cpfile, cp_bh,
 								 nicps);
 		brelse(cp_bh);
+		if (unlikely(count < 0)) {
+			ret = count;
+			break;
+		}
 		if (count)
 			continue;
 
-- 
2.47.3

