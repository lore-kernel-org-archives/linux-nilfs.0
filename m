Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795773298;
	b=0EpoRy+uEybsGNuS0zBd8WtVmWUKa5EuBM3vQDfAMUuWp99V3kmFeTz1utS93TdUzblf
	 LZQ786CKnualQGXQ4FTAl1ETfoUcTgxKiteTzuSY02STkNNxMPwyLdzXeUPDNKocmy3Lb
	 k50WUq7B5hwrGnkgVgCAcq9VxJsvzVKQP8hL4Tzu2d41dIQCikC4W7/jy5S6j7sf4Rn5S
	 C89aAyrY9ITLXbuQ567HJOxnYHoTIGYfzcfWBnAwISR1jDGIPdx9F8d8JOIJ3l6EoMalC
	 qlaS/Yts/tNqmyDRtzi3ShiQRdFH2LNO+9IKga/ZFXvXUomwob1ikQLxk6b/Zapt5Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795773298;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R5NRBFE6LyQ+OcOMVwBzMt4B5m7JjyvvYW8xEn2fXVY=;
	b=FQkxhzjdzIG2Sh6Jg7z6x+KRVnGMVezVcXbkRrdmJXubKwVLuOp1Jzy54SA4L+SITvH1
	 pzes6BjNrFaLGec8Gt6FThpeGDafVJcUbuMDuqr+3Ht6qUU2CYPHIY29xGIg1wxATCjgK
	 ILjcWwrq5YDfCU6v3rrAoL1rn2UPzFIShfJnavHcBbZSLMzfBXsBltjslP5uHgrfO/w+q
	 ShOhIMLAXyYFKk3S4uFzSshp/WuiSjST0ufNb7HMK6cbpOyZWp5ecb1Df2CAVwp9l7Swl
	 Emq8Ni3cWOYCYcIOp8BTvOtYZBiGhF+9b3HUEEsiKs6pT9eQE1jjkoJBOq4NgRFdMOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=nJpM88aV;
	arc=none smtp.remote-ip=209.85.128.182
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59217606A33B
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Nov 2026 09:54:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59217606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=nJpM88aV
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b4e04eda5aso58124497b3.1
        for <linux-nilfs@vger.kernel.org>; Fri, 27 Nov 2026 01:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1795773296; x=1796378096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R5NRBFE6LyQ+OcOMVwBzMt4B5m7JjyvvYW8xEn2fXVY=;
        b=nJpM88aVuWd6NlXHVoqKaTO7UqOEpXIliV1H5+UHbq4wjj2ZeqLqUwGUY7hS0N08V7
         RHNJs3fHTck5qPsixpUH7UX7vxNZC3XTwF8lWnOtSkkGHOILCuAKivHo7AZRS5CBeytq
         1rG0938Q+tPwd2ZXBhFMAwy54PHOlqXB2reeoc+jZTG1DMnP29NbWf/zcw97lGcoGRFJ
         Jc7oSajVj5ADGTlU2Zd9/5l4kyjH7TnR4uNy7yqzYTvp51hkQ/CkvbAo+Ntqf+yXGwxO
         gSaDu0IRotpK+BQJv3HJ/55STY9aSgiXtmfxjE/dTiG1LqZNMFLC3B5LRkVIY1M8j8Q0
         z2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795773296; x=1796378096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R5NRBFE6LyQ+OcOMVwBzMt4B5m7JjyvvYW8xEn2fXVY=;
        b=FKNn2pAWNIpkcuLmW5V0H5DIID8QXUvjB3r6H4UWkSTvArPrc75XSrEmZBRQ7fXxeD
         UUOejgmvX4a0VXipJSEW/n0FztF4E/ZE8vWNnCf+rVYd2H0oQN5USTVN/1PJav9+whHQ
         z6TjBVkC6dtOVYAdZNkLhpUxFZUMD4Qd/PUTnbCtOzVReReykIx+FqP7/30zscHXlSH6
         d1Mb4+CEpYcIlKyZ+BfdJCuZIojIL41O8/AdP2icQ5rQ+5vAMVLz6rlWYAfNoiUonAUe
         0x9Ix/q3LicCssD/DrzHD1T/8xV04G6EP20XQOexarVMeSku7BdNaro+VAZVixe8tfrv
         4QCw==
