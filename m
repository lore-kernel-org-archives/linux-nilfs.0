From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix data loss with mmap()
Date: Tue, 16 Sep 2014 00:24:05 +0200
Message-ID: <54176705.6080107@gmx.net>
References: <1410810450-2637-1-git-send-email-andreas.rohner@gmx.net> <20140916.070130.858349725408024032.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140916.070130.858349725408024032.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-09-16 00:01, Ryusuke Konishi wrote:
> Hi Andreas,
> On Mon, 15 Sep 2014 21:47:30 +0200, Andreas Rohner wrote:
>> This bug leads to reproducible silent data loss, despite the use of
>> msync(), sync() and a clean unmount of the file system. It is easily
>> reproducible with the following script:
<snip>
> Thank you for reporting this issue.

I just stumbled upon the weird behaviour of mmap() while testing the
nilfs_sync_fs() patch.

> I'd like to look into this patch, it looks to point out an important
> regression, but it may take some time since I am quite busy this week..

Of course. I understand.

br,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
