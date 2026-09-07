Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBD93A168B
	for <linux-nilfs@vger.kernel.org>; Mon,  7 Sep 2026 06:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762279; cv=none; b=D9XGeg+z41XHNJcorG5fYGa4KlIDg1K+RUyRPGZ3qlV4bnA/T49P4V2UbbsITgL1z1sidz4fVCNn1WB3zH/j91uJKxLrc1UZ6kHcvYPA0tB5W7WTgMOhobe+PBHHdU+KGvsRZ0afovGxNVCGJw7/77nqY/q8QXZbrQ3y6ywjQMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762279; c=relaxed/simple;
	bh=VdkVJzDQO+OBjCF1MtCaPsN0N+KhAg88SDzZqzXyrPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=beDdoJAs/YBQDOE+OVhM7hTAvgQGYcgOW7ulRhlr/EeHWWjh0HsH0DBRBy6Xy23e4P1W9377x2mwEpe/3xDteOg6Tg+iGOfrOqKIxvKCWMiJxMIYc1nVzCVwdzPkt2+lRSIWAZDIEdO8HDpJSu+5Oi9N277kT1WfBweN12miseI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aL/B0RTb; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aL/B0RTb"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84e0688b7e8so2405519b3a.1
        for <linux-nilfs@vger.kernel.org>; Sun, 06 Sep 2026 23:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788762273; x=1789367073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0IKKrl5YcZhRUUWHg2BiTHgq9GP40fvyQGauSEF11zQ=;
        b=aL/B0RTbjA8QU/Wj/J1EEvMOo4iPvVjf1fhm9wfoPAwivwKtxnI7kwb+H5XhfXmgmc
         R72NE15v7KEbpWqwlX4eoITOCE+pCdEUeNv/NcnJmlmzyX2ylBClII8FD4frNfwocmzC
         LbaFRHJSU7CG5nligHfthJPPoSoQWNY81hozdDvPAiK9HDjAJE7jcVnHxcY1mbo2Eegb
         jVbXcTGdiSY5wc0UssI1PPqJFj8hhSuh1c7bLRAayhcD0q0jo3M7MVr2fMcVkA/Ng74+
         kdMq6Oxa9wL0fGm8v+lHAPv0sPqssyRyGNCH7TdeRA2yXsJkdLXyNpit91NuSRKaxRtP
         f7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788762273; x=1789367073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0IKKrl5YcZhRUUWHg2BiTHgq9GP40fvyQGauSEF11zQ=;
        b=G7sG3I5mjPA2jo7ECLRF5ikjCAtEdjtVO8UhPXhn2+t/nHscv8zXyQ1JAFIFWxhXq6
         xY7IXV8DX32nue0lI6LItB+ISpMPyzi32EhlIzpf7ZeJv8b8CKkMLdjCI/wSEiVDkgx4
         04IqmFeYQnz1TVwmLEIN404amzN28Kzehwt57DErLapU5qAwTtqKEgwV4wIDyJFU1SwJ
         RTLamRNDuSg14PZfK1XeNTPsI3zh5F2ewjc+BZmhgRr77DwF+E0U/3/9sfKer7/GFoY3
         oBany/wjafOAKIaDX5cj1rDh65qPR7gZI8iVCqZec2J5XM1THdGt5piZwK07gbmq8st+
         NfyQ==
X-Gm-Message-State: AFuF++kFicLuFdbCvkhdRPh0vn5WeeSZqScrD9dCrdbK1wipEbdEn0g4
	h5nhdlq3iUyFiLrl86Y8LxVAlHo0wtrhuz3UXNltdtzKqqA6jwcgEBhp
X-Gm-Gg: AYBFou0lOShyAko9ohWvIejwpOZXriJZqbQmXK+ymj2wbfdrhes6F3LmFm9pMLrp7kB
	FxfoTcB48CjjoQ8M9diZ0/2jwOALwkj/8HtKF+OhMd6v6N54ywnChJ6aquIdOD6i8kphaJ7AuzZ
	AV6vutmYAL6y/dyczyoWewa4rRPu9CvK3jqQjimAJEOJG1M5Gcc7qXaudmsNzjvvIAmLKZ7lYLp
	eycVNeaECjidxGewNzpZuJsqDZ6NTug/VaDZZI7JKroqPkAtP+jL+Axg2sacYsQmWYhUoI3cNpQ
	sEerZYYW2Qhe2dIepdDBLYsosOJyqW86+eiAI+bYDu0hVVd0CdgnPiy4Y+yaalSK7tWWg6cGU0T
	XPUDvbbTktCdi7KzfH0EWPcCagAGATHT8TrGXl06u849dLDU1MqEXSOleJyM+QDan6vsve8JdWT
	hRyAysoO4/4A2HQRjzSWoM7iJ5aNTf4FeScjv/NxKdSxzFWObbHvj1dGz4O+V4UsY9csiethI4m
	qjmo7t6yYpTAw==
X-Received: by 2002:a05:6a21:e081:b0:3bf:6222:2e7e with SMTP id adf61e73a8af0-3da39b4390cmr31343540637.4.1788762272860;
        Sun, 06 Sep 2026 23:24:32 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-333c9db92b1sm24622408eec.9.2026.09.06.23.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:24:32 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: fix typos in comments
Date: Mon,  7 Sep 2026 11:54:27 +0530
Message-ID: <20260907062427.11910-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 fs/nilfs2/sufile.c | 2 +-
 fs/nilfs2/super.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index eceedca02697..6918be6fce2e 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1050,7 +1050,7 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
  * len:		number of Bytes to trim from start
  * minlen:	minimum extent length in Bytes
  *
- * Decription: nilfs_sufile_trim_fs goes through all segments containing bytes
+ * Description: nilfs_sufile_trim_fs goes through all segments containing bytes
  * from start to start+len. start is rounded up to the next block boundary
  * and start+len is rounded down. For each clean segment blkdev_issue_discard
  * function is invoked.
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 893a504cb80c..65f44ff6779e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -654,7 +654,7 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 			/*
 			 * If nilfs_palloc_count_max_entries() returns
 			 * -ERANGE error code then we simply treat
-			 * curent inodes count as maximum possible and
+			 * current inodes count as maximum possible and
 			 * zero as free inodes value.
 			 */
 			nmaxinodes = atomic64_read(&root->inodes_count);
-- 
2.48.1

