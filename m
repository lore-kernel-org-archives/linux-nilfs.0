Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB9C3BB107
	for <linux-nilfs@vger.kernel.org>; Tue,  1 Sep 2026 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788267529; cv=pass; b=rTHTl+q9A3lf3ZqupAnMSKUw6YoXWb22/ir3Knyun6U1FolcPWIBr9YZMPnCYlYgqkT4m1OcxCPPf90Au5MQLkNkBcXVqDs7Ci7uZxe15UUlQM3KK9lrWN8dIZLibcytTYBnkEVTvKHxFk+BgCNDkU3kKMRZ93ahXCUDvsmNT0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788267529; c=relaxed/simple;
	bh=WipR2M4O5BIyzHTb1X+UXEURWas1FXporpkv4RC0MNs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=P2h7vx8ggF+q9QlYKWr/5E+MoZndlMRrUonJpMa4dTr4w0LT6yE6Gip7hOnN1i6HjOhXWs2xtmY0fMy6dQtakNUawAfVW89VxNilXETxogxU4fpCzAx6BTED+vjPnWaFc4A8VoZyna/NXISlVkrSq2H3DWfRCp4DKqy1nvgZJKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4U1O+Lk; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4U1O+Lk"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c252e703fa3so691242866b.3
        for <linux-nilfs@vger.kernel.org>; Tue, 01 Sep 2026 05:58:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788267525; cv=none;
        d=google.com; s=arc-20260327;
        b=KbmUrWMxILyKPn5Zrgiv4teBCJeWyh8TvZTrVU8A4OPt4mLkQicwqltlDLr8btBLf7
         sIqyoGpVNva9HsddKCaL2ec723JQ67H02SSuIHMFfx+7s2ix5AJ3OmhXAMu2NbAVPw+5
         cDEwcLflez1nEFrxlJaZsNimuGkVMvPrNcMtquGUPCjM5N9QFREkvCr8sGyx6aRPG1Ef
         dYM7Eh6v4Yc2M5Hzk5dFAyQSqyhGG8WGoBhOBv2HY/W6m5FyUMIohavKDNabdzj490Y0
         texIKt+YBgaZgop8PVI+O5a21lakTRjCSOgXdkFpOSCUoi5t31qUNW40SHeJyO5VLKrM
         B8PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=LWjUX8zzx7+LNLmCs+ajPIDalfcCAkREkOUTkWSj5Jw=;
        fh=tGvqu+CrziTQBo4UtOzCwIXTxa/5ed8rUWFSvyf3LmU=;
        b=ppLKdBAxBIl+QOq5gvOYwfoLJjbowUUY05Jsa/Nictl1ug18OM6znypxAwj93gPg1c
         1q207q+vJ6xastmBp/Cnfy9LdnmjMDFfUT4YoyAjcVtwKOTp2Ydp4Zjs2FoRFLC/YiOk
         jIF2TU7akIe9Hgv2Fb5Kn5mWu5gdjiaSs46lUJHFgPb9rJcNgrabpr26JAEMGmg2oibj
         lU5LLJNh0PBzJaOw6NILlU9ndaGxI1zSDMKd/rdzpk77fjzIH7Oz1vnmUCpg41Pth8hT
         J8OfQGbzBbBB3Yn5VRv4QLL/niAwBhfKvL9dXzGvb/ChI5zvQLbII5ZNQxlhPA9Ho9Dy
         gopA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788267525; x=1788872325; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LWjUX8zzx7+LNLmCs+ajPIDalfcCAkREkOUTkWSj5Jw=;
        b=m4U1O+LkXi/EuruMagkkoAyBlzhCpYXYdAexpDkHxSLdZUh5Cz0QD/SRnGq+BvBiec
         O05O6+h5T2ab/LwUCXKb773Mj6Rop2xO3eN+xxMXxJ+TvW5xToe0CilPwawj+79LIvNP
         iezcj4vjWuYaFieVO6uWBnJKnp1jfs48CwYBOzxEMvge+LVSbPoOoPnQRuRlSOGrbwWm
         kMserDvUa9iyoH31U7425TlkYYE3XJS2pw2ZbgTwaTSuGovsVgyY7G9PjW8KKWx3wnkg
         uvNZs1eZeTEQhA5PCdY+LRfEM1s6kUQddA6ONmMpvTZPGUJNghpxe1kgQ5CO8sxshYB5
         arAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788267525; x=1788872325;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LWjUX8zzx7+LNLmCs+ajPIDalfcCAkREkOUTkWSj5Jw=;
        b=gswHb5h3uShekgCGZ6a9z9hYyyo/Ne6LGK+MQr4zqgwxELj5RKlWoZIPTaLgkJY1n2
         pYBewkmhdnNXfauXP9GfRln4vliMULeHzMhh3qrTuq6SqmrWIidMlEjxdJv8ZbFGzfhm
         FQ6ixaj7Ce1JwRulJAlvcTdB8tWBCxUexIJc/8mjjYCv3U28PGzDYqty+xsJMrPrlIOq
         xHc8WarhV1hXixE+iGR43uPqdz4FMWtVovWQnsJqxeXulD0LO3EUQ8uV/pG02Ib0RGQU
         y3o1BN2FLcJqA8KyQ7cMj0MdBdBqz/p9P5VpaSaJ6dmc08LIuuwSN0YuGu0LKjXrosnK
         fg0A==
