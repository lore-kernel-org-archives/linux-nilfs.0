Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91F51EBFEB;
	Wed,  4 Sep 2024 10:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725444987; cv=none; b=rLEghVW4GgAcIqKSlZZmu7xQ0uvc4gCaHKZkmeU2Af8KEIF23b1QsOCkGcc3wANB87oXxWJnGuEr611uZvspSibsZq+WMYOil9UgDBPv8RPVf5UKGIHkid3cTULjywtNsvPMOU5MUvA/uhTv5n+oTchWGzzMQHB+rRRBdqIjxQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725444987; c=relaxed/simple;
	bh=c5zgwRervJYJS/Dl+adZ4J/D5Z27/zxX6bPB+ouHVpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BttsayqxOVTSHtdJvkcuRG1ZVW0WjyZ4aPuDwC8rJYag1oFNnx0sQrGvyz83gqLXb8awmUBAuwI34SeaL++xOPpuLMo4YDIzs3Cx20gIl3jwIDVxL551rX1cGcJysYf2VXijHIEupSMnYNnDeTrmwkAS6jkv5aAhel4tpQkf+8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iiXTxOEZ; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iiXTxOEZ"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5e017808428so2121130eaf.1;
        Wed, 04 Sep 2024 03:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725444984; x=1726049784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QFfJDopo08396zla94L1PBabmTdXxT+6aOW8equ/pAo=;
        b=iiXTxOEZonaQKv/Q6S2ZtlBIpELtkfKmR8dc+Ffp5FNc8z0lWcExI+JClmFLYZkeeR
         j5wj42R2Bw9VGnHcnU833fvN7j75YUYo2XsNfceDtL90/+KYjvmq0YIba81Uj+fXqipD
         hShS2WMpeF/Nm3h/CG8gSIjVyaPMoZJRdvVh8Dc9sm9E1dgL65EsEKCOkJe08tZHQkQj
         hl1pf0Zx95EyLwnHmY3ykQLlbY4d9Q9wT+pDDUci6gAqc8oD/HPzIycaaPEfgX+JlvMv
         YxCVeJZ3XFuVirs+5nTPzUhU2zW3pLHF8FEFTproUNCYhnZT2vesN+T7HkUAm319LnVq
         y/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725444984; x=1726049784;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QFfJDopo08396zla94L1PBabmTdXxT+6aOW8equ/pAo=;
        b=M1e8Kc2X861/52DFqjAQMS4TEX4lBsmhli3IsdnhVc+Xe6i+O08344zY1Wf+YZ49ZP
         Z5xc9r3KJSzY1LrKqV5hPAkns2ZTed9mSert0YtZJVdstKktUarJqJaPwN4NT2VLlehm
         /4sATxK+RnNgSacNGZMQ9KJRIKgOe+loqNbSz/mmsrqGl14cLVKl3Um7NA/YJT0ceFRK
         b5f5rHR1xruKNXZ6V8DOul+hOr7OlOmVq7g+mYhi3Jw8/hUrt0Ui5W8byRjqyMwfbMIU
         I5gzLC/FVSWm9c4qa67iUDBTSu8la7Ldx2ti8Jzeo5FcZa4Hp5BS/S1maYnXTWijeKri
         gaUg==
X-Forwarded-Encrypted: i=1; AJvYcCV0HyFRZU7n9kANCqOfBsfuSqgQ/2N35BszwvQWGqkgM8hO85lLO4Oqs5ByUYI9RARTQ81BAREmkv0mmoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEhSZRRfiqVrA01pqG0jMhbCJkr0na6cMq8w7CveDAygMT+/Hi
	VQorjP+canwGGL+uLdP2iXMeX4ArZegWauJAy/6k+JndYZbgQfbMtgDezA==
X-Google-Smtp-Source: AGHT+IEapMITuaq2WwM91qAfDzjqmN/GNuW9F67mqywWSvXbN59GgQNmG+GrcdJzSw4Jag36U4b9dg==
X-Received: by 2002:a05:6358:989d:b0:1b5:fa6e:4606 with SMTP id e5c5f4694b2df-1b8117c47f3mr698249355d.14.1725444983641;
        Wed, 04 Sep 2024 03:16:23 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d4fbd8aab2sm1332102a12.20.2024.09.04.03.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 03:16:22 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] nilfs2: Remove duplicate 'unlikely()' usage
Date: Wed,  4 Sep 2024 19:16:03 +0900
Message-ID: <20240904101618.17716-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kunwu Chan <chentao@kylinos.cn>

nested unlikely() calls, IS_ERR already uses unlikely() internally

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Andrew, please add this to the queue for the next cycle.

An additional cleanup patch.

Thanks,
Ryusuke Konishi

 fs/nilfs2/page.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 7797903e014e..9c0b7cddeaae 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -262,7 +262,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 			NILFS_FOLIO_BUG(folio, "inconsistent dirty state");
 
 		dfolio = filemap_grab_folio(dmap, folio->index);
-		if (unlikely(IS_ERR(dfolio))) {
+		if (IS_ERR(dfolio)) {
 			/* No empty page is added to the page cache */
 			folio_unlock(folio);
 			err = PTR_ERR(dfolio);
-- 
2.43.0

