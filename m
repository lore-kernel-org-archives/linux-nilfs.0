From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 04/11] vfs: add a vfs helper for io_uring file
 pos lock
Date: Sun, 27 Aug 2023 21:28:28 +0800
Message-ID: <20230827132835.1373581-5-hao.xu@linux.dev>
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
 bh=W04QOWrrBuMFm18D/+g+MI2uZNnKBIsbwxq2wO1dKKw=; b=ffpwhn0FqZqO6YBgHLI2KFS6H4
 13elcb7yk3sypQS0bKjZPTot2hjgGD6knz+QBkgI+8fb+3ZT4sFyGQWqqXGpk9mmhKIA06hfRR7/W
 c3qvDpk3XMtgRIVNRT1cUz/PfTEnztqyWCh7efFjX959L1Wjiddc+Y8V3NM26s61pjcQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=W04QOWrrBuMFm18D/+g+MI2uZNnKBIsbwxq2wO1dKKw=; b=EBZwca2jEMHSL3/qYt6RTeChJQ
 wdD4c1xo1/tDdrNseUfJPJU2WSOeVrgi9qV6cjcgyj2eoB4Ai7Pa10GgMDWmBX2TosZOcZpAs1AJ/
 C7S3J4mfTbxGJXio5uRnzyh71a9N1JxIaPTBtcrCjmB5UmIiXHPc0U0D37kcN1sY37jc=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1693143164;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=W04QOWrrBuMFm18D/+g+MI2uZNnKBIsbwxq2wO1dKKw=;
 b=Yw+5XvRr3vDIU02wPbTBy+P7Vb3r5vANDo9ahLXEToHmV4GE1+GjTI2/FiGvzS/72CcLGE
 wNMghjMXDTPCiQyUzrxQFpeftIBQyMH0jGDsayXuE4xMGusaZd0pBKhpckAeDFF1jY1yin
 IKCCEyk0xEU76DQXzGM7PUWjnMG6kt0=
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

Add a vfs helper file_pos_lock_nowait() for io_uring usage. The function
have conditional nowait logic, i.e. if nowait is needed, return -EAGAIN
when trylock fails.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/file.c            | 13 +++++++++++++
 include/linux/file.h |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/fs/file.c b/fs/file.c
index 35c62b54c9d6..8e5c38f5db52 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1053,6 +1053,19 @@ void __f_unlock_pos(struct file *f)
 	mutex_unlock(&f->f_pos_lock);
 }
 
+int file_pos_lock_nowait(struct file *file, bool nowait)
+{
+	if (!(file->f_mode & FMODE_ATOMIC_POS))
+		return 0;
+
+	if (!nowait)
+		mutex_lock(&file->f_pos_lock);
+	else if (!mutex_trylock(&file->f_pos_lock))
+		return -EAGAIN;
+
+	return 1;
+}
+
 /*
  * We only lock f_pos if we have threads or if the file might be
  * shared with another process. In both cases we'll have an elevated
diff --git a/include/linux/file.h b/include/linux/file.h
index 6e9099d29343..bcc6ba0aec50 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -81,6 +81,8 @@ static inline void fdput_pos(struct fd f)
 	fdput(f);
 }
 
+extern int file_pos_lock_nowait(struct file *file, bool nowait);
+
 DEFINE_CLASS(fd, struct fd, fdput(_T), fdget(fd), int fd)
 
 extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
-- 
2.25.1
