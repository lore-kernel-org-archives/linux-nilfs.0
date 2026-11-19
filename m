Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795098085;
	b=o4CmE+j0+zJsiVn48RC0Xslf9imyq/0EhKhgHePA9CvUZrkuWSH6yPn3agesKuYNskbS
	 n45HUnJZLD/WhqUQkohDiCXoIuK3RsevonjauXoqpCTncFbYPH9XPbdKe6hLeGCf7mjV+
	 z00CHyofEQtJdSJzCpnKbdF258oA+1k4RuCaD3EqjQN6DZ2IQFkzz/oQAl2yCycCd8Lss
	 nLZxBv/cSRz4DmVUi46MgiBQq/B1mClyTRI5uunK7V9yKCtNj0pkZ5MALPo4LDlJ/M3K7
	 PwWrYwxW3qlD9oDw0hK61XWJYIm4kl0L5mGuHQ8yar4gic0YHheSwNgUOTjUePkB5RQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795098085;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=y04CS3a1J3CXqGFaQTOcHCW2uGdwJOdnkJAq0Pc5CFY=;
	b=tERgVazcWOz46W2NLLW2Ld7WcBCd5Jn6fW0SoxJFofDTgoldOna40gRjyXKztk5F3S2r
	 uR1J9x+C5aa1Zksp2179jQr8TKv6Jx8H50d0stApMrgbP1frItbt4ufsra++qrFZmMygb
	 kU6A7wXANs+KwvBIcJMRtcNz5zkPiGgJ6GdY+j75l0tJ4JDdMlYskf94hsxuIl6HR1+gN
	 TLWoO7v4yaNrf+qilF2I+/Tq9/p6COjhi79YNUIIA1awmM6sTqkPifr7AIcGELle4bJvK
	 I8zMQzidf7AzZUfMs69gX/wPPX6q3Ufbrkm+93CVB7yv/wvMwSyd0FOZ0A5G7OvM3Cg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IG75hVnM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E08606A32A
	for <linux-nilfs@vger.kernel.org>; Thu, 19 Nov 2026 14:21:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67E08606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IG75hVnM
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4a357b1c649so1483701f8f.3
        for <linux-nilfs@vger.kernel.org>; Thu, 19 Nov 2026 06:21:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795098084; cv=none;
        d=google.com; s=arc-20260327;
        b=nJJVRt+VsLuGkUNuc+Kqz1bf07tVJY7PURejEvnL6YkaeRyVRA73bgfi1jJfghSezS
         2uqUnMup+99W8E9ekAZsnilmvTf34TKRGa3JKlG84phtVCnRJxT/EUUUXktFcrElRFGY
         F2hf89K4d1anuEoevS19c9jdhPkn71G213bzp+XdHgEP9ozlZc1AAj8gySBJ/JsdkQvg
         5T4v4ukloLhXdHgY99JZsKiqt5CScgZdJ8uPBjhI2sH7lFW01EQgEt3F6xxEp/7aKNxx
         gZ3n5oL9kZYqjFuWQ8LqYPRz2vLmQWEXdSdEI4ZYOJ5Ak6Plw8Dg9ZIZeNDCcvPEf5gG
         ZGMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y04CS3a1J3CXqGFaQTOcHCW2uGdwJOdnkJAq0Pc5CFY=;
        fh=U0euYHwb56aNdhYyGTpMGVi/XB34Ce7dK+gj9jSeZSI=;
        b=sWTJJ+jJS3YLChaOu7tuDUVT+fpeUnt51wZ/ZA49g3kpbe9VaidnZ9RJmLCQxEjZJC
         e0q8GsxaVSDWSzYRJsarp+3W19SRokjm+8M2ckAKW5g2KszE/TabQ9jHXOIxo1i0btsr
         8uh6FT57Pn7Iog0ccNheIvQgn3pnIcbifGIUYu/A+Tr0vCWAnMK1MwfTUhPCxx73AXGm
         7r5dEW+DjZJMhh789+lQXhhJ9F4N/VFEQhKaMRXy/zM4IPYxcENqgnb7AqdD3KTvbrbI
         2GSnctjz4XxWjPX+LaLycyIlUX4wkKO9VLBCwZy0D90R3nPAMJeShNSDXmhi/XndmnBZ
         9EWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795098084; x=1795702884; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y04CS3a1J3CXqGFaQTOcHCW2uGdwJOdnkJAq0Pc5CFY=;
        b=IG75hVnM9ivavyaInozy3BqwUaU2lEXquJG5ktgX0AvFJu+BCLDa7gIxjFwvrd59xL
         GmfphVX7NJLErDWJ6nWKhM96AEf8YwYGs5yRSK0HE0lfAcyUBmZ4UOlxjRVUyN7XF9Qz
         GXl0OlT5FZJMn3ypCgmhgpLNgpdaNHEIn4QdHoAFO4pbIwb3fGp9A5gfjhe0z393taNS
         bcIDtWi/zW9vEmOoCzgQdRwIA3w1povoQ82aq5fu/00iiRiusrNeOlgvrhyHbJIGusZT
         iiRHiZk8wOss0b1TUqk0jvRCMk0qXps8Jw82/hF5iJ2At6JbsBA1WNfZof7/d76WtxCV
         iyow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795098084; x=1795702884;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y04CS3a1J3CXqGFaQTOcHCW2uGdwJOdnkJAq0Pc5CFY=;
        b=t4mH6ROflAWdJ232E1mH+4DODsYD6Q+1p1Gyk3ygmKXg2vTDCY09WAe2PeskOqG4NK
         CP8FSEkVDu3YOs4SxD4MQkIKiDSZfib/cuZdFCMC9Jm7MevvbWhOHJZonLSa/ewjJEO0
         QzKB5GNL71mit9q9JwGcHTS79Ogf5iPQFZHT5b9VI+q4r3js0vpRiyvrizectw9AjPRQ
         ZseEOsY7//WXFpW7ZEy42m/vm/T1W37S0L8gFbGqm76FdsjBEh6uRYuM4nibNHJ3q6iG
         WjkomK81QmJiXIsV6gKGk2jHTCg2nvBmksMrqUmnHUQuR29RJr9MmNOgcR5ks/az+laG
         pFkA==
