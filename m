Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C3044386
	for <linux-nilfs@vger.kernel.org>; Sun, 17 Dec 2023 13:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CY0wg1mu"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-77f4b8bbe0eso180062285a.1
        for <linux-nilfs@vger.kernel.org>; Sun, 17 Dec 2023 05:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702821042; x=1703425842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AR5K4+TgF2Io0XCc2UZ4DivsDir1ukFI1s2mK9JPOiU=;
        b=CY0wg1mudV2WT8ldoC/xYi+IPKYGLiyZlyo+4uFctBZ1ZyeYsCO5RFafxyJVkhPXxM
         ufjJVC5dzK/sUbnmvRokXB0lzubp4vJqha8q8RacVJGDYOwvEbp3Ymz2VdSaHqdshpLH
         O7KGY+V+2GA3kdaTMAgu6XiSU2HHrkQMGNqkG4EqBWOOLIHmjwat4zF77/pHij7Nzi8w
         2phFV1M6a/x46F722CLOysl01uai24E2QXGHMhZcma7r6x1gZf0SlknM6G5oNCDEXxPP
         vGakm6aTlAZib3iDTirfO9Y3+pQZ9/4HLdG+oNggGiNKEzDQLL+hECqS5tDqqHagTnyZ
         VM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702821042; x=1703425842;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AR5K4+TgF2Io0XCc2UZ4DivsDir1ukFI1s2mK9JPOiU=;
        b=VISiRo69dZZXnm19vMlptr6qtTTtT2tCCx5DYP93i114GazJ5vtgLnfwnoYSTuZjap
         5QnSkYvqzMTu17pLlI8o0BRKKnbPBm0D11eUNrw8MlEJL6Q8UhTdvmpCSKvjrsbYtITH
         3pnPnJ4aKAv3TlQN1cTw6yOw+QEvFMKEwUrqdtUub/ohteX7JmSp94yp9Azg0eJc/upz
         VB8Ef+ViE8eqeqy0iHezu4gSmUfRJCN/5C7SWOqvKkdVmBI2krfPm5Xw+EqcWik8kb3i
         vNq4eWJMN9wPPEioyHGlgxWN37aFDl55hpYUXjoyl+qCRKiiT3KrNgJf082ra1vaW975
         /eaw==
X-Gm-Message-State: AOJu0YzaOEVQINQb8k/HlyHD1dJIruoepFPmW0np0AmOII5pxxp5+BlN
	v0YyAQdxXoE5ltmvfBV1zj0=
X-Google-Smtp-Source: AGHT+IEJaM+Vi271w83uyUJTFng1Hmyz4zgYJz38m6QVU+pB2m+5tNisavosMVYxBQn6wRwNYWUqJw==
X-Received: by 2002:a05:620a:2984:b0:77f:95a0:43c1 with SMTP id r4-20020a05620a298400b0077f95a043c1mr10536989qkp.58.1702821041887;
        Sun, 17 Dec 2023 05:50:41 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id r2-20020a05620a03c200b0077d587e5589sm7556809qkm.27.2023.12.17.05.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Dec 2023 05:50:41 -0800 (PST)
From: Kevin Hao <haokexin@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] nilfs2: Add missing set_freezable() for freezable kthread
Date: Sun, 17 Dec 2023 21:50:24 +0800
Message-Id: <20231217135024.3116955-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel thread function nilfs_segctor_thread() invokes
the try_to_freeze() in its loop. But all the kernel threads are
non-freezable by default. So if we want to make a kernel thread to be
freezable, we have to invoke set_freezable() explicitly.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 fs/nilfs2/segment.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 52995838f2de..2590a0860eab 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2588,6 +2588,7 @@ static int nilfs_segctor_thread(void *arg)
 		   "segctord starting. Construction interval = %lu seconds, CP frequency < %lu seconds",
 		   sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
 
+	set_freezable();
 	spin_lock(&sci->sc_state_lock);
  loop:
 	for (;;) {
-- 
2.39.2

