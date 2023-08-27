From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 09/11] vfs: error out -EAGAIN if atime needs to
 be updated
Date: Sun, 27 Aug 2023 21:28:33 +0800
Message-ID: <20230827132835.1373581-10-hao.xu@linux.dev>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
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
 bh=y42FYySYNsis5G3mORomW/nSivl81IaFtk7YSUfz0Jg=; b=HuAEOxXqX67LnBCbKz9mMz1VXr
 OQP/zSOZ5thHvSxt9FwK908YGFxSNtahLQulgIxVx6hJYH5yDgRCxVN4e8yiexic/GcY7fu+EHXOE
 epkvDP02seye+i+vbAApwMuPeRNYHGEqPbXse16wn7Wzlw2E4VAaBSisce47EVgVuXE0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=y42FYySYNsis5G3mORomW/nSivl81IaFtk7YSUfz0Jg=; b=aZx88lppqmW3SX7dcZnKqa9yUL
 88kJqpYlK/6FVNeNFEGY4x/4+zi+p5Hd/AzpAl3Z45Loc0iY3g4ucw6UdIbuFjx0pvYCxkDQIrBlF
 ThKdwXJAxLLir7TouEb8ubMLFnv8qDQ0B+6/BPua4tImoFko6msbyKWQWlRXs0PPmb38=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1693143308;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=y42FYySYNsis5G3mORomW/nSivl81IaFtk7YSUfz0Jg=;
 b=S4P5Lis+5UgxAXsbIFEQ0bJcfwW5bp3gD+5EV25w4Odl6XRzUJpaJGVaokRckJ9Hpyff0y
 QCMWQ876jzpmtvZlXQ4fdJDhdeygghENaAwk2aokCERTn3SKcsNlbNr+KPD/7nkWidZUEs
 LZ/LAlKjzWeA2HQHZTdX8ZHXdvIJ060=
In-Reply-To: <20230827132835.1373581-1-hao.xu@linux.dev>
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

To enforce nowait semantics, error out -EAGAIN if atime needs to be
updated.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index e83b836f2d09..32d81be65cf9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1970,6 +1970,9 @@ int touch_atime(const struct path *path, bool nowait)
 	if (!atime_needs_update(path, inode))
 		return 0;
 
+	if (nowait)
+		return -EAGAIN;
+
 	if (!sb_start_write_trylock(inode->i_sb))
 		return 0;
 
-- 
2.25.1
