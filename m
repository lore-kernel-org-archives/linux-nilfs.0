From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000000000000a8 in nilfs_segctor_do_construct
Date: Sun, 16 Feb 2020 12:59:59 +0900
Message-ID: <CAKFNMo=ddKezZ7_q8R0N6Ldzqbf=J6NsOvfHQ2N2XLZdeiYCjg@mail.gmail.com>
References: <CAKFNMo=k1wVHOwXhTLEOJ+A-nwmvJ+sN_PPa8kY8fMxrQ4R+Jw@mail.gmail.com>
 <20200123.225827.1155989593018204741.hermes@ceres.dti.ne.jp>
 <20200210.224609.499887311281343618.hermes@ceres.dti.ne.jp> <20200216.111029.687350152614907818.hermes@ceres.dti.ne.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZumH7VSrBkKR9NuOEmDOA6BzNCZCemt1XDqhscI/Rg8=;
        b=oCKRXQmLkUaU9aBBVuQLL49iWPzXFYxZff6uobWah6jW+qQ07eqAIwApdkyYiYi5Ap
         wLI95FcbLBhSE/mfgqdXZxfE1zmhlR3hDWg323ma/ErVn2kVy0472MdERY5RalCIQKn1
         XOVWcSl19OfC5BgJHqkcJzD/mh/4pC8FNo+cxTkzOxqqh7A2UNbONOv6COOsdxoUO5hx
         0htoYl6MMNcJ3MeF6RzyyPhDadoQDUwpC0UATY1VzRMq5MPnxWMezdkaTkwlDAtwswgH
         p6ezQNFoZvTuB3/sqZ85+E4qZOeoXDWds/h9/yCa2+B0Qd+7J5jLC4ojKK7I2X9sJuoz
         OQgQ==
In-Reply-To: <20200216.111029.687350152614907818.hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Brian G." <gissf1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thank you Arai-san,

Your method with loopback device worked to reproduce the issue
even where the bug doesn't easily hit for physical devices.

Regards,
Ryusuke Konishi

On Sun, Feb 16, 2020 at 11:11 AM ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org> wrote:
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