X-Forwarded-Encrypted: i=1; AL+hErHmX/Zyc+KRwtH7t1F9GnPif10LWVwdRxClgJQQ0ac64OtQ+OsJ5h1icj+YdKhpd7ApL+yXx76H43khyA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9FH9oOzXUDn0yEg/K6oCZfo9ZAL7gBgG0A7+lNtKhYoMyP24hi
	flkb5AybdRc8cc4TNLQ/pKPH5bJ+FEJEgdXJIX14zVpzlw8z7NvIeFvIVX/W4JatKeo1BB6To/C
	06m9X7HExRWWqqVEXG8IU1JNE8hrNHS8=
X-Gm-Gg: AZFdTZfYOskzpoloGmxTsPsHHfwg6Wr3uht8aSwkfZ6JGhArg03X0gK04W9fxBz66jx
	8FN2H6yDp38a74tGgqdg1vFhbQ+Yccs0SOdj1yyyVImyxHrNJhvC+zS0/LL+04HxjMMlLwyHM3D
	/ldK8ptnsNj0wkxZP76ThqbEudPNtcLAHqydnhKBwOLeos/GOpbvJFZq2pMcSC1ZalsvzlONhcw
	OCyJela96WnWEHyU5hghVXgHrxGQI39MesbpVznOZZOtSBkaxPJJf1q8dpjZb4EAwA0cy3sMm2r
	PbvknZ7UnrWyWtjDglM+kvAzSKWGC4/nRzrlNfVR8DwgSx/XtSyAV1cI/PaV/kvGjQyet7msYT1
	CYr/bmormUa5x3YyQsT59Ji2inoHH0H0gFQoaSA==
X-Received: by 2002:a5d:5d12:0:b0:4a7:14d0:9c4c with SMTP id
 ffacd0b85a97d-4a714d0b8b5mr11508333f8f.6.1795098083499; Thu, 19 Nov 2026
 06:21:23 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAO-4RZ1Q-HzRCd+S1uHZJRdN-ZCtv47f=pXTxbq4YaJgn_DALQ@mail.gmail.com>
In-Reply-To: <CAO-4RZ1Q-HzRCd+S1uHZJRdN-ZCtv47f=pXTxbq4YaJgn_DALQ@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 19 Nov 2026 23:21:06 +0900
X-Gm-Features: Aa3M54pK07kbY1LM2qYIEccGv9secMekg3Dfzg9Ys1fOO7NnwNajglNV0FmzpIw
Message-ID: <CAKFNMo=LGQMgGK5_dj+wgByYBx8YxkOH13rXcqZ-cwAjff0ZDw@mail.gmail.com>
Subject: Re: [BUG] INFO: task hung in nilfs_segctor_thread (fs/nilfs2/segment.c:357,
 v7.4-rc3)
