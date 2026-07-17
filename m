Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A043BAD93
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 10:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784285951; cv=none; b=RPFNjqIe9f3/SGwcHHEzCYI1mU+Dbsw9td4oakSl6//H2T8op0jHxJba7bdFWrqp4WFsHeRj5MlB9JFB5nYnlfp7neZd55w8kb4fMzKkW54xsot2gxUMrATPsDLTIasVEwboXrbKtGZmiCGsvm6Bj3OkaxMh4qSKhsnNQ4WqRfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784285951; c=relaxed/simple;
	bh=A7r/EqcuRMT3w+ivfAS7asR3/rukxmKHD4XzQ99LdGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bjQeM7LQgFs6SphswHQEuCuuSeQV8KGXx0RiCwsrpj9aw7rfFRp7XOMCLPPcXccPqrkx1z1bhjdGvdbXUjxd7TZiz4lxUmB2Eh3HugmuZoC/emSCQhoyS8cIoR2KIvEFhM9qP/Bspsl53GswU7tUCyUwjo2RDswgf207PUeNo0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=geaRnfuR; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="geaRnfuR"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1670dad7a8so586273266b.3
        for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 03:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784285943; x=1784890743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dxYz8HMmlj/L4TPuKQ/ldFgmsuX3axNrHo8m5b0twRg=;
        b=geaRnfuR7dOFrmgOC7qK62qOMkQjYhc/C0kgHp4sL8AhuU9elldtP2c/HyYPtWXCV7
         R7h7bt7KHtoaf1GmYtb/EHD9+WBO6jyDfQmm0CCnpfjwiKywONkHgq1cCYKNZ+SwEkVu
         lT7TufD/4xpGx8K7/AZPmWIeJKSKNMS2IRQIYjzp8nhdKP0u1lyTR1DKJ7ZezBDf4X09
         /ebLmBML8h1qb38VIgWr9fWMU1pZZeEcCjPQcHUUSvytPwNtxLRt8MerHr0WoKRGE9G9
         z/pXimpIfJIQ266deXykEbtsCaNh7l4Mh4gelTK4Y7XvahXessrCPWg8zBizUTi/g5Lm
         004w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784285943; x=1784890743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dxYz8HMmlj/L4TPuKQ/ldFgmsuX3axNrHo8m5b0twRg=;
        b=KZJgC32hBxWBHxGB7/QWsW/7JYWzYL5FZhOdm+dkZ8djIzBRz6z0RcncvaFR3SzF7l
         FHcqgpgYNWTAKIHM+ckC6NykpAOGD9jzfnAwac4vY+LNTMBU5JRWp8cPs8PRCiSN74vw
         L5JvHrJ32EjKpRteNVK2fDmnadpHhFAaBKf+aATg7yb61ExVMO4mverOI1lnYB8/ek5m
         7f7Rtd0Mw1XBND4yqC03yKRJFH9rZN1evqIR2HNzFQYrt0JDl42gpHsYqkFYL3dYuxb3
         xMxYlyQktrRAfmevJCtomoslnHxLmy1KuAQn3ycNusCDdN31fSx7UUhRZKFtFbRYrPCv
         sh3g==
X-Gm-Message-State: AOJu0YwQmXUPP/IqvG1UQMez0VqRDTvS/ZYZiGpVeFbXjXhPfdegEaMR
	t8QndiPji4koDk8nbvKUhF4+WRHdo/QYr4GphoiJT3rXD1KYDE5OZCZS
X-Gm-Gg: AfdE7cmoPcGs3c5RqTsgl3CXCsPU0VhcHl1h4a0YlgioNI7akP1SOQH1IuRykj0B73a
	KWSaTDtWFrOIZLzvoMyqJ4wiVowPcriSn3wUWz43Wh0iMo4wcF0r1PywXXJDsfvsRLTs7rOXN0C
	92TSN0bR6/OWSjRAiGYNM8povwOulV8ynGngT3CnOjMJz2lBIsyH8vNJrGm9F+tqtMbengup+aE
	NT4odf2FBAcYSV8cXxBBCpPKNszbDJZBz1eklwz4hAyVS2tNFjPsJq8gUdIOj/f2hoIUHP1lcku
	dXXk5O15bGejik7Dz59+OVB55DkVwq817K5PgZFpzc5newVBDHK/oJQo5V4unBtcSNIbE48ChIJ
	DHP/ojR2eWSvs7G3GSA4KIZWS5gY1Ej+ccti7HVGTExzbB1b9Jy/A065RH/At/wmZ944hxhw59b
	EzqA2XQsjgLA/NDLUoiRoJcf4Y3Q+zMZhWgYX8MsmWD6wacwKRlCM3fUG4S3nIkM+xdECZJPnn4
	xcuYhAQV4vOTAYmHvq9xx7X3A2HkTQdbprwbzP1UyzRWe0xvGyxTw4zIvPaGjLK7pPlMAYyVTQ5
	UMUmEjQXs8aa3bjmr2emvxOpoIUUSaAuOoxb1K1WLuGXR1MkSyrRUQ3cnf5HAwo19IZhJojJJ5p
	jU5FEJBfnsOqTBdnj1SatqlyEZEEisak7LAnOg1Ve1YP7qH0qy3WjTCLUs4VGa/T9mBo4olQxT5
	mxp6onTbFRhsMec2PKa08=
X-Received: by 2002:a17:907:c0b:b0:c16:8931:245c with SMTP id a640c23a62f3a-c16b4756003mr102057866b.21.1784285943262;
        Fri, 17 Jul 2026 03:59:03 -0700 (PDT)
Received: from cs-280612103108-default.europe-west4-a.c.oa7bb030819b2a894-tp.internal (202.104.90.34.bc.googleusercontent.com. [34.90.104.202])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c170591172esm58080666b.15.2026.07.17.03.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 03:59:02 -0700 (PDT)
From: Joshua Crofts <joshua.crofts1@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Subject: [PATCH v2] nilfs2: fix infinite loop in nilfs_clean_segments()
Date: Fri, 17 Jul 2026 10:58:54 +0000
Message-ID: <20260717105854.1380-1-joshua.crofts1@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported a hung task in nilfs_transaction_begin(). This occurs
because the cleaner ioctl falls into an infinite loop if
nilfs_segctor_construct() repeatedly returns -EROFS (e.g. the device
is remounted as read-only after an I/O error).

Currently in nilfs_clean_segments(), if err is non-zero, it logs the
error and sleeps but doesn't abort when it encounters a terminal error
like -EROFS. This causes the thread to loop forever.

Fix this by breaking out of the loop if nilfs_segctor_construct()
returns -EROFS. This matches the behaviour in
nilfs_segctor_write_out(), which also handles -EROFS.

Reported-by: syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cae54346a70bbceeff2c
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Assisted-by: gemini:gemini-3.1-pro
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
---
Changes in v2:
- use `goto out_unlock` instead of break to prevent discard commands
  from being sent

As much as I've tried, syzbot is unable to test this and always fails
with "FATAL: Kernel too old". Nevertheless, I've tested the patch with
the same reproducer in QEMU and the system didn't hang.
---
 fs/nilfs2/segment.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9332f5ac6..218926789 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2561,6 +2561,10 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 			break;
 
 		nilfs_warn(sb, "error %d cleaning segments", err);
+
+		if (unlikely(err == -EROFS))
+			goto out_unlock;
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(sci->sc_interval);
 	}
-- 
2.47.3

