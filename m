Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F70364052
	for <linux-nilfs@vger.kernel.org>; Mon,  5 Oct 2026 19:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791229899; cv=none; b=GQbBb3zDMAi41cDb94RZEREInK9Z7L+vtL2wZSFy98alxVd85WLwPFMB/YLwGr5vd6P4m9wJk7RYHupARaaLzWotroJDHdiQxo6Lb2VDpESZAq6zwYYa/h6R/HO+pY/fa+/CfjDoJCR4DUIKAlPGLOnw/8fpFh5dI6BG51fYR/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791229899; c=relaxed/simple;
	bh=NvrK19xSRqV5UwLEr8ZIBkEz/xP0OEWjMxzG35qRPS0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=s0JDBgGsceiiWoE/zHQsVznPI3oAouSwSBKO+IzdanQmOQdsR2hM0+mQVJyae80fquWnBenazf5A/LvkOQOQom0HExMQgaX0vgTun3q6FA7mIo/Evwvvfr71Onh9nZIA+SNU3GV+89E3JHxvpyLjI9HHH0Vwiump3fAajKr8b4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4eb0b989f0eso413409b6e.0
        for <linux-nilfs@vger.kernel.org>; Mon, 05 Oct 2026 12:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791229897; x=1791834697;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wI7otykpoXnhYA8HU0VJLL5aQ0E6EyHfUyxGHFX7K/U=;
        b=Vk7OuRysgNWpadQoPe6xVbEy0uouKLHiKe4tCxVlx+4ua+x+Z10PSielko9hFyUTnD
         i/kocjz9OBgEeoZk7+W+uwhvTNCxnh0lnEYbPwckryJnA+3OTYZHPQKaJDoQHUosiORg
         rdg6VKrdHcjkOVlsemA4p/FMcB55DF7B/3oe8H/vSYNfJWRd/VHaoLn7pGHGBNYxV8kB
         KZ+sbATEADCJlsz2KCoFm8kJEGRdLkeeqOz/n/slDmr7/HiukH6U/Ja48NmqJAbT9b+3
         QaUfXW4nzNQXnBhyXNWOKpS4hThgt6+gbv1ikabPmBZnSNJ9fByXUB0U2fqrMhHs3wji
         ctMw==
X-Forwarded-Encrypted: i=1; AKwUvBx59qPzgxD4WlUQWdnPnk9+azUFSFSF8XcQtg2Ye4y1t7ItK3xTSsMu8mOsuitnnz8DGELMcfjUk0UHXQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mJiVPUs2Ev5f0Y8xDBU09p0i3zyP4SURw11Oz17HVeMuJpjRZY
	PKcx7W+RfKGdvCwXWaZovr+qLg+BHAgl8yPfFELOEQG+gLmBAkWdEqh+D0a8ccx3kEb4bv4GDvV
	q8x8/VPGPJxCSzo151SrENWlpBZyIdRdD0VbWwKyaAmS+NNdGsF0/PZaHscc=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:10cd:b0:4ea:b118:c436 with SMTP id
 5614622812f47-4faab5946ecmr565375b6e.5.1791229897379; Mon, 05 Oct 2026
 12:51:37 -0700 (PDT)
Date: Mon, 05 Oct 2026 12:51:37 -0700
In-Reply-To: <6abadfc1.69bd487b.a6f8c.0008.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac3ffc9.34119e79.2f92f3.0037.GAE@google.com>
Subject: Re: [syzbot] [nilfs?] WARNING in nilfs_rmdir (3)
From: syzbot <syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    67f0943b394d Merge tag 'selinux-pr-20261005' of git://git...
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=11cb9835580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=341a98f91c13ec9
dashboard link: https://syzkaller.appspot.com/bug?extid=c388db0347b7fc88fa7a
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d47ec9580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com

NILFS (loop0): broken superblock, retrying with spare superblock (blocksize = 1024)
NILFS (loop0): broken superblock, retrying with spare superblock (blocksize = 4096)
------------[ cut here ]------------
inode->i_nlink == 0
WARNING: fs/inode.c:408 at drop_nlink+0xc5/0x110 fs/inode.c:408, CPU#1: syz-executor166/5936
Modules linked in:
CPU: 1 UID: 0 PID: 5936 Comm: syz-executor166 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2026
RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:408
Code: 50 09 00 00 be 08 00 00 00 e8 e7 45 e9 ff f0 48 ff 83 50 09 00 00 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 bc 47 7d ff 90 <0f> 0b 90 eb 81 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
RSP: 0018:ffffc9000392fc70 EFLAGS: 00010293
RAX: ffffffff82498df4 RBX: ffff88805e9c9558 RCX: ffff888032d7ddc0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed100535792b R12: 1ffff1100bd392b4
R13: ffff88805e9c9558 R14: ffff88805e9c95a0 R15: dffffc0000000000
FS:  000055555fff0400(0000) GS:ffff888125cc2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb871d39286 CR3: 00000000361f2000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nilfs_rmdir+0x1b4/0x250 fs/nilfs2/namei.c:347
 vfs_rmdir+0x3e9/0x6b0 fs/namei.c:5515
 filename_rmdir+0x292/0x520 fs/namei.c:5572
 __do_sys_rmdir fs/namei.c:5595 [inline]
 __se_sys_rmdir+0x2e/0x140 fs/namei.c:5592
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8f87bafa97
Code: 00 00 90 48 83 ec 10 48 63 ff 45 31 c9 45 31 c0 6a 00 31 c9 e8 4a 07 02 00 48 83 c4 18 c3 0f 1f 44 00 00 b8 54 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 d8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffd6579c7f8 EFLAGS: 00000206 ORIG_RAX: 0000000000000054
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f8f87bafa97
RDX: 0000000000000000 RSI: 00007f8f87c393a3 RDI: 00007f8f87c0cc45
RBP: 00007f8f87c0cbee R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 00007ffd6579c800
R13: 0000000000000000 R14: 00007f8f87c34cc0 R15: 0000000000000002
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
