From: syzbot <syzbot+74db8b3087f293d3a13a-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: Re: [syzbot] [nilfs?] KASAN: slab-use-after-free Read in
 nilfs_load_inode_block (2)
Date: Thu, 27 Jul 2023 14:56:25 -0700
Message-ID: <00000000000019b5b106017f096a@google.com>
References: <000000000000b4e906060113fd63@google.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000000000000b4e906060113fd63-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

syzbot has bisected this issue to:

commit 28a65b49eb53e172d23567005465019658bfdb4d
Author: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Thu Apr 27 01:15:26 2023 +0000

    nilfs2: do not write dirty data after degenerating to read-only

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=177150e5a80000
start commit:   5f0bc0b042fc mm: suppress mm fault logging if fatal signal..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14f150e5a80000
console output: https://syzkaller.appspot.com/x/log.txt?x=10f150e5a80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d10d93e1ae1f229
dashboard link: https://syzkaller.appspot.com/bug?extid=74db8b3087f293d3a13a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15176d81a80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132d93d9a80000

Reported-by: syzbot+74db8b3087f293d3a13a-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Fixes: 28a65b49eb53 ("nilfs2: do not write dirty data after degenerating to read-only")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
