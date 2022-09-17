From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in
 kernfs_put_active
Date: Sun, 18 Sep 2022 00:50:49 +0900
Message-ID: <de81bf82-3ddf-4875-381d-e52949046b25@I-love.SAKURA.ne.jp>
References: <00000000000095339805e8d6958e@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <00000000000095339805e8d6958e-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: syzbot <syzbot+258ad6d2cb6685e145bc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

I don't know whether crafted filesystem image is used is relevant to this problem.
But I think a bug is inside NILFS2 filesystem code.

When inode allocation fails due to security_inode_alloc() returning -ENOMEM, some
inconsistent state happens. It seems to me that destruction of partially initialized
inode corrupts kernel memory (and causes various oops depending on timings).

On 2022/09/17 11:53, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a6b443748715 Merge branch 'for-next/core', remote-tracking..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=17025144880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=14bf9ec0df433b27
> dashboard link: https://syzkaller.appspot.com/bug?extid=258ad6d2cb6685e145bc
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=106b8164880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1040a75d080000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/81b491dd5861/disk-a6b44374.raw.xz
> vmlinux: https://storage.googleapis.com/69c979cdc99a/vmlinux-a6b44374.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+258ad6d2cb6685e145bc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

