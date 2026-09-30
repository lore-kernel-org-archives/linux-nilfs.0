Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B0C70809
	for <linux-nilfs@vger.kernel.org>; Wed, 30 Sep 2026 00:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790727060; cv=none; b=cTgDtDOALjqB1ECBtEDsVtNQodsXZcvEj9e6IsdJ06JhGtBYvEF+NTrWCy1bevs+UKS1oDTpf8JFprOy1galhW3AnzdWLiigS+s+wpnWwFQ6cJ6Hs1oaVRG1MllbYcFbkxG2A2QUFjKAMm+lslMwvYLp1FODi6C0dXSnCP4fPd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790727060; c=relaxed/simple;
	bh=BY87FKimd59PQaMTyGARPByMtFck+sAjqXTjUVW+weU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nObtUyz86uTeaCD+6jJtDw6749ORb1DmYewWHEkqRRDcQg+EXMq7NoITpOwmqMxj85p+6CyyisZmmatC8dhsvQ39nbAgCsZnoMpnByP1byCs4UgM32qnmxFXRnxpbQsU1kKdGKk4wuZ74Ca3W6ZF2yZThXg4NeUbp3qRIbnVCws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KbeRczn6; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KbeRczn6"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530d8a00bcdso39576371cf.2
        for <linux-nilfs@vger.kernel.org>; Tue, 29 Sep 2026 17:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790727058; x=1791331858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jI6TMBHI8KwnPSNdEc9UzL+4B3mUQx8Eqjf9YwwVlmY=;
        b=KbeRczn6/rzVtIXiMj+7oB4jrqa50dRNw7YPlk2Ikgo4MU2ZuYW43JbpWrFdOpxREI
         D+WGk/xQfccz5OYVjnTTQfrl8crLuOYG/vnCmo0/ZSE87UGFHZBhE4v+3MjLe7YP2Nkz
         ZBfotx0Hl++Y5kjCX2TZFpodOXoewLlYMAZHnr9MSVqSc2LRCk7+AItyPkmxNaQyU3jc
         55/dSSuHYOhUzd854gcbt2Vhklut8aTA+aSep8jhVbxE63zfhWUbjgjy4lR9PnSiew3T
         a63A67B+AzcZnIb/OW/LY6ai933Uamk7+csG9RocL0R8zl1hM0Vh+J2PXJzyfxzVXs+D
         di9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790727058; x=1791331858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jI6TMBHI8KwnPSNdEc9UzL+4B3mUQx8Eqjf9YwwVlmY=;
        b=IMgRnf3exV4pPv6zcFuRdFQkpTjOvufECTtHfRXVSqYDr9NicXWlaTSlvXdi+NCw2M
         uxxQG8+1C7G21cdF4rW6cxAQAt9HniLEXQfNq/eduzEkPY/gV4frDxZE1yg0UMZUpfBE
         AFCgCp/lzEDKNpBKQoWckdATfPmlMxsiRxkCXVLExB76RqfpwgXi6wTuf/ljpMCjP40Q
         jWWyARGeO8I9owV/3V0Dfn+dJBjgHuM+3861f/CXdTmqxbzM40X/WeN5olUd62boyfIL
         7+5BO0Pcl7xeZcsRz2shPqcUtqkACLzUZV8y3l+4yzjsBwAByr0GOZ3I9S2A2170BYZy
         lMrg==
X-Gm-Message-State: AFuF++k9C/BPBbwNnlBNsKoj5tS/r8s9AajK2dHsT+WNf/zFWLKfeMyB
	Q2PHC9TnhvxVxdpZ+R2y7OE+1Fzk7hJBxYGArziXP7QezPZMNnPJmUZm
