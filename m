From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fw:Re: [PATCH] fs: nilfs2: fix memory leak in nilfs sysfs create
 device group
Date: Sat, 22 Jan 2022 13:22:12 +0900
Message-ID: <CAKFNMokdB+Zph-1OyC1-Xnyi93r+yKSusgaEaa=CkuUBttwRZA@mail.gmail.com>
References: <3192BC90-D082-472B-B310-6E09A14A77C6@hust.edu.cn> <CAD-N9QUqfq+0UeMjQALUmGpX5xgjS6=BXvsqcXQpJRzhB6hHLw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WSl0n+WwVjP76UBPGcTgsvP7+rrxq9Ric0OqJhwHSkg=;
        b=Ifz1AWXrSg+wgkYOmdBm1iMMJyLipcIzsywwWvL28u7TFV6c2w+oQn70f5wHbm7bjy
         8pOqbS9n8ZsaagYrjRrYi6KrjdoRuuk5auolsU7jzm67aqVLfvUIklnVXV3pr2GanjfE
         UNBI7kxvS8znxD9CxpqcFgrSQJTjXqUAFeode9QFaEz9b2Vh/DJFs7jtQ4HOfB6nYL37
         6ol8AtPht+nBQKwMLVjp9p3dv6sl9kkT6Pzd8OXABDtkiCveZP6d7BJwdU7ECpvtojQF
         WPZBmNP/x6c6K9XEjUIOpJPlEV5SN3Shm3rksWd0q7Xmh7lS5WLH0/v42OWsikmV/fIs
         41NQ==
In-Reply-To: <CAD-N9QUqfq+0UeMjQALUmGpX5xgjS6=BXvsqcXQpJRzhB6hHLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>

Hi Dongliang,

On Sat, Jan 22, 2022 at 9:31 AM Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > (added Nanyong Sun to CC)
> > Hi Dongliang,
> >
> > On Thu, Jan 20, 2022 at 11:07 PM Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >
> > Hi Dongliang,
> >
> > On 1/20/22 16:44, Dongliang Mu wrote:
> >
> > The preivous commit 8fd0c1b0647a ("nilfs2: fix memory leak in
> > nilfs_sysfs_delete_device_group") only handles the memory leak in the
> > nilfs_sysfs_delete_device_group. However, the similar memory leak still
> > occurs in the nilfs_sysfs_create_device_group.
> >
> > Fix it by adding kobject_del when
> > kobject_init_and_add succeeds, but one of the following calls fails.
> >
> > Fixes: 8fd0c1b0647a ("nilfs2: fix memory leak in nilfs_sysfs_delete_device_group")
> >
> >
> > Why Fixes tag points to my commit? This issue was introduced before my patch
> >
> >
> > As Pavel pointed out, this patch is independent of his patch.
> > The following one ?
>
> Hi Pavel,
>
> This is an incorrect fixes tag. I need to dig more about `git log -p
> fs/nilfs2/sysfs.c`.
>
> I wonder if there are any automatic or semi-automatic ways to capture
> this fixes tag. Or how do you guys identify the fixes tag?

I guess `git blame fs/nilfs2/sysfs.c` may help you to confirm where the change
came from.   It shows information of commits for every line of the input file.
If you are using github, 'blame button' is available.

If an issue is reproducible, we use `git bisect` to identify the patch
that caused the
issue, however, even then, try to understand why and how it affected
by looking at
source code and the commit.

>
> >
> > 5f5dec07aca7 ("nilfs2: fix memory leak in nilfs_sysfs_create_device_group")
> >
> > Signed-off-by: Dongliang Mu <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>
> > ---
> > fs/nilfs2/sysfs.c | 5 ++++-
> > 1 file changed, 4 insertions(+), 1 deletion(-)
> >
> >
> > Can you describe what memory leak issue does this patch actually fix ?
> >
> > It looks like kobject_put() can call __kobject_del() unless circular
> > references exist.
> >
> > kobject_put() -> kref_put() -> kobject_release() ->
> > kobject_cleanup() -> __kobject_del()
> >
> > As explained in Documentation/core-api/kobject.rst,
> >
> > kobject_del() can be used to drop the reference to the parent object, if
> > circular references are constructed.
> >
> > But, at least, the parent object is NULL in this case.
> > I really want to understand what the real problem is.
> >
> > Thanks,
> > Ryusuke Konishi
>
> I know where my problem is. From the disconnect function, I think the
> kobject_del and kobject_put are both necessary without checking the
> documentation of kobjects.
>
> Then I think the current error handling may miss kobject_del, and this
> patch is generated.
>
> As a result, I think we can ignore this patch. Sorry for my false alarm.

Okay, thank you for your reply.
If you notice anything we missed on this difference, please let us know.

Regards,
Ryusuke Konishi
