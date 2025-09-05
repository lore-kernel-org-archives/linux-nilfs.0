Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066B62798FD;
	Fri,  5 Sep 2025 19:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757100268; cv=none; b=ls/ry5Dod1+EAJhrQ1ghcC934MlShTdZ9gNdaO2+l9EqQj9gpDS9AulSVU56FuPupbTfWZby+3qT9m3+gpX1VvuX0t1VD5ERUTLprZioUJuJIbb7n/M6FeiefONMFuUx6JCuTq1jH+JddrfCeZj/N72aGtD/ZGDNGVyUp672lPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757100268; c=relaxed/simple;
	bh=PneSr0UFkyje7hiRxdgfda0/0faF4NUEJ+o+j1qL+sc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hNK/ww4k5rfe3NHZZZP9YXNS5p6lpksdsXSUvYOJLNfG6i/8FoSz1f6zrbo7DQ79zkZPytgcRO/x73c/cN7U7X2q+tqsZ5egkjh3j7IWKPFiF7q3AAFBgBGvfPVHGacWXO0QN8YOzkJ+/DiWxWETcYCL3u1Ywu3/zMxvRpZpSdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFuPcJc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFuPcJc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22400C4CEF1;
	Fri,  5 Sep 2025 19:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757100267;
	bh=PneSr0UFkyje7hiRxdgfda0/0faF4NUEJ+o+j1qL+sc=;
	h=From:Date:Subject:To:Cc:From;
	b=WFuPcJc0u1IB0G+xb6m54A2SVprt+VURztyXSXsOtv6TQZnjptkXW00SV5sqwpvmS
	 J1omyhIE9VkmYjYz9RypCZES6Rn7i62OCf+SY1rr/A2Zi80lI5NfMqqJ4D8uI+tpQ6
	 wLwPVciyTL915kWOBYVjwmW3ckYe+WR+9+P1siOV7Wqtul8PlyAExP/LVUZDWaHHnX
	 GoQj7ODF1f3S0AAY20XKl2G3Uc8yTAEzZwBnLNEhWSVccpZ02Chesl2TshAMS08zN7
	 T3tO3VA85anwXcenlxKlGjWxUNhWtzKgkpeOrAOfoKATdTMAQPBlRuguONXEjVYefk
	 nGJzVSS/CFm4w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 05 Sep 2025 12:24:17 -0700
Subject: [PATCH] nilfs2: fix CFI failure when accessing
 /sys/fs/nilfs2/features/*
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-nilfs2-fix-features-cfi-violation-v1-1-b5d35136d813@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOA4u2gC/x2NQQqDQAxFryJZNxBHBtGrFBepZjQgY5lYKYh3N
 7h88N9/J5gUFYO+OqHIoaZbdqhfFYwL51lQJ2cIFCJ1FDHrmixg0j8m4f1XxHBMioduK+9uY8O
 xkU8M3BKB/3yL+PppvIfrugEy5dlvcwAAAA==
X-Change-ID: 20250905-nilfs2-fix-features-cfi-violation-3a53eb52a700
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Kees Cook <kees@kernel.org>, linux-nilfs@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3674; i=nathan@kernel.org;
 h=from:subject:message-id; bh=PneSr0UFkyje7hiRxdgfda0/0faF4NUEJ+o+j1qL+sc=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBm7LV5O75mxwrtSTGB7lt4OySaL1axT1hyo3X23TPHVj
 zSXNUtvd5SyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJfHjK8FdyqecGt+93zgof
 WWk4/esd/vmzVDu/7qrn84kRerXXc9sLhn96lipyE1R2aex6MTleduPdM0tnt1lmKTZNk7hVosz
 5pJEFAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When accessing one of the files under /sys/fs/nilfs2/features when
CONFIG_CFI_CLANG is enabled, there is a CFI violation:

  CFI failure at kobj_attr_show+0x59/0x80 (target: nilfs_feature_revision_show+0x0/0x30; expected type: 0xfc392c4d)
  ...
  Call Trace:
   <TASK>
   sysfs_kf_seq_show+0x2a6/0x390
   ? __cfi_kobj_attr_show+0x10/0x10
   kernfs_seq_show+0x104/0x15b
   seq_read_iter+0x580/0xe2b
  ...

When the kobject of the kset for /sys/fs/nilfs2 is initialized, its
ktype is set to kset_ktype, which has a ->sysfs_ops of kobj_sysfs_ops.
When nilfs_feature_attr_group is added to that kobject via
sysfs_create_group(), the kernfs_ops of each files is
sysfs_file_kfops_rw, which will call sysfs_kf_seq_show() when
->seq_show() is called. sysfs_kf_seq_show() in turn calls
kobj_attr_show() through ->sysfs_ops->show(). kobj_attr_show() casts the
provided attribute out to a 'struct kobj_attribute' via container_of()
and calls ->show(), resulting in the CFI violation since neither
nilfs_feature_revision_show() nor nilfs_feature_README_show() match the
prototype of ->show() in 'struct kobj_attribute'.

Resolve the CFI violation by adjusting the second parameter in
nilfs_feature_{revision,README}_show() from 'struct attribute' to
'struct kobj_attribute' to match the expected prototype.

Cc: stable@vger.kernel.org
Fixes: aebe17f68444 ("nilfs2: add /sys/fs/nilfs2/features group")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202509021646.bc78d9ef-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/nilfs2/sysfs.c | 4 ++--
 fs/nilfs2/sysfs.h | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 14868a3dd592..bc52afbfc5c7 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1075,7 +1075,7 @@ void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
  ************************************************************************/
 
 static ssize_t nilfs_feature_revision_show(struct kobject *kobj,
-					    struct attribute *attr, char *buf)
+					    struct kobj_attribute *attr, char *buf)
 {
 	return sysfs_emit(buf, "%d.%d\n",
 			NILFS_CURRENT_REV, NILFS_MINOR_REV);
@@ -1087,7 +1087,7 @@ static const char features_readme_str[] =
 	"(1) revision\n\tshow current revision of NILFS file system driver.\n";
 
 static ssize_t nilfs_feature_README_show(struct kobject *kobj,
-					 struct attribute *attr,
+					 struct kobj_attribute *attr,
 					 char *buf)
 {
 	return sysfs_emit(buf, features_readme_str);
diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
index 78a87a016928..d370cd5cce3f 100644
--- a/fs/nilfs2/sysfs.h
+++ b/fs/nilfs2/sysfs.h
@@ -50,16 +50,16 @@ struct nilfs_sysfs_dev_subgroups {
 	struct completion sg_segments_kobj_unregister;
 };
 
-#define NILFS_COMMON_ATTR_STRUCT(name) \
+#define NILFS_KOBJ_ATTR_STRUCT(name) \
 struct nilfs_##name##_attr { \
 	struct attribute attr; \
-	ssize_t (*show)(struct kobject *, struct attribute *, \
+	ssize_t (*show)(struct kobject *, struct kobj_attribute *, \
 			char *); \
-	ssize_t (*store)(struct kobject *, struct attribute *, \
+	ssize_t (*store)(struct kobject *, struct kobj_attribute *, \
 			 const char *, size_t); \
 }
 
-NILFS_COMMON_ATTR_STRUCT(feature);
+NILFS_KOBJ_ATTR_STRUCT(feature);
 
 #define NILFS_DEV_ATTR_STRUCT(name) \
 struct nilfs_##name##_attr { \

---
base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
change-id: 20250905-nilfs2-fix-features-cfi-violation-3a53eb52a700

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

