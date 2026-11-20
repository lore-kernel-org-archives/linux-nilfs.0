Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795173901;
	b=zaijVeGb6/iaGuTFxr9wpXjmMoe6JqXmBy/vlE4WsZFl/7ZTzXcRoEtgaxux19mXqhLa
	 8ueuhwZducfYAjK8XHPtsukLoqM7CQ3iHR3PkIDfzTrCZnaXQOUQjcOUpUt479bTjzjin
	 eOukxUfNreqoQAYAiTIfDV0hyyF0+PMzdUOb/ONrC7jFqmrGx0WcUeStz6zKqJMR5c7TD
	 baxzcqe2RhFJG6/E8UwZiAXFacWcExUOWQ8piLKiztAMnMiUkex3zxyxgP3hK4u/yGPkl
	 MBXS0yuHvGcREMXDJhuF/mpoIPuYSVg49zOPOMu7LJaWq9oG9t87vsfQPIZhitbdEnA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173901;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=QtxjPtWyAORLLdXxS1zO3pkCCQgK9BiQlfjTBORq21Y=;
	b=5COXNKa23Uqo5BptfES1djE3uVlAlrlP+HG4YFUH7yUpN/u7yeD1KS2v+Grrm7QtkDjz
	 HbTGqL/vsP4CIKyODD3Nw0iDHL/VOhRCN35ckxFObo2kf7Ay/Rm3lDF7Om6fmftiJiowR
	 l2XGaPRBeEA3O+r9YvszrsTzidBtyfuPUQwTzALR0KwK9QcPK+6cFGdtDA5svD5gvcou1
	 NYdeWXVQm4qXIUAzRMQf8NfEy7fKWHniY4Td37Slr0d/ezem1JWzy9v7WaZqFrcPig+5s
	 7OzSRwLaUyXRU+8tG6YvahHBSyjjFDJJ3A/3AyypzBPZ73xSrqNqXYlLJT9RH7XRN5w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZYX6o4lh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43713606A326
	for <linux-nilfs@vger.kernel.org>; Fri, 20 Nov 2026 11:25:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43713606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZYX6o4lh
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso5392535e9.2
        for <linux-nilfs@vger.kernel.org>; Fri, 20 Nov 2026 03:25:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795173899; cv=none;
        d=google.com; s=arc-20260327;
        b=D5JwwgbHq+/99aj/k20nBGCPSnVPFv2ml9gu1i1/jith04NhUvEl/AyOpksqpPARbE
         YKwfJq8c/yIhbtE9jMNhpiolr4jalJiKA05NHij/De+V+dgRQy1b/2dU0kt9AaQ0GU1O
         mkqB/GumHW/fHF5VRzyhuG1zGnIgN9d1B4gdk8bf9QnhNAr5xe8fPBcaX7L2LkGKRY+l
         jRzQYmz8QXfnduiibj0WoGwuRV84wZR39uznrOokIIduM2CynnEHEdugOCu2CQBMiAAI
         3/gmM55k3CFz/bcW4IxqbELCaxl+2HwQrh+0GsBbwFlx9XNZlvBxFpGdZPN9sgwiwO9A
         jUGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QtxjPtWyAORLLdXxS1zO3pkCCQgK9BiQlfjTBORq21Y=;
        fh=hJkfmWHvaG3kQfmQMPSp0bZK4XdqfqNYB00ahHQCGBo=;
        b=CliPiswSL/kikQBUf+yRWyCa/E+lYgBwb1JCRhMG0PzHQikhWJgIKyt2OwFnxEK216
         ZsxOnZ4WBmKU1F51G64lArciMbjL4JFjGgdpbYnoE8W165McV9+2sMWX3fhQtM36Gp2d
         OlhRgtTPNXkK9BbfceSaxZ7+IKnK/g06iuky6ngwA80dSHIFxtti1ftkRCzswRzSsxUD
         wbrdnD9XxH2/85R6t8wgM0S0S9kE9stOAH3uRVz/I2E8FG8fQS6nfphHjCSl9BcXhN8x
         uN9NinagenyGgFv31rhEhmygYZtTWpRs6K6LAsahV1jmkuR0K7gUii5lr08m2GVnKrDd
         U3ag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173899; x=1795778699; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QtxjPtWyAORLLdXxS1zO3pkCCQgK9BiQlfjTBORq21Y=;
        b=ZYX6o4lhmeOQeWdznHmyaZLd4Rk3J1q2E8T0FvsLzBqC+pq1lIlrU2+4AvMCIGLeMu
         jxmnizU2cQ9Tzf+9pS10mXnkYvswFAR9R3bdCi1aMqSwE0aPii7MgkJVGnHFrhP3dTpC
         eBFTWCnU9AL5MTVuE1YRMktGQrgUfd53U0srC2HXpAsvQXaGkAb/8nvB4yjdkYd+EgI4
         GROSDhXNN7DToDT4hHHK8li3OGFEkpmcfqkR2vuwZv56hZBhxl2tkBWNRc8uqMMFUey8
         OCh6jCqQPUe1IBG4m19xWs55VprqYxorlG2E8kqyb7RVa0IrtV50x+WR0j/0sAM8SfSX
         oBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173899; x=1795778699;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QtxjPtWyAORLLdXxS1zO3pkCCQgK9BiQlfjTBORq21Y=;
        b=lssksF8vYt3ZLtRNbi5hjoEAKEvoY6Qm/sNuoMWSkUZar2th552RgiEFdTJzfW3Dd2
         +xsi3casGwL3RQjUYgRX6wlH2BswgKW85JcKhrz7efmcg7r67gj3FiFPndafFBhDf1qs
         EI6NmFLS7cKCTm859KsJZWOFdJPnBcawQaRVs7JpaWFJ6sHbuEP0MO5E1z87ojqV0DTF
         6gCKO1UImThHyXlFcOHz4x9N4y54I1aPQcNS83jspeKpA+8n6R9ne5f/SbYf9dfdHgTi
         lyHHkxzyk0eoFFasIR3gRV1l1WTLQhll0y3Xmvyn3xxeWztq0gjywdI9Kx13L679sEhX
         1tnw==
