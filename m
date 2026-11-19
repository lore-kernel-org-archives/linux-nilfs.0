Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.73
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795097249;
	b=zWEnOlhGxfPVDDMao6vD61gFWrNm8B5uFxH2fKU8SMVW4V2SH/p4QwQkD0daY3XpVFbs
	 8FaVK4dkUwFd8yKtmnOSu/H765+SumOZJjuVnD0MpmatV+czaHwXEep8IrotCmX4wDY/B
	 u/ORgFfgbXnDaH4LHL+U7pjvB03b5tIzq3h+jtHk/Uiaia2GE1k8lOYdD/TOHcSQJMhCf
	 oCSDxCkVFyMpjeDUz9voTCTFVTCXVRkDwfX3B/kOyBEx4vrgcx0jK63WRaRqVD7pq0/ta
	 BCkSHF2L+ikZOvAV40gdq2ZcCSHD5zbP0LmYchwkVt2Ty+IneDSGcjHCjkq8XwvGXIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795097249;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=5fdfxp+3cN1O7P0/cteggQR2R9addmyAbUwlKtxIGuI=;
	b=gjI4FpfwSeY7BdpeQeECYQJkx+3wgTI+PzqAK9ymRb9JXKxdI33AevpyOtiJzgw6mgUw
	 IpAvSo9qFH/1YAiO9hcMoxUWr6nuV1mtYDex5kl8GhIcpdX3A917+KfRKOTnOLO6N/u9p
	 muT0ZuBtWgU9bbSAsHixLN9AZXXfCbyYzbwwzYT1rzP+BZ8KrAmHPfwI92IvC9vier6e/
	 yggQeOp8YD3uGtct6nbx4inlbIJShKunF2r+mAE+BAKkFDyNdntDXa/HaJ+BI46LEM9r9
	 0l0MdCPDX1psEB+5XZL2yL8lCEOXVA/doGkYQhXaT4V55f72Onpbz7gNy+aplTjSXvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=apSCs1mR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.73
