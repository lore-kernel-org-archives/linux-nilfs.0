Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9624712BF32;
	Fri, 16 Aug 2024 07:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723794215; cv=none; b=QUKUSxysIOekmPzamtajbOrBx/rzC9NQulUzdIQjtDjv4lYzN2pRwJb/7GAyU7oLr0Y+PB4uo8UfsCOvwXVTx3No0hQTdDBXkrKhJuAqvBUyrIDfjPESZUdNOCU1/qzCHcOrTfPGFwG+3EtATl5VwR68qgYj3BJmKEVIwoubT+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723794215; c=relaxed/simple;
	bh=QkJcD+/7+feE3IKtKVd5MY7QxZ35Ciq4ku4FJsISGwg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LH3svkCUW1JzUyGDTw7GHbYx0/2bApbHxDSpXJHp9STn/wFSiO598vbVIA7I4vzHbCo+lydo0rrLaDl4nZ5pinMJ8q54sOdE5kl9cdkh9zhg5GaT2M0ZoWPrGZILatAavFvssOjhnT0Y1OpFtbgh3uRqnNeOKPALQfnqRFAphec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jOLfe1Ku; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jOLfe1Ku"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5d5bb03fe42so994043eaf.3;
        Fri, 16 Aug 2024 00:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723794212; x=1724399012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f6eyKXO4gQ7WsuUsRihPfatUBDrlwvh2bJ1+YnjG9XA=;
        b=jOLfe1Kuu2UKVuJ5W0HIvh3D2rHxWQ3f1buc0IDUkIcMKQDLP80l73HjmPBvkTDe0j
         NyUCojBueuxJkZOlgqlf6XCFSeDwt8uOSsEPZeQYHmM+V/BP5EIuEhaTkE291yMqqMDw
         vtDnUxKxKIW0McZAwHnq3ryNXyzjj3dTItJPuEn9OKCIFHV4JHZhXV5HBny9YLhsXx7q
         Y5N62v6luAPeUBPSwXLzEJbSRkQZ2TvudDEUDIL2D3DYOKOcSvEt6XKkhIKKKP7B4CpH
         uG1IHGWwLhcXWVs4b1AJnAYCemjW9wEq5yPucR/Ei/gI3SS5R8uzRBJs06e6ajSRks9j
         FusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723794212; x=1724399012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f6eyKXO4gQ7WsuUsRihPfatUBDrlwvh2bJ1+YnjG9XA=;
        b=Ym2OIVef5N4jMZ9tAMIus9f8yF636WqVlpYxWcc2qY2Pdax9jowMCuCJPQyeob+bBb
         Vcln2OjMuBp5cliSxmr+t6BNuVIfkDgiwUI1PJcM3ov0Amzu8MzlrT2tbWXdc98fiz1X
         kNYrv01OC7hli6OxgLGjlvN2XlRHT2ZFrFRjjwa+jhmzf1FoKPX1s6krNa308dfin7Wl
         mZR//VZ7B6v4Ua0yECLcrtqPYWoZ4i5stcP9jpKViXPsLIjX2BWY6eUa4bccRI1O01eK
         YuglwoeeZ8+EliZn6NUHIAqYKEXIv159x5M3gLN9sIPMtYDIA8PHu8DOQxVYIQgx+rDr
         rxBg==
X-Forwarded-Encrypted: i=1; AJvYcCVQ9LHDOyAP+Z0FXPlnHVAc/S22nhV+KaK+GUxbOwPa+k/pQWpdjgEf4nfy4RjSBqOTlFd+xZrFu51GRlPreA2T2aHCfbYiZ2Gro+cX
X-Gm-Message-State: AOJu0Ywx4kfFedHG1f5OhocsON8tANTQ7J4aB27d6EvLu3iyVS2UmqHl
	4msiqzq/nH5HKi6ajrAxqr8P/vOUN4Uld9ck2fq8sJ55seBOf9GCvGpAsg==
X-Google-Smtp-Source: AGHT+IHhsZA0iQUnIsJIWt6Xqia6sfSohcfChNNJ0cALOZccgegDiKNxUuL/bSfLoYMbuclcynQPPg==
X-Received: by 2002:a05:6870:5687:b0:254:a09c:6ddf with SMTP id 586e51a60fabf-2701c3f7b34mr2314519fac.24.1723794212377;
        Fri, 16 Aug 2024 00:43:32 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61e7c7asm2365971a12.45.2024.08.16.00.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:43:31 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] nilfs2: add missing argument description for __nilfs_error()
Date: Fri, 16 Aug 2024 16:43:12 +0900
Message-Id: <20240816074319.3253-2-konishi.ryusuke@gmail.com>
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

Add missing argument description to __nilfs_error function and remove
the following warnings from kernel-doc script output:

 fs/nilfs2/super.c:121: warning: Function parameter or struct member 'sb'
  not described in '__nilfs_error'
 fs/nilfs2/super.c:121: warning: Function parameter or struct member
  'function' not described in '__nilfs_error'
 fs/nilfs2/super.c:121: warning: Function parameter or struct member 'fmt'
  not described in '__nilfs_error'

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 76e35e6773d1..8eb8dbc9f51c 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -105,6 +105,10 @@ static void nilfs_set_error(struct super_block *sb)
 
 /**
  * __nilfs_error() - report failure condition on a filesystem
+ * @sb:       super block instance
+ * @function: name of calling function
+ * @fmt:      format string for message to be output
+ * @...:      optional arguments to @fmt
  *
  * __nilfs_error() sets an ERROR_FS flag on the superblock as well as
  * reporting an error message.  This function should be called when
-- 
2.34.1

