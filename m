Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795754578;
	b=pRpd/ObvOZX25NxS/VqAok1c7q6BtEdZPYldvatgZFHxJzR4oZLPcqrTtRUlkc3If+qz
	 ka2Yz/elik9s+kMP+ndKNHIwGbPJC3GxYEDuEZg/PmSKKNTSIK+2n0WLn/duloSmZGKUf
	 Vjciq2mw/kQ8V7RsSfidesLOnH7MOFZc38khQoIKphHiLAGkT0mBlLDvdMNf+fKZB4g6z
	 BLM0aZp7zc0m3EmbMawfaud0QijjPbq28YymQhuKCWISuDUhpYOZ10xpZuSOorwcEU80R
	 2LuGfUo7qLWuSD5DsPZI1xEDfzHURKcBJYTuejZX26Mm6glXXhk9/gKtAItkn03f5Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795754578;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FlZVgstUiKok9fd01FeyZhK0bRQdfrsI1x6ZmeBZqEA=;
	b=gEV79v9xmGyLAIqPjDVkDIVMRISfjqeYAvknh/U61AZxbPDzmwgQe4aIZNFfcS0s9LCU
	 vy1qqjIA9EFqoRky1mpfTnUgr8z2AaYdJrupUEYM4l2MznirlePYHhaROwB7CsFKZ2jPS
	 g3csOrfGcczOQGGuocf9JjOwt8+WP2e0+RtGzl3Hn8p20kzT8/gXDrnj35HaEBavwRb6L
	 xEHZh3bQpJ5kurqUauc/XF+SWJzAU9spCBEwXUZZW8bbOKBuFFJTBqPXjxoqBfApfjf2I
	 D0H5LDH7WP9xkKlwAkIgc7RRw3C/zOyMH5bszBYAV8OhOYl17dXxCeuSPmX9RiNe1kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rygzqj3A;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0BE606A696
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Nov 2026 04:42:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A0BE606A696
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rygzqj3A
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-15dd124bbe7so11248564c88.1
        for <linux-nilfs@vger.kernel.org>; Thu, 26 Nov 2026 20:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795754576; x=1796359376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FlZVgstUiKok9fd01FeyZhK0bRQdfrsI1x6ZmeBZqEA=;
        b=Rygzqj3AG5bwJnLyOQL8p/munsxO7nnRa15tC/ekWKJXZ7BMiXrqx7k0kQTU5ErkaJ
         3+QqPB/GlrTtqNeqABtYQWzFn/1896WbOhBYz7hc1Hsi8FoYQLlXA3gJZB2MBvssH3i+
         pQTsj6yPwdAi9dpEKjDpDdit0bNxmAc2oGZmoofe+1HM87uMADaxRpdLYfQVe8Mnsn7i
         O1Qu///S51WfW59B2px4YMNRYn3BpX/WpmpC/8ZmsAFo6MCUn5DPDwcEP2nNw2/XnhJS
         7mwfdeyWGJ8xPE00a5ayVvxuomNgF6TRBKXIQMOTVXRx0kzLlKWBT/a0APITwmEoJDO9
         qYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795754576; x=1796359376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FlZVgstUiKok9fd01FeyZhK0bRQdfrsI1x6ZmeBZqEA=;
        b=HC4owZhi5cCBH/inlPLSNnaotkqMZOvrh2oRAUUeiu9ICqoHR3IwIcguyNUo2ZtWVt
         Fs+erbEgm8iHd/vRIFjdCy8eXjdph+bvSyBDNyiiHIZk5VTPg3zV2w01ooMdJwWQvRy+
         wcFSpavRxKQSKRv1fygArwzXkdWtVqqwNKhivXB0N0lNAam7wh58XN4veosqlfNisGDH
         x1Lf8XIsMsNtmDZl42Ha86b5FWovXfS8jlaaA+v04yfykIQr+czb1Tawx+r19YxGgscT
         8maKpPz3DPYyuhKmIZ9c29w/ZrJxQGtU4FypL8w6PWSq33/L13Hj5SgeQ2I/KsnPePH1
         6sgg==
X-Forwarded-Encrypted: i=1; AL+hErEwFRURf2vdQ2KoLSMFqSM9vDOIph4lFCkis+a0Tr1r+vocAzOtvnKjfmzZAycC+v7RhuW6K3jc54MG3Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z+Ll2bJpLbaA+092o2Za0QQ7uNv2s+S0vQ1msd2x/3Nf5l5vyQy
	+1Oh2kc8AnngqbV01kS4b6bUTu4U8OeS1py/40pmD9E7difYLFuKOyF0
