Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DF812D758;
	Fri, 16 Aug 2024 07:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723794217; cv=none; b=k2GxSZxxJWuIf3dIHXfmkvEXAqTMnRc/yA/LDZw0Jcol69baqXCUr263zDC3bjzMzIm1iIsHCDt9Bcle+QkzVeNmuCbQNgOBmE8nhsh4orF9fRH5nUO4G5rh/FXD737t2pdFEY83Zc2icKeubNrD+ZjKpsLFpnHOCslIkrRGCU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723794217; c=relaxed/simple;
	bh=0O3wDAmTm2R1VMrqJvvg3nYqYNOHRJm6KgJ2d0woyj0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JLamBFa8TrMxpPzTBNBW5STLtIh3+xbhpqwh8VswiEbA+dk17PkRZ7hkC8xmJH4PHXjCnBNZyF70Tix6NqY0FpG47L/9v1eG5yMnU++0p2ribSztzPVpflNT7JCgaezWxm0A2mpm4vMs0XVAyFgVSHa+bsyOTuJw1haSocAKw/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qna0m8lr; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qna0m8lr"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3db14339fb0so991916b6e.2;
        Fri, 16 Aug 2024 00:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723794214; x=1724399014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tkr4pPScm9JM4FL7Xb5OEIFIgdaIIjYg1Mhw7IU/3oY=;
        b=Qna0m8lrDF2ia+AthA0KKRDuyXZCfMBuagZIqtjZq5j/d9d5xm+jc4x/kRBalYdQUt
         KlK2aNlDpALJ/6Q+Bo/dNmPN9yLHHpBOmFTi7QeKlVuZ5rTOhivU4KdmQh6xHc5v8XZP
         X8w8m7c1fFMJPPsUDNIQ7SQKTW5Sbe1ymhWx8u1r0yzYL8zZ4VIIr4T9AlN3BZaDoI+L
         TtyQMfnVTWGp5fV5Skynr6d1HMG3n2h+4Qi/vXEY0Xt8fHTvBsp+Q9fySR+Et6yPa2Sg
         FjRfk4xUkQPWMyZx8DxvE+1xpNDWHyh0esGhyFL7H5/P087/0RmzJe8QxMjTvFNrhhbp
         gsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723794214; x=1724399014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tkr4pPScm9JM4FL7Xb5OEIFIgdaIIjYg1Mhw7IU/3oY=;
        b=j0ArYZs1fa8IWkw1gnw/pRXNfabXVs5unOagOA2wr3wdpfgQkuf509UB+B4Nni2aqT
         u+nsHPOEAMZcqcuzuXbvoYN0s0gIakD4OJ2o5xvTrO6w6K088KSrfIjW2xn7qRjooDN1
         Sx/ANX8z25bO+ZfjDE1pdicXekeZKREmTzXH5uWLAoPJjxsg4s5M2Lrk4K1UUSvEF4c/
         IiJ1bCDZkClbDdzDL4zLM5tTuC7A5pPekiyeZYEijs+fE3ckWvTiCwh1AbOV8S/f37kF
         sJCKL2dXHU2u9iKRMrLU/3OMxAXUit9toVsrCxKPTU1w+7AO1KfcHvjle7Y3x80VfVWT
         sysg==
X-Forwarded-Encrypted: i=1; AJvYcCUinRvSGsJ+1T/H/0WUKpec9zrPQ0OvPCmDpTdRdhzrTYF+GmF6qgGTtyW2nGu8f0mtrKnrnFJqWQ1FKiOo+HukZMXXan8vLX21ZQw8
X-Gm-Message-State: AOJu0Yzc+17fnkBfiXdc1OLeR+kO7Q7IucTL4S4Ygh4sLyL8VjtB1QoB
	hEhvHq2omY+6TfPQvw88IH01lG/3LdVy7gnNhLsqac4GtnbXoRAiTdf/FQ==
X-Google-Smtp-Source: AGHT+IGMu8hARPHej8oEN2vm6zpj/KqMKT81sLaIr6ulqQ1zduObVayQj2yRqUUChAcfsCZIR9in5A==
X-Received: by 2002:a05:6808:1513:b0:3d5:5fbe:b2fa with SMTP id 5614622812f47-3dd3ae00e4amr1937514b6e.35.1723794214503;
        Fri, 16 Aug 2024 00:43:34 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61e7c7asm2365971a12.45.2024.08.16.00.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:43:33 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] nilfs2: add missing argument descriptions for ioctl-related helpers
Date: Fri, 16 Aug 2024 16:43:13 +0900
Message-Id: <20240816074319.3253-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
References: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing argument descriptions and return value information to the
kernel-doc comments for ioctl helper functions, and eliminate the
following warnings output by the kernel-doc script:

 fs/nilfs2/ioctl.c:120: warning: Function parameter or struct member
  'dentry' not described in 'nilfs_fileattr_get'
 fs/nilfs2/ioctl.c:120: warning: Function parameter or struct member 'fa'
  not described in 'nilfs_fileattr_get'
 fs/nilfs2/ioctl.c:133: warning: Function parameter or struct member 'idmap'
  not described in 'nilfs_fileattr_set'
 fs/nilfs2/ioctl.c:133: warning: Function parameter or struct member
  'dentry' not described in 'nilfs_fileattr_set'
 fs/nilfs2/ioctl.c:133: warning: Function parameter or struct member 'fa'
  not described in 'nilfs_fileattr_set'
 fs/nilfs2/ioctl.c:164: warning: Function parameter or struct member 'inode'
  not described in 'nilfs_ioctl_getversion'
 fs/nilfs2/ioctl.c:164: warning: Function parameter or struct member 'argp'
  not described in 'nilfs_ioctl_getversion'

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/ioctl.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 297989e51ee6..fa77f78df681 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -115,7 +115,11 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 }
 
 /**
- * nilfs_fileattr_get - ioctl to support lsattr
+ * nilfs_fileattr_get - retrieve miscellaneous file attributes
+ * @dentry: the object to retrieve from
+ * @fa:     fileattr pointer
+ *
+ * Return: always 0 as success.
  */
 int nilfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 {
@@ -127,7 +131,12 @@ int nilfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 }
 
 /**
- * nilfs_fileattr_set - ioctl to support chattr
+ * nilfs_fileattr_set - change miscellaneous file attributes
+ * @idmap:  idmap of the mount
+ * @dentry: the object to change
+ * @fa:     fileattr pointer
+ *
+ * Return: 0 on success, or a negative error code on failure.
  */
 int nilfs_fileattr_set(struct mnt_idmap *idmap,
 		       struct dentry *dentry, struct fileattr *fa)
@@ -160,6 +169,10 @@ int nilfs_fileattr_set(struct mnt_idmap *idmap,
 
 /**
  * nilfs_ioctl_getversion - get info about a file's version (generation number)
+ * @inode: inode object
+ * @argp:  userspace memory where the generation number of @inode is stored
+ *
+ * Return: 0 on success, or %-EFAULT on error.
  */
 static int nilfs_ioctl_getversion(struct inode *inode, void __user *argp)
 {
-- 
2.34.1