X-Forwarded-Encrypted: i=1; AHgh+Rrd+14E94tGEA6dWgY9ru5bGpsCNlPPSMwriYrBjJomvxDHqeNB5YfjZ5jBH2oZrKpl2ooDgPvCNSqxuw==@vger.kernel.org
X-Gm-Message-State: AFuF++m4tBEU6SYefwlNN/mnln3vj1BxmZOr+rLP9P5QpYdHoUIkH7a8
	j4XYFxCxJaNfzfIMcTx6O+8fXsJ5QeaZut1sOoQXoERx/x1/8Id0J6NHw7vXLBXGoVB23wpGvdM
	s7XBRjanYRDrSpG6jvGNUfhdf0RChSSo=
X-Gm-Gg: AR+sD10nu0BqAbdqu+KY9YzerHG4gKxsKXdBa1HHOIzR9b3W9tX3JwLrSn2uYUUU+Va
	qfsH8txxN7ov+hpNn2CzZyytnkf7lKcOAbdkSmvW12Oln+0AxyCdswtxHrArUXLGmoBJUnA/MZe
	sJonIoUF9yRgBO3cNuVQUvKnikxFrSgCMV+PIRPZiW6d49nX2pUVZK0i8xNapNR5xUaM/AyLRZ9
	jOiUmC5oNYaMKOqk0OlITC75x+51IFxsd46HoZzJgg4e37uQDfoAuFCPVuP6ylCIq4PuTGg4CO8
	pPFRLqoZe3PHca/vtesjFM4ixu236+LRHqi0Mo+5kRaDYcbDXuyaz9DD
X-Received: by 2002:a17:907:7baa:b0:c25:8e4f:6d84 with SMTP id
 a640c23a62f3a-c25b3affeb5mr562311666b.2.1788267524998; Tue, 01 Sep 2026
 05:58:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jiaming Zhang <r772577952@gmail.com>
Date: Tue, 1 Sep 2026 20:58:07 +0800
X-Gm-Features: AcwNN1VB_ENk6kWI8lv4Ys3icAn6OwQkUGv924isugtWz0GLqJr07xczjt02Gok
Message-ID: <CANypQFZSYrtcshnUzOPiqatyLd-M8_OReOewQoAi_V5yY0dTtg@mail.gmail.com>
Subject: [Linux Kernel Bug] WARNING in nilfs_copy_back_pages
To: konishi.ryusuke@gmail.com, linux-nilfs@vger.kernel.org, slava@dubeyko.com
Cc: linux-kernel@vger.kernel.org, syzkaller@googlegroups.com, 
	r772577952@gmail.com
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel developers and maintainers,

We are writing to report an issue discovered in the NILFS2 subsystem.  The
issue is reproducible on the latest version of linux (v7.3-rc1, commit
cee9395acd8043be0644b25c34bfa86623f2b935).  Below is the kernel report:

