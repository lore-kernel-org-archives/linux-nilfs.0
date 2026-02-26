Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7349463
	for <linux-nilfs@vger.kernel.org>; Thu, 26 Feb 2026 03:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772075733; cv=none; b=W8JscwJ0xlo2h191gmeyQ9qCevlTq0fASrCW6llcOyhIWVgqWEYg8W1vceZHaCAfEgfww77ZE1e5YpvMJ1n2mmWzeBFEoTZ3o0fTij9bZXR8mNqLmoqz73WUqKsaSV+I01V8oAvaBU0TQQgCOfjz4IgY5VXtTPYyLTb93dLF/VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772075733; c=relaxed/simple;
	bh=3Uj98JRcjkXg45L932sgBQ4jyAOkKnrA4eVXq0Mc2RQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iT1aEv/XURsa5QOIexzww8RSBXljwHfKJd204Ha/6f0RvPgCKT5XbMN4+Fasoi18+6gFJUHQmBhrobWoZgzMM1EHuo0lm8gJk8Fx4GJ4QWeVTsaGZzBGn23qj8fkNRxzs6ajU/FH9Lu6S9BMMGFHapjOzD+IabNpBglkAoTViCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pt3QESqe; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pt3QESqe"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-4638fe85a7eso160796b6e.2
        for <linux-nilfs@vger.kernel.org>; Wed, 25 Feb 2026 19:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772075731; x=1772680531; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=myOpzKKufRrzTXzkKkTioHHnRh1Fxba9oHbsZ8bSehI=;
        b=Pt3QESqeGYGEyfcbtu599/TaELTldNHt9ng7MdkbQscEZnkRuSh25I41b9c9dvwbs0
         pbRiegVYVhXxN6kv/Eg0EFcqolSkF8sW2dHcoxou+89/W6wTpoKs3MeS5dRmlnq0QHLz
         beD0NKXnUFkxdzpurznywZsv0jcAXSFUEZlDVEaGEZX/fH8nT2ZLRuRzU4wRZYWgAJYK
         HjXy/ScGA0aB6TeNRft1Dvn6Qb35HEKMPwb1Y7g7J2FWEhFtSj7eArl0e01dC8zPx26E
         xYJnhHsEiybj+rxDtRCtjALwF7rqZEnbad8aUzCkCd2gR90/cfeFhG91HuY5K4g9N7cT
         grQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772075731; x=1772680531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=myOpzKKufRrzTXzkKkTioHHnRh1Fxba9oHbsZ8bSehI=;
        b=fe6ifW/l6SCuriqxyDiFec/4NoIwGkHI8v+bw3O1qNmxTrQgz96MADbop8nT+mUp21
         7IJ7SQDy9gCbejgLmBsvYEf4heFhiNLgLmGQAApnsSx9mcVgt4sWLgU+PzIPIlaZdiCW
         1uYiyaKFyfBOVP/+SaEmn8TueozqI+bqCKPmT7xaj7gB/O36uxcRrBiXUWN70iSboeLU
         KTWsCRXjnipeNNc/ysxN6egOtpawCxHE6u7o0WwPUX2us0f1mjUV9Zumrys5Wg6kCnKs
         AwyFdSURDP+GLk59SMYn9jLusboSGrWPRip+uYa8d9uFKDXG2mryQtT6aomKGCOCICgV
         9GUg==
X-Forwarded-Encrypted: i=1; AJvYcCUBLPxJDAoyp5kC/RkqLvp5JFk4NJXweEioZoyVXSeN03g1YfeUJc7tzEeKsjjKqKwJmZwSF9C1BvOfdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwogodLUPEYOoAI9dC2R/YjYO7UZPqc/eB5ggqoUO2gga9IyTc8
	IfyyFiX00ytAO/uvFJdWr0Vy/V38rADt4uycpxQktn8FoiOH5eNHnpjHrRTT0IeQml0=
