From: syzbot <syzbot+53369d11851d8f26735c@syzkaller.appspotmail.com>
Subject: Re: [syzbot] [nilfs?] general protection fault in nilfs_clear_dirty_page
Date: Sun, 11 Jun 2023 14:18:29 -0700
Message-ID: <000000000000c0951105fde12435@google.com>
References: <000000000000da4f6b05eb9bf593@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <000000000000da4f6b05eb9bf593@google.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, dsterba@suse.com, hch@lst.de, konishi.ryusuke@gmail.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, wqu@suse.com

syzbot has bisected this issue to:

commit 4a445b7b6178d88956192c0202463063f52e8667
Author: Qu Wenruo <wqu@suse.com>
Date:   Sat Aug 13 08:06:53 2022 +0000

    btrfs: don't merge pages into bio if their page offset is not contiguous

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17778475280000
start commit:   022ce8862dff Merge tag 'i2c-for-6.4-rc6' of git://git.kern..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14f78475280000
console output: https://syzkaller.appspot.com/x/log.txt?x=10f78475280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7474de833c217bf4
dashboard link: https://syzkaller.appspot.com/bug?extid=53369d11851d8f26735c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e9d48b280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d7fa63280000

Reported-by: syzbot+53369d11851d8f26735c@syzkaller.appspotmail.com
Fixes: 4a445b7b6178 ("btrfs: don't merge pages into bio if their page offset is not contiguous")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
