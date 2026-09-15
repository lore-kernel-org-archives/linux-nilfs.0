Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C744508EB
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 19:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501919; cv=none; b=sHGNrERPsOxQ15veEx4NueYjsqw+XUzutAi4qFHhx6EJQjawyMYTfmus3vr5PWlJGR4dWZQFOwSfptZy/hZYKlD9ezBcUj+JLiirfrfqGAYeJEUjcO3CW/DDXLQipS5lcDE6hYvqPL8ZPfAMwnNnWSGt1DJZeKaN1nDpnptthAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501919; c=relaxed/simple;
	bh=bKVl5EPxdtpk2JfngniCgZ1c/53BvJXdrA/23hblqTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lI4NYffEVbOgkYSD8OgtHIo4lPn7Frrr484WA2+35SF9XsplyV9nxbB6XJWnMpk8RF6HaFKguOTCV/GcQODdWVE3bcOZM2pefBU1VJlzqXrFdlsvKYT1NVZgPAbqL3LJs0J19aw5dcxTuLBY5Scuu12yFOEBaxLwNobmSOQsClw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EmOnCern; arc=none smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EmOnCern"
Received: by mail-vs2-f12.google.com with SMTP id 71dfb90a1353d-5c67e5292fdso48062e0c.3
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 12:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789501917; x=1790106717; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bKVl5EPxdtpk2JfngniCgZ1c/53BvJXdrA/23hblqTU=;
        b=EmOnCernvjuloBz9pl+YCk+s8O+IcFX1DXmV2IYgYK5Z1i7TohuVUeGAwO2MiSlYnp
         fLQBx5wsJ5BbMI/8f9YFg1dXfaP2Y3tpYpwgxaSGLmUiNkIaTI+XJDadReFjIf6EgZc7
         73rsbQtoOMK/jdRVLjfzhJoX83N4ZbHtDQcGFItjWGr8S288c/oj77w/h89Z3BKMC2A7
         JU+siw+8vBw1i3uXxnX2YdFqBP51nOZL3MZsnprRlr944MIehv+odD2fYac5rlDOIoqC
         BdVpBZf5NbSNEL7YGqyC7BYnYlQHiqUdxzNv9+fNWPys6LQK0sjpnLhRrk3r0t1YvO5p
         lr8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789501917; x=1790106717;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bKVl5EPxdtpk2JfngniCgZ1c/53BvJXdrA/23hblqTU=;
        b=bACINctNx6rP8UD/8CLI1s59gwC/dg9ImplQ1cdeQ1kBl8aL2PL8fpDBPCVORxsQTJ
         LlJOEO2PgesfYkTDMxcKc/9so69wfNyuE6xv/HR+4bjDyhkJRlz9rtW/yirrBvUsgHiz
         6EqsJQEGmuRp22WWdMKBieemRBW3sKzyX2Pb4XqlWFyDpJ5zIvnbHaaOL/rN+eK3ixpp
         5iTwscTyWGU/eytCtxKz6s9gtLfPHZZPQTveduGz59OCS13J3LsRAWG9lAQPdEdz1JZQ
         ijabKY4iVyaOrxO8U+/lSd3TzWdcLRuK0SfTzWJy11vNDLc5LZTZDblCvkpumIhoGzPt
         PBUQ==
X-Gm-Message-State: AFuF++mCTt6yIr67y+nmuPhs1G2f957DOhUhy0r0MNbIMVdS4kR6Emnr
	QYsZXmlx0jj1WQo+ZVFza/7unKW0iE1AvMm/z0gNwIRDkORf4CX3dXiO
X-Gm-Gg: AYBFou30nxPTB1xNrPhUTMS7h3ouAGds3+gmsYz3AwAZBmzpV/hl2j+eTTHTmNYHp+D
	5YTwJw348sC4M14fd0mETGnxPxcWYP6qaRi484ZNqLd6SxbdotO+DQF4zSDGe446j5ylmCSiC+R
	YPzj2FkIWBa8/C3Jk4D3vCD+akVpzU2lLnMSxeeI++4/BX3reI22sOsdO4Rj0wk8qRRcq87Up5/
	6YNwCl8SH+Kpt7TrZmSR0a8Eubh/a6A0ur24cbxExdS8gO0AQE/kOcS+rEwD6RKdhdZ3yoYTbHO
	4JqJZFXYypBa0VKGAUPkFX+WE96NTHhoEedBnJ1TegyXknAFdkmYmku0y2thH8mEOYS7HNfnZ0t
	K1t/7y0UBB3j8AGl5dJrm0VV7T9ycboZkZAuO6NEAtSxzZ/Hx1jy1I28QShRw2y0dhBe/jL7wIk
	e86/hGqT6rSkfTvpZhcZlhm2eY9gXF/bDwEfe33RLuK5Bpl7tolvYVKAVRT8yhpFqI
X-Received: by 2002:a05:6122:8d5:b0:5bd:b2e1:e1f5 with SMTP id 71dfb90a1353d-5c981a8a2f5mr5665227e0c.2.1789501916850;
        Tue, 15 Sep 2026 12:51:56 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c998a65a83sm564826e0c.10.2026.09.15.12.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 12:51:56 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: Re: [PATCH] nilfs2: validate segment number in nilfs_sufile_get_suinfo()
Date: Tue, 15 Sep 2026 16:51:38 -0300
Message-ID: <20260915195138.3331490-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <MSG-ID-sufile-v1>
References: <MSG-ID-sufile-v1>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Slava,

Good catch, no need for a separate variable. I'll reuse nsegs in v2.

Aldo
