From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 06/29] vfs: add file_pos_unlock() for io_uring
 usage
Date: Fri, 25 Aug 2023 21:54:08 +0800
Message-ID: <20230825135431.1317785-7-hao.xu@linux.dev>
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
 bh=/w6lIGuCSX5M2SzS7SE+A2P7DaEhoFOZKnfxuRd6M0g=; b=FCNMCaBUurNOocntHO+hi3C1sj
 SE0FvH/VYkKrJ85X3hQZlsekwf4rEqQFHH1GbD52pgvXm5DyjixSVeNA9FP+pgf47GQKxJ5HhScaB
 83BijIq/9ol8tth9/z3L+8bl+Yc8CYf+VnzG36kR+yBsFqwOyL1zaiV8h3fmM2ImcC9w=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=/w6lIGuCSX5M2SzS7SE+A2P7DaEhoFOZKnfxuRd6M0g=; b=fmC08pBfD7JIvTyoQesMQxWJI8
 ABadLHf3v79TxrzHYZI8JkclhMMW+WdMzz3uyZp9RyWCjLA5o3Ib+6+2qd2NixZDE7jFw7W8D/FQ0
 z4mSDZ/CqHrMr/s5HV2hhLa2Vaxsui1i58fHhLtTh0KhWTZAjqiFR+j5rk2VfLYGOX5s=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692971837;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/w6lIGuCSX5M2SzS7SE+A2P7DaEhoFOZKnfxuRd6M0g=;
 b=ZBBdmQmn/QswMnMhJaSAfXlf1oUY8DtSqPmmn75d8pDMERuOJJX6J86JCF/c0yd1RLwCFL
 31gixh9w5LkzzEj2vO8LvkCfQ90DBKrPt5Zp4Wgls4dziWWNaF03qzW9wejmnudGoy1bT6
 SZd55YvanxvHQ0hgcOptPehal51m0m0=
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

Add a helper to unlock f_pos_lock without any condition. Introduce this
since io_uring handles f_pos_lock not with a fd struct, thus
FDPUT_POS_UNLOCK isn't used.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/linux/file.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/file.h b/include/linux/file.h
index bcc6ba0aec50..a179f4794341 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -81,6 +81,11 @@ static inline void fdput_pos(struct fd f)
 	fdput(f);
 }
 
+static inline void file_pos_unlock(struct file *file)
+{
+	__f_unlock_pos(file);
+}
+
 extern int file_pos_lock_nowait(struct file *file, bool nowait);
 
 DEFINE_CLASS(fd, struct fd, fdput(_T), fdget(fd), int fd)
-- 
2.25.1
