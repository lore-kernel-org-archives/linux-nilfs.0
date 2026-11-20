Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=74.125.230.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795172371;
	b=GFwYgUZ2JZi0JzwD/YYsJH4IR9PrmbTq+xviH5yoqrJgbr0HCgyOStFs7zkJBs6EN7c4
	 QJ8kiH5xO75DUHImGeZagHMvhgGt0uoI94BzqPUgj02WS/ovteKdalbFZkfr9FFw8/nbp
	 OIljHQupx3m0b1sPlTi//bQSzQjLcK0OGiuQ6FxaUjBUVdXfk7k1gSgD6i4aJNXkxcnGX
	 jQlM/ZqpoZteHpiUlDMJFkJI9Hbc+6EynMj+zJsLKq4yrP2Zvd+ykDAIB6ZJiEjizBi/P
	 70BCb51+u1958EqfhCucchCUQzemx0BpXtBL05mSOTH5l3Pe+1ZKcOcGNVSOoj+Rg7Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172371;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=lsuDl5Mn3UwB19cNkcSJlYu8KKq2fYppJdpOiWNy9qk=;
	b=5HHH6O8ZyYDHQ2oGw4762uuTNgTUPu2dbO72LpY5RvqNQ9VUMM6yLAva3q64xhiJJjYK
	 McXcdl8gfuht9s2LP95k7ptgwRm21PXicKQpxhGm2hjwIQvCgJT6WRKwz1ajAqyoUOp7f
	 gthB8KEDh/6jmbdTPhlqsEWm2n2Gx7Q7HytUhD3vpcVYYTqiNggR9X/bqTgCTMz6k8cPn
	 1oUrRN89l0UvsrNmcZu7WQVb3RwMqr4FAL9K+4/oY7aDgMwc82VdEpeLf+xARUKVNeD7E
	 pjzf6G0U45IxaZM7tQs+kHbRgg5sEjddhKzdwaC5IZDMiXVkTRrTCZTRKmQW2DeflHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hjZVtA5I;
	arc=fail smtp.remote-ip=74.125.230.71
