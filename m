Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09CD36605D
	for <linux-nilfs@vger.kernel.org>; Wed, 25 Feb 2026 22:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772059968; cv=none; b=AIsu+r+uXtDxNaq2rf5CwlnQjAsDbbmVamiOIMGzzGNo4uz6Cz3IbYhAhCeGxcDMs4bitwSZ45JPX2bi4zfX/UhUMlfxtHP9xlN/kcMCytbTNl/hxGg8BHXxTK4qrewqAR2St+gJsV/DzATz/PsjbK5/Gmeg58f6KfWefqVJdYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772059968; c=relaxed/simple;
	bh=wl1g8RbugLIpEDcyc9u4uEv7Y6gAeD6SXR7a/OTVtKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GiucQYI3GtshiXcovydrOYS5juOTjNSVAyy9ESMBC5B/PyWRXjwnCC3T+Rg48qyLsyykpVPip+Pkcb4Umf4nB3y1AiR4PU9U+Dzi0xY/dkEHuJNQXWTsqJy7sW3tD9NPXkjosUifMSBQACLhBepXVbC0ULnJLxJnjzXB3AJrTSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PyyFmDLL; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PyyFmDLL"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cb3e22435fso119030085a.1
        for <linux-nilfs@vger.kernel.org>; Wed, 25 Feb 2026 14:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772059965; x=1772664765; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lV5yfIvdQy795zXZiEFYEcuoFYVuQqyybCf8AopsVu4=;
        b=PyyFmDLLmfYGeUoSFdMNaKcxPIYfVWRyKHkjYN1AOMLfJjBkgVhelDmRwyaNkrvaxg
         X5Tftjj54JW4LcXOOXe4ydWQtvSCDKkti7pwobNJNqGWVbwR246lnWp+1JHxeo1tjB+a
         Hfk0M4D/g4q4BNiHWI5+bTzgsK1JbXr8ybVVN2/vHfSAS3Z/gQbr05x5T2/lVGC2i1So
         EZ4zGAfHl/MWl/pRUsJlMLdane92z65ltzx7z6EjBl19O2KKF1ET1wWtHNM6CzfgZq9P
         gC0XxK9lsby6dwIlS2aE1ykYeVebLuNb70ieBpLFHaIhDNod4Adz0pvZJp9vGncw5CKJ
         49ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059965; x=1772664765;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lV5yfIvdQy795zXZiEFYEcuoFYVuQqyybCf8AopsVu4=;
        b=U7xjf2ir1DjWv5aK7oKrvo/0mugFgJzefUyxvfxnk6BJY1v71YnNOpsG+yTbRtjLEY
         uKv/iByXJ6XcVmU5HRTNGzp5rrWXFEA/sDUsLu7UyRnynetfePRmlblZo6Exfcc2cVrT
         Ky+wepr6grfFpvCbrlF5KS0TNGt4iD3pgkbEb5pLAJpDUYOZazxKBlorUOBCSfQ4+SBR
         ZutZ6xSu/nRqGHVXbBKXzoCAEUJl5b9UFWaPxojVoLlkzqfVBG1H5/bLYkkd0077DoZT
         qyZDYJZjOP5e/Wn6cCYvlmvSDxFBXNGDFOwJxfZ/TpnyQtc4Z4M+DlzG0Auk0WW1/TQD
         taZg==
X-Forwarded-Encrypted: i=1; AJvYcCVHL8n5PDcQ4QaG+qKBqveWXisrRE+9q/DA5gBFc9MCeby9thvNshxabL/W1dEDvIDN2Xs1wsdpxSrbAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YytOWOMecDtNS8Cv7UQHXONdfHFsn0Se6DQSeSekh0YDIJJ9Ghx
	U3aiwm0jSv8T5UOO7siDwhhnPpe1UJAUtDsToogter50pvpJZEbNbfOphGH4D+epppc=
