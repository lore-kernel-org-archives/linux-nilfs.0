From: syzbot <syzbot+cdfcae656bac88ba0e2d@syzkaller.appspotmail.com>
Subject: Re: [syzbot] [nilfs?] WARNING in mark_buffer_dirty (5)
Date: Thu, 17 Aug 2023 17:58:23 -0700
Message-ID: <0000000000009095e80603280632@google.com>
References: <0000000000003da75f05fdeffd12@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <0000000000003da75f05fdeffd12@google.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, konishi.ryusuke@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

syzbot has bisected this issue to:

commit 28a65b49eb53e172d23567005465019658bfdb4d
Author: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date:   Thu Apr 27 01:15:26 2023 +0000

    nilfs2: do not write dirty data after degenerating to read-only

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11c5be4ba80000
start commit:   6eaae1980760 Linux 6.5-rc3
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13c5be4ba80000
console output: https://syzkaller.appspot.com/x/log.txt?x=15c5be4ba80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d10d93e1ae1f229
dashboard link: https://syzkaller.appspot.com/bug?extid=cdfcae656bac88ba0e2d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127ac14ea80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1693a06ea80000

Reported-by: syzbot+cdfcae656bac88ba0e2d@syzkaller.appspotmail.com
Fixes: 28a65b49eb53 ("nilfs2: do not write dirty data after degenerating to read-only")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
