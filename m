Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516C6C4332F
	for <linux-nilfs@archiver.kernel.org>; Thu,  2 Nov 2023 18:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377211AbjKBSjA (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 14:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377235AbjKBSi7 (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Thu, 2 Nov 2023 14:38:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FDF186
        for <linux-nilfs@vger.kernel.org>; Thu,  2 Nov 2023 11:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698950291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4TMeJ+np4weC9A1EJ0nwAbg03A0sROonQrm4coY6tYI=;
        b=UCGnL2+VJP4vnUmAqNIpvUwfhKQAmqiNC+dNTw++dk5bB6yTP7dPG7xEKaw4NXrpeARbES
        a01ae19YLuTFyYrjYJuduhA9EIlGNFtnARCE0AO385hPYHMmV+zEyWFOvZ5fEGgKPp2An8
        nH1fkjK9OItP7KyfjJ+DVThpGaCbjjo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-vhub9pGPOKWqOkLuplnt4g-1; Thu, 02 Nov 2023 14:38:09 -0400
X-MC-Unique: vhub9pGPOKWqOkLuplnt4g-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4084b6f4515so2601905e9.1
        for <linux-nilfs@vger.kernel.org>; Thu, 02 Nov 2023 11:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698950287; x=1699555087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4TMeJ+np4weC9A1EJ0nwAbg03A0sROonQrm4coY6tYI=;
        b=nup5V8fIW21xON+79NJreR1FCX3TsRzYPCmmbOYpb6mjyJ/fhig53M0VeCr2whf/Ru
         o+HHN2R2XE2GGUtskDknI7Ldj8sdLE0owD/DCLeGK+G1NIleBTgvIqyYwEv/qmJESNrZ
         8ccwAUXbEYoIMub8w1UnwxwfYjymkgnZlFRuuCj17ZAXX9ROVYD2unJ84DsaR/BplwE6
         hQIoWSqDpq7uGwen3lD6OdBm4XiFv/iNUmsmx8JUNyHx/dWKaT0C7DraIBz9XtY1gXS4
         2xnxabJkUX59fPCGf7IBy9tAVBE8abh8JbIAIHX13WHXuftMLYoSko9Q+xIN1TXY9QTD
         ja8Q==
X-Gm-Message-State: AOJu0Yw/XusPjb6IzxTz2eHJqNYaE5A3A4QVCKOKWN+hg+bTTF98VZpn
        vAEtS8wQ4HmSJNl8bcvX4ohUa8x9x4wsrjDUqVnm+hb9Z0rienc/dHx/zcYHRbmqyf1lTtHWihW
        Bz/kp82GcLd+PK1cV+45Odpq0J24NAkg=
X-Received: by 2002:a05:600c:35d6:b0:3fe:21a6:a18 with SMTP id r22-20020a05600c35d600b003fe21a60a18mr15734357wmq.3.1698950287732;
        Thu, 02 Nov 2023 11:38:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2LMtKNka+8H7xT/HXHVzvSunLZOLL2dRHM5nf8ghfToyNM+Y4NcP0YwDWUwqyeLZhv+q0aA==
X-Received: by 2002:a05:600c:35d6:b0:3fe:21a6:a18 with SMTP id r22-20020a05600c35d600b003fe21a60a18mr15734346wmq.3.1698950287375;
        Thu, 02 Nov 2023 11:38:07 -0700 (PDT)
Received: from pstanner-thinkpadt14sgen1.remote.csb ([2001:9e8:32c5:d600:227b:d2ff:fe26:2a7a])
        by smtp.gmail.com with ESMTPSA id k15-20020a05600c0b4f00b004094e565e71sm306179wmr.23.2023.11.02.11.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:38:06 -0700 (PDT)
From:   Philipp Stanner <pstanner@redhat.com>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philipp Stanner <pstanner@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH] fs/nilfs2: copy userspace-array safely
Date:   Thu,  2 Nov 2023 19:37:51 +0100
Message-ID: <20231102183751.47413-1-pstanner@redhat.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

ioctl.c utilizes memdup_user() to copy a userspace array. This is done
without an overflow-check.

Use the new wrapper memdup_array_user() to copy the array more safely.

Suggested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
Linus recently merged this new wrapper for Kernel v6.7
---
 fs/nilfs2/ioctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 40ffade49f38..6a9dceebb18d 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -877,11 +877,11 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 
 	/*
 	 * argv[4] points to segment numbers this ioctl cleans.  We
-	 * use kmalloc() for its buffer because memory used for the
-	 * segment numbers is enough small.
+	 * use kmalloc() for its buffer because the memory used for the
+	 * segment numbers is small enough.
 	 */
-	kbufs[4] = memdup_user((void __user *)(unsigned long)argv[4].v_base,
-			       nsegs * sizeof(__u64));
+	kbufs[4] = memdup_array_user((void __user *)(unsigned long)argv[4].v_base,
+				     nsegs, sizeof(__u64));
 	if (IS_ERR(kbufs[4])) {
 		ret = PTR_ERR(kbufs[4]);
 		goto out;
-- 
2.41.0