X-Gm-Gg: ATEYQzzZh7zjdj7ySvH3gQmAu09VYxzDmwrHXGMvjZZ8rA9Yz4jB5pXZitBBQrJuZei
	etW3uY6Lmi+Oa3ra01UPukeiqDuqauNg/jEn9m2XY6EmXZ5dq4eKKBRojrz96TF9xxj9SrkYB0I
	xdgJng5n5pjE7yOVVib/rL31jonRxRjqFCA282wCRc4TiK0spZHkFoPvMcns4jpD1ItfF318pTR
	sCiIlIxodmxgE6I7NMHnb0Bk6XJyH4YKEN/Yyadgv3aj0ulpna4YOlB9qW3I4sfxTX+5Hg1J9N1
	zwLhMCyjtYw3fdjnRn/Od5gZ+6ynOugPXsrp1sBMLuAxNs4jNsotPHjL1ErNqZfPIWnv+NQ+kSZ
	LIw09Sg7hTKcMyxey782QAkoyEN/vfZgkvOygN577SbSLhwwzfdymSMg+gndHXPvz4ab6TsEud+
	JyDadWfImx++xoYR6wCJLF1dYsjO+P5MQ5ZFxERtKtvcxTAJm9J61dh2nZ+k3vk6tRQbXkUfM7D
	jNXRKCL
X-Received: by 2002:a05:620a:2807:b0:8cb:2b1f:99e4 with SMTP id af79cd13be357-8cbbf3cf398mr113515285a.34.1772059964616;
        Wed, 25 Feb 2026 14:52:44 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf652bb6sm51863585a.4.2026.02.25.14.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 14:52:44 -0800 (PST)
Message-ID: <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
Date: Wed, 25 Feb 2026 15:52:41 -0700
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 1/2] filemap: defer dropbehind invalidation from
 IRQ context
To: Tal Zussman <tz2294@columbia.edu>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Bob Copeland <me@bobcopeland.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
 linux-mm@kvack.org
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/25/26 3:40 PM, Tal Zussman wrote:
> folio_end_dropbehind() is called from folio_end_writeback(), which can
> run in IRQ context through buffer_head completion.
> 
> Previously, when folio_end_dropbehind() detected !in_task(), it skipped
> the invalidation entirely. This meant that folios marked for dropbehind
> via RWF_DONTCACHE would remain in the page cache after writeback when
> completed from IRQ context, defeating the purpose of using it.
> 
> Fix this by deferring the dropbehind invalidation to a work item.  When
> folio_end_dropbehind() is called from IRQ context, the folio is added to
> a global folio_batch and the work item is scheduled. The worker drains
> the batch, locking each folio and calling filemap_end_dropbehind(), and
> re-drains if new folios arrived while processing.
> 
> This unblocks enabling RWF_UNCACHED for block devices and other
> buffer_head-based I/O.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/filemap.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 79 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index ebd75684cb0a..6263f35c5d13 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1085,6 +1085,8 @@ static const struct ctl_table filemap_sysctl_table[] = {
>  	}
>  };
>  
> +static void __init dropbehind_init(void);
> +
>  void __init pagecache_init(void)
>  {
>  	int i;
> @@ -1092,6 +1094,7 @@ void __init pagecache_init(void)
>  	for (i = 0; i < PAGE_WAIT_TABLE_SIZE; i++)
>  		init_waitqueue_head(&folio_wait_table[i]);
>  
> +	dropbehind_init();
>  	page_writeback_init();
>  	register_sysctl_init("vm", filemap_sysctl_table);
>  }
> @@ -1613,23 +1616,94 @@ static void filemap_end_dropbehind(struct folio *folio)
>   * If folio was marked as dropbehind, then pages should be dropped when writeback
>   * completes. Do that now. If we fail, it's likely because of a big folio -
>   * just reset dropbehind for that case and latter completions should invalidate.
> + *
> + * When called from IRQ context (e.g. buffer_head completion), we cannot lock
> + * the folio and invalidate. Defer to a workqueue so that callers like
> + * end_buffer_async_write() that complete in IRQ context still get their folios
> + * pruned.
>   */
> +static DEFINE_SPINLOCK(dropbehind_lock);
> +static struct folio_batch dropbehind_fbatch;
> +static struct work_struct dropbehind_work;
> +
> +static void dropbehind_work_fn(struct work_struct *w)
> +{
> +	struct folio_batch fbatch;
> +
> +again:
> +	spin_lock_irq(&dropbehind_lock);
> +	fbatch = dropbehind_fbatch;
> +	folio_batch_reinit(&dropbehind_fbatch);
> +	spin_unlock_irq(&dropbehind_lock);
> +
> +	for (int i = 0; i < folio_batch_count(&fbatch); i++) {
> +		struct folio *folio = fbatch.folios[i];
> +
> +		if (folio_trylock(folio)) {
> +			filemap_end_dropbehind(folio);
> +			folio_unlock(folio);
> +		}
> +		folio_put(folio);
> +	}
> +
> +	/* Drain folios that were added while we were processing. */
> +	spin_lock_irq(&dropbehind_lock);
> +	if (folio_batch_count(&dropbehind_fbatch)) {
> +		spin_unlock_irq(&dropbehind_lock);
> +		goto again;
> +	}
> +	spin_unlock_irq(&dropbehind_lock);
> +}
> +
> +static void __init dropbehind_init(void)
> +{
> +	folio_batch_init(&dropbehind_fbatch);
> +	INIT_WORK(&dropbehind_work, dropbehind_work_fn);
> +}
> +
> +static void folio_end_dropbehind_irq(struct folio *folio)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dropbehind_lock, flags);
> +
> +	/* If there is no space in the folio_batch, skip the invalidation. */
> +	if (!folio_batch_space(&dropbehind_fbatch)) {
> +		spin_unlock_irqrestore(&dropbehind_lock, flags);
> +		return;
> +	}
> +
> +	folio_get(folio);
> +	folio_batch_add(&dropbehind_fbatch, folio);
> +	spin_unlock_irqrestore(&dropbehind_lock, flags);
> +
> +	schedule_work(&dropbehind_work);
> +}

