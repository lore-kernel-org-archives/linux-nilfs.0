Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A1819AD9B;
	Thu, 15 Aug 2024 07:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723707913; cv=none; b=tdgPp5b/LE80pFo0kflEBT+lZOn1kvNwJIYtLPAwujmZddMNwQdv+cN2pO+4MHnAHQ9UVwqN3nhIAxYwO2hGppBJlhlXroIYIZkylsEz88JBC/emkLmoX/AVO1OFXNBkrux+B90PreKXEiRDodztQoqne2LEO6kpfZeGgBsDs2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723707913; c=relaxed/simple;
	bh=Q6g3LPgyCADVj19dPUzRQGLF9lwAt91WnJ0TQOfM82k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=epGfrG0c40NMaMFbrunP/JRPYSHrgZNTX4zBuglvaqDbhSY4LrSq1uyoOZaKE27kXjiy8g6I0TrlV/iDCkhnp8p6TbqNaG6TjG4Ky1uhQ5/mJ4VShVPRYruuKTJtEYVxvXf+CQhMKhnlL6u1nLcIQALv9rHQYtSOFXOfrp6hjtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AsnzXuOf; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AsnzXuOf"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-26875acdf72so470029fac.0;
        Thu, 15 Aug 2024 00:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723707911; x=1724312711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+dYBANd8pfFCoJ+XNI+1toZoLmt0pOoCbgwJ2lH9os=;
        b=AsnzXuOfZu/geaAI8QplBrJg0Ee4M+IqlvdvkE/mh1dLMx8FvlwO89cLqHA2gMPYjN
         o9UJLY+OZ/oUtdNSGtL6YVrDmmWB+px1TQdmTqIpIynku8ZvguhffQte5Hk8J171XKSr
         Rxqr9Ip/GYMQrZNRjGdnTSa2csCi28+fMc5PuzZkQ50j3uX4WfzXPZ7Ory5Zlw1s6YGH
         fndEzZNvRioVyX+CA5JrSFc3e0k0u3eZEj9BDgpCCk0O+cfBGnMVWmbe4fm4LrvUIaDi
         jhePHuyOLefc3NUv2oiyT9sQUIOldddwJkrJCrDEdcnfsAunkUXiFY6DrAukknr4e1ZC
         ng1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723707911; x=1724312711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r+dYBANd8pfFCoJ+XNI+1toZoLmt0pOoCbgwJ2lH9os=;
        b=sOlfeMrb8hHWqJatKHUruIzD7So5Ao6UXdbxGtQFRR1/Gy4vtrysqtOcjqENVoVDkJ
         bVgq/pjKMkc4zNbEo/Jcb5mlLLB0uueWPBtvqv1Qn+sMJpgwX76M9/orRXq20W+wCL1K
         M+pgK8k5qhfW7RmNXIvgvjhuW/66hXZ2NRbtq7PXbQIJepf6+ZG3SySEtw4K7WlzP9mE
         +24hLGRhSJ5ZwLeg6FwHmNTwRA/j539s6wUiHEdZvFw1enQWwAQIKtybcDq5QVJRXUmg
         DBHHVioRN2NNsgqpwuQQCGtiVMcoz7iozsKxoLIjjP2efUZpofknbRs8bvqZtWMypCPT
         gSeg==
X-Forwarded-Encrypted: i=1; AJvYcCXratDU6nQj//gdkhDVHaFhv7DnOCx5AIyNU1j9STNua/xHS9ouDidTQbXIAwjmDGPWQ+QeTNVaI2Wn7NmamchfkC+kF9sXXvEPg8h9
X-Gm-Message-State: AOJu0YzbQtGoETqMwjnOncx7IvryBG7W8eP3Qv7I8cZvfASBs7t6OUjr
	ZoFxMpGLgLIOQ0joFOILZAKdjPDO1O5PwDOM02DmIV2WW6mgZV0J7zrsJw==
X-Google-Smtp-Source: AGHT+IGyxIMewG7i4MlRC9JERyzn2OCdjZOiNESc/L67k1t++OLQ+N4oSK1TAt4PvDwgj2Vp/uw6Gg==
X-Received: by 2002:a05:6870:a111:b0:261:1ffb:4ab2 with SMTP id 586e51a60fabf-26fe5a9d6bfmr6877271fac.20.1723707911371;
        Thu, 15 Aug 2024 00:45:11 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127add721dsm584767b3a.42.2024.08.15.00.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 00:45:10 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] nilfs2: add support for FS_IOC_GETFSLABEL
Date: Thu, 15 Aug 2024 16:44:07 +0900
Message-Id: <20240815074408.5550-4-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240815074408.5550-1-konishi.ryusuke@gmail.com>
References: <20240815074408.5550-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement support for FS_IOC_GETFSLABEL ioctl to read filesystem
label.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/ioctl.c | 27 +++++++++++++++++++++++++++
 fs/nilfs2/nilfs.h | 12 ++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 8be471ce4f19..b5c6a50d6d5d 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/mount.h>	/* mnt_want_write_file(), mnt_drop_write_file() */
 #include <linux/buffer_head.h>
 #include <linux/fileattr.h>
+#include <linux/string.h>
 #include "nilfs.h"
 #include "segment.h"
 #include "bmap.h"
@@ -1266,6 +1267,29 @@ static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
 	return ret;
 }
 
+/**
+ * nilfs_ioctl_get_fslabel - get the volume name of the file system
+ * @sb:   super block instance
+ * @argp: pointer to userspace memory where the volume name should be stored
+ *
+ * Return: 0 on success, %-EFAULT if copying to userspace memory fails.
+ */
+static int nilfs_ioctl_get_fslabel(struct super_block *sb, void __user *argp)
+{
+	struct the_nilfs *nilfs = sb->s_fs_info;
+	char label[NILFS_MAX_VOLUME_NAME + 1];
+
+	BUILD_BUG_ON(NILFS_MAX_VOLUME_NAME >= FSLABEL_MAX);
+
+	down_read(&nilfs->ns_sem);
+	memtostr_pad(label, nilfs->ns_sbp[0]->s_volume_name);
+	up_read(&nilfs->ns_sem);
+
+	if (copy_to_user(argp, label, sizeof(label)))
+		return -EFAULT;
+	return 0;
+}
+
 long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1308,6 +1332,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_set_alloc_range(inode, argp);
 	case FITRIM:
 		return nilfs_ioctl_trim_fs(inode, argp);
+	case FS_IOC_GETFSLABEL:
+		return nilfs_ioctl_get_fslabel(inode->i_sb, argp);
 	default:
 		return -ENOTTY;
 	}
@@ -1334,6 +1360,7 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case NILFS_IOCTL_RESIZE:
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
 	case FITRIM:
+	case FS_IOC_GETFSLABEL:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 4017f7856440..3097490b6621 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -103,6 +103,18 @@ enum {
 	NILFS_SB_COMMIT_ALL	/* Commit both super blocks */
 };
 
+/**
+ * define NILFS_MAX_VOLUME_NAME - maximum number of characters (bytes) in a
+ *                                file system volume name
+ *
+ * Defined by the size of the volume name field in the on-disk superblocks.
+ * This volume name does not include the terminating NULL byte if the string
+ * length matches the field size, so use (NILFS_MAX_VOLUME_NAME + 1) for the
+ * size of the buffer that requires a NULL byte termination.
+ */
+#define NILFS_MAX_VOLUME_NAME  \
+	sizeof_field(struct nilfs_super_block, s_volume_name)
+
 /*
  * Macros to check inode numbers
  */
-- 
2.34.1

