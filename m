From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fw:Re: [PATCH] fs: nilfs2: fix memory leak in nilfs sysfs create
 device group
Date: Sun, 13 Mar 2022 00:11:38 +0900
Message-ID: <CAKFNMon3=fFWtuUa1_wDyK9agpCXjbzA8b+rj=OYu=7Gs8nMqQ@mail.gmail.com>
References: <3192BC90-D082-472B-B310-6E09A14A77C6@hust.edu.cn>
 <CAD-N9QUqfq+0UeMjQALUmGpX5xgjS6=BXvsqcXQpJRzhB6hHLw@mail.gmail.com>
 <CAKFNMokdB+Zph-1OyC1-Xnyi93r+yKSusgaEaa=CkuUBttwRZA@mail.gmail.com>
 <CAD-N9QU8-Od3G+-=RHM5K7vR2-4Af+4t=XutJJVdmkKhH7OarA@mail.gmail.com>
 <CAKFNMo=E8mMuY7Et0auH02fOzGKx04k2=LOj8mZJ6a-=J+sPzQ@mail.gmail.com>
 <CAD-N9QWt=d2Vj2bevSzOPL4AWF08_zTyq=hHOcOOROCazNY4_A@mail.gmail.com>
 <CAD-N9QWrBLygN24EC6QLRFF6uf7=PiTRdA4suKqEXJ7tk9aocA@mail.gmail.com> <dac7104a-21ac-24f4-6132-e51960fa0b7e@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K98030A73zLeeoJmJeXlU5g/68giFukC00BYhoPQePQ=;
        b=PJWpgYp3y0X47kmD0RbKsQsv50e9EHMwVHy1fGRT7+xPaXqBBTyb8WJlhz4aXeUmX+
         i/3bK+Je/HlZShOGXMYLYxN8oXmb99quNJJx73gq2YNhS/zrIYHouDgIdJbmubBv3OuI
         CmqGu9lIl7ghHJWkSKX9hghFz17XkbYgrbjZwN4adnQB6VYn2hZxYkf3esSi2cizPCYO
         x/lxj1iA4z9/8HKKCZ0vJ44SQwHL6aPsIBD+vkNEzWVlYfPHTyph1K/kXboaRa1azVti
         dKpzLi75jl/Y9F8YUU0blFYSbja9ClzAVi4UWckQF+sgJUsoCyJRwIVjr3Uow+TxaeAz
         O32Q==
In-Reply-To: <dac7104a-21ac-24f4-6132-e51960fa0b7e-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>

Hi Pavel,

On Sat, Mar 12, 2022 at 11:20 PM Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi Dongliang,
>
> On 3/9/22 11:30, Dongliang Mu wrote:
> >> Now I am checking the log and trying to find error injection in the
> >> log file, as said by Pavel.
> >
> > Attached is the report and log file.
> >
> > @Pavel Skripkin I don't find any useful error injection in the log file.
> >
> > In case I made some mistakes, I will clean up my local crash reports,
> > update to the latest upstream kernel and restart the syzkaller. Let's
> > see if the crash still occurs.
>
> The execution path is clear from the logs. Quick grep for nilfs shows
> these lines
>
> [  886.701044][T25972] NILFS (loop2): broken superblock, retrying with
> spare superblock (blocksize = 1024)
> [  886.703251][T25972] NILFS (loop2): broken superblock, retrying with
> spare superblock (blocksize = 4096)
> [  886.706454][T25972] NILFS (loop2): error -4 creating segctord thread
>
> So here is calltrace:
>
> nilfs_fill_super
>    nilfs_attach_log_writer
>      nilfs_segctor_start_thread <- failed
>
>
> In case of nilfs_attach_log_writer() error code jumps to
> failed_checkpoint label and calls destroy_nilfs() which should call
> nilfs_sysfs_delete_device_group().

nilfs_sysfs_delete_device_group() is called in destroy_nilfs()
if nilfs->ns_flags has THE_NILFS_INIT flag -- nilfs_init() inline
function tests this flag.

The flag is set after init_nilfs() succeeded at the beginning of
nilfs_fill_super() because the set_nilfs_init() inline in init_nilfs() sets it.

So,  nilfs_sysfs_delete_group() seems to be called in case of
the above failure.   Am I missing something?

Thanks,
Ryusuke Konishi


>
> So I can really see how this leak is possible on top of current Linus' HEAD.
>
>
> Also in the log there are onlyh 4 syz_mount_image$nilfs2 programs, so
> only one of them may be a reproducer. If you have spare time you can try
> to execute them using syz-execprog and see if it works :))
>
>
>
> With regards,
> Pavel Skripkin
