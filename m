Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68A32BEC2B
	for <linux-nilfs@vger.kernel.org>; Thu,  2 Jul 2026 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008651; cv=none; b=OUmGJK++eXe+UDqtbSdxLJZqET64NNbheTtFiEiz5lQDr+5W+rXW7rClIlVg7oIPjR5VnuszrXSIBUcIF4TRtiMpPB1UBP/4kPYzcX70LdYw3UDyoTZYe+hLZjcRF4OSnQNKa6mIrHgKlSwcYJCMwGZIZDe2CmUWRBdmJx5QMQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008651; c=relaxed/simple;
	bh=S+QOLbaZBffMtAwY7eI4nF8jMNl+AcbOfdBCFi/9jbg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HQkta4gnbeJr9Y3royu0Hk3LL4Scc4VWtE8pcsvlkbWnZy/AfWb7r+P7liF4bBA1HZxeic02LHCyLdQ2xl9VnGNokpy2xCDPHWnpu0ORKbX8ZSwZNAvrJ6NxrBBu+nWaAOVofGsyJPIrhAHEbK4OIzDJFM2mFczlwvX47mB/paQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a8uXxiRq; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8uXxiRq"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-845f2909cd4so1328708b3a.1
        for <linux-nilfs@vger.kernel.org>; Thu, 02 Jul 2026 09:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783008649; x=1783613449; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pt9aLH0W1iBFqqXb0hqSlhwrsUPlus7T+qwbix6/Epk=;
        b=a8uXxiRqfGvP78pjUkg/kw/+bF7c8na66TDnJaqB2kbg5oS4Cx8xA/NlXFKMGBW3iV
         7T6xFJ+Un/XSVH8QtpbrRp8T5POxWfxRL5JBEm0XHd/v3DzelHv7nWC5akZJjzsYmOfc
         V2YuU5tJqglUIa7c/ciwCnhfWsiTM/HsJaVaZ7j8qi5LH9+m22K5bplZHVQxEi0WmYCO
         F89JuDzCVkddrkmw/5DfFK0w29hphyu7z6UyA5AWmbKc3Nw1s1umnYylqKgfFFPvyMTm
         7tp9vrMtoQSRODSNxd8bHSWlrc2k6tajWmzH5xuF6fQj3tFJMufLlf46Wf89XRpOWUG3
         eCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783008649; x=1783613449;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pt9aLH0W1iBFqqXb0hqSlhwrsUPlus7T+qwbix6/Epk=;
        b=RpR49ESMcBXOK4/CA5Xk5HW1MOtRGDSCy1Ebfea0cQbkxd66M5QYzNnCSIRg3gZ0pd
         YpuF6GGt8gmS/QIkM6h6V318WuqbSdywn+qpEYQ5WuFXMdpR/4qpWfgOzftllneL/5J4
         Fb+9fqB97DshsE+30Us3q6v2jo723006kR0mb3vkSvvB5Ru9rgZg53lfXM7jCAJ5IjD3
         N3nXYifhS9sD56NxlNqRtbTIPWqIBUbUC3FxX0sO2tA63rA89pT4bOdCKd9pYYAKmKew
         iOhToVIJOxTKmui84mskLgZKWJGIWXh2UZ/sh6uWBrEy20zKu4qdiOfVqLqFRDrRmS7U
         wO/A==
X-Gm-Message-State: AOJu0Yw2FUNagQ8OkUuCsuDM50w0eZLz5MQxTgLVIBzdEYwXosINS2ua
	qBjs7uLGwFAollhpOnPgRy0r2GrgcaVr1qzuMECNJrqv329QLRYYzZSz
X-Gm-Gg: AfdE7cmrRsrQCn/lRgskfx/iYNdydhiQ8s868L7rqy+2XxWK9L/otiU7hxO68CBRzz7
	ReAwYWTJj7VRvy2up9ibLroNH7/ZLWEzwZ9TG0ICNcjSGe+bxu8MAP+aEXX6s19s6Uj1owYA5QK
	pZ73EBMREl4/1QjqNummrVFS2hMQQZ2DFiw686d7kh0Ums35cdro9eJQSlFvJd4j8BlUThpIkit
	R/gw1FgClR134gm+5fQ+x8jlpA89sTP+hRtfXtB738qdtMrzsvcid4ODEKZZfahPTTjswDoFgs6
	9CmDIU3CS+SXajIJC8wsQGTMVTPEfx11SB6YdnJtk5MflSKWecSlyinRLFpPZwdRlcC8OAW9wFg
	Booi3z0HCAONcTTxI5DBKBIH8KrEKvTFYuvywpmTCvhptCHsw8id6AXFImD1yj3hzzkMZnCO5jC
	Nu5XRKRDrL8D70MSBodv536lu4MGbJaIeYKIlUs4CqIyv76RjO
