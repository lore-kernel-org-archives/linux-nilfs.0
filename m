Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71DB27CCD3;
	Mon, 28 Apr 2025 17:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745861897; cv=none; b=J8mHwAyKweRmbyZ7pJk/BM+hF+6PFu+V1EhhGxIm4NoJWjpa+mQZ1ucP9S81d/8Vpp6MWSmo85ttfTZFg8dHbXU9d9FehZf+0mQhJOrsBsOqPICBq3vz+SwFfNgwCQcT6oOhupsP93K5+Omf2Yo5iBUslof3W3DYr3fPwDolTaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745861897; c=relaxed/simple;
	bh=wGsGNntzfwimCGodoEYW0PJc41Mgztn8cadRRoTHeRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WESyIc0jbJSBsacbDWfMhlydvUjcjDYodRY3Se5M4i48XZ+YZxmq1q7ikGuLC6E6vbYbLt28feWXjwef1qu4joNTueFEhEIIXFgp6z3i3ZflJAvbQqgm5f94g8uv+je/U5KxLtOT+m/BQQKkLoD7BIpi3daVKRfezOBNGjzMu5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VTwQL5y/; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VTwQL5y/"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736c1138ae5so5111810b3a.3;
        Mon, 28 Apr 2025 10:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745861894; x=1746466694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uay2PEsDgvrvX6RZkvxDCbi3qhSS/xmxQT3/0DG7puw=;
        b=VTwQL5y/MLvxLbIH/5FFiF5wxLlxy2wePI9ZVRye3h3oYEvNyENW/yhDBAd9lZf+o3
         GtBL5tDqsYSJ7nSvJk5eIGdqruEXY2RyXVe2zDUbors9oHwvJwDcjqjpBmx2GSJrs75p
         s4f3oBLxjZvfszYihebIQ9tzudZ6gTxhM4XlfgxCBjenK0DG+u24KR64lMhjvTXb1ovz
         rk2JLeUrIelj/uJD/VrK3XEAfFJuK+4VlAzPhOBVQf8El4QlBiqEdVd5bHoncFFnFiyM
         Zlkikko0IPglX6H428EAVeYI7BoyONFJTlHT+N4W4BHnSzGLpxoZwnkga7fMaB1bcf+v
         MB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745861894; x=1746466694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uay2PEsDgvrvX6RZkvxDCbi3qhSS/xmxQT3/0DG7puw=;
        b=Ikyn/E5QQRN9QqBR/m/HfRTEkA8LjryJuUmgzby2xOY0kL5CGZRExP36T/L1pk+AZS
         iSEpbb1CqQ12mC/7BUekSIakVj9k76xojvw91yFPZYxzZT5BIhIF/JBG3goLa+G/gSlJ
         DMqkk1joaGdCczvmdW+K7rtKO7dwchSzrJxfqCRv+yn59CN3APz+ioVgorVdzZLceA4s
         9xWnGDPkd5kJZphY7jYith+/CrGPQhIEz9rK6ocNgID82euWawVTWWaoLXc7CXmLXNc2
         IIvHytwekNpejlUduylqQB7IH7NLPKI6NpPGL91d9xe/chXMrQdTFrHGfrMj+xwJ/mON
         Pr9w==
X-Forwarded-Encrypted: i=1; AJvYcCXvSvm6IWjRFvwosjxuIqquSREyTVYR30opG9zeY158MMw1wZCvMpmPefqEEcr2WVWLFvrOtiGV4yVxvOg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzujyRmWx9WD/N/JohvByy10aNhyoCONn/T33So8alTgCILgDvu
	/5vVjZGm7hFeBAL6eyPpItG0P2XLhVSrReHMUGKBYxw9dDoHX7OKE1w2WQ==
X-Gm-Gg: ASbGncvDQwuuXcUclyxptp8N0b0XqFaMQZ6mGiFGWT3X4cv24sF+JHW3UjnDIaRzeu8
	8/hrrO7jFydUwMz1DpTupXcXvd6ByaxSWd9QI+izf2RVgmgFs2hZJ5NDRgyQ+MNdVNpoX8yf9ZT
	aLAHvjE/LtfIWv1LQ0DaANOhwac6S6ZoasiUP7libHDHsJohhuks5wcjG9XSSJM99YVB6AW+fZw
	nWKgkEC/xvQg51reB4D4gikRr/e91BRgf0b7r3RnK2Cls1yxA3QsUUQVR9V+TPXczZ29XgVbbn4
	gnm+5G6UpXRBr7tOXzVhh2qGwcUgxWd2tq6teG0hIRWgBNlHZAnj9KKqfXmaL6XbMhxSHxIkLye
	gbMCJDer0qZ7R9WqP0P8SXEcSog==
X-Google-Smtp-Source: AGHT+IEPNyvK1qzZQT1PQVIE4V/dBFmEiSDVJxXNxZcfBHVg4dNirMlnQaivrFWbzE9zwB93acq53A==
X-Received: by 2002:a05:6a00:14c6:b0:736:2a73:6756 with SMTP id d2e1a72fcca58-73ff73eed7fmr13322237b3a.21.1745861893819;
        Mon, 28 Apr 2025 10:38:13 -0700 (PDT)
Received: from carrot.. (i223-218-150-204.s42.a014.ap.plala.or.jp. [223.218.150.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6ab27sm8314939b3a.110.2025.04.28.10.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 10:38:13 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 0/2] nilfs2: improve sanity checks in dirty state propagation
Date: Tue, 29 Apr 2025 02:37:06 +0900
Message-ID: <20250428173808.6452-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew, please queue this series for the next merge cycle.

This fixes one missed check for block mapping anomalies and one improper
return of an error code during a preparation step for log writing,
thereby improving checking for filesystem corruption on writeback.

Thanks,
Ryusuke Konishi

Ryusuke Konishi (1):
  nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()

Wentao Liang (1):
  nilfs2: Add pointer check for nilfs_direct_propagate()

 fs/nilfs2/btree.c  | 4 +++-
 fs/nilfs2/direct.c | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.43.0

