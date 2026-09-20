Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24003C9EFC
	for <linux-nilfs@vger.kernel.org>; Sun, 20 Sep 2026 20:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789937747; cv=none; b=c/5tDmj7tsu8blUkmxDV/k/IGhVFrGJW4BkYm1ugwasA9NPGMkT/JhU4xqbMXCbw122dH4HHygbRVXeAkd9731Vn2kzEM2368+5xCQoVkfIKRuz+bwXEEepzGvjFfSHpnmvpkUHQFrrqW+Vlp63r6+KDrmPP5P3kBqpuecn1eOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789937747; c=relaxed/simple;
	bh=Jw/55RJP99DwICDWpHIhgTih1Qhw3HFsJ9v37M1n3gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbC26mfQaFdnKdIvbIeSJnIoFJVG6MwWEbq3aHIOsej0/c6cE+JFONvFdmfSp54291hpkfH7DbWAL0c3MCj156dziGbUjBSbs5AnlrkZaQCLyDogq+t7vOgRKIw4giCf+l/2kf3s4FIfrgixtAxb+LaW6OrUCn9VvzsLsKlczt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EmVwmWbQ; arc=none smtp.client-ip=74.125.230.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EmVwmWbQ"
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-52fb76ec395so20912161cf.2
        for <linux-nilfs@vger.kernel.org>; Sun, 20 Sep 2026 13:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789937745; x=1790542545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PDHM8FbqBKMx5I7vQtnKZ0zL66hxJJmsdr/YfBmG+Q4=;
        b=EmVwmWbQSNAp5MLLpQc/xBstAlGymsQ+lwYURKPZEOuh5/uFGOUXp6chEK6DymZTpW
         em0MegfEn3hc1+x/no0wN+wvIOW3el5nkQhxAG5oXEsvDbJf73Gap9rUnuNwydznAKKN
         x+6Ft0IDls41CT3y9f5Nnd45tjVbinxONyEZnS0EokNEkH1p/DR/0lIopkBaaSa4vRpT
         1AT2RiHkyEn6RMVpZ7rdh78bCoO8BaT2rr6rCzmzSukEZf68vBEnrD21wCdpNKo7V9Oc
         XqA+sqlWh2zdo4Jx0uSYg7EioWWik19e0YzhTPhHUdU6PIYcWJ6UonyBKQM3HxWZpWeH
         rr9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789937745; x=1790542545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PDHM8FbqBKMx5I7vQtnKZ0zL66hxJJmsdr/YfBmG+Q4=;
        b=xDtNtBlLbb7FTxEEwj6aqEzNYG7Lkl++wkTEYADyHGZjzzmvq2S2ztMAJ9NkI4z6ws
         FTCLC8DKGnYsFLgxIzqhDiowAkS7WL7W5s674qxLEMFYbLwbK0zQP8bHDENP/Y6Yrogd
         dmt5W/zB6S+Hg7qDTHeNcj/D8fh8KF7E9w2S4spmsHFwHmDMxsy+2H89V7ptxbJbvohW
         wK630JqOl3ocVfuczhM/fj6MR+bH87OxP03+PnLIqkvDolhrTvAQwjLh4gwcHy4cyrtP
         PpCDkcAqXGQnqKC4vgbsbeeBvyPx61nQhnzFoAA7PBEts6YkwSLezfhTWwnpGQb6kObg
         F6IQ==
X-Gm-Message-State: AFuF++lycgb3a505UDW28RMPSgO/iQ36hJ0LGtJtDbCNIchKLCDd6SqW
	VNpWN5GnQVbbO7VrtVG2CunFyVzkaDKOAkQS4OJB1at1j3U9elW9vz7D
X-Gm-Gg: AYBFou2dIP5XPqVty707cTiN5oHdOufDQ/cOxzNiYB/NcoDQWVb7wVzTSWuASD9mLtC
	LKAqaok4Cp8xI06o7iXZ0i6ngqxMuDwIFfDAfZkmdvVhH/ESlhF3QPNSzGAbijxE41W+m9OA9i4
	NetIpns0IP2MMCf4HRBTeqvzUq7QmJe/v3Hby2R4kqzeM6ZIErOUBH998UYyTRNFC8yHVxlKEqk
	WHhFS1MW/ZZC7rSixU8keW8QrQ5+285L6VsOU47h28ljVuXsOu/4lB4Hd4h51hgGhobsnyrNFdO
	kdhK/4NLkKjPMbdVhb7p64AwhJ+rbGq3W5Shm/3DUTD3ifmFg9De4iSjdNxjtKsiA2cloce6bTt
	c/7MFUvv49alcvV75lLyL8Kcl/u/OFIBxiCaxu+sPRqtn/xBya6QMrw2p8jRlHl6HX9InkrdUVY
	eLUBXqVfZVeLQde+p/wuwCfHeWvCk1muz31xgXg9oGKJWEP+awzOVUcuSWYWHS5vS8Ssm7MY8m4
	GkLTQGyGmjWv+CqvDcCI23hKuwjrFloAv4wXyHs
X-Received: by 2002:ac8:59cb:0:b0:51c:fc4:a144 with SMTP id d75a77b69052e-532b71af293mr66821911cf.4.1789937744799;
        Sun, 20 Sep 2026 13:55:44 -0700 (PDT)
Received: from jake-B450-I-AORUS-PRO-WIFI ([2601:84:8f81:33f0:4668:3d1a:1c3d:3767])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae511d1fsm48075091cf.3.2026.09.20.13.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 13:55:44 -0700 (PDT)
From: Jake Labelle <southampton.jake.labelle@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org
Subject: [PATCH 1/2] nilfs2: reject non-regular inodes in dsync recovery
Date: Sun, 20 Sep 2026 16:55:31 -0400
Message-ID: <20260920205533.426028-2-southampton.jake.labelle@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
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

Only regular files have data blocks to recover; reject anything else
before touching its block mapping.

Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Co-Authored-By: Claude Mythos 5 <noreply@anthropic.com>
Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
---
 fs/nilfs2/recovery.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 45fb37215..baa9507cb 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -540,6 +540,19 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 			goto failed_inode;
 		}
 
+		/*
+		 * Only regular files have data blocks and an initialized
+		 * bmap; a crafted image can reference a special inode here,
+		 * whose i_bmap_data was never set up by __nilfs_read_inode().
+		 */
+		if (!S_ISREG(inode->i_mode)) {
+			nilfs_warn(sb,
+				   "%s: ino=%lu is not a regular file",
+				   __func__, (unsigned long)rb->ino);
+			err = -EIO;
+			goto failed_inode;
+		}
+
 		pos = rb->blkoff << inode->i_blkbits;
 		err = block_write_begin(inode->i_mapping, pos, blocksize,
 					&folio, nilfs_get_block);
-- 
2.43.0