X-Received: by 2002:a05:6a00:2303:b0:845:c6c1:2e36 with SMTP id d2e1a72fcca58-847c0895636mr6724098b3a.28.1783008648785;
        Thu, 02 Jul 2026 09:10:48 -0700 (PDT)
Received: from carrot.devel.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb9b409fsm1601712b3a.52.2026.07.02.09.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 09:10:47 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	wuyankun <wuyankun@uniontech.com>
Subject: [PATCH] nilfs2: reject invalid block index in GC ioctl
Date: Fri,  3 Jul 2026 01:07:19 +0900
Message-ID: <20260702161045.27555-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported list corruption caused by a double list_add_tail() call on
bh->b_assoc_buffers within nilfs_lookup_dirty_data_buffers().

Analysis revealed that the root cause was the insertion of a page/folio
with a page index of ULONG_MAX into the page cache via the GC ioctl.
filemap_get_folios_tag(), called by nilfs_lookup_dirty_data_buffers(),
repeatedly detects a dirty folio with a page index of ULONG_MAX due to
index wrap-around, leading to duplicate processing of dirty buffers.

As a preparatory step, the GC ioctl loads the page/folio of the block to
be moved during GC and inserts it into the page cache based on information
in the nilfs_vdesc structure passed as an argument.  Normally, this does
not cause issues because the user-space GC library configures the
nilfs_vdesc structure properly.  However, since there is no range check on
the parameters determining the page index, a request with artificially
crafted parameters -- such as those generated by Syzbot -- can result in a
page/folio being inserted with a page index of ULONG_MAX, triggering the
above problem.

This resolves the issue by checking the ranges of 'vd_offset' and
'vd_vblocknr' in the nilfs_vdesc structure that determine the page index,
thereby preventing the invalid page/folio insertions.

Reported-by: syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c37bed40868932d790e9
Fixes: 7942b919f732 ("nilfs2: ioctl operations")
Cc: wuyankun <wuyankun@uniontech.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please apply this one.

This fixes the list corruption issue recently detected by syzbot, that
can occur when out-of-range values are intentionally passed to certain
GC ioctl parameters.

Thanks,
Ryusuke Konishi

 fs/nilfs2/ioctl.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b73f2c5d10f0..0957316e58b8 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -527,6 +527,7 @@ static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
  * Return: 0 on success, or one of the following negative error codes on
  * failure:
  * * %-EEXIST	- Block conflict detected.
+ * * %-EINVAL	- Invalid virtual block descriptor.
  * * %-EIO	- I/O error.
  * * %-ENOENT	- Requested block doesn't exist.
  * * %-ENOMEM	- Insufficient memory available.
@@ -536,15 +537,30 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
 					struct list_head *buffers)
 {
 	struct buffer_head *bh;
+	__u64 limit_blkidx = (__u64)inode->i_sb->s_maxbytes >> inode->i_blkbits;
 	int ret;
 
-	if (vdesc->vd_flags == 0)
+	/*
+	 * vblocknr 0 is reserved as an invalid pointer.  Also, limit_blkidx
+	 * ensures that the page index converted from vd_vblocknr never
+	 * overflows the page cache limit and respects the architecture's bmap
+	 * key width.
+	 */
+	if (unlikely(vdesc->vd_vblocknr == 0 ||
+			vdesc->vd_vblocknr >= limit_blkidx))
+		return -EINVAL;
+
+	if (vdesc->vd_flags == 0) {
+		if (unlikely(vdesc->vd_offset >= limit_blkidx))
+			return -EINVAL;
+
 		ret = nilfs_gccache_submit_read_data(
 			inode, vdesc->vd_offset, vdesc->vd_blocknr,
 			vdesc->vd_vblocknr, &bh);
-	else
+	} else {
 		ret = nilfs_gccache_submit_read_node(
 			inode, vdesc->vd_blocknr, vdesc->vd_vblocknr, &bh);
+	}
 
 	if (unlikely(ret < 0)) {
 		if (ret == -ENOENT)
-- 
2.43.0

