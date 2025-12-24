Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5BB314D28
	for <linux-nilfs@vger.kernel.org>; Wed, 24 Dec 2025 00:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766536295; cv=none; b=QlAAlPWcS1xXfejhRIWbAub6Rtt2MD/OwPMe0Onn34YL1qs0rJRpR/bFt0OZWwufFh2iDXyEvS0Tss+bFnDRD946EF7QkXvZd8O5hIk1bOSpnwsoKT2RE/w8d0hagJiofZhKfQ1h0k5nE9pqbOd0NjqcBTHhdpmYIW9umvr62Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766536295; c=relaxed/simple;
	bh=q5gMSiXxK+19YQ5unrApHjloewkL6CM34gTEsVFcHd8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aAMSPupyxwASocwsNMYGY7fYoRjExmzqgh27CD/Xg2LdibtC2pmBSbcscwee2y4gqE4Z6ShecGWmi4B29q39GC7vYkEDdVVJjIyDfkpSylAdh4GBQZpjG/3uutvS1Gp7m3NVtla/jYb3mO6H2eXDivHYtc0zid9Ao8Nl1kEBh5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=2BQi91xP; arc=none smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="2BQi91xP"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-64467071f9fso4289764d50.0
        for <linux-nilfs@vger.kernel.org>; Tue, 23 Dec 2025 16:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1766536293; x=1767141093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L5rDvPECvFaCsu10CL1S5YzrNkaWKW7eAydUhkB1MXQ=;
        b=2BQi91xPTyJSjdEJZgRXKTyiIg5puizTdWi8m8SwqA7zYhzA5Y3MxnHPSIvUcVDTMV
         O/QNUomNwj12IEUkYP/oFFuKPXY73/fiB2T+bDzSPqXZPggQl0oK/vwE3qB44HSiNanP
         asjnvNaw5kM30c9Bh6szwlvXR+79zLY5R3oLMS0DK2z9Qv+aOGzm+ZNZ1yT31mwINk67
         v7QFHNvy9cJWgNuAUUNtsD3ES8S2UAQoB3dfXFHeGZubMZu2d82//slZTajQ5LGfSP6J
         5FLwZWJ8uYGaUjQcNrs+O8FDii6kJe7G5Rx7a8BmFcnPXQ5jTI1Z2ps3QpM2H8USUKaC
         c9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766536293; x=1767141093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L5rDvPECvFaCsu10CL1S5YzrNkaWKW7eAydUhkB1MXQ=;
        b=FpIWcDzu0b9z7Dxgk0MC3sWAq9AQippafrEP9zkr5QNHqpynqK0WeDnvsNLvD1i2ai
         EMp3XSRZxw1jZp/cX2QWG9rQTsFUoaetAJjgCSj6x5izOVw3wlCdr+F1zqR0ij+mu6/T
         fWNJ52I+EHahs4L2Qn689/zjEbXATnQhYly/BXd7AvKPy1LnExXFpSWUkCvA0+4P56xr
         m51HcKsbn8dHY/n9hymx89xX90+tRorG7RIIWzPfM6+kLMj/RGipeWITHjSELwuIl1+U
         MQkxv9eYezuO70CCv69rUeXIBBJP+QDYamWpKXpyc1v4qhf/S1dajzL4kyidt4QbI7FV
         pSuA==
X-Forwarded-Encrypted: i=1; AJvYcCVrNLvNhARDMhuBgiH1WrZebfmbuNo1FLIpTI0JyZ0XYGQKnso8r1ri9LgvzJ5y1a7a4BpHc4znaPgEVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzK97dAHtwBN5yYd+kV9TIGQFnC4a63iyTiWc0UVLd2/SmcW/66
	sN+eeRN5rfq2Zemk55Pu8FWKnsgFizfOUbcS5jSHjigAUIgApjIaHZvf+4oWRFxRw0Y=
X-Gm-Gg: AY/fxX7OOzQyOlaK6r3/5k8jedEarS6b2X3Wkw/77A/F1o9CKnAk3/X0fhyZCnGwLKs
	q4JzTSuno+FMTcBZpqxT5SQ7HKa8yE993V8/tTlY++i4ckRIYW50988UbbFm4h5klsQvK2xXC1+
	BvAiqr5tGwD3KHZbEDH+kAIEto5ACXrRanpAl1PAa7EE4pjaV3TKJ8zgdVpNOa1k1AQAeuZEK4m
	H5U8IG1K5NC/ojCkjLsD0IuIoc3AFYNOAGdMjRMIOlU9WkSadefSRvyl57j8RCAwKZmAl/Qdd2X
	sBjRJfttYwa6v2Plzmsf+5xvM7iKfBwun/pnAhc6WHcKEXcW0IlfHQV6yOdRdGLBK66GMOsWKoZ
	0FxlKTyzkO5HWnrhgF9mxIGsyf6WE+EBGoXwQ8ZTthoh1ZlUxYiV3oUQAglkSB/m74dgeoqFSMa
	aPHhE6PRwQBh66Zehlj8iRMpUXin/srTFol7pSlNgpvl8P52MzuUYFIlyMtS1tkxt0TjDWP2fzR
	CsTSyp90egx
X-Google-Smtp-Source: AGHT+IEjLsxjJgm1tNq7go/FJWytc3qikX7hfJ771aCTmb2GXgsRKeoMSeIHBck7CqE/+dxxSKBwnw==
X-Received: by 2002:a05:690e:2453:b0:641:f5bc:68de with SMTP id 956f58d0204a3-6466a8d7899mr10102913d50.75.1766536293059;
        Tue, 23 Dec 2025 16:31:33 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:d3b4:b334:ddb5:458e])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6466a8b1758sm7595565d50.4.2025.12.23.16.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:31:32 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: glaubitz@physik.fu-berlin.de,
	linux-fsdevel@vger.kernel.org,
	frank.li@vivo.com,
	fstests@vger.kernel.org,
	zlang@kernel.org,
	konishi.ryusuke@gmail.com
Cc: Slava.Dubeyko@ibm.com,
	linux-nilfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] xfstests: add HFS/HFS+ and NILFS2 into supported FS table
Date: Tue, 23 Dec 2025 16:31:21 -0800
Message-Id: <20251224003120.1137284-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds HFS/HFS+ and NILFS2 file systems
into supported FS table with L1 level.

Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
---
 README | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/README b/README
index 196c79a2..d5a94205 100644
--- a/README
+++ b/README
@@ -87,6 +87,10 @@ L4: Active support from the fs list, has lots of own cases.
 +------------+-------+---------------------------------------------------------+
 | 9p         |  L1   | N/A                                                     |
 +------------+-------+---------------------------------------------------------+
+| HFS/HFS+   |  L1   | N/A                                                     |
++------------+-------+---------------------------------------------------------+
+| NILFS2     |  L1   | N/A                                                     |
++------------+-------+---------------------------------------------------------+
 
 _______________________
 BUILDING THE FSQA SUITE
-- 
2.43.0

