Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B3D33EB0B
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Dec 2025 18:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167607; cv=none; b=DggstleBTSaJajfGBMsLwZ75DcBcxymUg3NxG+jBnyXj60EbVM6tq92SjsDQk98KaLemvbOzw8fhKXCOlKfWDE4xomqDgMt2uya8YvtXMnGaXI8aAm1LWbYpbsrZ9ecuXgmm6dboKGRDvcuRutARP9sbWGGwtIfb5L03Um+bM8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167607; c=relaxed/simple;
	bh=6lZg6ilh6tUAkEyDhY8aXtPT8xREk772+NnaNRBlPPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBXF0+nzVH1wM9C0AMFzHcXUVICu0yPdWYSnUf56CFGqS2rOJPNo1vayCr8vZIzbx6UsTLbwadb0srV1lN2Se1qip83NuIKCA4e64AoPDOdK0iVTCxTTURqjbY5gWQhX7wVhTV9aAurRXqj5d0wGMsag3Uny/szv1BPv4qKJ6dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EOfJN76/; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EOfJN76/"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34c93e0269cso1623485a91.1
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Dec 2025 10:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766167604; x=1766772404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LC3SzuQK4lQaWagpwzAMXcp9OAihVv8YS7EU8JQc+pw=;
        b=EOfJN76/GMd/L7mPs3y2Z7PoEoDsRLyJdnVV2nnTDNDzQ4H3uiu8OzVSlVLMZeuUjY
         WC8/TxCPFW+IkCLkRWfa24rKl35WApyStYFOsD6Mc3+drZtMQiD/0SZvSNEoSKLWFL5O
         /ox4963T7WmX/jJqR/lRlCwFvp8/5IVgLq3BqJo33vx+exB32mx6tBMNc2Q3CL53PdyF
         V63yhukOpyZ7xi603pOJoTj2JIokUpHTcH+gJ49GFe4filbIVUYf+JdwPLerIyE9bP8+
         O+ZbgDRUPZT9moOmJe+pUFlZ9/k3A5W0FFkRDkdAiz0VBCk/ElUfB1W1dEs2DD8Rxvn8
         Ep1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766167604; x=1766772404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LC3SzuQK4lQaWagpwzAMXcp9OAihVv8YS7EU8JQc+pw=;
        b=GOEmP2230C4EM0/82PdpSn0v8WRgW+lNGjiWGjOmXvRR+Q9l1GAZbhGhoxQKZZx3J0
         /uceTVoK+TmvpfNRCHV3ZtZJ1EKwt6bTaddN4Ivn+jQlzbqoSV8AMZ3usryrew1V0yzW
         0chJsaPcMjmINqSHyPxMHB/LLdrZe+ZmXw5/zK5kRFEmUG5qvrGI4pX3CbazxXexDhxo
         o0lai2GKjWMDnrngRqGrE0IhsbTKKGO/tillOVHBh3UFW8N1XpNdweYQegdDEeZ+p339
         BtmoRpsPpmUc8oKFw+heI2XKBNDk6PFfSOf0pLv6fjKU++yOqCEhYBw8QvO/LhDul+8/
         RhMw==
X-Gm-Message-State: AOJu0Yyxd1rPh3D53RRgmWCNwFTam9tuqWt8LAwt/b//2sugc4j8shKT
	KQXKltBI1X2lpOA2J/FZIuyuFYmHOUY5aKgbzbp1fZa8rjXp3WaQ/yXe
X-Gm-Gg: AY/fxX6ahj4Mlk+zWaoaWWloT4cDmDMn44jmd20nEh27ECQ9cgFfA91IVNqTDmNsJbH
	OX+b/tZf+Mae94D/zIvhHN3gchAIznToNXhe6ffviWqtJxBZzznOzdovHyI8KWgFwZBImrtaLu5
	3yPXuzQbqeexJPW0okwY4f2lwZoPKGvZMZw60oDg2UXy8Y4jZz1/dfKOZWCLXvGMqw7jhtqeFDB
	1bqyGPBNPqLgs+tZEsQGCBam4Q9Gs7VFT+pOs+ms3vSQga+yKqacjg43sEo9G8rklinqIZoJnFK
	bk2r1mCjUM+ZmJ2DDWHtOpKifhskEmb+hS1a3+jDLIYt22DvC+pKQzyv6rWzuJMh9kWwvMBGWEV
	BWcUmQtw9E99wpNfHXgQ8a9xORbIIXK2FtYYlzhIQgyJSR+4P2Xi7LsqfSR7PAxzXn8zXrSQ+nX
	JxYSBWFBsiIwoba2tttJLi0C2udYhTsYlfhghnrD//qawrvIPExaKk9beqb+XsLWJ3Rdxr0BEtU
	joqOtjzXw==
X-Google-Smtp-Source: AGHT+IGrBkGdp0AGHooV/VY4XJYreOLG+FwblAbF4EIFCRaneMj0/aBVxLoryVEqlan0xNesarhTHg==
X-Received: by 2002:a17:90b:4a43:b0:34c:2f01:2262 with SMTP id 98e67ed59e1d1-34e71d6961amr6032809a91.3.1766167603465;
        Fri, 19 Dec 2025 10:06:43 -0800 (PST)
Received: from carrot.devel.local (i114-180-53-102.s42.a014.ap.plala.or.jp. [114.180.53.102])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7961c130sm2688468a12.3.2025.12.19.10.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 10:06:42 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] nilfs2: fix missing struct keywords in nilfs2_api.h kernel-doc
Date: Sat, 20 Dec 2025 03:04:27 +0900
Message-ID: <20251219180631.27554-4-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219180631.27554-1-konishi.ryusuke@gmail.com>
References: <20251219180631.27554-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eliminate the following kernel-doc warnings in nilfs2_api.h:

Warning: include/uapi/linux/nilfs2_api.h:65 cannot understand function
 prototype: 'struct nilfs_suinfo'
Warning: include/uapi/linux/nilfs2_api.h:101 cannot understand function
 prototype: 'struct nilfs_suinfo_update'

This ensures that the documentation for nilfs_suinfo and
nilfs_suinfo_update is correctly parsed and generated by adding the
missing 'struct' keyword to their kernel-doc comments.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 include/uapi/linux/nilfs2_api.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nilfs2_api.h b/include/uapi/linux/nilfs2_api.h
index 8b9b89104f3d..d1b6fcde2fb8 100644
--- a/include/uapi/linux/nilfs2_api.h
+++ b/include/uapi/linux/nilfs2_api.h
@@ -58,7 +58,7 @@ NILFS_CPINFO_FNS(INVALID, invalid)
 NILFS_CPINFO_FNS(MINOR, minor)
 
 /**
- * nilfs_suinfo - segment usage information
+ * struct nilfs_suinfo - segment usage information
  * @sui_lastmod: timestamp of last modification
  * @sui_nblocks: number of written blocks in segment
  * @sui_flags: segment usage flags
@@ -93,7 +93,7 @@ static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
 }
 
 /**
- * nilfs_suinfo_update - segment usage information update
+ * struct nilfs_suinfo_update - segment usage information update
  * @sup_segnum: segment number
  * @sup_flags: flags for which fields are active in sup_sui
  * @sup_reserved: reserved necessary for alignment
-- 
2.43.0

