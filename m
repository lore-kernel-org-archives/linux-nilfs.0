From: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fw:Re: [PATCH] fs: nilfs2: fix memory leak in nilfs sysfs create
 device group
Date: Tue, 8 Mar 2022 10:58:02 +0300
Message-ID: <3d52c633-befc-b128-d063-ef8a9908be26@gmail.com>
References: <3192BC90-D082-472B-B310-6E09A14A77C6@hust.edu.cn>
 <CAD-N9QUqfq+0UeMjQALUmGpX5xgjS6=BXvsqcXQpJRzhB6hHLw@mail.gmail.com>
 <CAKFNMokdB+Zph-1OyC1-Xnyi93r+yKSusgaEaa=CkuUBttwRZA@mail.gmail.com>
 <CAD-N9QU8-Od3G+-=RHM5K7vR2-4Af+4t=XutJJVdmkKhH7OarA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8H62A7bY/REvpOM9FEUHdRBpq6Rax/WotG9i5gVPJuQ=;
        b=NiOyj27MscCFQKpr/GhdbrKroO+EeEppQkSO1sWZi8xyDoi6kqdThqd3k+0cCeqADb
         lkCOBq/pVSQ0Tw7Fu2loF3wAuAY21POJeJcjr9BtI0LO6/AO+UUhEaqIqMhvb6ijjUo7
         tL/5Ruhxs9R9CvnfzMBUEJ2rm2cIAMwbQhudlYFW2l8VKFrhollgxU1hgNcNPpwKpGBY
         g/xlxEtN15AB26RRm8fVHkZVc1o+gpki7A/0ppNNcyZ3CQjoiELp0AvirjWplqmufj++
         zhTnjGiqZjbSN5XG/bKKcEewJKo9IVbyIEHXH8g/yzq/y7PxyNAeJ6O4UffhIgwjAtxJ
         i9kQ==
Content-Language: en-US
In-Reply-To: <CAD-N9QU8-Od3G+-=RHM5K7vR2-4Af+4t=XutJJVdmkKhH7OarA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>

Hi Dongliang,

On 3/8/22 05:22, Dongliang Mu wrote:
> Hi Ryusuke,
> 
> My local syzkaller instance always complains about the following crash
> report no matter how many times I clean up the generated crash
> reports.
> 
> BUG: memory leak
> unreferenced object 0xffff88812e902be0 (size 32):
>    comm "syz-executor.2", pid 25972, jiffies 4295025942 (age 12.490s)
>    hex dump (first 32 bytes):
>      6c 6f 6f 70 32 00 00 00 00 00 00 00 00 00 00 00  loop2...........
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff8148a466>] kstrdup+0x36/0x70 mm/util.c:60
>      [<ffffffff8148a4f3>] kstrdup_const+0x53/0x80 mm/util.c:83
>      [<ffffffff8228dcd2>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
>      [<ffffffff8238ca5b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:289
>      [<ffffffff8238d3bd>] kobject_add_varg lib/kobject.c:384 [inline]
>      [<ffffffff8238d3bd>] kobject_init_and_add+0x6d/0xc0 lib/kobject.c:473
>      [<ffffffff81d39d3a>] nilfs_sysfs_create_device_group+0x9a/0x3d0
> fs/nilfs2/sysfs.c:991
>      [<ffffffff81d22ee0>] init_nilfs+0x420/0x580 fs/nilfs2/the_nilfs.c:637
>      [<ffffffff81d108e2>] nilfs_fill_super fs/nilfs2/super.c:1046 [inline]
>      [<ffffffff81d108e2>] nilfs_mount+0x532/0x8c0 fs/nilfs2/super.c:1316
>      [<ffffffff815de0db>] legacy_get_tree+0x2b/0x90 fs/fs_context.c:610
>      [<ffffffff81579ba8>] vfs_get_tree+0x28/0x100 fs/super.c:1497
>      [<ffffffff815bb582>] do_new_mount fs/namespace.c:3024 [inline]
>      [<ffffffff815bb582>] path_mount+0xb92/0xfe0 fs/namespace.c:3354
>      [<ffffffff815bba71>] do_mount+0xa1/0xc0 fs/namespace.c:3367
>      [<ffffffff815bc084>] __do_sys_mount fs/namespace.c:3575 [inline]
>      [<ffffffff815bc084>] __se_sys_mount fs/namespace.c:3552 [inline]
>      [<ffffffff815bc084>] __x64_sys_mount+0xf4/0x160 fs/namespace.c:3552
>      [<ffffffff843dd8e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff843dd8e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>      [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Unfortunately, there is no reproducer attached to the crash report.
> But I still think there should be another issue in the code.
> 

Can you, please, attach the log or try to find any fault injections? 
Them may point exactly to the root case.




With regards,
Pavel Skripkin