X-Forwarded-Encrypted: i=1; AL+hErFL7m4wGcYwCWQ2SqlA9YV8XooX6UF5B2I/Ip148A2oFyHOAgIAO0DtD8S1+xXtlu3Xu3/quKrrNqc74g==@vger.kernel.org
X-Gm-Message-State: APuU4Z84wL7fg9FbxrnSr1PhSDqItxDm+ZuGSW8zjhdEeD1Fw53Q5PrV
	q23GCjEU+VDt6/f8B/UXvg9bEQvth4NatwKnA0EUadU+V/+PuaztV/PIBM+J3lXYmw==
X-Gm-Gg: AZFdTZcfZNPFyX+2AKSmYyi4WKV8bYq2Qp3NttCDH2f5zFV9pDFPMHNfL4JOTXDXRHf
	OoZurr7P9PWFigcjbwHbknsld2wa8v71aRVdvrJbUKtpaCdCjPVcnVm4DOxh1QMV+qtjHwbTxgZ
	9YPR887isRPUvmK+I63c8vpYMR/rzAJmq5ufcq7M0vOioIDZUiAz7tVTaqvYepk7b0/M9onuYII
	KWApYgxK9SGmn5NgRT7tKB4IjcCcAPJIE+4hzPTH1NxYmNdFxjq7vMZiY068Mz656T3yy5IwMVg
	lieGDtZsktTb62uGxBboQ9OUQBr5/eCcFpXsdsd781bLQJdYVfTBAKdqgb5iUv2/tCMRR+n1niH
	CojPD03kap8e2l/e5PxU8qI93Hi+JEIqvnjXIb/0vPbMmLlRQDbfzG6Lw+Vrt+MVobS4dlq8zPL
	GSakUiC997idovdpD3DjlmqQqKNp2bqilD5U1aH7/BkHwFfwO8Ko6TPKyulEj41SZtk0cYbz6mY
	4y5AHQ7iB/cQNMN8rbwGItA5t48etqCb0Z+BzB9HqlL2aq7QR9WH3pKJDmIPmfLPSOHMDpo3+eH
	/6PK3IuMtF7IrkXbFXikVVIA8yiNIg1yGzSV0uF0PgvKQ0bZ6Vs=
X-Received: by 2002:a05:690c:3347:b0:8b4:da4e:ef09 with SMTP id 00721157ae682-8b520325401mr116169647b3.1.1795773296194;
        Fri, 27 Nov 2026 01:54:56 -0800 (PST)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b5202cb0b0sm95567197b3.23.2026.11.27.01.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:54:55 -0800 (PST)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] nilfs2: count new blocks that a short copy leaves dirty
Date: Fri, 27 Nov 2026 04:54:49 -0500
Message-ID: <20261127095449.1379289-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_write_end() adds only the clean buffers of the copied range to
the count of dirty blocks.  After a short copy, however,
block_write_end() also zero-fills and dirties the newly allocated
buffers of the part that was not copied, which is the whole range when
the folio is not uptodate.  The write is then retried, finds these
buffers dirty, and does not count them either.  This skews the free
space calculation: nilfs_near_disk_full() does not stop the writer in
time, and the reserved segments are consumed.