X-Forwarded-Encrypted: i=1; AL+hErHGpdpWwoLQrz2f84EFri7W+mW5snVYk6ym7w3KWuZHzPgeUT+TPiU0rxsXApB/fLhotQywkaV5lwn/Vw==@vger.kernel.org
X-Gm-Message-State: APuU4Z8wFzNjgKUDao9WPlAchnYY9/KXz3shGZ5RD58675DLIQphnQnM
	3PnFZoZpNELZC7hDc/yxmOv1Age+8C+ifqjdIRzek7U9tfI39UXe3QKq1O/K3ixLFpLPv+tK7Ve
	7l8Ff7FDqQdJ7fyyYkrAdeJmg5lxLKlU=
X-Gm-Gg: AYBFou0zIW3N+FhlNTFw7od2Z9wEXOM3Y2bRDtNgZyY6eFdEW7BgIVs3uTVpT3LYtMH
	8rfdpikDWq1iXzARCQ2IO8tGqj1GY7D6k8IXzZRD6/pKGDJTyzGeJTQtBL9bMuKSSoN++PBchT+
	JUK6HgOT6UlEtEeVW71Ciz9jTRUCZ0NlcoKf25foHYMKoWLLu4ZfJ+BaeTfWH1dgBjAsYW/8cNP
	qTilfKEz+Ckjr/JEw3ppgPHOs2Fb+3LZDTF+qi8Z/FO2CD63kZLtK7OKenI6Pj6zLhSwvcHRXD8
	j7DlqSLfNG7Q8G9sOypJK2DJZpCjS1KFTMIvYoZk01xuu0Wchs75QU5k/x2W2ZZ14Qf82T+iXXJ
	rgywqZZA0Pojl09LRq4hqNa9dBDzDC1W5Ql5zAg==