X-Gm-Gg: AZFdTZfVwaoetCPLYeeqL2J6HGNy+SF4tpR9WQePXEEm1ivCZS4drQn1vhNhy3ygQTQ
	I12lF9BT933DMyjheVX+fH2KVjDNta3rBmjnuqoDlxI6o2E2xRnobBiXz6mWLYP23xD0U3+CZo+
	aiAjfo6nZe1ktz8gFLwb5EuknFO40i1mQKT0Etl9v55iuesiOacwi34zaw7A9t+67pJMB8wn7Aj
	HoX96wxvFEFmgGN0dna4E3iNRwiKe0INGYV8+ERYYLhjFn/1nznVG1I8wkZ3WImicVKSCIBzbg4
	OyL/6SLO92hLJEGByJctc2KosAqmJd8y5YJdZWdNEZQWLjJevCCN0nAQ5/q+Rc3gjhSEA7Xjo5c
	64If0Mdo6pMlEWkRXQWlzziboPoEpnsJ5XA7qIahIL1EbBWEKkdL9rkFaQqG2or2rkeA6GxekQS
	tQ3msfzUIWQ4lCcndLmO8s/3nXQBGTXGagDY7GrLYSryjaQ+xYhywJPHARlj5mT8Gz0AqysotFg
	acPeSBP1egl11OT1jCacv1+5ojwQvODUSXgvmtru8MqGv6FNNnv8m5vc0+ZfC3agB9OJT5csw87
	prlFgT8TEMWQhiOuHCwR9sYaa1wYtgZK5sk6Iv6zuwTj6qp1HKeDcX3UmGV6DOg=
X-Received: by 2002:a05:7022:5f08:b0:144:c112:5f24 with SMTP id a92af1059eb24-1b5568f9e24mr23217860c88.25.1795754575621;
        Thu, 26 Nov 2026 20:42:55 -0800 (PST)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556829d31sm88000388c88.9.2026.11.26.20.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:42:54 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Wang Jianjian <wangjianjian3@huawei.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Zheng Zheng <fengaojigui88@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>
Subject: [PATCH 8/8] nilfs2: avoid infinite retry loop on GC failure
Date: Fri, 27 Nov 2026 13:41:01 +0900
Message-ID: <20261127044231.37630-9-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127044231.37630-1-konishi.ryusuke@gmail.com>
References: <20261127044231.37630-1-konishi.ryusuke@gmail.com>
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

Currently, the GC loop in nilfs_clean_segments() only breaks out when
nilfs_segctor_construct() returns -EROFS, continuing to retry on any
other error.  When a persistent or non-retryable error such as -EIO or
-ENOSPC occurs during log writing due to filesystem corruption, I/O
errors, or free space exhaustion, this loop can spin indefinitely while
holding the transaction lock, leading to task hangs.

Now that GC-specific state changes can be selectively reverted on log
writing failure to preserve filesystem consistency for subsequent
operations, modify nilfs_clean_segments() to abort immediately on
errors in general, leaving only a minimal retry loop bounded by
NILFS_GC_RETRY_LIMIT for -EAGAIN and -EBUSY.

Fixes: ce5a5ad1a833 ("nilfs2: fix infinite loop in nilfs_clean_segments()")
Reported-by: Zheng Zheng <fengaojigui88@gmail.com>
Closes: https://lore.kernel.org/linux-nilfs/CAO-4RZ1Q-HzRCd+S1uHZJRdN-ZCtv47f=pXTxbq4YaJgn_DALQ@mail.gmail.com
Closes: https://lore.kernel.org/linux-nilfs/CAO-4RZ2pjEOpTBzqca5UxZHtaFS2Dj9zmNj1BtjvKm1yFE7_Jg@mail.gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/segment.c | 9 ++++++++-
 fs/nilfs2/segment.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index b306f09c9497..5765959617fe 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2582,6 +2582,7 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 	size_t susz = NILFS_MDT(nilfs->ns_sufile)->mi_entry_size;
 	__u64 *segnumv = kbufs[4];
 	void *subuf = NULL;
+	unsigned int retries = 0;
 
 	if (unlikely(!sci))
 		return -EROFS;
@@ -2644,7 +2645,13 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 
 		nilfs_warn(sb, "error %d cleaning segments", err);
 
-		if (unlikely(err == -EROFS))
+		/*
+		 * Although the log writer should not have any paths returning
+		 * retryable errors (-EAGAIN or -EBUSY), keep a bounded retry
+		 * path conservatively.
+		 */
+		if ((err != -EAGAIN && err != -EBUSY) ||
+			retries++ >= NILFS_GC_RETRY_LIMIT)
 			goto out_unlock;
 
 		set_current_state(TASK_INTERRUPTIBLE);
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 711c69e24575..4158948d890d 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -204,6 +204,7 @@ enum {
 					* Retry count of construction when
 					* destroying segctord
 					*/
+#define NILFS_GC_RETRY_LIMIT	    2  /* Number of internal GC retries */
 
 /*
  * Default values of timeout, in seconds.
-- 
2.53.0

