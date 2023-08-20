From: syzbot <syzbot+7e5cf1d80677ec185e63-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: Re: [syzbot] [nilfs?] kernel BUG in folio_end_writeback
Date: Sun, 20 Aug 2023 11:41:23 -0700
Message-ID: <000000000000d299b406035f1bbd@google.com>
References: <000000000000dc83d605f0c70a11@google.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000000000000dc83d605f0c70a11-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org

syzbot suspects this issue was fixed by commit:

commit 92c5d1b860e9581d64baca76779576c0ab0d943d
Author: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Fri May 26 02:13:32 2023 +0000

    nilfs2: reject devices with insufficient block count

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170c6337a80000
start commit:   929ed21dfdb6 Merge tag '6.4-rc4-smb3-client-fixes' of git:..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3da6c5d3e0a6c932
dashboard link: https://syzkaller.appspot.com/bug?extid=7e5cf1d80677ec185e63
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cb3b69280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f34201280000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: nilfs2: reject devices with insufficient block count

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
