From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fw:Re: [PATCH] fs: nilfs2: fix memory leak in nilfs sysfs create
 device group
Date: Sun, 13 Mar 2022 01:01:33 +0900
Message-ID: <CAKFNMon7cdJ092Ppne_kU6A23pRUb+1tThCkoB2vn0HN-rWUUg@mail.gmail.com>
References: <3192BC90-D082-472B-B310-6E09A14A77C6@hust.edu.cn>
 <CAD-N9QUqfq+0UeMjQALUmGpX5xgjS6=BXvsqcXQpJRzhB6hHLw@mail.gmail.com>
 <CAKFNMokdB+Zph-1OyC1-Xnyi93r+yKSusgaEaa=CkuUBttwRZA@mail.gmail.com>
 <CAD-N9QU8-Od3G+-=RHM5K7vR2-4Af+4t=XutJJVdmkKhH7OarA@mail.gmail.com>
 <CAKFNMo=E8mMuY7Et0auH02fOzGKx04k2=LOj8mZJ6a-=J+sPzQ@mail.gmail.com>
 <CAD-N9QWt=d2Vj2bevSzOPL4AWF08_zTyq=hHOcOOROCazNY4_A@mail.gmail.com>
 <CAD-N9QWrBLygN24EC6QLRFF6uf7=PiTRdA4suKqEXJ7tk9aocA@mail.gmail.com>
 <dac7104a-21ac-24f4-6132-e51960fa0b7e@gmail.com> <CAKFNMon3=fFWtuUa1_wDyK9agpCXjbzA8b+rj=OYu=7Gs8nMqQ@mail.gmail.com>
 <7da316f4-aa65-896e-9020-2dfff2bbfc09@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=44lnphS+Jc2ofnB5ToOWXva8vzn4mU0qO5/nu90TMoM=;
        b=hlmMXZqU7JAWCp6pen2phIq+CLrWpquN9uGoFul+Hr83pr/FBc+j+l+EvBPqZltp77
         VYZuNWDFbMdl2VKSmV5WioiflCyv0WgRVS7f+ccO+LeBekDy3SVgZ6nLPImM2wlRWU5L
         gagvRd1Km5rrWZ4UtuaqcEto3sw6I5F8JKZkkzvSCfKYI9Jgj6X7jHgKtomc7Aeqb2U5
         TkgN5QM1IWYe9DV7c4Y0Bon2UgOGvF6mtRVQ2qoRIAEDe8QDPQR7eu1yFLrffG6tySSq
         9fl74w19uz7xjBGLIEqjSui1M7lk1ivGlhf4Ibofd6OGXUqTHbnQwKBjmOn13RhKv/BW
         KOjg==
In-Reply-To: <7da316f4-aa65-896e-9020-2dfff2bbfc09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>

Hi Pavel and Dongliang,

On Sun, Mar 13, 2022 at 12:16 AM Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi Ryusuke,
>
> On 3/12/22 18:11, Ryusuke Konishi wrote:
> >> In case of nilfs_attach_log_writer() error code jumps to
> >> failed_checkpoint label and calls destroy_nilfs() which should call
> >> nilfs_sysfs_delete_device_group().
> >
> > nilfs_sysfs_delete_device_group() is called in destroy_nilfs()
> > if nilfs->ns_flags has THE_NILFS_INIT flag -- nilfs_init() inline
> > function tests this flag.
> >
> > The flag is set after init_nilfs() succeeded at the beginning of
> > nilfs_fill_super() because the set_nilfs_init() inline in init_nilfs() sets it.
> >
> > So,  nilfs_sysfs_delete_group() seems to be called in case of
> > the above failure.   Am I missing something?
> >
>
> Yeah, that's what I mean :) I can't see how reported issue is possible
> with current code.
>
>
> Sorry for not being clear

Understood, thanks for the reply.

If so,  the case where nilfs_sysfs_create_device_group() itself failed,
is suspicious as mentioned in the previous mail.   A possible scenario
I guess is :

- nilfs_sysfs_create_device_group() on the first mount try fails and leaks
  due to lack of kobject_del() in the error path.
- Then, nilfs_sysfs_create_device_group() on the next mount try hits
  the leak detector at kobject_init_and_add().

So, if the leak bug is reproducible, I'd like to ask Dongliang to
test the effect of the first patch.

Regards,
Ryusuke Konishi

>
>
>
> With regards,
> Pavel Skripkin