NILFS (loop0): error -2 preparing GC: cannot delete virtual blocks from DAT file
------------[ cut here ]------------
folio_test_dirty(dfolio)
WARNING: fs/nilfs2/page.c:331 at nilfs_copy_back_pages+0x639/0x810
fs/nilfs2/page.c:331, CPU#0: syz-executor887/9521
Modules linked in:
CPU: 0 UID: 0 PID: 9521 Comm: syz-executor887 Not tainted 7.3.0-rc1
#37 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:nilfs_copy_back_pages+0x639/0x810 fs/nilfs2/page.c:331
Code: 44 89 fe e8 39 8e 12 fe 45 84 f6 74 25 e8 9f 8a 12 fe 48 89 df
e8 67 9a 55 fe 4c 8b 7c 24 10 e9 e5 fe ff ff e8 88 8a 12 fe 90 <0f> 0b
90 e9 1d fe ff ff e8 7a 8a 12 fe 4c 8b 7c 24 10 e9 c8 fe ff
RSP: 0018:ffffc9000854f4c0 EFLAGS: 00010293
RAX: ffffffff83a8e928 RBX: ffffea00013cf3c0 RCX: ffff888026619f80
RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000000
RBP: ffffc9000854f6e8 R08: ffffea00012db607 R09: 1ffffd400025b6c0
R10: dffffc0000000000 R11: fffff9400025b6c1 R12: ffffc9000854f548
R13: ffffea00012db600 R14: 0000000000000010 R15: 1ffffd4000279e79
FS:  000055558d08a380(0000) GS:ffff8880985d9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055558d08aca0 CR3: 0000000044f02000 CR4: 0000000000752ef0
PKRU: 55555554
Call Trace:
 <TASK>
 nilfs_mdt_restore_from_shadow_map+0x127/0x260 fs/nilfs2/mdt.c:652
 nilfs_clean_segments+0xab8/0xba0 fs/nilfs2/segment.c:2552
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:938 [inline]
 nilfs_ioctl+0x242a/0x2590 fs/nilfs2/ioctl.c:1368
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x170/0x540 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa00bf4d42d
Code: b3 66 2e 0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd36ab1678 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fa00bf4d42d
RDX: 0000200000000300 RSI: 0000000040786e88 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffd36ab16c0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd36ab169c
R13: 00007ffd36ab16e0 R14: 000000000000000c R15: 431bde82d7b634db
 </TASK>

Following is the root cause analysis for this issue, note that the
analysis is performed with the assistance of LLM, but we try our best to
ensure the accuracy.

The WARNING triggers because a folio of the DAT metadata file is still
dirty where nilfs_copy_back_pages() expects a clean one.  That function
runs when garbage collection fails, which the reproducer causes by asking
it to free a virtual block number the DAT file does not map.  nilfs2 then
restores the DAT page cache to a snapshot taken before the collection
started: it first clears the dirty state of the folios in that cache, then
copies the snapshot back over them, assuming the first step left nothing
dirty.

The clearing step can skip a folio.  Since commit ca76bb226bf4 ("nilfs2: do
not force clear folio if buffer is referenced") nilfs_clear_folio_dirty()
returns without clearing if any buffer head of the folio is busy, to avoid
clobbering the state of a buffer somebody else is using.  A buffer head is
busy here: reading a metadata block goes through nilfs_mdt_read_block(),
which also submits read-ahead for the blocks that follow and waits only for
the first.  When the block size is smaller than the page size, several
metadata blocks share one folio, so a locked read-ahead buffer can be
adjacent to a dirty buffer and keep the whole folio dirty.

nilfs_copy_folio() then copies the snapshot over that folio and clears
BH_Dirty on all of its buffer heads, leaving the folio dirty with no dirty
buffer under it, which no later segment construction cleans up.  On a
kernel booted with panic_on_warn, the WARNING can lead to a system crash.

To fix this issue, the dirty flag of the destination folio should be
cleared before the folio is overwritten:

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index cf4f1c6798f5..b26d9c3bda6d 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -328,7 +328,8 @@ void nilfs_copy_back_pages(struct address_space *dmap,
  dfolio = filemap_lock_folio(dmap, index);
  if (!IS_ERR(dfolio)) {
  /* overwrite existing folio in the destination cache */
- WARN_ON(folio_test_dirty(dfolio));
+ if (unlikely(folio_test_dirty(dfolio)))
+ __nilfs_clear_folio_dirty(dfolio);
  nilfs_copy_folio(dfolio, folio, false);
  folio_unlock(dfolio);
  folio_put(dfolio);

After applying the above patch, the reproducer no longer triggers the issue
on our machine.  If this solution is acceptable, we are happy to submit a
formal patch.

The kernel console output, kernel config, syzkaller reproducer, and C
reproducer are available at google drive:
https://drive.google.com/drive/folders/1R6EqqLPh5vgylKRPvO2ji5Q8Tsf0x8QY?usp=sharing

Please let us know if any further information is required.

Best Regards,
Jiaming Zhang