X-Gm-Gg: ATEYQzxJLxMxgOrRCWDNyM3weA+X6rG4UfvRhAQG6eMvQogmisP4q/Cl9bKjDVCshC8
	YeDlTP9T0Y2/KfjaKfMlEJY80PUTKHXr5xqwFmq66BCcjLYl/sFai8v+o14dvEkcaDkK1lKsdpz
	MITgpVg5AcX5xhuz/Hcssgl4xSNtvWNE7Quui+ObPbH4QwNueIp9B/Kq7Z7yj5259PiA/aRluD4
	GXpfK7ukKJ40meY+GP3qdpphQZInpUK4TQvZMefo9gKNlyt4qx/J8oR8svJ2A1eU8QE/8oDGH3E
	wW/KbL3WTpowokIHix6dEhIILJVNt0Ogsd0ajyJoMDTjbIMRKpDPTdzvXtl7Mi1+reH/B060+HI
	MNPZ/jFQBVJWPWWEQcQiq0OvpmpKdN5FHNyE63prBezf48CdCVidQPA0xa+7030zehC3b6MmYKs
	2I8u7KfUgK49XUT/TkwRI097ijrTN7dOLzH1X9PzHgFhUo+b8QsOpRZo0dATJv88HC2VM45EV0v
	hINLeoiRQ==
X-Received: by 2002:a05:6808:320b:b0:462:d9a2:84e1 with SMTP id 5614622812f47-464463ef61fmr8794809b6e.60.1772075731397;
        Wed, 25 Feb 2026 19:15:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cf9b240sm786090fac.8.2026.02.25.19.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 19:15:30 -0800 (PST)
Message-ID: <44e3e9ea-350b-4357-ba50-726e506feab5@kernel.dk>
Date: Wed, 25 Feb 2026 20:15:28 -0700
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 1/2] filemap: defer dropbehind invalidation from
 IRQ context
To: Matthew Wilcox <willy@infradead.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Bob Copeland <me@bobcopeland.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-karma-devel@lists.sourceforge.net, linux-mm@kvack.org,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
 <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
 <aZ-2G_6lDZePLSyx@casper.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aZ-2G_6lDZePLSyx@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/25/26 7:55 PM, Matthew Wilcox wrote:
> On Wed, Feb 25, 2026 at 03:52:41PM -0700, Jens Axboe wrote:
>> How well does this scale? I did a patch basically the same as this, but
>> not using a folio batch though. But the main sticking point was
>> dropbehind_lock contention, to the point where I left it alone and
>> thought "ok maybe we just do this when we're done with the awful
>> buffer_head stuff". What happens if you have N threads doing IO at the
>> same time to N block devices? I suspect it'll look absolutely terrible,
>> as each thread will be banging on that dropbehind_lock.
>>
>> One solution could potentially be to use per-cpu lists for this. If you
>> have N threads working on separate block devices, they will tend to be
>> sticky to their CPU anyway.
> 
> Back in 2021, I had Vishal look at switching the page cache from using
> hardirq-disabling locks to softirq-disabling locks [1].  Some of the
> feedback (which doesn't seem to be entirely findable on the lists ...)
> was that we'd be better off punting writeback completion from interrupt
> context to task context and going from spin_lock_irq() to spin_lock()
> rather than going to spin_lock_bh().
> 
> I recently saw something (possibly XFS?) promoting this idea again.
> And now there's this.  Perhaps the time has come to process all
> write-completions in task context, rather than everyone coming up with
> their own workqueues to solve their little piece of the problem?

Perhaps, even though the punting tends to suck... One idea I toyed with
but had to abandon due to fs freezeing was letting callers that process
completions in task context anyway just do the necessary work at that
time. There's literally nothing worse than having part of a completion
happen in IRQ, then punt parts of that to a worker, and need to wait for
the worker to finish whatever it needs to do - only to then wake the
target task. We can trivially do this in io_uring, as the actual
completion is posted from the task itself anyway. We just need to have
the task do the bottom half of the completion as well, rather than some
unrelated kthread worker.

I'd be worried a generic solution would be the worst of all worlds, as
it prevents optimizations that happen in eg iomap and other spots, where
only completions that absolutely need to happen in task context get
punted. There's a big difference between handling a completion inline vs
needing a round-trip to some worker to do it.

-- 
Jens Axboe
