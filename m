Received: from mail-ua2-f12.google.com (mail-ua2-f12.google.com [74.125.226.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0B4485CE2
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 11:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.226.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789470845; cv=none; b=pbW+RZw+2NzoUfX+g1wTJdAAJCqEsju3Zq9ucm50AC3P1/pkcc0k8tFrNC/Hqd49F4au97zXbM/28/T9sw/ZQIokIduTXoVMRhdG/QepwYsGgKDg4ioHswBiIMolpcaFMR7E/icLs6UU6J/xPjf/91kWPO5am4/sVybDlv6aQqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789470845; c=relaxed/simple;
	bh=sJrFySi4bYC5wzYpLo3wzSMqebdql/9/GrvU2FaX1d0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TlA572svzqBLRd6Ao3EFSbxpHocMrxAzl2f32RmK3TQkjQD6f0W6b9EbBOokNGVvx/lBnUZSKEWfYhA5gcIv4fdWoNJwrRmeX5HGquz4SMUWDkWatWXa+SGk47ERhqBbH/Cd8DsdCfWBLXLdcpDy550D/+dOZhYpYrV3elBDnes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iaaVaaA6; arc=none smtp.client-ip=74.125.226.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iaaVaaA6"
Received: by mail-ua2-f12.google.com with SMTP id a1e0cc1a2514c-97ea5bd53b4so987093241.0
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 04:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789470842; x=1790075642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bz3i5Bjgy+qhtJ2RiKqbQXOaeVHp9WfJ3fh43+g/sbs=;
        b=iaaVaaA6IUwirkHWEJtUbSt0AG/Fpl7Vu6TvTnrFn9LNqCexAWDsiWi17NxaQAc63W
         u38KMjoM8xpF0/W0c3i8l2E3KeiiCbrvC/hMwCrS9PR2ylH+DE9poabPl9l2G73a10w+
         9BmgJj4cRzRqS/bMxlnvFIyuDL/adzE3itUgPJbT9GA2IGGazEGFsMVcWWgYHRLlxpW9
         8Ed2g5K9XRp0VipgyhJF5CdkgctEmsJYtglUhuCvBof3LNnlg/XkTck6ckwCA0iEKXxO
         jh4hvkN5PE5umO5BHXM4m+ZcFnu3mEUN/DfKpMi2VB6v7rS+btH5VXtbmxoJUvesG3EN
         lLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789470842; x=1790075642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bz3i5Bjgy+qhtJ2RiKqbQXOaeVHp9WfJ3fh43+g/sbs=;
        b=dMLpJ3Y6D6kZwDDxwpSIKsPLubcEKEycndNBmhpfjGGu0fJXzPA0A+Kc20mmYioAAi
         1vAu+M1dWGZTrNqaCXYIzX9SPeRMCN7muybSJgkNb757eNlNVsh31XVqjnR7Xxmo7Uo/
         8vhl3wsRfdRdkuysb53wHgfB6fyl7VuxneE8xnma1J6YGOirg5i6KSlFY/jGFkJg9z6e
         R1i+NjzXAQNop5nHmK3pTdlruqzf+2HU11rRncl4GNDx7XrDhXaghEtZFvS0lESP9dHu
         BMHNoHhqDi3KZxR6GInFOjg46YSpdgwSwyMJ1QdoI1bcQ/aSoTUkIJndUrjAD2sDK+i/
         LcuQ==
X-Forwarded-Encrypted: i=1; AKwUvBzIKd2VhyJ83NGrvw4/uIFtOhathnLLWOSTxboNlq6CS3Pm5z03C5a5/+qGWC462ZUUTcS94eUtrnXUDg==@vger.kernel.org
X-Gm-Message-State: AFuF++nvAHuSF2WfmelGNOnGfLcs++7ko2irmOBCORnWJPpIJOok+Qi5
	pC81oAuZtwVQSkAkkeeMs3Zy5rii2PfxPbspvzuzR04NNP2zzjM8RgQY
X-Gm-Gg: AYBFou3Fuzd/Uw+V0/Fma5HfjAJEu2Ud1nbr5LyboPwzUCROz49aKRlJqZGTLmC0JEa
	AmpB3DHD7MqYej0ZhYJdtHySbUFHmSb4R0YG7BeeCejaqjlph6BZVjnNy6fDbgnIjnhuiA5V4eA
	pt64tL4DUIHNlVnhj0KW3UXnnBqaKzW/VkjMBHbhJZYoq/cxn2kTfbDwfPvTtuhC57icjzewpp8
	eWQRnH+rdbWVtww/voSldsjZVJJiiutxajRub2K6IKWt+bS/oMMSq0I32PP6l77hRn3G9gFIdPK
	PFEVenA/dDkYI7d2clS805qdlOXVOIVp193LZjip7IfauNGGzHs/B+2s90rKDxGiGRurgxeawid
	/lSH2oIKy606bPw4OqT2iY3N2HHTbwZrPNRc0PNEcQGswM+vvJZJqwzvN2yeKs2+tnkpRs8DOJQ
	xllFuXo53/CG9FlG61LVKXuf+S9zAy46R7wZLAODaSR0CWpZ6rcGyNAX8fFrCGoNvH
X-Received: by 2002:a05:6122:32d0:b0:5c9:72ea:141b with SMTP id 71dfb90a1353d-5c981d701dbmr8067066e0c.6.1789470841672;
        Tue, 15 Sep 2026 04:14:01 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c8470ae56asm16455579e0c.6.2026.09.15.04.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 04:14:01 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH] nilfs2: validate file block counts during recovery
Date: Tue, 15 Sep 2026 08:13:51 -0300
Message-ID: <20260915111351.2726334-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_scan_dsync_log() trusts the block counts in each on-disk file
information entry. If fi_ndatablk is greater than fi_nblocks, the data
block loop can consume excessive summary entries and the later subtraction
used to derive the number of node blocks underflows.

Reject inconsistent file information entries before consuming their block
information.

Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
 fs/nilfs2/recovery.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 4d5a6aa521..6e4e0cf4cc 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -322,6 +322,7 @@ static void nilfs_skip_summary_info(struct the_nilfs *nilfs,
  *
  * Return: 0 on success, or one of the following negative error codes on
  * failure:
+ * * %-EINVAL	- Invalid block counts in a file information entry.
  * * %-EIO	- I/O error.
  * * %-ENOMEM	- Insufficient memory available.
  */
@@ -359,6 +360,10 @@ static int nilfs_scan_dsync_log(struct the_nilfs *nilfs, sector_t start_blocknr,
 		ino = le64_to_cpu(finfo->fi_ino);
 		nblocks = le32_to_cpu(finfo->fi_nblocks);
 		ndatablk = le32_to_cpu(finfo->fi_ndatablk);
+		if (ndatablk > nblocks) {
+			err = -EINVAL;
+			goto out;
+		}
 		nnodeblk = nblocks - ndatablk;
 
 		while (ndatablk-- > 0) {
-- 
2.43.0