Received: from mail-lr2-f9.google.com (mail-lr2-f9.google.com [74.125.230.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CC5606A334
	for <linux-nilfs@vger.kernel.org>; Thu, 19 Nov 2026 14:07:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83CC5606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=apSCs1mR
Received: by mail-lr2-f9.google.com with SMTP id 38308e7fff4ca-3adfc43e68aso3311771fa.0
        for <linux-nilfs@vger.kernel.org>; Thu, 19 Nov 2026 06:07:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795097248; cv=none;
        d=google.com; s=arc-20260327;
        b=WQmITYAWi5pGJaLEhISSBEXvnqWBsrN5YDxrQNJG9Il/pmIUnIqeVKfMV4dZc5Lr54
         1BetcBpsLElBMPFhUge2qO+zblNv66kDLFhy/OBOeH6LWyPbduuiLwEIcyw1K44/jO7U
         rTmLzBmaWEI1FJpuu2WSVU9wWk4itOC0uYhgCl79oKh32loEVLd8OmOu1oWzb5qtNc6h
         vkYocwmQRMgUgl7GXT4Tr/0YDHCmUMi2n50W05X7J7hxz7FJTtFyIq0zUmFKJmmNTb03
         B6AjyDUi79XU4rxYBm1KuXOzIomh+92pdlQorpy1cMsil/QDUlkKQ2bT9pTYeyEId8tn
         mAvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=5fdfxp+3cN1O7P0/cteggQR2R9addmyAbUwlKtxIGuI=;
        fh=QHnYC5InCybljciDffv5VQs4zN3iIbcp9jUh4mcBlzs=;
        b=EAvOsQA78Wx90GYYbz5suK19VYaP7MysjMqIcV201kOT42ZxfV+AVnWYBmCEifEif5
         hhvbPDhB2SC+8WPOFuTdBG3EHNfQho/UzjJ1y+jzPiZ70PgOx3Youhh3oZun0JnhYh1j
         YVUPLGk9WKgEncMYddjQ++Q0ybs4oxRuYs5/2RBBnZmd/31hGAwNyZz9nP86jvEdR1m5
         VOUx2dYjuc9t8XDAiqPTMv+Xv/xrp0zWVQPzjcgjiEZK8zHc0L/8/fqHxtaCNzM82gYI
         GUP9MsyEKXLvxKdTUZzQeM2LOLGXbMEGx6IG6MMgv+eSlmltVRphD8Hhfy1HJeXJmSo5
         tF9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795097248; x=1795702048; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5fdfxp+3cN1O7P0/cteggQR2R9addmyAbUwlKtxIGuI=;
        b=apSCs1mRbYfiyuOplCR30hz6MbUxMYh93+x2cpTBQxkIrqhHyPOfu03EV9FN9SyUzc
         g8F0ElaX571dOfSmkhssW3ExTSEbPitJw/hWlwoN5aZk7mMMclNinfzG03Hd4XqD9zAB
         9Oibl2aZyxObNcMzHt5OY7pL6UvxVwDosf/MNfFrrj8C/lI5/kmOXM7kpAq95K8u8TG9
         i5414Nz9Qseu8tXH9DZPMf2+fQ1SWkdHCUUzYHqqLK/gAOZvixGnpV5EBsXuw3Hd51+/
         vVl5gXDeSqVAqiyh+9VAt8mFBqntpq5S28BxgBbavYRi9P2kqQ16/oS9wlxDFryhPrQm
         7Vjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795097248; x=1795702048;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5fdfxp+3cN1O7P0/cteggQR2R9addmyAbUwlKtxIGuI=;
        b=cUavDe1Dq5q7zFHnD8cIoh8el2S+LZGuYmwJJDPtDr2qQtxFV8+qb3SYD36TkSpIFW
         0Mt4iPvSciLP48ITcDrRSsA6a8LB5cV7eiXdNg8dIRKfgX6vXXyBeCMvXjWd0KJyYQoD
         7FD9pj0bT1BqCbU12W8iPH+ZYrj5qV6uF3lZP4NE5I24phW4ZdWtvApWU8xh1GMDKefI
         BLYzb6okch+sqvNZkISleCjAyrot9Kl07Et6HqzakFc7ucVPyPhhQ14KSVqYiKVRjSkb
         LltBMay6cC2NAEmE+2I6yg9g0jtngOcduSre/xi2cuzTmabWqGk4zZyCiyrLBy6xyQcm
         AEpQ==
X-Forwarded-Encrypted: i=1; AL+hErFVIDLs76SEy1ty4RCSlIjkM4Im4f1ocWCnYWq3zne+YMvRE9fxoyNTHbDi1EmrH/JZMxk2EMrl5CgrHQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/6vxIie6s1kN4fH5o6hhhT2VTP7qu3ClJ8v7jSk74oTYJkpkZ/
	ejVl3kjFw08qY1vleripqQDtoC185NQzrw5MCqdywFgTsWfgYQNOdufEAhya7e3LvaONSXs8t/+
	bt5+znITn6z23A7AVRhn43TjdqdEK+AM=
X-Gm-Gg: AYBFou3UZr2efJNQEao5G7E6gJjkZjo6RVJ3USCs1EGKc2efaPC3SxGu1RHvMOEBSs7
	3FqORHY6iMNb2TqNzZd8GFBjrpuIraKaLzNHl6g6jNFv57MPt+ImVbuy0l7SrSj+rg0HFXDm8uf
	RX3ZyLWHPUbiHe5kUX47ftiQq5MBDotMsZvtnM0LdiYuw955+mP6WigDyVaDTMoJ2KBo9N8wnKa
	LU6ynfh/8Nl/YHFqYKlhBP+Hh24UiJqbo6VojILy75RUVD8aVFn7hXOD4XWDm6jtn8WYYTBZcSP
	P96GwOhwpAGAkcLuK+mVSXuaF9/B/tRILyq6+nqGeuWfS1Inyv68xjX6lg+4gcvK41esxDpMl1T
	sb3QNQ+7czyHf8G5ZUQDha1rDIw3yijUjoAWoC4l0dtkI0h5Q0/LMndTKo8ANLUlLtFA=
X-Received: by 2002:a05:651c:2105:b0:3aa:f4c5:8920 with SMTP id
 38308e7fff4ca-3ae7b7b4759mr3971431fa.12.1795097247395; Thu, 19 Nov 2026
 06:07:27 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Zheng Zheng <fengaojigui88@gmail.com>
Date: Thu, 19 Nov 2026 22:07:12 +0800
X-Gm-Features: AclHuK-b4i_d8VXZZJ0Fe5n8p466ow-YpKHzxH9f5HZX4zjZqSLG9FFtE1oPG30
Message-ID: <CAO-4RZ1Q-HzRCd+S1uHZJRdN-ZCtv47f=pXTxbq4YaJgn_DALQ@mail.gmail.com>
Subject: [BUG] INFO: task hung in nilfs_segctor_thread (fs/nilfs2/segment.c:357,
 v7.4-rc3)
To: konishi.ryusuke@gmail.com
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hi Ryusuke, Viacheslav,

We found a reproducible NILFS2 segment-constructor hang on v7.4-rc3 with
syzkaller. The supplied recipe reproduced on three independent fresh VMs; no
state snapshot is required.

Repository and reproducer:

  https://github.com/Zheng-zheng-codes/nilfs2-segctor-thread-hang
  commit 2d94e07741d28d2dccaba174d06d6a5255ce0134

Hung-task report
----------------

  INFO: task segctord:35823 blocked for more than 183 seconds.
  task:segctord state:D stack:29568 pid:35823
  Call Trace:
   <TASK>
   __schedule
   schedule_preempt_disabled
   rwsem_down_write_slowpath
   __down_write
   down_write
   nilfs_transaction_lock+0x25d/0x410 fs/nilfs2/segment.c:357
   nilfs_segctor_thread_construct fs/nilfs2/segment.c:2601 [inline]
   nilfs_segctor_thread+0x600/0xa60 fs/nilfs2/segment.c:2716
   kthread
   ret_from_fork
   ret_from_fork_asm
   </TASK>

The blocked thread is waiting to acquire `nilfs->ns_segctor_sem`
for writing in `nilfs_transaction_lock()`:

  for (;;) {
      down_write(&nilfs->ns_segctor_sem);
      if (!test_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags))
          break;

      nilfs_segctor_do_immediate_flush(sci);
      up_write(&nilfs->ns_segctor_sem);
      cond_resched();
  }

The lock dump also associates `&nilfs->ns_segctor_sem` with a task in
`nilfs_ioctl_clean_segments()` holding `sb_writers`, while `segctord` is
blocked in `down_write()` on that semaphore. The serial log repeatedly reports:

  NILFS (loop6): error -28 cleaning segments

i.e. `-ENOSPC` from the clean-segments path. The reason why the
clean-segments ioctl holds the semaphore
for an extended period is not yet clear. We have not established
a circular lock dependency or identified the root cause.
We would appreciate your analysis.

Reproduction
------------

  git clone https://github.com/Zheng-zheng-codes/nilfs2-segctor-thread-hang
  cd nilfs2-segctor-thread-hang

  # boot v7.4-rc3 with the supplied kernel config
  # using a Debian trixie x86_64 guest

  # in the guest, as root:
  syz-execprog -procs=8 -threaded -repeat=0 \
      -executor ./syz-executor reproducer/repro.kernsight.prog

`-repeat=0` enables indefinite repetition. The recipe has 227 entries: 226
replay programs followed by the testcase.

Verification:

- Main KernSight pipeline: attempt 2, `confirmed=true`,
  `status=verified`, 226 replay programs, 2026-11-19T11:10:28Z
- Pipeline verification scope: `snapshot_restore`
- Independent external fresh-VM verification: **3/3**
  - run 1 hit after 422 s
  - run 2 hit after 257 s
  - run 3 hit after 320 s
- External serial logs are in `external-verify/serial-{1,2,3}.log`
- Runs were counted only when a `nilfs_transaction_lock` frame appeared next
  to `segctord` or `nilfs_segctor_thread`; checker:
  `external-verify/verify-logs.py`
- C reproducer: not generated; the syzkaller recipe is the primary reproducer

Kernel/guest details:

  kernel: v7.4-rc3, bzImage sha256
    0c16409f8aec508ac44a63e631c2bd352536401f3fd0856df1d839fb953a1882
  guest: Debian trixie x86_64, 6 GiB RAM, 4 vCPU, QEMU/KVM
  boot: oops=panic panic_on_warn=1 hung_task_panic=0
  config: CONFIG_KASAN=y, CONFIG_PROVE_LOCKING=y, CONFIG_NILFS2_FS=y

Thanks,
Zheng
