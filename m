Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C12E3644C1
	for <linux-nilfs@vger.kernel.org>; Tue,  1 Sep 2026 15:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788275489; cv=pass; b=CXvVSVN+Iz5Ot8TptOAU8lB13OQtTJNEYm5onIrlhPzdmasAmeeQNzaPO3h/6EaKPuQSr5asCQgIMMAlYihX62nPxgY6E0yFZ5RrFzQGjZlIdgwnuKwEUbnovPOv6NlmhWHAtU7jl7eIxLdpz2OWaVOxyQlGsmS2PmrOXwJB/8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788275489; c=relaxed/simple;
	bh=PoiIHNTNx3lCGtWvtVOmy2CRdMbunTMo9WNj7vlPfNM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iJnf1J0VhzMGqDBgEWgqLkYXDkOebSUOn9Aik1fcQ9rmqF9aml7dcoKWCb7C6UziOFperNplTjcRRVsmRm8FYtmixX2yhaBaW4VKYZPnUKKBcEeUBmIllYD5PxJL7g3yDG5MWO77XlhwlT3LrbpDYoiWHFA3azEV2JWKlVeBfY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Td/H7Qms; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Td/H7Qms"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-39c86945164so41596561fa.1
        for <linux-nilfs@vger.kernel.org>; Tue, 01 Sep 2026 08:11:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788275485; cv=none;
        d=google.com; s=arc-20260327;
        b=LhzRFG7i/J18wqYNXMSToX/Znkdf8POflQiVYyqPW1IW8JMp5WzzAAw/G7qmtSdhTE
         11Iry5uK1KKIird85ibMkTShzwrVZvTfi/EL8ZETsd/GNMHUCLpkvt6mjsyY9TEBquXm
         1NJPOqQkffxf+VhD2cEVjzuBHGlzVNFrhnUXQ53D4fqtt/fJ9CMEmGSF8rzEB8ShWXkl
         gKEMSZaaqfOGh0q96zoq2x9FPqByjoXBMP7RdfrgFw4QaMtzjyfRfuNpAPyG7ysvzuCe
         HGXDAcOzceGUG0lp8jq5Xs4WFNvNms+YszSsnCLytbG3ijrGpJqXcxLA3z5PsIaXoFbj
         614g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sFjRf0xF3iW8uj2MA7nWCCbMBFUYzI0bHmQeVRyy12g=;
        fh=/QfGGxl/yLze9eHWJWIeq9bN54fuHv5kWFqcFS8KVwI=;
        b=TZ+I+w+Ov2wThJEE+hxvbpbnxzD1bR6qG5n00v0AK3X7aKdNUlnqswSn/+bbg3Tn5l
         xrYLoRyC8RymrR/oR0+itHApskzmA44h0PrkHeF6nUMjgHU1AEk1tWBDvpfEx+OZsHmw
         hvVSGuTCykDSnnkR6P3x3bQaU6Fa91FNrHiHnrYmnyp5VmFfDg78UoaBHVSms4GKDywo
         hT1JIGCdPjYwjp67e/DvNMuu5OwKG/o62U4w2tTZz6+Ua6kIl/wclkxGQfsm+d8bq2MH
         7Q82V1dRHF2ryOP6dkUG8myZ1lyvteS55F+EHyyGkhpmTuO1p9EUfh9cny0jyVPA+xAd
         tjmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788275485; x=1788880285; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sFjRf0xF3iW8uj2MA7nWCCbMBFUYzI0bHmQeVRyy12g=;
        b=Td/H7QmsItu2FCNzoejtLsBOIjrpSQq1VzYG8/SZrj1q2Hj9eEB1FMEoqXGbx2pcLx
         hSmLfGTVf9lTt9rmKoiJGJbra0pZh9mH8AxxiAOdNDP5yupkAvbb6fqwIM0niLD2qSjf
         4VmfjVZzEYW1Lpm7XxI3z5t8QoQUEWEC2q2P4awZkDsUVTq3dl21wLzFMkxJWRKSAyw2
         zSg4X3d0Vxy9O+WQEGc4lyYu5htGfF0WAgLnCg5OslkKpjH940z9UWNokeENU2/5KVbj
         GvcyIPuQdL8GSHP9spyAYQbmbImGPjL5f08qYm7yqJktrAVuzPbGXqKTU+xjNRHK1hzX
         7bLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788275485; x=1788880285;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sFjRf0xF3iW8uj2MA7nWCCbMBFUYzI0bHmQeVRyy12g=;
        b=gZMkbBqgfuYYU+SFCm0ooZjj3pZ4uFU72z8+2q7hmHIiOAwWvCQhJ3bWgYKZXCwYti
         0w8QCRTH7Gy9PR8igcZXSvxxI0HiS6vrZlC1JI6lzWPM+EQdl4y/Tovbe8+0tQHQ8MVE
         XOUeErhEzEY3WzTIHETGRl8TADjEQusgXhtDmidlhrbdvYxVH3ij9k9ShqWsx+wBqyT+
         CccQKgxhuvAz7W0M4sxfQd3ugv8Ai7e9clOOv/Q2T8buONfYUzmBSQyrc8yMUQMl+HGQ
         pCRx5ziLj+jwYIwANOVPsbOIpYuJJTXYwU2g6WmWPfJ/0v9prtwst137WLGUp8szCLhF
         oitA==
