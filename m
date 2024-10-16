Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B091D31B8
	for <linux-nilfs@vger.kernel.org>; Wed, 16 Oct 2024 08:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729066410; cv=none; b=gXWWpHAGDLGtqorhVRkSKJqLY4IUqqPNv2hZXl1yJJGu6jx/H8HxtaK/SChKAK9S20oLB054mqOu1EANCauR9ewu5StT9ldIpCooUtWxMrg4HBCM5TJ2+MZ+WmALUP1YAD517nu8etdo5uoZgFgBR5TqwDvsSEDiMqpgZne9BC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729066410; c=relaxed/simple;
	bh=w8Tk4n705nNyRW1xbeYWx1LNcuN+LVsr40rj16oNIgY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=RctY2TGSv26lyRQVyWhTSRVsrZ7sQEZ3p20BPfV08YrSqq/PcMXhjif1V29dQ+5lxyngRLHoGXHGbi2uDcmAdpgapPCoOVV5lNetAw49ceiP/erWCCiFnfMmnltfKnQ+C4t3nhI3Di89GnBJJwOY7Cb0OX2gsQueHuRU0M2WwhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3b7b13910so71638995ab.1
        for <linux-nilfs@vger.kernel.org>; Wed, 16 Oct 2024 01:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729066407; x=1729671207;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TVIN2neW1jgQWowjU/CpjfwI82Py+nPYyy5JLOE84dw=;
        b=ANq0WgjhN9+P6EPguo7dpxSVfvKpUsc2co2IGj7DX5uazaQXXh+XvMxLlACVTdnpQt
         Dy0f1S9G/1YR3ofjEXjWYLXY9m6Fj5R175owd+f4Anl3Ka1nn/ksBusJY3vum2wAMLNi
         Sq77HEAPJ/2PIDsHttacxRiSQ/Aq75VwS3JtntpL+msnr7eFnXbERifFrSAP67QBLpT3
         O45fWBb9aW+nv6lTeSLq0LMU8WRFzVOevqLTuKGIyJZsDn7XrridEVtDR2nlWHplZecJ
         kV9EOmFqpl4/SJKIVV6XM4IR61JP7RsiSc61j4Vv3zNTrGdHSmGhi+Z0Uto2IaNVNQLc
         d0fA==
X-Forwarded-Encrypted: i=1; AJvYcCWo79GSKUJCMJXEXIvuHPDiLvn43+V4DvQP1Tq46ki2v4rSxrFh+9CQxYyz5+V5kxlQ1j/diJ6sOXgDfw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkGKhSomlgqwqcF+z5w9y60NAW+QrJ5xkwaRJuxyFaD2zImr0e
	D6+CZRsbmZFWsK+4pxJ+z8c97HbGcGGl6dohV536zZdA+zp8bWQhxai9PXI7k9HD1yM+3DmXrAH
	st9dlHypQct6juWBB+Xq5b7xsw7k2YkDy/aelVp173pSmcj3Tye7yga8=
X-Google-Smtp-Source: AGHT+IGEkbTu4HvABtbwo2ctd33R+ZFnfY+GUCIJp9HuOU1G5ox+GqscgRFLe+uOiFr4mHVDDcaFOJoP9kOsrKI75NYGLPQ5iuB3
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170a:b0:3a0:b471:9651 with SMTP id
 e9e14a558f8ab-3a3dc4fba9cmr27682495ab.24.1729066407385; Wed, 16 Oct 2024
 01:13:27 -0700 (PDT)
Date: Wed, 16 Oct 2024 01:13:27 -0700
In-Reply-To: <670cb3f6.050a0220.3e960.0052.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670f75a7.050a0220.d5849.0014.GAE@google.com>
Subject: Re: [syzbot] [nilfs] [fs] kernel BUG in submit_bh_wbc (3)
From: syzbot <syzbot+985ada84bf055a575c07@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, konishi.ryusuke@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2f87d0916ce0 Merge tag 'trace-ringbuffer-v6.12-rc3' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1773b727980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=985ada84bf055a575c07
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10015030580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-2f87d091.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2704ba6867a8/vmlinux-2f87d091.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9f7121fd532b/bzImage-2f87d091.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/51d4ae79614c/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+985ada84bf055a575c07@syzkaller.appspotmail.com

