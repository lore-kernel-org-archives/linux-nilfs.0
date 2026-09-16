Received: from mail-vs2-f42.google.com (mail-vs2-f42.google.com [74.125.227.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAE0472521
	for <linux-nilfs@vger.kernel.org>; Wed, 16 Sep 2026 23:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602379; cv=none; b=iwEFyXFAsiEMjXNWG9YTdfvxqsO4CZePfHHOOzZiAAYtNiYF9Om0e0geMgO0ZLnvjJXa/d7qUWx8ZmRJTNMZS9fDHMbgGcoRHa9hVYtlHsQCeG5/xTg5B3xc/Yaky9oUsUCHdcIbmi0xsPhtTnqwtPEI2LU3lgREq61NX0DAA6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602379; c=relaxed/simple;
	bh=2OhXfXlxGIDEVphsIawGeDZhndr5+3TI4gbyGiqZyB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9edVh/GIQJqSJuKpjwqV0dUUuhi9rB28T2n2dtehRdQR2oFP45sja51Ubuai3q63ubvfpM1V9RIdD6/7vt4a2V0ln4MG+hpWf+/kwoGw/7V8NcTWXSZw+bZVNgOwqTrvyiL4rL5QyljBXngT3l+glYggne/Kg57epbFn6aEat4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nzB2R6ok; arc=none smtp.client-ip=74.125.227.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nzB2R6ok"
Received: by mail-vs2-f42.google.com with SMTP id ada2fe7eead31-798396c2ec0so154158137.2
        for <linux-nilfs@vger.kernel.org>; Wed, 16 Sep 2026 16:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789602377; x=1790207177; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dpu5ToiMC1D2AynV1iB9BM+jRcYbmOZxbF1W5LEpeiA=;
        b=nzB2R6okEg/3UkWKspZXxmAVwp7nomGIODrdPUp/09TW93TnR/nHATXuQWcZe9VsEH
         rSXvDZtvLqYSSg8vUhGZA4a1i/3K/7vA9YaFicYtBbwT11bnvtIcyJPYTgJ0heTukpm1
         5q0f0195QnpEgCL4d7sCstNwGtik95kc/afjm+9F8iGmKpFV5uW3EDLff9rBvnmHJQl/
         pf0o/SFxqor8GCbCE8ffZqSuL1sa59x8SV1uW5fRUIfQEKfm3Kl1lZfqTakzFSyitDus
         3RKggRPNy+nvqS67ebzQqo1kCCOjIS111XIuZUyItS6H04DMPyRKDXKGWCi85vae0zIo
         djPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789602377; x=1790207177;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dpu5ToiMC1D2AynV1iB9BM+jRcYbmOZxbF1W5LEpeiA=;
        b=cHX6D8xBiMM0adiP0nstGJIpRsxHJFKIJOyhiisQFEQWIQ1EfmgP+UG/1kdYockPml
         Lf8yaXDw11a0th+JS7tN+eyPACPXJ371gjUQRHuh9U4UWuPwbltruP5ZGIYgDHPFy4H1
         ZCntf3iAxYppe/INks3G7xrAZaGs80BDyizeBluTSFhMWxb7QWxiNm+anyXhX2x0ErVE
         yzdYuhGIvTQ4tGOn3YqqILRfJcqRe+LdNic/k2ualsVjvcgxkkUIhJz0ARuzVn22Nrr+
         qfN/CSCFvmXu6KcuWRzv07eNV8wDEgh35TOzYytG+JaH/hGIUBNFMiZ3hy3cPj8wQqlO
         Rg1A==
X-Gm-Message-State: AFuF++kHpjl8mP2gE5OdgzCidoAXKqOW8pqFzCFXUTKeDZ4ygUqQSO+B
	TDKoNp5SGfXL3j8JjvR7wa2gLBm7bObk4MuAXrYxAJO6Xzbpf4g39VlP
X-Gm-Gg: AYBFou0ehWeRWEQVgpZuVrTmnUxbx1OlN1elRmthnM/KrFSHnMlqrUecOSy0OJEHtva
	bP/RjaLYa6RVG4Xe4FZn9/KW2B6WPosXXTjxZpfec/MHN03ZZlPVg4cSQ+wdiq6oQz7NUlJ0ZoJ
	L9JpreE53heswt5IFf7zyYTFXzcrLbfv8uhztlVqtBBFcN9JpYr4FYBZUkbABza8QNy9TlITxKQ
	ECpvr/nUIdaRxwdhu2/zzi+Tyy2XNzIbMNVSUwPHYVi+XFfo+o3BEI1rFME78T1oGf83NJJ/l09
	ADvOGMYgj8emsDBYjzAUbfYc4KnY/55trVzG67UAST+JC2bPogeoaFVu7Le/VUR5cGkYRHgJsMM
	iQtvKrqb0C0zlxi4ZvVRkgv8A8/WVlldFtX6xhEz+yIqHLzZJLcvjuNj61M4e36loEidgY05dlY
	oJNsfz2o/+ffv3DSg81eNySRB+V+zD70Ya8ZHRq4NcYRuviT6P4+NVnhy+u26yMZh4
X-Received: by 2002:a05:6102:5344:b0:7a1:f7c3:3a41 with SMTP id ada2fe7eead31-7a1f7c33f3amr1280846137.14.1789602376909;
        Wed, 16 Sep 2026 16:46:16 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7a1e314e925sm1533528137.9.2026.09.16.16.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 16:46:16 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: Re: [PATCH] nilfs2: fix checkpoint root lifetime on sysfs errors
Date: Wed, 16 Sep 2026 20:45:48 -0300
Message-ID: <20260916234548.376973-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915041206.2430937-1-qwe.aldo@gmail.com>
References: <20260915041206.2430937-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Slava,

Good point about the wait_for_completion under the lock.  There is no
circular dependency (the release callback only calls complete() without
taking ns_cptree_lock), but holding the mutex during an unbounded wait
is unnecessary.  In v3 I move wait_for_completion() and kfree() after
the mutex_unlock() in nilfs_put_root().  By that point rb_erase() has
already removed the root from the tree and the refcount is zero, so no
concurrent lookup can find it and no other put can race.

Regarding rwsem: the kernel does not provide a combined
refcount_dec_and_rwsem_lock() helper, so nilfs_put_root() would need
the two-stage refcount_dec_not_one() / down_write() /
refcount_dec_and_test() pattern.  That is doable, but the lookup
contention on ns_cptree is minimal (mount, segctor, recovery), so the
added complexity does not seem justified here.

v3 follows.

Aldo
