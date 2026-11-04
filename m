Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753735;
	b=HP9vN5N25bNW7rNwwshp6W6zmoN3ZH2xYkKQCEgLrGdoPSAZiBtiaS3nbFzW1WQDutCU
	 /aw+EyOUljrdQ9/jZJwhlrOqm8vWcUaEklVped/t24XcbPFJElRX12yPo3FuknMEnUNSk
	 8eoknC3WSdxX1ln61o5r3pQfcqN00Gw8l+ePAMYxJeAkhCuRm3v7dGsRgC6bVPirxlevW
	 H5DoZm8I9ag6nbY6DlsyV4K0Dm5hrNrn/GLVAsda8opAxkg3zdr/6CCowvOqIRn0QvUmQ
	 8YCJQUh+yoPA4coZGQd40B8BjBb3zcd5265CsnksHSRA36fywhyeicITRRDvii25BPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753735;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
	b=P/pBYecSFfpcgoTz6TX1ZPDdtUgVmNUWygs5djsieH1KCMj33EYLXbVtksWLOCd/7CpA
	 u3QzzD+JJNviSpPKNswBSoFJuiNXqkIQq4W0cHKvlyQWcjUL4ud/m86E6/p6rmdi+TNp6
	 aXxPX+j71/frCvJog4ynEAVDVaHQX/IGu27JvF1u90Ig2xS79nEBaWSK4GpmEpdMqEAtT
	 /qfxXZ1rKRPpsMYl0qIrOmabbKSYdFZ+WRQHcARyOLM+k+JKfbIgE4s59CTxhckLSldBx
	 z6haK2b1Hc9OsJCXWh5/eQgbZHhF0u7Eh0qWYj/tMQpCdZljgMtlbaRTfbg+bCSKD1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sudo5wuz;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88833606A337
	for <linux-nilfs@vger.kernel.org>; Wed,  4 Nov 2026 00:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88833606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sudo5wuz
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3ac7842c17dso153318a91.3
        for <linux-nilfs@vger.kernel.org>; Tue, 03 Nov 2026 16:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753734; x=1794358534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=sudo5wuzf8me28sIhbntLBwUiKNWuwSV6wtIncQpUBbsN4Zu1yMj1uOdtNMULS+qse
         p10GSTbsQZQej+RmcaRVIPfYXpiJc7DVP332tBPCeYi6iIxYHtw/pCGnwu6pUZaiYkuu
         1jzqj0fIApJI24vXlIZRW+4LFyo/2rv7mV5cIr8Gch74DjfIbhBYVLv8/dyYnqAxTrWw
         7/Kxsv4asQfbrP6PWPBOlk/xWVzyI0hLDQrJy+RjayW+oFANYAqhfVZpq60HUf6srI5f
         LvFF0LRAtEUesVRTlzKq8hIDxyh050q8ogJnunYhdFI0Mss29VGLQmid0PHrrP/vhgJw
         FudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753734; x=1794358534;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=uQiiMgQajUz65hxz4O//JlVXzJkvoz5F0uUL4rkl1pMjO1/9q/+kY57taHDbJkSf7r
         UmxbyJbadWWnRM/IS4SCTq4pX8ZJBZu9HnwAJlIcv9H9RTdjofUsHPQwjgpmbbq1H5um
         HpWfb+rZL9L2AfDMrmTTXNnElkAQ+CNlsrcKxnZD3lD2SBHquy9e1Rq7o5H4wfxgdRln
         +MrdmODwy7mlyf8kyk0o5uFw8ZJ6CmSAgNPc3Y2Kz2S73170Iq4rhJ3Zmu7Ymf0Xbeaw
         omsHI85iu/LdKyLrAQhRsnCaxpE8HneKtjAW16scu8JX3MoQbsVwAyh/x7DmizvKfVSe
         Fzpg==
X-Forwarded-Encrypted: i=1; AKwUvByjZGg3kOlLJqXWYV3pgvKuQfXC/OZch2cWbvK//IgwEIXrjrfZFWQLNB/wZ+WCFkYsjg8xUVsz1A/zlw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/0JmoqrD8Fl7er6JeS1QXiIZu3Nl3lZGcWArGcV48qf56rFCnC
	TNQ53rL+Oj/PnB55sO5mDIwW7rWCiNm4mSemLKxgmb5b7dKy/KnD5bAE
X-Gm-Gg: AYBFou284PZ7O4rLY+R/M6qqW872hFTNZhUjMLV/r4Fb5lhU9aHeavT68RU+POPkDpo
	BvMM4eXOOe638yxp8UT6aboinxtsaIKyV2Juhr2kyxHixa9iyj0B9nOUIAR2h3Ytuhn8mDtP/Xy
	UndwBHSfTWAM48e0C6p81hrAjbvhHIvj+iy8ruktZchesrDo8t/JawXrKKNzhXSODZtbHKPdC+O
	K5m3/rSApMmaslI+Ri+DZLbjorllyQQ+4onNbEKR0d0jBjQcATS1bcYqkThWFesCf+4TY0HFok4
	SzVpVoe3cBQobH+Kfxu+arHjs8P5ocpwCycnEAncYHqily1q1f+jBFS8Nx1Nuc8TxHidPaby/4L
	cUdgQ155lT3Br+kYkmku89XUCxuX1BHN5OIKy4ISDq9rzwDOmDXY8wxa2L0dwZWwSAgkf5xsTeX
	6HZPZ+nf0ewQD/LFxlEXngXoFnHn70x/pQN7CPmyI1RoYD6Qs4A6Gcbg1r9iHv1IJNSPS5fVBQ5
	/lUilhbL1ePyJ8/8Nv2jO2mCisOfbwAj3JOdcqOkJXGkmL+ZSZzRU/6U1GitcBcV8Yjad1jmMJe
	uG+t4R4vf/3Bb23pIQ==
X-Received: by 2002:a17:90b:184f:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3ae897e06efmr11479861a91.64.1793753733906;
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm1222403a91.5.2026.11.03.16.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Date: Wed, 4 Nov 2026 09:55:30 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 18/34] ntfs: use the generic emergency read-only state
Message-ID: <auqCgguXEsKCq9p2@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:09PM +0100, Christian Brauner wrote:
> Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
> an error makes the volume read-only. ntfs_emergency_state() keeps
> telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
> its callers stay as they are. /proc/mounts shows the volume read-only
> again.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
