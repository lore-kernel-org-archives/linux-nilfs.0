Received: from out.smtpout.orange.fr (out-15.smtpout.orange.fr [193.252.22.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33722BCF5;
	Sun,  7 Jul 2024 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.252.22.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720360968; cv=none; b=RACJrP1a9oGYVTvjemDytwfmXwn4Hxg7RAxCa/L2YGn88/4RvO8Ep9OQw0yabvpqwZR1J3V7X7vaBK6rpKqcxTmrgxsuIan6yNHKnTq/rY8nzbmakSUuWc2AWkx7VfPjDiJJ5h8HJyOugj6ohdO1KsXDs/R9xZ/X4biOdi1/J5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720360968; c=relaxed/simple;
	bh=cNY4FBrDVyFvxJ1FcOjdbsesqA7en96tMYxacO6mzj0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ozgg+YpUJFinvsS2riuwPyXP4iMmXMcqsgm/pJH7ZWDscoYP59d3CdjwgDWPzwIprqHBM0fs8UELiBaeAucNQuizQyUSylmSFS3aLbjkEVi2eCgvJVgPUznB6SGH+zvD9qJK0bEt8c5wrpd4jkp31WE0OzxnljGbee47t7nngqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=cKyOn3j7; arc=none smtp.client-ip=193.252.22.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="cKyOn3j7"
Received: from fedora.home ([86.243.222.230])
	by smtp.orange.fr with ESMTPA
	id QSSCsitZDDoZEQSSCsv4du; Sun, 07 Jul 2024 16:01:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1720360884;
	bh=yVl9ZDegeHLmo3z4LwytZC3MJwUOtHfsHQOYoM/Kvbo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=cKyOn3j7qIWtromjRHSwjED+tRnvDYNG4upPcM0jfIDp/1W4WJK7nr5ihTPth/p+p
	 4R2dvhee0xboI2GQoIeSNQeflpvos/n641SsqFNZctFORTZ5n3dPw1ql2YUtDYjfWR
	 sTbwLRd7Em1bre+8+9iwZ0fQy2QdgZwgowsuwME7hYE9QcJMJS8KKKnDLJFazH5cdt
	 QSjc8X2T1ErJOSKIii3BYSiLie2rUwmy7EeDpSpfoawkH3G+ejB5z0u5gBG/jE4jbi
	 Q/3c+Ief03aHXz9Qu9+ZLhaa8OvgMjcDs44riOgYwXoKN0uHE1fzaCj0KbQKaQGwAv
	 8QIN2uN9aszwQ==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 07 Jul 2024 16:01:24 +0200
X-ME-IP: 86.243.222.230
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-nilfs@vger.kernel.org
Subject: [PATCH] nilfs2: Constify struct kobj_type
Date: Sun,  7 Jul 2024 16:01:14 +0200
Message-ID: <7da501fae4f96e3d2c740fe5638cad813d33fcbf.1720360830.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct kobj_type' is not modified in this driver. It is only used with
kobject_init_and_add() which takes a "const struct kobj_type *" parameter.

Constifying this structure moves some data to a read-only section, so
increase overall security.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  22403	   4184	     24	  26611	   67f3	fs/nilfs2/sysfs.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  22723	   3928	     24	  26675	   6833	fs/nilfs2/sysfs.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested-only
---
 fs/nilfs2/sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 379d22e28ed6..a5569b7f47a3 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -56,7 +56,7 @@ static void nilfs_##name##_attr_release(struct kobject *kobj) \
 						sg_##name##_kobj); \
 	complete(&subgroups->sg_##name##_kobj_unregister); \
 } \
-static struct kobj_type nilfs_##name##_ktype = { \
+static const struct kobj_type nilfs_##name##_ktype = { \
 	.default_groups	= nilfs_##name##_groups, \
 	.sysfs_ops	= &nilfs_##name##_attr_ops, \
 	.release	= nilfs_##name##_attr_release, \
@@ -166,7 +166,7 @@ static const struct sysfs_ops nilfs_snapshot_attr_ops = {
 	.store	= nilfs_snapshot_attr_store,
 };
 
-static struct kobj_type nilfs_snapshot_ktype = {
+static const struct kobj_type nilfs_snapshot_ktype = {
 	.default_groups	= nilfs_snapshot_groups,
 	.sysfs_ops	= &nilfs_snapshot_attr_ops,
 	.release	= nilfs_snapshot_attr_release,
@@ -967,7 +967,7 @@ static const struct sysfs_ops nilfs_dev_attr_ops = {
 	.store	= nilfs_dev_attr_store,
 };
 
-static struct kobj_type nilfs_dev_ktype = {
+static const struct kobj_type nilfs_dev_ktype = {
 	.default_groups	= nilfs_dev_groups,
 	.sysfs_ops	= &nilfs_dev_attr_ops,
 	.release	= nilfs_dev_attr_release,
-- 
2.45.2