How well does this scale? I did a patch basically the same as this, but
not using a folio batch though. But the main sticking point was
dropbehind_lock contention, to the point where I left it alone and
thought "ok maybe we just do this when we're done with the awful
buffer_head stuff". What happens if you have N threads doing IO at the
same time to N block devices? I suspect it'll look absolutely terrible,
as each thread will be banging on that dropbehind_lock.

One solution could potentially be to use per-cpu lists for this. If you
have N threads working on separate block devices, they will tend to be
sticky to their CPU anyway.

tldr - I don't believe the above will work well enough to scale
appropriately.

Let me know if you want me to test this on my big box, it's got a bunch
of drives and CPUs to match.

I did a patch exactly matching this, youc an probably find it 

>  void folio_end_dropbehind(struct folio *folio)
>  {
>  	if (!folio_test_dropbehind(folio))
>  		return;
>  
>  	/*
> -	 * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
> -	 * but can happen if normal writeback just happens to find dirty folios
> -	 * that were created as part of uncached writeback, and that writeback
> -	 * would otherwise not need non-IRQ handling. Just skip the
> -	 * invalidation in that case.
> +	 * Hitting !in_task() can happen for IO completed from IRQ contexts or
> +	 * if normal writeback just happens to find dirty folios that were
> +	 * created as part of uncached writeback, and that writeback would
> +	 * otherwise not need non-IRQ handling.
>  	 */
>  	if (in_task() && folio_trylock(folio)) {
>  		filemap_end_dropbehind(folio);
>  		folio_unlock(folio);
> +		return;
>  	}
> +
> +	/*
> +	 * In IRQ context we cannot lock the folio or call into the
> +	 * invalidation path. Defer to a workqueue. This happens for
> +	 * buffer_head-based writeback which runs from bio IRQ context.
> +	 */
> +	if (!in_task())
> +		folio_end_dropbehind_irq(folio);
>  }

Ideally we'd have the caller be responsible for this, rather than put it
inside folio_end_dropbehind().

-- 
Jens Axboe
