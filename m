Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B1C19D88A;
	Thu, 15 Aug 2024 07:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723707917; cv=none; b=Zuv3av5QbrqXm3kUsDWETDfhxmNxNewHtw9/VFWWxL8t/1JPVG2JGfbvJiOSVg+8/VYTUyQONlQaZaktGC6peDG0J1YErm2q+T+blTlo/oLddfYIgDMebwkxszdqT6dvsNk32TWWhlRizOcTOcDVrvZErHz3GCgXw2l9RP0ECcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723707917; c=relaxed/simple;
	bh=XRm/Hh9LpO+CU7azMzRcjb/D/KLYwphLujSoP1+9cpk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C/k21SQZeN/pD6Jy3Y3zOJv7XgmtWJX/SKEbrjJ6qMbhrAry5fjvF7AZDQSSC7EJq0H4Fr/iQWl+RnySc5yH+dvjqGjZqKUqrkJc7WStiAY4DHyh76kADHEkka8+euCwptW7Sx4165GPWCU99vcIbVYctpFgFGBs2leY3bPQ9kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iu7PsNve; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iu7PsNve"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3db1e21b0e4so401132b6e.2;
        Thu, 15 Aug 2024 00:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723707915; x=1724312715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLkgFkP50yQCZ9OQre3ESLs2M2JG8masVEc+QrHO/IY=;
        b=Iu7PsNveybn7IRk7ZRE8FhrW+QzagGqjl3T99ueNWW3PiShIcFHadxbudnXwQOg+RR
         2wdgHBa7HwMJBBNiHdNxk/5MZsT3iuU07ZrvDtLa7TmN5EgB1SU0L0P2wqxMNW1DGlvq
         eueHtlFVn1fMeklYMPPOf8A+A13zPleIOzqWD+sfwoupewr6OdcY+2jXotRZZc5x1KVS
         YUwCbBWWcYeQNypRfikEPq01wQHVUTFDyEAn9G+Z5baf2RDK3Umb8fl2uXd+jUy0oU7h
         rWT266vXWZHUeNqeURAcsfsVr4ZNBbts5qey11oU3ytJCUGG153IyHJlXQrCueXHgJSV
         arnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723707915; x=1724312715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLkgFkP50yQCZ9OQre3ESLs2M2JG8masVEc+QrHO/IY=;
        b=Brl+uNjitgC4b6R+pBJpiaynCNAmgLKKyJ6fVPOO9rppBLJO3qY6nob6+jP0/8eZKY
         nL/V4kqLyZXcxodSqfuSnMPGL6L7cVD8zQZKoMChLCLl9V6xqleGvM00R32ByFUjMrfQ
         0x8FW0m7kKI/RED7eSOgrFlZfaItK/yeixIqs3d5AnftbP+fbv7yNKKv5uV+ayaRMH97
         vTPaqMIlVcRZznFYi4GFKi2dKHTEFG41jfaSHk37OjfzLKuMVD2NYU0JM72L7QaxRuGC
         CzpiWx9LNZeTYkGR7aX2xkm9y9t5E3w1qBdZQ5QxiqDXLOD5bBa6JQ999U2G3ndVEAR5
         4DxA==
X-Forwarded-Encrypted: i=1; AJvYcCXl4YbLu0d/najM8tH+wMnGtlXRD4q0CrIpvDJBd3+3AK8A05GCNGW2sBaWhMMPGQLbvVcvSIKRb4jcBB/xu+4LoPcY3HFn6DLSTwwp
X-Gm-Message-State: AOJu0YzWUXtnYaaJxpscp9wnsroKFagWYtq4XKwROmIW+XgRHwo4/aCx
	bnBojcezrx5zW8M82nAmXvqllvyx8iRqSZ1rfRaA2NXuyNRh6Dye
X-Google-Smtp-Source: AGHT+IEdYGqEmS3GdMnyNDBtnW/m3aKZ7RZs9uygKYTBvuJ52C5cYDq0fjT1bK2SoBCtVLlnuAR0oQ==
X-Received: by 2002:a05:6870:1cc:b0:26c:5312:a140 with SMTP id 586e51a60fabf-26fe5a41704mr6003339fac.17.1723707915017;
        Thu, 15 Aug 2024 00:45:15 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127add721dsm584767b3a.42.2024.08.15.00.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 00:45:14 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] nilfs2: add support for FS_IOC_SETFSLABEL
Date: Thu, 15 Aug 2024 16:44:08 +0900
Message-Id: <20240815074408.5550-5-konishi.ryusuke@gmail.com>
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

Implement support for FS_IOC_SETFSLABEL ioctl to write filesystem
label.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/ioctl.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b5c6a50d6d5d..297989e51ee6 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1290,6 +1290,68 @@ static int nilfs_ioctl_get_fslabel(struct super_block *sb, void __user *argp)
 	return 0;
 }
 
+/**
+ * nilfs_ioctl_set_fslabel - set the volume name of the file system
+ * @sb:   super block instance
+ * @filp: file object
+ * @argp: pointer to userspace memory that contains the volume name
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EFAULT	- Error copying input data.
+ * * %-EINVAL	- Label length exceeds record size in superblock.
+ * * %-EIO	- I/O error.
+ * * %-EPERM	- Operation not permitted (insufficient permissions).
+ * * %-EROFS	- Read only file system.
+ */
+static int nilfs_ioctl_set_fslabel(struct super_block *sb, struct file *filp,
+				   void __user *argp)
+{
+	char label[NILFS_MAX_VOLUME_NAME + 1];
+	struct the_nilfs *nilfs = sb->s_fs_info;
+	struct nilfs_super_block **sbp;
+	size_t len;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	if (copy_from_user(label, argp, NILFS_MAX_VOLUME_NAME + 1)) {
+		ret = -EFAULT;
+		goto out_drop_write;
+	}
+
+	len = strnlen(label, NILFS_MAX_VOLUME_NAME + 1);
+	if (len > NILFS_MAX_VOLUME_NAME) {
+		nilfs_err(sb, "unable to set label with more than %zu bytes",
+			  NILFS_MAX_VOLUME_NAME);
+		ret = -EINVAL;
+		goto out_drop_write;
+	}
+
+	down_write(&nilfs->ns_sem);
+	sbp = nilfs_prepare_super(sb, false);
+	if (unlikely(!sbp)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	strtomem_pad(sbp[0]->s_volume_name, label, 0);
+	if (sbp[1])
+		strtomem_pad(sbp[1]->s_volume_name, label, 0);
+
+	ret = nilfs_commit_super(sb, NILFS_SB_COMMIT_ALL);
+
+out_unlock:
+	up_write(&nilfs->ns_sem);
+out_drop_write:
+	mnt_drop_write_file(filp);
+	return ret;
+}
+
 long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1334,6 +1396,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_trim_fs(inode, argp);
 	case FS_IOC_GETFSLABEL:
 		return nilfs_ioctl_get_fslabel(inode->i_sb, argp);
+	case FS_IOC_SETFSLABEL:
+		return nilfs_ioctl_set_fslabel(inode->i_sb, filp, argp);
 	default:
 		return -ENOTTY;
 	}
@@ -1361,6 +1425,7 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
 	case FITRIM:
 	case FS_IOC_GETFSLABEL:
+	case FS_IOC_SETFSLABEL:
 		break;
 	default:
 		return -ENOIOCTLCMD;
-- 
2.34.1