Received: from mail-lr2-f7.google.com (mail-lr2-f7.google.com [74.125.230.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75019606A325
	for <linux-nilfs@vger.kernel.org>; Fri, 20 Nov 2026 10:59:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75019606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hjZVtA5I
Received: by mail-lr2-f7.google.com with SMTP id 38308e7fff4ca-3adf87dd550so3657061fa.1
        for <linux-nilfs@vger.kernel.org>; Fri, 20 Nov 2026 02:59:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795172370; cv=none;
        d=google.com; s=arc-20260327;
        b=WhkfrSV4iJ8LdyjhAOKyy+q+96PT386B3A68ctgPEaK/vVD5OHsXrIzQgFy+c39eAG
         63+d1P9y0FyVebgaffSj908L74QNEhOiKVwj0v3HACZ/QJJ7hj+zMWX2TLKzmLrdxdij
         qDQL4QgHnumoc0qzwbfGEnYhoSbTktHhcbSF2z0ev7kgx0DQD8MW6Tkx4xo/fD1KijUh
         piWBQcO16sgbp05EKZCTAOB3/Smn9TvwFiH9vvVG5YXi21pHWZPNqC241AYsO6qDcw+E
         5y+avp6HwXPzbjKwv2dcy/coLiK0cRLqv6UyCWtS9OKLIaLpQH0CtcBvM3hzw6crOU5r
         ZRTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=lsuDl5Mn3UwB19cNkcSJlYu8KKq2fYppJdpOiWNy9qk=;
        fh=KIa0Mhk09ihYGLnMuf/XPbZfWXKrnrTn7BNX/Ih7lDs=;
        b=lGNSi8XA2hA4wiIeeJXwvpkbkP5rn10SJsgl3fc5jaNlOvXxq5nUqai/V03F1vgwz7
         W5guuZZ6y54EGjfbORx22VlE2cisgYHFEB9eivuaQMbAig5yoU9BKhfRaJ5uCGOeXU0x
         tw+Clr5Q8GN8+mSfJBeDRwD+23IVIwJmDMpJkwVHNwTm04FbIgQpsxv/HLnF6UH6X8Nc
         x2fgCaOu3XMomn435m4s+M/TPzdiPOuf8nXQ6dZSDqskL8slNsLleKTnhxEzXpawZc0c
         HBMz/UHrp+A9+OfbQ30Bu+acU3O7I5oz0dAKczWJxKwy5PyzpcMuEX+VRps4wzJub9Ay
         5MsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795172370; x=1795777170; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lsuDl5Mn3UwB19cNkcSJlYu8KKq2fYppJdpOiWNy9qk=;
        b=hjZVtA5I3GOQ3OgGiXpAh4D/yiWo9n387+63YqmnJU8rK6mUkJsQCbGY/Ryfmj4PG7
         POiFVQfTW9uzhfKwvXmSKNLW1YkN/zO0PKc1tZpAIn2ZN71ygI5F6MJf5mRq2YhUApRw
         Jn5mUuk0f5jRbWdBzrP3tKCsIy61XMt6s5r8o4wSy9g2mZ0HqlnCZyybpySMbUvfRxXW
         KBLGqSBia5V1CZuzax3w6ZDBX/34Va8R6FA9ERAKaCf16ELD+klxRjhxpXofsKocJE62
         LOManfqKvXTvs49MVsXib5bhQoDtiYdcfP/1xv/XAEjlMM09sx+Y90rZ1rMs/DRA6Jh+
         FO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795172370; x=1795777170;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lsuDl5Mn3UwB19cNkcSJlYu8KKq2fYppJdpOiWNy9qk=;
        b=STxCRcldmtSlAW03mpZ3paw4xAVJ2BLp5IyiF2oEFFKhu5RiW6eGSdo/CL2zDSHf42
         iEbcwhsNkSnhF3A19rrGrNUOsMaQAlMvVvPx1bsbWyy3gadAaZZABnd/x7MhrBT2s9sv
         N0jsMzQdz0FW9OmoOv4ZcrKQtBvp6lEE+6kDVxIjjNVgckfHLrrDW/wNOpDVx6e3it1F
         ZxxH9FtOl6rObfsWXoI1vitMro4Hlv9m63mbP+se3VaHzwH99M4/Ds6wo+eueoQVgUJi
         LSDP0+sqWpLUCtxlwMrRCtZskuzJ8z68Ab4dezn03Nv49mQN1BqAvwJZGpQh/XyG1j0k
         mp+g==
X-Forwarded-Encrypted: i=1; AL+hErFlnCNW32M8MUX4FA+TxUuYdgfUNUwu23qTE7nIo4FS4tSDQiqq87ChrLyPbjLwBBychJ0QxewM467VLg==@vger.kernel.org
X-Gm-Message-State: APuU4Z89UhjkwnaGNvpMR3bKl977YbrLWwFtP1Ut/KzaurRhriGr/Yq+
	UZhDeyNdKLT7kJJ5dgp2dZ3Bh/YFkv+fIpu/f4Rnh5RdxrBJWAPa3vST5Y63zhMn1Skb22Gvcp0
	dXCbl2M4/xpn4NpfR9u6TpFeS1rzoe50=
X-Gm-Gg: AZFdTZeBhcdZPV39CE1wzOOPwpELeeuWWU7Cq2XIgCPB1g1VUlx8skSL4wz0dQ9jlDN
	jgFUCDJYJddMf7o7h1FOAVdi/qvE6qsigOBOcaPLQnThylwSSA/Fsz71qZfDopTnoGBNiq1hVoR
	UcygwTy8yHPYI6P9tFU6J2C5xnFw7k36YAPeC8qUEaEeqAm/54Qgdqf7Z4IEaIJrAyHwEFCndFZ
	xxyPdeK0IN8SjjZyChUdaytVjNIPl3UKdFLY4QH7WdnwhJ/hvi/1C2ZoHeuisq1k9W8lW9iuMtz
	1beX77pmoDzEmsLV3HjmGQ79CuHeUIMEshTv7hbKCkUv+J0tIt/aedO3XqYbBBTiJjKKbP0zg1m
	VCA0Ft25CRb4Fbhw0AYJ3LpTuBHpOJYCCjaLc4AwL54plZcRpJYd/j7untKfYesQjOwGR
X-Received: by 2002:a05:6512:3187:b0:5c1:9752:4a4a with SMTP id
 2adb3069b0e04-5c1bc85a157mr752168e87.65.1795172369334; Fri, 20 Nov 2026
 02:59:29 -0800 (PST)
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
Date: Fri, 20 Nov 2026 18:59:15 +0800
X-Gm-Features: Aa3M54rmQkwWBhrijL1QXQXHklkFcgZIvs5-RQmIqvid1q9B1KJKQjJZfoZUeyk
Message-ID: <CAO-4RZ2pjEOpTBzqca5UxZHtaFS2Dj9zmNj1BtjvKm1yFE7_Jg@mail.gmail.com>
Subject: [BUG] INFO: task hung in nilfs_transaction_begin (fs/nilfs2/segment.c:221,
 v7.4-rc3)
To: konishi.ryusuke@gmail.com
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hi Ryusuke, Viacheslav,

We found a reproducible NILFS2 hang on v7.4-rc3 with syzkaller.  The
supplied recipe reproduced on independent fresh VMs.

Note: This hang may share the same underlying root cause as the
previously reported nilfs_segctor_thread hang (issue #182):
https://github.com/nilfs-dev/nilfs2/issues/182

Repository and reproducer:

  https://github.com/Zheng-zheng-codes/nilfs2-transaction-begin-hang
  commit f1065fd59515bd55bbb5141b45e979bc0b3c9993

Hung-task report
----------------

  INFO: task syz.7.24:13081 blocked for more than 142 seconds.
  task:syz.7.24        state:D stack:23176 pid:13081 tgid:13075 ppid:10344
  Call Trace:
   rwsem_down_read_slowpath
   __down_read
   down_read
   nilfs_transaction_begin+0x323/0xa00 fs/nilfs2/segment.c:221
   nilfs_write_begin+0x78/0x1b0 fs/nilfs2/inode.c:228
   generic_perform_write
   vfs_write
   ksys_write

A second thread of the same process (PID 13109) is blocked on the
f_pos_lock held by PID 13081.

An NMI backtrace of the semaphore holder (PID 13190) shows that it is
executing the NILFS2 segment-constructor path through
nilfs_clean_segments(), including btree/bmap propagation:

  nilfs_segctor_apply_buffers fs/nilfs2/segment.c:1010
  nilfs_collect_file_data fs/nilfs2/segment.c:589
  nilfs_bmap_propagate fs/nilfs2/bmap.c:329
  nilfs_btree_propagate fs/nilfs2/btree.c:2128

The lock dump identifies the semaphore holder:

  locks held by syz.7.24/13190: 3:
   #0: (sb_writers#17)                at: nilfs_ioctl_clean_segments
                                          fs/nilfs2/ioctl.c:869
   #1: (&nilfs->ns_segctor_sem) WRITE at: nilfs_transaction_lock
                                          fs/nilfs2/segment.c:357
   #2: (&bmap->b_sem)                 at: nilfs_bmap_assign
                                          fs/nilfs2/bmap.c:373

So a NILFS_IOCTL_CLEAN_SEGMENTS task is inside the segment-constructor
path, holding ns_segctor_sem for writing while doing bmap assignment,
and normal writers cannot acquire the semaphore for reading.  In this
report the segctord thread itself is not among the blocked tasks.

Relation to the earlier nilfs_segctor_thread hang
-------------------------------------------------

We previously reported a related NILFS2 hang:

  INFO: task hung in nilfs_segctor_thread (fs/nilfs2/segment.c:357, v7.4-rc3)
  https://github.com/nilfs-dev/nilfs2/issues/182
  https://github.com/Zheng-zheng-codes/nilfs2-segctor-thread-hang

Its hung-task report showed the constructor thread blocked acquiring
the same semaphore for writing:

  INFO: task segctord:35823 blocked for more than 183 seconds.
  task:segctord state:D
  Call Trace:
   rwsem_down_write_slowpath
   __down_write
   down_write
   nilfs_transaction_lock+0x25d/0x410 fs/nilfs2/segment.c:357
   nilfs_segctor_thread_construct fs/nilfs2/segment.c:2601 [inline]
   nilfs_segctor_thread+0x600/0xa60 fs/nilfs2/segment.c:2716
   kthread

The two reports involve different blocked tasks:

- In the earlier report, the segctord kernel thread waits
  for ns_segctor_sem in write mode in nilfs_transaction_lock().

- In this report, a normal file writer waits for the same
  semaphore in read mode in nilfs_transaction_begin().

In both reports, the lock dump identifies a task executing
NILFS_IOCTL_CLEAN_SEGMENTS as the semaphore holder.

The new external verification logs also repeatedly report:

  NILFS (loop0): error -28 cleaning segments

This resembles the repeated -ENOSPC errors observed in the
earlier report.

We suspect that both hangs may be manifestations of the same
GC error-handling problem, but the root cause has not yet
been established.

We would appreciate your analysis of this additional
reproduction alongside issue #182.

Reproduction
------------

  git clone https://github.com/Zheng-zheng-codes/nilfs2-transaction-begin-hang
  cd nilfs2-transaction-begin-hang

  # boot v7.4-rc3 with the supplied kernel config
  # using a Debian trixie x86_64 guest

  # in the guest, as root:
  syz-execprog -procs=1 -threaded -repeat=1 \
      -executor ./syz-executor \
      reproducer/repro.kernsight.prog

The recipe requires sequential execution with -procs=1.
Using -procs=8 did not reproduce the hang under our tests.

The recipe is a state-reconstruction sequence (72 replay programs plus
one model-selected priming program, followed by the crashing testcase).
The crash depends on the kernel state built by the recipe; the testcase
alone is not sufficient.

Verification:

- reproduction run: two attempts verified (confirmed=true,
  status=verified), 2026-11-20T07:17:00Z and 2026-11-20T08:05:31Z
- independent fresh-VM verification inside that run: 2/2 target hits
  (2026-11-20T07:46:46Z and 07:50:15Z)
- stability on fresh VMs: 5/5 reproductions, 187-194 s to the
  hung-task dump in every run (2026-11-20, external-verify/)
- evidence: reproducer/repro.outcomes.jsonl, external-verify/,
  logs/external-manager-session.log
- C reproducer: not generated; the syzkaller recipe is the primary
  reproducer

Kernel/guest details:

  kernel: v7.4-rc3, bzImage sha256
    0c16409f8aec508ac44a63e631c2bd352536401f3fd0856df1d839fb953a1882
  guest: Debian trixie x86_64, 6 GiB RAM, 4 vCPU, QEMU/KVM
  boot: oops=panic panic_on_warn=1 hung_task_panic=0
  config: CONFIG_KASAN=y, CONFIG_PROVE_LOCKING=y, CONFIG_NILFS2_FS=y

Thanks,
Zheng