X-Gm-Gg: AYBFou0tk57YD39ujMYuD4urB/PVGN7sQhZCxNFpmDf1RbIulSHaqe+S0EqUGlfGJdv
	Ysryw43ktzWfmHgoKo5TU1VjsWa5dU+XL6w/PHxbzP4cLJRm9DEwLmkDGBKhdVuRt5Seq5ttNXw
	JU2mfwnwCIFUZXny5YnAahN+aA5HWDS2z3oHyrjp+3I7487ylwtHos1fH75tWoi8oZJt9FkP9+R
	kgJ8j8za4yp7485gcUC2E/f8bObtAiItAgWvOI1CLYBQvqtQYiXH+0SMEULzzP3BUWAyW3Rbq/p
	RWNCdvmVQuBzu9YYmv4gT28Jexi7vuu1hqzGr5jdCASxkKQOxU4jqZA8A5NwDz3VVm2aFaGPHmd
	3XJev3h3ec2tRZfLxjvHVreNqwyml+ti7ltd3JJxUfvrS0Ne4jToB2o/0xqt7ja7M2OCF218fWb
	gDUl9EaVYnerohsFi+XhPhA5fr+aarq/mio5hoxVcbaaJP5KEC2X7tHguAQlPfEntZRfOrLB5jr
	o4xQqLNqJMOGymyCraNgtZ2ZWaLX/dTpcw9gas=
X-Received: by 2002:a05:622a:554:b0:533:25e4:daa8 with SMTP id d75a77b69052e-5336a286feamr17850231cf.15.1790727057696;
        Tue, 29 Sep 2026 17:10:57 -0700 (PDT)
Received: from jake-B450-I-AORUS-PRO-WIFI ([73.194.254.128])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53369b9f477sm7175391cf.19.2026.09.29.17.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 17:10:57 -0700 (PDT)
From: Jake Labelle <southampton.jake.labelle@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org
Subject: [PATCH v2 1/2] nilfs2: reject non-regular inodes in dsync recovery
Date: Tue, 29 Sep 2026 20:09:51 -0400
Message-ID: <20260930000954.371774-2-southampton.jake.labelle@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930000954.371774-1-southampton.jake.labelle@gmail.com>
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
 <20260930000954.371774-1-southampton.jake.labelle@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During roll-forward recovery, nilfs_recover_dsync_blocks() obtains the
inode designated by fi_ino of a dsync log without checking its type.
If a corrupted image designates a special inode (e.g. a device node)
there, the inode's embedded bmap was never initialized:
__nilfs_read_inode() calls nilfs_bmap_read() only for regular files,
directories and symlinks.  The subsequent nilfs_get_block() then
dereferences the uninitialized bmap->b_ops and jumps through it,
crashing the kernel or worse.

Regular files, directories, and symlinks are the only inode types
with data blocks to recover; reject anything else before touching
its block mapping.

Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Co-Authored-By: Claude Mythos 5 <noreply@anthropic.com>
Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
---
v2:
- Also accept S_ISDIR and S_ISLNK, not just S_ISREG -- directories
  and symlinks have an initialized bmap too, only the check was
  missing before (Ryusuke Konishi).
- Wrap the check in likely() since dsync log CRCs make it fail only
  on a corrupted/crafted image, never in normal operation (Ryusuke
  Konishi).
- Return -EINVAL instead of -EIO to match the mount(2) error
  convention used elsewhere for on-disk format errors detected
  during mount (Ryusuke Konishi).
- Reworded the warning and comment for the wider set of accepted
  types.

 fs/nilfs2/recovery.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 45fb37215..baa9507cb 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -540,6 +540,23 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 			goto failed_inode;
 		}

+		/*
+		 * Regular files, directories, and symlinks are the only
+		 * inode types with data blocks and an initialized bmap;
+		 * a crafted image can reference some other inode type
+		 * here, whose i_bmap_data was never set up by
+		 * __nilfs_read_inode().
+		 */
+		if (!likely(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+			    S_ISLNK(inode->i_mode))) {
+			nilfs_warn(sb,
+				   "%s: invalid inode type (ino=%lu, mode=0%o)",
+				   __func__, (unsigned long)rb->ino,
+				   inode->i_mode);
+			err = -EINVAL;
+			goto failed_inode;
+		}
+
 		pos = rb->blkoff << inode->i_blkbits;
 		err = block_write_begin(inode->i_mapping, pos, blocksize,
 					&folio, nilfs_get_block);
-- 
2.43.0

