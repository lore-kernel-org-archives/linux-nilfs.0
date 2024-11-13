Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2352D057;
	Wed, 13 Nov 2024 03:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731467069; cv=none; b=FHFinSeEAz3wcVEzm4/hqUvtsaY6VsojZGJp9CF0D+lbQuv5BvEijWvsaKHP/4FoXuvJ4eIJlG+SZ+kDKczFdKlnz4olexu3W0mwiGe1Rm+R4mcEQSmWilUottR0h1NaM+u4nAoiToMo9A//gYMQD6/ssyNC+H+E+HpSLol+O3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731467069; c=relaxed/simple;
	bh=ClsvbLAOjDY+lv/Bfvl1TlwV71ZawlYgp11ERu/u5X8=;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:
	 Mime-Version:Content-Type; b=iFSUHXwArnE0Z5UOaa8h60l93imUHEfGEoFlucAC66gZDOfV92gKpxPPafLoxHJdvg5zFRYJV5KujmfH9Vt0aws+5YFwv7S0Mq2wFz9H9SRjeaKQipLCLy4NeiqhDvMQtucDOdfB8QNRsOC9fKn6E3FDnV4WYtp3fRA6SA3fcnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHJV04pc; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHJV04pc"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2e91403950dso4939990a91.3;
        Tue, 12 Nov 2024 19:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731467065; x=1732071865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MfGvSnNXVufWcoCNAr8wCyAcyLmYxKQmmVQCV3zOeP0=;
        b=kHJV04pcniMiD56vFloWPBMpaTLOFfACoKnrMPyBSZEpNhklmwMg4EkcM7yKNMp8GB
         FXTS0V73A1sOJMfvMQbpDOJtJniZPC0Wir1ioEFuwtqMggxKqS1NOQd/B8cy0Oqb73se
         yExhFI9xXrnNztcrK7rqwymj1guFpFuScuNeaHLGHi5ltFJJDWCCWo+vkXnG8/dnMk5e
         NHtkKbg7T+RSzVvhTx2vCEMQ+mvZyejI1GbnKxhjWLQ7k5/Rwitj3JfKAnaThZxbxIOA
         Hemsr4QiQqDKcnxPSOPtxrHZTy1KuUwSqJyCD1eEHqqPSVV7Q0P/OP8g4hbf4VF+XE6r
         N8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731467065; x=1732071865;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MfGvSnNXVufWcoCNAr8wCyAcyLmYxKQmmVQCV3zOeP0=;
        b=XKX8Lb/HyrqKY04mxL/2lJZAqR82MQSMoKVqMwoUmEqx8iBLGMp5uBYx7odQR0MrRL
         mfi/CrsPhBZhMu+6oJ4P8TzIZ21vt0l1n0UezSZgpWQHPvZ9mb9RDSXGUKImhhE7u1CV
         zYBYZ5JS4TWTxc+PkSJCOZ2zOBiGmGaKn5IS1gPEQ18BS63a6jvJTFZGLdAYEjENj1KE
         tymF9e17MeyItMXd8LO6d6Vdt7+IjnugvsRZnvQGY1nekTIWRXTI12IWmDG7Gq9Z8f8n
         W7zA91R4YWrOQFZikZSepQtj6/2M0L5U3gLxSaJ7axE8o6oDvp9q9GDMWLe1PGL+rxi3
         RWtw==
X-Forwarded-Encrypted: i=1; AJvYcCUwJBXPM8gBbkL4RW0ta0ryKdlvLr3JY/jfNcmlLCNm0IlMxyBMa4kCAzSjVeYTZdTbftK9JHHoP/VCTA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtYsD8FP4KyYmthTiapMAzzRcCU5F1dxZ3DUrjv5BPSLDh6dZx
	Vf/JS5jQ0INABM4tOScAmM1CJFtRjZ9nZVcgBh5wzjllxxYrIyXN
X-Google-Smtp-Source: AGHT+IEZY44YC28C51jHuKuS5xHGf/G5hVS890OSmtNPdpN+4ckgirmiILSOITq1BZbvgZtd5T7VBA==
X-Received: by 2002:a17:90b:1f8e:b0:2e0:d957:1b9d with SMTP id 98e67ed59e1d1-2e9b17163cbmr25396408a91.13.1731467065422;
        Tue, 12 Nov 2024 19:04:25 -0800 (PST)
Received: from localhost (i223-218-156-103.s42.a014.ap.plala.or.jp. [223.218.156.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9f3ec86d2sm334580a91.21.2024.11.12.19.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 19:04:24 -0800 (PST)
Date: Wed, 13 Nov 2024 12:04:20 +0900 (JST)
Message-Id: <20241113.120420.319092919822964048.konishi.ryusuke@gmail.com>
To: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [nilfs?] KASAN: use-after-free Read in
 nilfs_find_entry
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
In-Reply-To: <6732e1d8.050a0220.138bd5.00d3.GAE@google.com>
References: <6732e1d8.050a0220.138bd5.00d3.GAE@google.com>
X-Mailer: Mew version 6.8 on Emacs 29.3
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Test a variation of the nilfs_last_byte() fix in which the type of
the local variable last_byte was changed from "loff_t" to "u64".

Since both PAGE_SIZE and the argument page_nr are unsigned, in
arithmetic and comparison, both are calculated as unsigned by implicit
type conversion, and the behavior is the same.

However, changing the type of last_byte from unsigned to signed
results in a new comparision between an unsigned integer and a signed
integer, which may introduce a new warning from the grammer checker
when using "make W=2", etc., so use the unsigned type in the
declaration.

#syz test

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index a8602729586a..f61c58fbf117 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -70,7 +70,7 @@ static inline unsigned int nilfs_chunk_size(struct inode *inode)
  */
 static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned int last_byte = inode->i_size;
+	u64 last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)