X-Gm-Message-State: AFuF++n2HZ26CbQku144wqX44XEW+MlHa/iRVOa0LCtZA+S9ZaYf7//h
	ZAX22IIThHAi4V+Hu/yvdOZOMxe3Rno29TUxhUgGbnjX1Bmy4QV38fME6GxMHQAvuElVQRmTJ4F
	7sdtpyQhNAM5TJvOlQK8Awym8XvCyOLs=
X-Gm-Gg: AYBFou2HWVnjsnyjS+6XUdILxmKIbw6no/Vovsiyxnwe2k74LgpPdifvIgBehorUZFv
	PyNvQDo2cmL5RnhkAHigAfPxCxw5pNf8fM0hUz5hgJ5ktl6hmeZAjLAsLGnCmhtU0zbLSWc37Wl
	rmmqXqmDsv9ov9E0y+YiAXHk82lyrqXidZjn77WFeK5QYKbnGzdrG1jOI4r0IS2s49RF3nXkfOk
	Hfi/odfgnXi+Apj4RO1zeye0tHSympZ7UEVPuN0jU3YtHoDw+Jbs8XRCYJCrKXI+B+V/F3z/otZ
	yhXvSyxWvXxZViJXuVqWex0zjzvI6tg52v6R1TDZXMJRgA==
X-Received: by 2002:a05:651c:25c3:20b0:39c:8124:93b3 with SMTP id
 38308e7fff4ca-3a301abb8d2mr63332481fa.9.1788275484825; Tue, 01 Sep 2026
 08:11:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANypQFZSYrtcshnUzOPiqatyLd-M8_OReOewQoAi_V5yY0dTtg@mail.gmail.com>
