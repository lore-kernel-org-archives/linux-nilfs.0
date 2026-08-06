Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CC129B776
	for <linux-nilfs@vger.kernel.org>; Thu,  6 Aug 2026 12:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786021132; cv=none; b=pYCSS/WutvqOGznu5nQ42/rQBCeHcYgYW810kJAIzbgGrzNmiR13439qutBf/CJOLOnu+tQDNZZPUSf1LluZiidGbu2oi5xrlTQYIa+2hQxNzUCx0mRmx3iI+Kq0B0BGRAbkrbU7kAWXcfmYgyztprmQ3f4ESAF583LwOJJM53w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786021132; c=relaxed/simple;
	bh=i2fEoTnSV8ZDM8Uzo4OGxA5JrURXbkh7eqiwrniLlYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mc4F4/OQxzqy8LYF3323TIlLL6NWFRQVxxPutNYW2AFOHW7K06gmPBn89N6yma6Xr4g2oy70ZJOdGWgnR1R1tWsccmKOUHaLIWGccwzh8Ors+f0a1Onyoi2yfCZIMNmskJEaNL/jMPufjbhXQXUrk0Dlbc7LiQstsBZF+IJkcZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E93tWxLp; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E93tWxLp"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38deea72eebso1825913a91.1
        for <linux-nilfs@vger.kernel.org>; Thu, 06 Aug 2026 05:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786021130; x=1786625930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v0NcKBO/5GvUdRnzqAbWSDaYYg4LEVhlHT+OIMo4nlk=;
        b=E93tWxLpnKV58LQ570EQ+2m3mfIoEWtk0/PJ1wmOyRI6vfsg7t+JEAlGzDLxMSl9ma
         dqItMtc4NYyAnGqLycAkdS9fA4P1puFP0xH6aIKlEeAy7zP1a70eWKVL6v6e/7d3L06u
         QyMqUazHGfoEGN6Dpb/6DKu6HbWkj6nE6kEyYAlye8xI+MvDZQU9mpOh6s4jJBzkZof/
         IBW80CLtfGlxLeNsWhuPbMcDpeecow8qr//JLWC3QgmTI8x7OcEkMDzDJrd6Zshylqis
         sxwlA9jqajpdAj1AQadhDUGQSY4VrWDOzgsF/K3nMy5sA7aijUxDjsQQiUCpZ5HQyUty
         r2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786021130; x=1786625930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v0NcKBO/5GvUdRnzqAbWSDaYYg4LEVhlHT+OIMo4nlk=;
        b=YMXTY0TOoU85UpGjMq3C49oILGw5rNBOv/Zkkh3a91yr8LDDw95rmK7ocl6w2E2ac9
         jbWfRJG4P3b9+gyLi+HCKTsaJfuqVi2CR2eQvHysAYtj8evrO9Zr1qYWzMP/VorYLZlu
         owFJkj7JMzzAutiYBNOzqKCdD9LZiQ6dAdwsB2eXa/x3aYhRPsZ1r/MCW6pYYoeL/oVL
         Mt/FH5NQUj3HtERliDmD2G4bOCeSoLAcmj6twPmklVm3f6CPx61zAemyeRdB9E9cntNm
         KSjSkNUN6qeH3pACcB4KBw2d1Eg/RlyUoKuTBUZSTt7BRHJc2P3R7h+C6070NthDXR2D
         27XA==
X-Forwarded-Encrypted: i=1; AHgh+Ro2YNYnKQgscLxfZY+TTvkAz3HsI+dP7vQul74Yb8tpEk1pw0Bbjq8sooibo0J4D34sJXCvR3Xh5mObmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzgWwrXJJe3U9JnOkC0Bt0EYdNInIlhHGMjEZznyQLk1dvr6hqh
	MIEITTUqHExkDVd3znm3On/tJaNugvUfQCCYF1v6bEIzx4GCbF4xCjR+
X-Gm-Gg: AR+sD11Rj0p8N3aD03EEsIRRtG6ZDhtk1o2GG3DtB73hZX+e0SRcpoIBMOOMrvNcf5k
	zliI9wDvYAwo+B9iyWumvr3yRPRb5WCex9kv+q0mytLapY2oY9Y293+qKwiw9w0j4dHbVhisOAA
	RRRqHSJArnA8XKeUUHDWxVfaX86SgMqwEQr8S1waMOEh+cHKjl9gIkANSQXpRlUqVq4P98n/ujO
	/N8DwiuRt5s3zpxLrJdW5rt+SpvsQjXqJ6fwtVxME2Zk5QVFzkoTauWvhcpViQZZGI1WII0/O9e
	6ezfW4UQldA3tqzH4yDb98DEkZmEl/OpYIx/hP0rcuMxqRIHjGpxj6CdWL1/9Gm5Cp5xXQjyYoj
	9bwZLTyoh6QjXqtoKwa6kKG5HdbitrNHEL49fSDOnYc1DvaIZ6UIfxYMiZgHqFZXqK8JlCn7vtO
	KP6tSW95aVp0OmzGFmIHXRQ2V+Y/HeU4x2SFYcalPceQwAppigXh4wM/o3VhktMsac2svlb7xV
X-Received: by 2002:a17:90b:3944:b0:38e:2517:5d1f with SMTP id 98e67ed59e1d1-3903c58f3cdmr16356903a91.9.1786021129923;
        Thu, 06 Aug 2026 05:58:49 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3903d2f9a9fsm2804951a91.1.2026.08.06.05.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:58:48 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	syzbot+5957361606d7b750b874@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] nilfs2: suppress false positive WARN_ONs for sufile after an FS error
Date: Thu,  6 Aug 2026 20:58:39 +0800
Message-ID: <20260806125841.966577-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806090311.32633-1-konishi.ryusuke@gmail.com>
References: <20260806090311.32633-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu,  6 Aug 2026 18:02:00 +0900 Ryusuke Konishi wrote:
> +#define nilfs_sufile_warn_on_error(sufile, err)		\
> +	({						\
> +		int _err = (err);			\
> +							\
> +		if (unlikely(_err))			\
> +			_err = WARN_ONCE(!sb_rdonly((sufile)->i_sb),	\
> +				"unexpected sufile error %d\n", _err) ? \
> +				-EIO : -EROFS;		\
> +		unlikely(_err);				\
> +	})

The warning-suppression itself looks right to me: WARN_ONCE(!sb_rdonly)
only fires when the fs has not degraded to read-only, so the false
positives from the log writer go away.

But I think the value the macro evaluates to is not what the kernel-doc
above describes. The last statement is unlikely(_err), and unlikely(x)
expands to __builtin_expect(!!(x), 0), so the statement expression
evaluates to !!(_err), i.e. 0 or 1, not _err.  So the macro returns:

	err == 0        -> 0
	not read-only   -> 1   (documented as -EIO)
	read-only       -> 1   (documented as -EROFS)

For the WARN_ON() replacements that discard the return value this does
not matter.  But nilfs_segctor_truncate_segments() consumes it as an
error code:

	ret = nilfs_sufile_warn_on_error(
		sufile, nilfs_sufile_free(sufile, segbuf->sb_nextnum));
	if (ret && err != -EROFS)
		err = ret;
	...
	return err;

so it stores 1 rather than -EIO/-EROFS, nilfs_segctor_collect() then
returns 1, and the "err != -EROFS" preference cannot distinguish the two
codes.  That seems to contradict both the kernel-doc and the intent to
"return the error code appropriately".

Wouldn't ending the macro with plain

		_err;

do what's intended?  The branch hint is already provided by the
if (unlikely(_err)) above.

Thanks,
Zhan Xusheng