To: Zheng Zheng <fengaojigui88@gmail.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 11:07=E2=80=AFPM Zheng Zheng  wrote:
>
> Hi Ryusuke, Viacheslav,
>
> We found a reproducible NILFS2 segment-constructor hang on v7.4-rc3 with
> syzkaller. The supplied recipe reproduced on three independent fresh VMs;=
 no
> state snapshot is required.
>
> Repository and reproducer:
>
>   https://github.com/Zheng-zheng-codes/nilfs2-segctor-thread-hang
>   commit 2d94e07741d28d2dccaba174d06d6a5255ce0134
>
> Hung-task report
> ----------------
>
>   INFO: task segctord:35823 blocked for more than 183 seconds.
>   task:segctord state:D stack:29568 pid:35823
>   Call Trace:
>    <TASK>
>    __schedule
>    schedule_preempt_disabled
>    rwsem_down_write_slowpath
>    __down_write
>    down_write
>    nilfs_transaction_lock+0x25d/0x410 fs/nilfs2/segment.c:357
>    nilfs_segctor_thread_construct fs/nilfs2/segment.c:2601 [inline]
>    nilfs_segctor_thread+0x600/0xa60 fs/nilfs2/segment.c:2716
>    kthread
>    ret_from_fork
>    ret_from_fork_asm
>    </TASK>
>
> The blocked thread is waiting to acquire `nilfs->ns_segctor_sem`
> for writing in `nilfs_transaction_lock()`:
>
>   for (;;) {
>       down_write(&nilfs->ns_segctor_sem);
>       if (!test_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags))
>           break;
>
>       nilfs_segctor_do_immediate_flush(sci);
>       up_write(&nilfs->ns_segctor_sem);
>       cond_resched();
>   }
>
> The lock dump also associates `&nilfs->ns_segctor_sem` with a task in
> `nilfs_ioctl_clean_segments()` holding `sb_writers`, while `segctord` is
> blocked in `down_write()` on that semaphore. The serial log repeatedly re=
ports:
>
>   NILFS (loop6): error -28 cleaning segments
>
> i.e. `-ENOSPC` from the clean-segments path. The reason why the
> clean-segments ioctl holds the semaphore
> for an extended period is not yet clear. We have not established
> a circular lock dependency or identified the root cause.
> We would appreciate your analysis.
>
> Reproduction
> ------------
>
>   git clone https://github.com/Zheng-zheng-codes/nilfs2-segctor-thread-ha=
ng
>   cd nilfs2-segctor-thread-hang
>
>   # boot v7.4-rc3 with the supplied kernel config
>   # using a Debian trixie x86_64 guest
>
>   # in the guest, as root:
>   syz-execprog -procs=3D8 -threaded -repeat=3D0 \
>       -executor ./syz-executor reproducer/repro.kernsight.prog
>
> `-repeat=3D0` enables indefinite repetition. The recipe has 227 entries: =
226
> replay programs followed by the testcase.
>
> Verification:
>
> - Main KernSight pipeline: attempt 2, `confirmed=3Dtrue`,
>   `status=3Dverified`, 226 replay programs, 2026-11-19T11:10:28Z
> - Pipeline verification scope: `snapshot_restore`
> - Independent external fresh-VM verification: **3/3**
>   - run 1 hit after 422 s
>   - run 2 hit after 257 s
>   - run 3 hit after 320 s
> - External serial logs are in `external-verify/serial-{1,2,3}.log`
> - Runs were counted only when a `nilfs_transaction_lock` frame appeared n=
ext
>   to `segctord` or `nilfs_segctor_thread`; checker:
>   `external-verify/verify-logs.py`
> - C reproducer: not generated; the syzkaller recipe is the primary reprod=
ucer
>
> Kernel/guest details:
>
>   kernel: v7.4-rc3, bzImage sha256
>     0c16409f8aec508ac44a63e631c2bd352536401f3fd0856df1d839fb953a1882
>   guest: Debian trixie x86_64, 6 GiB RAM, 4 vCPU, QEMU/KVM
>   boot: oops=3Dpanic panic_on_warn=3D1 hung_task_panic=3D0
>   config: CONFIG_KASAN=3Dy, CONFIG_PROVE_LOCKING=3Dy, CONFIG_NILFS2_FS=3D=
y
>
> Thanks,
> Zheng

Hi Zheng Zheng,

Thank you for the feedback.

I have filed this issue at:
https://github.com/nilfs-dev/nilfs2/issues/182

The issue you reported earlier was related to GC error handling, and
Wang Jianjian has just proposed a patch for it, which I was about to
look into.

Since this one also appears to be a GC error handling issue, I will
look into both together.

Thanks,
Ryusuke Konishi
