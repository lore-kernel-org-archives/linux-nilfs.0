Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FB613D8A2;
	Mon,  8 Jul 2024 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720449169; cv=none; b=pZ4lo5vsKd1zZSTE27sbcr9pC0QbsOzPS5yzZ/fVR9YOEjXfr2I9cuGojUEyosOqByZqaON6DljHvn3CxzaH2BlFNT9vbnZ4Q4rT2kiHbWduyHR6QVq/kPy0xbFJatQiy5HIWdP5uG2dWzwdKZHMjd0yXVnRrV19ArzANxn2Lv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720449169; c=relaxed/simple;
	bh=NI5fpI9Hib+Y/PXNo78qFH2ZKvv9sfbmvg9l7dWOm48=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VC5n4FMqyadZOeYcBMCuMMD3NTg6SUCnbnFzjPwv8jGlP0VE4/UEVTEpa1kJxHdYKIGrdK4n8V4zHhy1Sr4dQJAZ5yAUTkeK9zrOOgCuK7LjIxNhx6wTYJgtx7fwnbtgaFv/C+HTuFROE/ABFVUOn3nV3IUDh/IEu3LLBcx1npA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LWqtK6ja; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWqtK6ja"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f9de13d6baso22612115ad.2;
        Mon, 08 Jul 2024 07:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720449167; x=1721053967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z3usQXbSFBRmkGJBd7qR0UYdHTHd+PmUwMaBHQBg7tQ=;
        b=LWqtK6ja4tf6KDV3ceV/LAPhjt0N7p2vWk0QEdrPN6tWt3kabhrEzD5CvS2lbidts3
         ZUc6gd+Xq3NoZpl8s3ocieUOBBKKbSf2OgpL4V6xgHv3qCm8eIY9v0ECzlCqYxM/DM9a
         BKgPG8GM1pz+pPmCX9Oo/nKSxY9MR369SGLODQAWTbhrTF4Ve3zN6dpCrcj7xuPfQdZd
         BQPpZdlekjrBYJSDCggMkDYo+HChM/6cewNgNNgKIZj2O+VaAoYNSbgI5KAfZRzlPopZ
         4vhF9FXuFMd7pIjtCmTAvdwLI9dWD/+9QoZEzHfkm8IPA5VW+nkfGxcF5easuLGBk+BK
         a/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720449167; x=1721053967;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z3usQXbSFBRmkGJBd7qR0UYdHTHd+PmUwMaBHQBg7tQ=;
        b=OM84vwQDTIumqBbVBc9HC6ndHjulDOC+7vVPxFGPxxcMvwaMA8ggH3xCYD52EHIy47
         VWSIJ8uf+wADRIMnDVRa7ZE9iXtW7QYPXdW4lDF7CSZ/u4DFFB5oZy8czZLtbNilDmwn
         0PIVP4T6RicGFcpcWYuHzqTzqh208IcICzdpB+OXB+l+xVYefShI4W+bpb4KzrqjQI0t
         NIev39p8ki5QyUdX1IQo3V/rDlr+D6/cEDj2OSs9HItn1WzvAG+E1vUKuKULolnHrEox
         PVZtkiqvHq/WAb1+SQFBPjfpH2upHnYUdCzrehiaG1snlJB1tXTuxvyAqDgPbVtF8vwO
         K9lQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3dOreMMvW1rYWiGtzqyScziabBEeuRObQLeCREC9Y+Q64hAL5n7trskQewizMVqsXInXKy+rSbgYTBJ3fINhVooD5DqN0oAqOLg5T
X-Gm-Message-State: AOJu0Yy4FofyM1ewDoPzSY3dpXjC161x7q13RzHdCESdM7s12zUikx6p
	uxerN9j/5YBvkYFBXWcCFXHhxMFCza+EtKC7YrpGK3ZCxeywy8EsCVqjdg==
X-Google-Smtp-Source: AGHT+IE4ZYNokkKnLsvQiZcU7NCm8/KmTeodXKOAN8hA87Kx7tJ2yyEqQ9cAbytOEby9TZZItPg98w==
X-Received: by 2002:a17:902:d512:b0:1fb:666f:ddf9 with SMTP id d9443c01a7336-1fb666fde56mr34218315ad.30.1720449166924;
        Mon, 08 Jul 2024 07:32:46 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fb8e1ef3efsm23283745ad.223.2024.07.08.07.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 07:32:46 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH -mm] nilfs2: Constify struct kobj_type
Date: Mon,  8 Jul 2024 23:32:42 +0900
Message-Id: <20240708143242.3296-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

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
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Andrew, please add this to the queue for the next cycle (or the
next if it's late).

This moves a few static tables in nilfs2's sysfs code into a read-only
section, making them secure.

Thanks,
Ryusuke Konishi

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
2.34.1