This has been the case since nilfs2 was merged, but it used to take an
unusual short copy, for example from a source buffer that runs into an
unreadable page.  Commit 665575cff098 ("filemap: move prefaulting out
of hot write path") made it much easier to hit: generic_perform_write()
now faults in the source buffer only after a copy into the page cache
has made no progress, so a write from memory that is not present yet
first calls ->write_end() with copied == 0 for each page.  As of now, a
write from a fresh anonymous mapping is accepted far beyond the free
space, fsync() fails with ENOSPC, and the file is gone after a remount,
together with the other changes made since the last log was written.
On a volume shared with another user, that user's fsync() fails with
ENOSPC too, and the files and directories that user created after the
write are lost the same way.

The issue can be reproduced on a 160 MiB disk with this program:

    #include <errno.h>
    #include <fcntl.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/mman.h>
    #include <unistd.h>

    int main(int argc, char *argv[])
    {
            size_t len = atol(argv[2]) << 20;
            /* fresh anonymous memory: none of its pages is present yet */
            char *buf = mmap(NULL, len, PROT_READ,
                             MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
            int fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);

            printf("write: %zd\n", write(fd, buf, len));
            printf("fsync: %s\n", fsync(fd) ? strerror(errno) : "ok");
            return 0;
    }

and these commands:

    mkfs.nilfs2 -q /dev/vda
    mount -t nilfs2 /dev/vda /mnt
    ./cold /mnt/f 256
    umount /mnt
    mount -t nilfs2 /dev/vda /mnt
    wc -c /mnt/f

Before commit 665575cff098 ("filemap: move prefaulting out of hot write
path"), the result is:

    write: 67518464
    fsync: ok
    67518464 /mnt/f

After that commit, the result is:

    write: 268435456
    fsync: No space left on device
    wc: /mnt/f: No such file or directory

With this change, the result is:

    write: 70217728
    fsync: ok
    70217728 /mnt/f

Count the buffers that block_write_end() is going to dirty, including
the zero-filled new ones, before calling generic_write_end().

Fixes: 05fe58fdc10d ("nilfs2: inode operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
I found this while comparing the behavior of different kernel versions.
I used an LLM to analyze the problem and to draft the patch and this
message, and I analyzed the result myself.

v2: as Ryusuke asked, the Fixes tag now names the original
implementation, the stable Cc has no version, and the message says the
bug is old and 665575cff098 made it easier to hit. No code change.
v1: https://lore.kernel.org/linux-nilfs/20261122130247.2069007-1-hengyul@cs.unc.edu/

Tested on nilfs2 for-next with KASAN and lockdep, also with the short
copy from Ryusuke's reply (1 KiB blocks, source running into a
PROT_NONE page): the dirty block count is right, and a nearly full
volume returns ENOSPC instead of accepting more than the free space.

 fs/nilfs2/inode.c |  3 +--
 fs/nilfs2/page.c  | 41 +++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/page.h  |  4 ++++
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index b217eee57c36..dd0bed24972a 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -249,8 +249,7 @@ static int nilfs_write_end(const struct kiocb *iocb,
 	unsigned int nr_dirty;
 	int err;
 
-	nr_dirty = nilfs_page_count_clean_buffers(folio, start,
-						  start + copied);
+	nr_dirty = nilfs_page_count_buffers_to_dirty(folio, start, len, copied);
 	copied = generic_write_end(iocb, mapping, pos, len, copied, folio,
 				   fsdata);
 	nilfs_set_file_dirty(inode, nr_dirty);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 857926da9f21..0dec7b5b27c4 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -481,6 +481,47 @@ unsigned int nilfs_page_count_clean_buffers(struct folio *folio,
 	return nc;
 }
 
+/**
+ * nilfs_page_count_buffers_to_dirty - count buffers a write will dirty
+ * @folio:  folio being written to
+ * @from:   offset of the write in @folio
+ * @len:    number of bytes to be written
+ * @copied: number of bytes copied into @folio
+ *
+ * Count the clean buffers of @folio that block_write_end() is going to mark
+ * dirty: those overlapping the copied range and, after a short copy, the
+ * newly allocated ones in the rest of the range, which it zero-fills.  As
+ * there, a short copy into a folio that is not uptodate counts as a
+ * zero-length write.
+ *
+ * Return: Number of buffers that the write changes from clean to dirty.
+ */
+unsigned int nilfs_page_count_buffers_to_dirty(struct folio *folio,
+					       unsigned int from,
+					       unsigned int len,
+					       unsigned int copied)
+{
+	unsigned int to = from + len, end = from + copied;
+	unsigned int block_start, block_end;
+	struct buffer_head *bh, *head;
+	unsigned int nc = 0;
+
+	if (copied < len && !folio_test_uptodate(folio))
+		end = from;
+
+	for (bh = head = folio_buffers(folio), block_start = 0;
+	     bh != head || !block_start;
+	     block_start = block_end, bh = bh->b_this_page) {
+		block_end = block_start + bh->b_size;
+		if (buffer_dirty(bh))
+			continue;
+		if ((block_end > from && block_start < end) ||
+		    (buffer_new(bh) && block_end > end && block_start < to))
+			nc++;
+	}
+	return nc;
+}
+
 /*
  * NILFS2 needs clear_page_dirty() in the following two cases:
  *
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index c3ba3468af5c..4ccd740966ec 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -45,6 +45,10 @@ void nilfs_clear_folio_dirty(struct folio *folio, bool force);
 void nilfs_clear_dirty_pages(struct address_space *mapping, bool force);
 unsigned int nilfs_page_count_clean_buffers(struct folio *folio,
 		unsigned int from, unsigned int to);
+unsigned int nilfs_page_count_buffers_to_dirty(struct folio *folio,
+					       unsigned int from,
+					       unsigned int len,
+					       unsigned int copied);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 					    sector_t start_blk,
 					    sector_t *blkoff);

base-commit: 8fef1a9dec7bf58a29bc8a7ee6909ab629401cd3
-- 
2.53.0