In-Reply-To: <CANypQFZSYrtcshnUzOPiqatyLd-M8_OReOewQoAi_V5yY0dTtg@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 2 Sep 2026 00:11:08 +0900
X-Gm-Features: AcwNN1Xt3qzMpz1uwXHvgZu6Fu-sp-6BPaodXbIgqPit6ohsCuwA064TimxMg8Q
Message-ID: <CAKFNMo=GevQ+76gNdPvaQf4rP7=UbiPipRYj6BD3tCaSYj_hcQ@mail.gmail.com>
Subject: Re: [Linux Kernel Bug] WARNING in nilfs_copy_back_pages
To: Jiaming Zhang <r772577952@gmail.com>
Cc: linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 9:58=E2=80=AFPM Jiaming Zhang wrote:
>
> Dear Linux kernel developers and maintainers,
>
> We are writing to report an issue discovered in the NILFS2 subsystem.  Th=
e
> issue is reproducible on the latest version of linux (v7.3-rc1, commit
> cee9395acd8043be0644b25c34bfa86623f2b935).  Below is the kernel report:
>
> NILFS (loop0): error -2 preparing GC: cannot delete virtual blocks from D=
AT file
> ------------[ cut here ]------------
> folio_test_dirty(dfolio)
> WARNING: fs/nilfs2/page.c:331 at nilfs_copy_back_pages+0x639/0x810
> fs/nilfs2/page.c:331, CPU#0: syz-executor887/9521
> Modules linked in:
> CPU: 0 UID: 0 PID: 9521 Comm: syz-executor887 Not tainted 7.3.0-rc1
> #37 PREEMPT(full)
> Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
> 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:nilfs_copy_back_pages+0x639/0x810 fs/nilfs2/page.c:331
> Code: 44 89 fe e8 39 8e 12 fe 45 84 f6 74 25 e8 9f 8a 12 fe 48 89 df
> e8 67 9a 55 fe 4c 8b 7c 24 10 e9 e5 fe ff ff e8 88 8a 12 fe 90 <0f> 0b
> 90 e9 1d fe ff ff e8 7a 8a 12 fe 4c 8b 7c 24 10 e9 c8 fe ff
> RSP: 0018:ffffc9000854f4c0 EFLAGS: 00010293
> RAX: ffffffff83a8e928 RBX: ffffea00013cf3c0 RCX: ffff888026619f80
> RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000000
> RBP: ffffc9000854f6e8 R08: ffffea00012db607 R09: 1ffffd400025b6c0
> R10: dffffc0000000000 R11: fffff9400025b6c1 R12: ffffc9000854f548
> R13: ffffea00012db600 R14: 0000000000000010 R15: 1ffffd4000279e79
> FS:  000055558d08a380(0000) GS:ffff8880985d9000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055558d08aca0 CR3: 0000000044f02000 CR4: 0000000000752ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  nilfs_mdt_restore_from_shadow_map+0x127/0x260 fs/nilfs2/mdt.c:652
>  nilfs_clean_segments+0xab8/0xba0 fs/nilfs2/segment.c:2552
>  nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:938 [inline]
>  nilfs_ioctl+0x242a/0x2590 fs/nilfs2/ioctl.c:1368
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x170/0x540 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa00bf4d42d
> Code: b3 66 2e 0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd36ab1678 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fa00bf4d42d
> RDX: 0000200000000300 RSI: 0000000040786e88 RDI: 0000000000000004
> RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffd36ab16c0
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd36ab169c
> R13: 00007ffd36ab16e0 R14: 000000000000000c R15: 431bde82d7b634db
>  </TASK>
>
> Following is the root cause analysis for this issue, note that the
> analysis is performed with the assistance of LLM, but we try our best to
> ensure the accuracy.
>
> The WARNING triggers because a folio of the DAT metadata file is still
> dirty where nilfs_copy_back_pages() expects a clean one.  That function
> runs when garbage collection fails, which the reproducer causes by asking
> it to free a virtual block number the DAT file does not map.  nilfs2 then
> restores the DAT page cache to a snapshot taken before the collection
> started: it first clears the dirty state of the folios in that cache, the=
n
> copies the snapshot back over them, assuming the first step left nothing
> dirty.
>
> The clearing step can skip a folio.  Since commit ca76bb226bf4 ("nilfs2: =
do
> not force clear folio if buffer is referenced") nilfs_clear_folio_dirty()
> returns without clearing if any buffer head of the folio is busy, to avoi=
d
> clobbering the state of a buffer somebody else is using.  A buffer head i=
s
> busy here: reading a metadata block goes through nilfs_mdt_read_block(),
> which also submits read-ahead for the blocks that follow and waits only f=
or
> the first.  When the block size is smaller than the page size, several
> metadata blocks share one folio, so a locked read-ahead buffer can be
> adjacent to a dirty buffer and keep the whole folio dirty.
>
> nilfs_copy_folio() then copies the snapshot over that folio and clears
> BH_Dirty on all of its buffer heads, leaving the folio dirty with no dirt=
y
> buffer under it, which no later segment construction cleans up.  On a
> kernel booted with panic_on_warn, the WARNING can lead to a system crash.
>
> To fix this issue, the dirty flag of the destination folio should be
> cleared before the folio is overwritten:
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index cf4f1c6798f5..b26d9c3bda6d 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -328,7 +328,8 @@ void nilfs_copy_back_pages(struct address_space *dmap=
,
>   dfolio =3D filemap_lock_folio(dmap, index);
>   if (!IS_ERR(dfolio)) {
>   /* overwrite existing folio in the destination cache */
> - WARN_ON(folio_test_dirty(dfolio));
> + if (unlikely(folio_test_dirty(dfolio)))
> + __nilfs_clear_folio_dirty(dfolio);
>   nilfs_copy_folio(dfolio, folio, false);
>   folio_unlock(dfolio);
>   folio_put(dfolio);
>
> After applying the above patch, the reproducer no longer triggers the iss=
ue
> on our machine.  If this solution is acceptable, we are happy to submit a
> formal patch.
>
> The kernel console output, kernel config, syzkaller reproducer, and C
> reproducer are available at google drive:
> https://drive.google.com/drive/folders/1R6EqqLPh5vgylKRPvO2ji5Q8Tsf0x8QY?=
usp=3Dsharing
>
> Please let us know if any further information is required.

Thanks for the report, Jiaming Zhang!

I think the issue is that commit ca76bb226bf4 changed the expected
behavior of nilfs_clear_dirty_pages(), which is called before
nilfs_copy_back_pages().

Originally, nilfs_clear_dirty_pages() was implemented for
nilfs_mdt_restore_from_shadow_map() to restore the pre-GC state from
the DAT shadow page cache. It was designed to forcefully clear dirty
pages/folios in the DAT page cache, assuming complete synchronization
with the log writer.

However, over time, it started being called to resolve page/folio
dirty states when the filesystem degrades to read-only during a
page/folio writeback request.

Since this page/folio dirty state clearing was asynchronous with the
log writer, it caused unpredictable bugs in various places after the
filesystem fell back to read-only. Commit ca76bb226bf4 is one of the
essential workarounds introduced to avoid this.

The root cause is that the same helper function is being used for
calls with two entirely different premises. I believe the solution is
to restore the original semantics of nilfs_clear_dirty_pages() only
when it is called from nilfs_mdt_restore_from_shadow_map().

Specifically, how about adding a bool force flag argument to
nilfs_clear_dirty_pages() and nilfs_clear_folio_dirty(), and having
the call from nilfs_mdt_restore_from_shadow_map() set this flag to
clear the dirty state regardless of the buffer head's reference state,
just like the original implementation?

Would it be possible for you to propose a fix using this approach?

Alternatively, since their premises differ, we could separate the
implementations entirely, but I expect that adding a boolean option to
switch modes would be simpler.

Adjusting the WARN_ON in nilfs_copy_back_pages() would break the
original design (premise) and is therefore undesirable, in my view.

Thanks,
Ryusuke Konishi

>
> Best Regards,
> Jiaming Zhang