NILFS error (device loop0): nilfs_check_folio: bad entry in directory #12: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
NILFS (loop0): unable to write superblock: err=-5
Remounting filesystem read-only
NILFS error (device loop0): nilfs_readdir: bad page in #12
------------[ cut here ]------------
kernel BUG at fs/buffer.c:2785!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5210 Comm: syz-executor Not tainted 6.12.0-rc3-syzkaller-00044-g2f87d0916ce0 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:submit_bh_wbc+0x556/0x560 fs/buffer.c:2785
Code: 89 fa e8 1d d9 d1 02 e9 95 fe ff ff e8 f3 72 71 ff 90 0f 0b e8 eb 72 71 ff 90 0f 0b e8 e3 72 71 ff 90 0f 0b e8 db 72 71 ff 90 <0f> 0b e8 d3 72 71 ff 90 0f 0b 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000253f618 EFLAGS: 00010293
RAX: ffffffff82237475 RBX: 0000000000000154 RCX: ffff888000800000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000000
RBP: 0000000000000100 R08: ffffffff82237039 R09: 1ffff1100639095c
R10: dffffc0000000000 R11: ffffed100639095d R12: 0000000000000000
R13: ffff888031c84ae0 R14: 0000000000000000 R15: 1ffff1100639095c
FS:  0000555563876500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fddb347fb98 CR3: 00000000566ca000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 submit_bh fs/buffer.c:2824 [inline]
 block_read_full_folio+0x93b/0xcd0 fs/buffer.c:2451
 do_mpage_readpage+0x1a73/0x1c80 fs/mpage.c:317
 mpage_read_folio+0x108/0x1e0 fs/mpage.c:392
 filemap_read_folio+0x14b/0x630 mm/filemap.c:2367
 do_read_cache_folio+0x3f5/0x850 mm/filemap.c:3825
 read_mapping_folio include/linux/pagemap.h:1011 [inline]
 nilfs_get_folio+0x4b/0x240 fs/nilfs2/dir.c:190
 nilfs_readdir+0x1b3/0x7d0 fs/nilfs2/dir.c:251
 iterate_dir+0x571/0x800 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:407 [inline]
 __se_sys_getdents64+0x1d3/0x4a0 fs/readdir.c:392
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5be9db0193
Code: c1 66 0f 1f 44 00 00 48 83 c4 08 48 89 ef 5b 5d e9 42 43 f8 ff 66 90 b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 c7 c2 a8 ff ff ff f7 d8
RSP: 002b:00007ffe94f96358 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
RAX: ffffffffffffffda RBX: 0000555563899640 RCX: 00007f5be9db0193
RDX: 0000000000008000 RSI: 0000555563899640 RDI: 0000000000000006
RBP: 0000555563899614 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000293 R12: ffffffffffffffa8
R13: 0000000000000016 R14: 0000555563899610 R15: 00007ffe94f996f0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:submit_bh_wbc+0x556/0x560 fs/buffer.c:2785
Code: 89 fa e8 1d d9 d1 02 e9 95 fe ff ff e8 f3 72 71 ff 90 0f 0b e8 eb 72 71 ff 90 0f 0b e8 e3 72 71 ff 90 0f 0b e8 db 72 71 ff 90 <0f> 0b e8 d3 72 71 ff 90 0f 0b 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000253f618 EFLAGS: 00010293
RAX: ffffffff82237475 RBX: 0000000000000154 RCX: ffff888000800000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000000
RBP: 0000000000000100 R08: ffffffff82237039 R09: 1ffff1100639095c
R10: dffffc0000000000 R11: ffffed100639095d R12: 0000000000000000
R13: ffff888031c84ae0 R14: 0000000000000000 R15: 1ffff1100639095c
FS:  0000555563876500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fddb347fb98 CR3: 00000000566ca000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
