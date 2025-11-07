Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A709232B996
	for <linux-nilfs@vger.kernel.org>; Fri,  7 Nov 2025 15:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762529738; cv=none; b=tLqRYiLm3x9BHWBt+2jgu6/nRs1dP0PLqphdHKBAupfdcGijmDo8FDf6/eru1Co/y600Zs79JqyLB6UXhNt8CygR6TBuEfBofGTEhrH2loNzM5PJ0aOhZ/eWVR+mh0N9xXlVNCRThFGIaC2pNelSjJuQ2P0WTDzvIuBtMJtCZFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762529738; c=relaxed/simple;
	bh=zJdrcgoALR0xH2DkImtOIpo+BNEvKbIMo9Z6qrx/plA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TccwXiCCdBi6xhrPmFqs/JfKB7XN7aMAPZb4ChSnY/jy8o8iRcspQq56JoiehlA8hc9LBVRANFq/9Qk7NJvGN2SNwUyDV/p9qjrwRYufJQcDHeqmJhYnIg4k+GyQv4ylR1vQFs6ochRKh5KCRVWfZih+61fFlQUtbkyF/i2mV8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YorsSntO; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YorsSntO"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-78af3fe5b17so718814b3a.2
        for <linux-nilfs@vger.kernel.org>; Fri, 07 Nov 2025 07:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762529736; x=1763134536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/W0MVeUMNs9wcZldJ+mVuCnE4W2Lpw3nds3hMNg6jvI=;
        b=YorsSntOgrY+2ojMZ5H/ZumsKqvQqc9DjW0EEHYG7LhhndVeei5St8NIIUXUNbdBmL
         BPxIEfYTVORjnBBYl1oWQw6lGQKqA+Cd4CF0qXgX/pnLmSJoTTFVvv/ZRdKih9eHdvWM
         fyjzxYC0eIcz+4UDLjvVYI6kmvzW4KbAUW+2YjzwQyRaUdGFJd3TamScgfXHYEAYSg9+
         +00beu3aOOF3wro6YiQc/RhGkb+7jJ5N3wnYC3bTNhJ5OBvxv/UyPX1BccBWhl0VZb4d
         JmkFeyYc85x4wlslbbYVxALIMDqeFphCMWOrE6k7mgefz6/8MpmSjd/HYAxpR15NWcRM
         3mFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762529736; x=1763134536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/W0MVeUMNs9wcZldJ+mVuCnE4W2Lpw3nds3hMNg6jvI=;
        b=A5zEkGCE6cVxwlwP7NNNemwNZHQXffa7ry98RBotRvFlLWLw0BplWEWhD0y7Qs7yhV
         RjqmFI5WAiKnzqoq591rpHn3ksrhysapDGsV6SBeRwAtOgGpEEoOAnaGkyLV/YsBzjan
         EKfPg74wz92/fhny5s2inq69fYwEai8m9ppOHljDPs0v5bLGuq/6/EfqPGoRA2Ugcn7B
         SoG6sNzFskOEsgjkT1+xqxqlQguTRUPrYB4cjAP8sJjZw3nKkwgfBiQ1hWMgedp4AAH5
         nKFoj+sqGJQB1ghxcRRSVvzbElQ1hTErdHkltg7qtg/2j7zKu55qGNv5UYfCQ5+IiL3v
         G6Fw==
X-Gm-Message-State: AOJu0YwEcdU/oV66uiI9d1Ya5w5mjL4xZi1wdknJKJQ7qfGlM9wAftiE
	1w5g/McZ1Z7ZyFxrSQTUNPJPr4W9uSKR9+lEiETObIsAFFQHMQf0XYSDBfRncg==
X-Gm-Gg: ASbGncsIewVSOXfc3fbBhSZ4NmTmF86JhiDi/Fw/yi8U5bCQiHBWwpGOzaQbafrkPO2
	L8Yod9ElFkfinXjcO2zDjG33emtsYh2lI8RaxJMlhQ+tNyjmRvlbvxE0QvXrIHyOrGFzZbCOVPv
	bZLCWw9v0wurCIk6aanogZH2AObKZbsMzBbAVhom/C2KIVT28GYVSw8r2hL9yDUkuguo9jmGrqr
	dKeLQUY3LJaqfkORJgV/x6xIsaWlT4yCDyXdzaLZE5oyti7DmvjzQvBSU3uV2C1rUHJlRaZym+J
	JtC66x7joaRHswyDGJ6VR8y5GVv77Qp/lan1lKuZqBt2DB2ekzyohaukwFt567nXuKNflZPruJc
	wNLoPexbSYEVuUH+vDO6DhFdVww3LRyiNHGNUGPzjOCGj5MsZ6chcC+ujNPD4fIfjWpdHLpgkfr
	DD2PTZ19hMz6OWQ7g1PmU4rFSlh+Ej5ofhxypUVf0s8AeWEiGN81U2tFTntVUl
X-Google-Smtp-Source: AGHT+IGLW5hrLEauNfqtWP7rMnZ70eoI+w9zgxcAeBxmGbfmB2VZwOYD50GSPrR8QqMdFwFBfd70LQ==
X-Received: by 2002:a05:6a00:1ad1:b0:7aa:8397:7750 with SMTP id d2e1a72fcca58-7b0bbef7e14mr5320351b3a.12.1762529735770;
        Fri, 07 Nov 2025 07:35:35 -0800 (PST)
Received: from carrot.devel.local (i114-180-53-102.s42.a014.ap.plala.or.jp. [114.180.53.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c9634f56sm3360011b3a.4.2025.11.07.07.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 07:35:34 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update nilfs2 entry
Date: Sat,  8 Nov 2025 00:32:49 +0900
Message-ID: <20251107153530.9023-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Viacheslav has kindly offered to help with the maintenance of nilfs2
by upstreaming patches, similar to the HFS/HFS+ tree.  I've accepted
his offer, and will therefore add him as a co-maintainer and switch
the project's git tree for that role.

At the same time, change the outdated status field to Maintained to
reflect the current state.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
---
Hi Andrew,

Please add this to the queue for the merge window.

Viacheslav will help with nilfs2 maintenance (upstreaming), so change
the entry in the MAINTAINERS file to acknowledge this.

After the next merge window is over, I plan to send nilfs2 patches to
the mainline through him.  I sincerely appreciate your cooperation in
the upstreaming work over the years.

Thank you.

Ryusuke Konishi

 MAINTAINERS | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 46bd8e033042..d5e2c1524a96 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18254,10 +18254,11 @@ F:	net/sunrpc/
 
 NILFS2 FILESYSTEM
 M:	Ryusuke Konishi <konishi.ryusuke@gmail.com>
+M:	Viacheslav Dubeyko <slava@dubeyko.com>
 L:	linux-nilfs@vger.kernel.org
-S:	Supported
+S:	Maintained
 W:	https://nilfs.sourceforge.io/
-T:	git https://github.com/konis/nilfs2.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git
 F:	Documentation/filesystems/nilfs2.rst
 F:	fs/nilfs2/
 F:	include/trace/events/nilfs2.h
-- 
2.43.0