X-Received: by 2002:a05:600c:a088:b0:4a2:1a:a120 with SMTP id
 5b1f17b1804b1-4bb8880ac02mr60110345e9.6.1795173898451; Fri, 20 Nov 2026
 03:24:58 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAO-4RZ2pjEOpTBzqca5UxZHtaFS2Dj9zmNj1BtjvKm1yFE7_Jg@mail.gmail.com>
In-Reply-To: <CAO-4RZ2pjEOpTBzqca5UxZHtaFS2Dj9zmNj1BtjvKm1yFE7_Jg@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 20 Nov 2026 20:24:39 +0900
X-Gm-Features: Aa3M54pngFl2bEEaSiGVCZXRR4_jUeP31-DZipStF-kFqq9kWuqVkgu-WIQdrq0
Message-ID: <CAKFNMokyeDzig1aJMjTN0nid4DGdnFPKC9G-xk3L30yMikgpRQ@mail.gmail.com>
Subject: Re: [BUG] INFO: task hung in nilfs_transaction_begin
 (fs/nilfs2/segment.c:221, v7.4-rc3)
To: Zheng Zheng <fengaojigui88@gmail.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 7:59=E2=80=AFPM Zheng Zheng wrote:
>
> Hi Ryusuke, Viacheslav,
>
> We found a reproducible NILFS2 hang on v7.4-rc3 with syzkaller.  The
> supplied recipe reproduced on independent fresh VMs.
>
> Note: This hang may share the same underlying root cause as the
> previously reported nilfs_segctor_thread hang (issue #182):
> https://github.com/nilfs-dev/nilfs2/issues/182
>
> Repository and reproducer:
>
>   https://github.com/Zheng-zheng-codes/nilfs2-transaction-begin-hang
>   commit f1065fd59515bd55bbb5141b45e979bc0b3c9993
>
> Hung-task report
> ----------------
>
>   INFO: task syz.7.24:13081 blocked for more than 142 seconds.
>   task:syz.7.24        state:D stack:23176 pid:13081 tgid:13075 ppid:1034=
4
>   Call Trace:
>    rwsem_down_read_slowpath
>    __down_read
>    down_read
>    nilfs_transaction_begin+0x323/0xa00 fs/nilfs2/segment.c:221
>    nilfs_write_begin+0x78/0x1b0 fs/nilfs2/inode.c:228
>    generic_perform_write
>    vfs_write
>    ksys_write
>
> A second thread of the same process (PID 13109) is blocked on the
> f_pos_lock held by PID 13081.
>
> An NMI backtrace of the semaphore holder (PID 13190) shows that it is
> executing the NILFS2 segment-constructor path through
> nilfs_clean_segments(), including btree/bmap propagation:
>
>   nilfs_segctor_apply_buffers fs/nilfs2/segment.c:1010
>   nilfs_collect_file_data fs/nilfs2/segment.c:589
>   nilfs_bmap_propagate fs/nilfs2/bmap.c:329
>   nilfs_btree_propagate fs/nilfs2/btree.c:2128
>
> The lock dump identifies the semaphore holder:
>
>   locks held by syz.7.24/13190: 3:
>    #0: (sb_writers#17)                at: nilfs_ioctl_clean_segments
>                                           fs/nilfs2/ioctl.c:869
>    #1: (&nilfs->ns_segctor_sem) WRITE at: nilfs_transaction_lock
>                                           fs/nilfs2/segment.c:357
>    #2: (&bmap->b_sem)                 at: nilfs_bmap_assign
>                                           fs/nilfs2/bmap.c:373
>
> So a NILFS_IOCTL_CLEAN_SEGMENTS task is inside the segment-constructor
> path, holding ns_segctor_sem for writing while doing bmap assignment,
> and normal writers cannot acquire the semaphore for reading.  In this
> report the segctord thread itself is not among the blocked tasks.
>
> Relation to the earlier nilfs_segctor_thread hang
> -------------------------------------------------
>
> We previously reported a related NILFS2 hang:
>
>   INFO: task hung in nilfs_segctor_thread (fs/nilfs2/segment.c:357, v7.4-=
rc3)
>   https://github.com/nilfs-dev/nilfs2/issues/182
>   https://github.com/Zheng-zheng-codes/nilfs2-segctor-thread-hang
>
> Its hung-task report showed the constructor thread blocked acquiring
> the same semaphore for writing:
>
>   INFO: task segctord:35823 blocked for more than 183 seconds.
>   task:segctord state:D
>   Call Trace:
>    rwsem_down_write_slowpath
>    __down_write
>    down_write
>    nilfs_transaction_lock+0x25d/0x410 fs/nilfs2/segment.c:357
>    nilfs_segctor_thread_construct fs/nilfs2/segment.c:2601 [inline]
>    nilfs_segctor_thread+0x600/0xa60 fs/nilfs2/segment.c:2716
>    kthread
>
> The two reports involve different blocked tasks:
>
> - In the earlier report, the segctord kernel thread waits
>   for ns_segctor_sem in write mode in nilfs_transaction_lock().
>
> - In this report, a normal file writer waits for the same
>   semaphore in read mode in nilfs_transaction_begin().
>
> In both reports, the lock dump identifies a task executing
> NILFS_IOCTL_CLEAN_SEGMENTS as the semaphore holder.
>
> The new external verification logs also repeatedly report:
>
>   NILFS (loop0): error -28 cleaning segments
>
> This resembles the repeated -ENOSPC errors observed in the
> earlier report.
>
> We suspect that both hangs may be manifestations of the same
> GC error-handling problem, but the root cause has not yet
> been established.
>
> We would appreciate your analysis of this additional
> reproduction alongside issue #182.
>
> Reproduction
> ------------
>
>   git clone https://github.com/Zheng-zheng-codes/nilfs2-transaction-begin=
-hang
>   cd nilfs2-transaction-begin-hang
>
>   # boot v7.4-rc3 with the supplied kernel config
>   # using a Debian trixie x86_64 guest
>
>   # in the guest, as root:
>   syz-execprog -procs=3D1 -threaded -repeat=3D1 \
>       -executor ./syz-executor \
>       reproducer/repro.kernsight.prog
>
> The recipe requires sequential execution with -procs=3D1.
> Using -procs=3D8 did not reproduce the hang under our tests.
>
> The recipe is a state-reconstruction sequence (72 replay programs plus
> one model-selected priming program, followed by the crashing testcase).
> The crash depends on the kernel state built by the recipe; the testcase
> alone is not sufficient.
>
> Verification:
>
> - reproduction run: two attempts verified (confirmed=3Dtrue,
>   status=3Dverified), 2026-11-20T07:17:00Z and 2026-11-20T08:05:31Z
> - independent fresh-VM verification inside that run: 2/2 target hits
>   (2026-11-20T07:46:46Z and 07:50:15Z)
> - stability on fresh VMs: 5/5 reproductions, 187-194 s to the
>   hung-task dump in every run (2026-11-20, external-verify/)
> - evidence: reproducer/repro.outcomes.jsonl, external-verify/,
>   logs/external-manager-session.log
> - C reproducer: not generated; the syzkaller recipe is the primary
>   reproducer
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

I have filed it separately at:
https://github.com/nilfs-dev/nilfs2/issues/183

Since these GC ioctl reports involve destructive corner cases that do
not occur under normal userland usage, we are addressing them
step-by-step at a pace that does not disrupt other tasks.

As these reports seem to stem from the same underlying error-handling
issues that I am about to investigate, it would be helpful if you
could hold off on further reports until the initial fixes land.  That
will help avoid duplicates and allow us to process the reports more
effectively.

Thanks,
Ryusuke Konishi
