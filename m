From: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fw:Re: [PATCH] fs: nilfs2: fix memory leak in nilfs sysfs create
 device group
Date: Tue, 8 Mar 2022 10:22:02 +0800
Message-ID: <CAD-N9QU8-Od3G+-=RHM5K7vR2-4Af+4t=XutJJVdmkKhH7OarA@mail.gmail.com>
References: <3192BC90-D082-472B-B310-6E09A14A77C6@hust.edu.cn>
 <CAD-N9QUqfq+0UeMjQALUmGpX5xgjS6=BXvsqcXQpJRzhB6hHLw@mail.gmail.com> <CAKFNMokdB+Zph-1OyC1-Xnyi93r+yKSusgaEaa=CkuUBttwRZA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yCgLkIUzX0S1MPQ66B3UsRJrG7vCxhG0ViRgp3VSlm0=;
        b=OOjEXZgzwjFsdIbhqzzjlQxzSofhD9Ic2WaeB89faJvEAV21gIEOg92lH3wimqZre2
         gsgtouroJceNsyvuB4ou4TNXRIclfarYt8jHLu+LONKYM5gMrFlj04fWFnWDr9Igwlfz
         wiFg8pGrwhXMOQDs/QX7yjeK6qd+DhiTzLrrt6dq+UXwKzgSZOyeseT2h2OwrWUxognA
         tTj4KfDr6/W4y/npmQkbR8vDnizc8ailpW8oEwZdrUSAh9W6K+gNPML9YpCL7j8LgV9T
         bhwjUriPORy0lg9s1TTQsXgn0Vn7z4XLB1p7xlWFgGRdWnLHiFF3Y6jPxLbpB5PbwdBT
         HRfg==
In-Reply-To: <CAKFNMokdB+Zph-1OyC1-Xnyi93r+yKSusgaEaa=CkuUBttwRZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>

On Sat, Jan 22, 2022 at 12:22 PM Ryusuke Konishi
<konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi Dongliang,
>
> On Sat, Jan 22, 2022 at 9:31 AM Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > (added Nanyong Sun to CC)
> > > Hi Dongliang,
> > >
> > > On Thu, Jan 20, 2022 at 11:07 PM Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > >
> > > Hi Dongliang,
> > >
> > > On 1/20/22 16:44, Dongliang Mu wrote:
> > >
> > > The preivous commit 8fd0c1b0647a ("nilfs2: fix memory leak in
> > > nilfs_sysfs_delete_device_group") only handles the memory leak in the
> > > nilfs_sysfs_delete_device_group. However, the similar memory leak still
> > > occurs in the nilfs_sysfs_create_device_group.
> > >
> > > Fix it by adding kobject_del when
> > > kobject_init_and_add succeeds, but one of the following calls fails.
> > >
> > > Fixes: 8fd0c1b0647a ("nilfs2: fix memory leak in nilfs_sysfs_delete_device_group")
> > >
> > >
> > > Why Fixes tag points to my commit? This issue was introduced before my patch
> > >
> > >
> > > As Pavel pointed out, this patch is independent of his patch.
> > > The following one ?
> >
> > Hi Pavel,
> >
> > This is an incorrect fixes tag. I need to dig more about `git log -p
> > fs/nilfs2/sysfs.c`.
> >
> > I wonder if there are any automatic or semi-automatic ways to capture
> > this fixes tag. Or how do you guys identify the fixes tag?
>
> I guess `git blame fs/nilfs2/sysfs.c` may help you to confirm where the change
> came from.   It shows information of commits for every line of the input file.
> If you are using github, 'blame button' is available.
>
> If an issue is reproducible, we use `git bisect` to identify the patch
> that caused the
> issue, however, even then, try to understand why and how it affected
> by looking at
> source code and the commit.
>
> >
> > >
> > > 5f5dec07aca7 ("nilfs2: fix memory leak in nilfs_sysfs_create_device_group")
> > >
> > > Signed-off-by: Dongliang Mu <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>
> > > ---
> > > fs/nilfs2/sysfs.c | 5 ++++-
> > > 1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > >
> > > Can you describe what memory leak issue does this patch actually fix ?
> > >
> > > It looks like kobject_put() can call __kobject_del() unless circular
> > > references exist.
> > >
> > > kobject_put() -> kref_put() -> kobject_release() ->
> > > kobject_cleanup() -> __kobject_del()
> > >
> > > As explained in Documentation/core-api/kobject.rst,
> > >
> > > kobject_del() can be used to drop the reference to the parent object, if
> > > circular references are constructed.
> > >
> > > But, at least, the parent object is NULL in this case.
> > > I really want to understand what the real problem is.
> > >
> > > Thanks,
> > > Ryusuke Konishi
> >
> > I know where my problem is. From the disconnect function, I think the
> > kobject_del and kobject_put are both necessary without checking the
> > documentation of kobjects.
> >
> > Then I think the current error handling may miss kobject_del, and this
> > patch is generated.
> >
> > As a result, I think we can ignore this patch. Sorry for my false alarm.
>
> Okay, thank you for your reply.
> If you notice anything we missed on this difference, please let us know.

Hi Ryusuke,

My local syzkaller instance always complains about the following crash
report no matter how many times I clean up the generated crash
reports.

BUG: memory leak
unreferenced object 0xffff88812e902be0 (size 32):
  comm "syz-executor.2", pid 25972, jiffies 4295025942 (age 12.490s)
  hex dump (first 32 bytes):
    6c 6f 6f 70 32 00 00 00 00 00 00 00 00 00 00 00  loop2...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8148a466>] kstrdup+0x36/0x70 mm/util.c:60
    [<ffffffff8148a4f3>] kstrdup_const+0x53/0x80 mm/util.c:83
    [<ffffffff8228dcd2>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
    [<ffffffff8238ca5b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:289
    [<ffffffff8238d3bd>] kobject_add_varg lib/kobject.c:384 [inline]
    [<ffffffff8238d3bd>] kobject_init_and_add+0x6d/0xc0 lib/kobject.c:473
    [<ffffffff81d39d3a>] nilfs_sysfs_create_device_group+0x9a/0x3d0
fs/nilfs2/sysfs.c:991
    [<ffffffff81d22ee0>] init_nilfs+0x420/0x580 fs/nilfs2/the_nilfs.c:637
    [<ffffffff81d108e2>] nilfs_fill_super fs/nilfs2/super.c:1046 [inline]
    [<ffffffff81d108e2>] nilfs_mount+0x532/0x8c0 fs/nilfs2/super.c:1316
    [<ffffffff815de0db>] legacy_get_tree+0x2b/0x90 fs/fs_context.c:610
    [<ffffffff81579ba8>] vfs_get_tree+0x28/0x100 fs/super.c:1497
    [<ffffffff815bb582>] do_new_mount fs/namespace.c:3024 [inline]
    [<ffffffff815bb582>] path_mount+0xb92/0xfe0 fs/namespace.c:3354
    [<ffffffff815bba71>] do_mount+0xa1/0xc0 fs/namespace.c:3367
    [<ffffffff815bc084>] __do_sys_mount fs/namespace.c:3575 [inline]
    [<ffffffff815bc084>] __se_sys_mount fs/namespace.c:3552 [inline]
    [<ffffffff815bc084>] __x64_sys_mount+0xf4/0x160 fs/namespace.c:3552
    [<ffffffff843dd8e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff843dd8e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Unfortunately, there is no reproducer attached to the crash report.
But I still think there should be another issue in the code.

>
> Regards,
> Ryusuke Konishi
