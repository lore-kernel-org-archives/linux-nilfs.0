From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 18/29] xfs: set XBF_NOWAIT for xfs_buf_read_map
 if necessary
Date: Fri, 25 Aug 2023 21:54:20 +0800
Message-ID: <20230825135431.1317785-19-hao.xu@linux.dev>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=qTb/druvnHmAZS3W1u50TERu+WCPGmDec9gQaqemBTg=; b=FKl5ThvG2Ey5oxslwgPtROr3Sf
 YuNRm7IBm6S3vE1EQUcOFZngOOMq4ScOQQfhWBB6QQTbMzFN/uMx2wlVTC3OtxET110U/OoXjVO9F
 X5gfdgyE4AflOMq/nRafxa+Fh+/7hnHksRgV6k0H0uXMk8WcsE++dwhjSWk4UKU90vu0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=qTb/druvnHmAZS3W1u50TERu+WCPGmDec9gQaqemBTg=; b=Z9B3K61YgMXfRKWvnOqEpnJ1g/
 hLQFY2m0HchY/spHAh26PPyvb/sM9/NMXrleVA8YHeXCz/QtSI91NxxtqJrMs4SpXtrQtsYwlMtjS
 hxVTDSNjkIMU7tyagp+83dKVhyHpZp/IrIakT62KIxChtv3v6HZYq9sIUV3wfltY5qnE=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692972185;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qTb/druvnHmAZS3W1u50TERu+WCPGmDec9gQaqemBTg=;
 b=F3s/OJUcPEY5Zlidje3R3yeS51LSjhWu/qJIZQ5RlOJtYZFuPHsEDcjE4qLEmmAUjn6Noq
 1FuuA0oBiaR8ILzLTnrrBydu7XR0r/KR3HJXB7nZmLWLG0jXn8HNnNNNLFYiSbQJ1kLBWH
 sWlvtA/UHWBfhR+BdKG+F5ETxQfMgq0=
In-Reply-To: <20230825135431.1317785-1-hao.xu@linux.dev>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Wanpeng Li <wanpengli@tencent.com>, "Darrick J . Wong" <djwong@kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, linux-cachefs@redhat.com, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-cifs@vger.kernel.org, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, netdev@vger.kernel.org, samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, bpf@vger.kernel.o

From: Hao Xu <howeyxu@tencent.com>

Set XBF_NOWAIT for xfs_buf_read_map() if necessary.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_trans_buf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 6549e50d852c..016371f58f26 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -286,6 +286,8 @@ xfs_trans_read_buf_map(
 		return 0;
 	}
 
+	if (tp && (tp->t_flags & XFS_TRANS_NOWAIT))
+		flags |= XBF_NOWAIT;
 	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops,
 			__return_address);
 	switch (error) {
-- 
2.25.1
