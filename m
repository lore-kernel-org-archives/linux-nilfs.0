Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E96F35C1A0;
	Fri, 31 Jul 2026 08:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487137; cv=none; b=P2aHTxCbhhjgg+HnzGKyAPwyoVcXFanYMXnUoDSieBvDma01cFvtz8nuC0i/JNVVfUrgsTWjT76USR3+c0LxUIdpwpix3TM1eTBV7lmLmpFAaYjlNFVINBpxxvsD5IRXQMQvpZ8ic24Axk/qt6oHeliJRtZOJZ/0VA0n+xmCUuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487137; c=relaxed/simple;
	bh=2nkO/JSdQ6mln8JAiuRXZQ3Odf6CI5D2N04tJVQTyGI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ndoCI8RqOdAK53qTeB3bF8ku8QkJeecUC5yyMbY2nIl/Zq/GIspgkEqi0aA1w2LkfEulSK05uG0ltMNFkJ1EzcbXMGy5Qfa9R4GUUJ4+875sxuiMqXnjN/soFoTRsa+tjpTzqvnvm2Layp72K1+qEX6eknZf/XaZ/RncgMIUums=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3d7b3fea8cbb11f1aa26b74ffac11d73-20260731
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:dbeca86f-725b-4056-b9ca-c297a4ce9af0,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:6b5516d29a3db7d005f58b4ac388fec6,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3d7b3fea8cbb11f1aa26b74ffac11d73-20260731
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 327566297; Fri, 31 Jul 2026 16:38:44 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH] nilfs2: fix block-offset handling in iomap reads
Date: Fri, 31 Jul 2026 16:38:40 +0800
Message-Id: <20260731083840.3643821-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_iomap_begin() looks up the filesystem block containing the requested
offset and returns the physical address of that block.  However, it sets
iomap->offset to the original, possibly sub-block, offset while leaving
iomap->addr at the start of the physical block.

iomap_sector() adds the difference between the I/O position and
iomap->offset to iomap->addr.  For an O_DIRECT read at offset 512 on a
filesystem with 4 KiB blocks, the two file offsets are equal and the I/O is
therefore submitted at the start of the physical block instead of 512 bytes
into it.  iomap direct I/O permits this alignment when the device logical
block size is 512 bytes.

Describe mapped and hole extents from the filesystem-block-aligned file
offset.  This makes the physical and file offsets refer to the same byte.
It also prevents a one-block hole mapping from extending into the following
block.

Fixes: b924d8d4e54f ("nilfs2: switch O_DIRECT reads to iomap")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 fs/nilfs2/iomap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
index 3ae3bf6ed3686..e130ed63abd9a 100644
--- a/fs/nilfs2/iomap.c
+++ b/fs/nilfs2/iomap.c
@@ -18,6 +18,7 @@ static int nilfs_iomap_begin(struct inode *inode, loff_t offset,
 	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	sector_t blkoff = offset >> inode->i_blkbits;
+	loff_t iomap_offset = (loff_t)blkoff << inode->i_blkbits;
 	unsigned int maxblocks;
 	__u64 blknum = 0;
 	int ret;
@@ -50,15 +51,15 @@ static int nilfs_iomap_begin(struct inode *inode, loff_t offset,
 	if (ret == -ENOENT) {
 		iomap->type = IOMAP_HOLE;
 		iomap->addr = IOMAP_NULL_ADDR;
-		iomap->offset = offset;
-		iomap->length = min_t(loff_t, length, i_blocksize(inode));
+		iomap->offset = iomap_offset;
+		iomap->length = i_blocksize(inode);
 		return 0;
 	} else if (ret < 0)
 		return ret;
 
 	iomap->bdev = inode->i_sb->s_bdev;
-	iomap->offset = offset;
-	iomap->length = min_t(loff_t, length, (loff_t)ret << inode->i_blkbits);
+	iomap->offset = iomap_offset;
+	iomap->length = (loff_t)ret << inode->i_blkbits;
 	iomap->addr = (loff_t)blknum << inode->i_blkbits;
 	iomap->type = IOMAP_MAPPED;
 	iomap->flags = IOMAP_F_MERGED;

base-commit: d5c57d9bf03516d625521cd6cf5acfd93e3e63c7
-- 
2.25.1

