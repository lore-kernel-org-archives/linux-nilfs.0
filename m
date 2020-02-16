From: "Brian G." <gissf1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000000000000a8 in nilfs_segctor_do_construct
Date: Sat, 15 Feb 2020 20:24:41 -0600
Message-ID: <CAAq45aOKxDXkb=4CqrM1HrbP-=VcLcgV9o468muJfWFg8JSKBA@mail.gmail.com>
References: <CAKFNMo=k1wVHOwXhTLEOJ+A-nwmvJ+sN_PPa8kY8fMxrQ4R+Jw@mail.gmail.com>
 <20200123.225827.1155989593018204741.hermes@ceres.dti.ne.jp>
 <20200210.224609.499887311281343618.hermes@ceres.dti.ne.jp> <20200216.111029.687350152614907818.hermes@ceres.dti.ne.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hn1LAaGTLMUYM/u3qFiUMUaaIMVmNm5PW8Pt3lKNegM=;
        b=Fvutr1hZbHBtGkF7oeQ/BdZ9cdHyLFGQF+ZfrNYLS8239jrnE8YQvZW4ZZm58G2bCy
         Z2MJpzqM4uwhUe1wjyVFAm4jJJvQjnTVZzNgDVluvY6XbyDgWZ6lBKfUbc/YmhwwGebN
         R1nP0Z2Q4tdPNgGgB8nZs1s4k0JqIyK5rMK8xyRtGdqQmWki5tPeJ5cVyyAyUn+xP1q/
         lkVLLiz9ySKl/J5cybUX51i34qtwKleoR/twuSqu426+7qrcKoeKjyW8oP+72X8WK83d
         V05qS14D/P8EudKj19OodvR9lWvNAMOY5lqSjm5+47E145IAKVuCv0HmbaiDGzrdkyGf
         gTKQ==
In-Reply-To: <20200216.111029.687350152614907818.hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is my first post to the LKML, so please be kind :)  I also have
been affected by this bug.  The bug is triggered whenever a write
happens to the filesystem, which means mounting read-only is an
available option to recover data.  I took the time to do a full bisect
on the kernel sources and have identified the commit where the
breakage happens.

Regarding versions, I can confirm that 4.19.83 is stable with regards
to NILFS, and 4.19.84 and later are broken.  I can also confirm that
5.3.10 works fine and have heard that 5.3.12 breaks NILFS as well.  I
can also confirm that the 5.4.18 kernel still has this issue.  I did
not trace how far back the issue goes on the 5.4.x series, or even in
more detail on the 5.3.x series.

To simplify my bisection task, I used the 4.19.x series, and
determined that commit d3b3c0a14615c495118acc4bdca23d53eea46ed2 is the
commit that breaks NILFS.  Furthermore, when reverting this commit on
otherwise clean 4.19.84 kernel sources, the NILFS issue does not occur
anymore.

I'm not familiar enough with NILFS's internals to determine why the
small caching change to the kernel from that commit breaks NILFS, nor
can I offer a patch to fix it (besides reverting the offending change)
but I can confirm that this is the initial cause.  I also know there
has been alot of new changes to kernel caching in more recent (5.4 /
5.5 / 5.6) kernels, so perhaps there is still more diagnostics to do.

I have the test VM that I used for bisection available if someone
wants to coordinate with me to put together a patch for this, but
ideally someone can take my diagnostics effort here and make use of it
directly.  I saved dmesg logs from both good and bad cases and I can
send them if someone is interested.  I can also provide some level of
detailed system setup instructions to reproduce the issue.  I did my
testing against an existing external hard drive, but I have been able
to reproduce the issue consistently against a freshly created loopback
mount as well, so it is not just caused by disk corruption or an
unclean unmount.

- Brian

On Sat, Feb 15, 2020 at 8:11 PM ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org> wrote:
>
> And,
>
> In <20200210.224609.499887311281343618.hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>;
>    ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org> wrote
>    as Subject "Re: BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8 in nilfs_segctor_do_construct":
>
> > Hi,
> >
> > FYI, reporting additional test results.
> >
> > I reproduced this problem with clean NILFS2 fs in previous mail.
> > "clean" means that "make filesystem before every tests."
> > In this mail, I tried to reproduct with/without VG/LV, LUKS, loopback.
> >
> > * Not reproduced
> >  USB stick - primary partition - NILFS2
> >  USB stick - primary partition - VG/LV - NILFS2
> >  USB stick - primary partition - VG/LV - LUKS - NILFS2
> >  USB stick - primary partition - LUKS - VG/LV - NILFS2
> >  USB stick - primary partition - LUKS - VG/LV - LUKS - NILFS2
> >  /tmp (tmpfs) - regular file - NILFS2 (loopback mount, kernel 4.19.82)
> >  USB stick - primary partition(512MiB) - NILFS2
> >
> > * Reproduced (always, immediately)
> >  /tmp (tmpfs) - regular file - NILFS2 (loopback mount)
> >  USB stick - primary partition - ext4 - regular file - NILFS2 (loopback mount)
>
> this loopback problem is seen in Kernel 5.5.4.
>
> > Test conditions:
> >  kernel 4.19.86 (same as previous test)
> >  NILFS2/ext4 filesystem, VG/LV, LUKS were made with default parameters
> >  size of "primary partition" in USB stick is approx. 14GiB
> >  size of "regular file" is approx. 512MiB
> >  "reproduce": mount NILFS2, touch file, sync
