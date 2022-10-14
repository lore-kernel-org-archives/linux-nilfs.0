From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: git://github -> https://github.com for konis
Date: Fri, 14 Oct 2022 13:18:18 +0900
Message-ID: <CAKFNMomKQg+NyA2zgYFNGjtZ6eGYj2buhmWxPP7RaczT5H6dKw@mail.gmail.com>
References: <CAKFNMonU3aVqwRdxyFefBJMg0-XC9j8bE-qYZ-9xx-4--NdkGg@mail.gmail.com>
 <mhng-1ec448c6-70ad-4964-9dd0-032892bfb2ef@palmer-ri-x1c9a>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a2TDlZ5xXQ65iqd5QWMtMPYq2MPwQ3qfXtGkGk9qg+8=;
        b=ZiyS5aMQZjQH/Evp2092kpbFea0MIVMSy7YVXIhJHRtLrvv09wfefJ//9ztDxwq1+u
         at4g7SW3NYq1gx73DR/LQPoPwMTrYNC1KX9u0J0eKq7lw+VuqJrGRPBv8UJ02ejqpCUD
         fiTkwORFjLAGHCMBJ9p0/HSN/n1Ygo4K+p+2FvNtphfjHsi5RfS9PbEpcL76/0EwClaI
         o6waarUVDn+9/g7WSHfk96Z6WdZZbvJ4UP8dDxTjsn1af/ez8UHAqyUopvX4mQXNrAaw
         cYw77Jz+oaarBUpr7SXccxVpfM+sB/WVkt5HomT1hpZQMzSafDL4SmgUzbzJxCKulSis
         zyag==
In-Reply-To: <mhng-1ec448c6-70ad-4964-9dd0-032892bfb2ef@palmer-ri-x1c9a>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Conor Dooley <conor.dooley-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>

On Fri, Oct 14, 2022 at 12:51 PM Palmer Dabbelt wrote:
>
> On Thu, 13 Oct 2022 16:06:43 PDT (-0700), konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > On Fri, Oct 14, 2022 at 6:49 AM Palmer Dabbelt wrote:
> >>
> >> Github deprecated the git:// links about a year ago, so let's move to
> >> the https:// URLs instead.
> >>
> >> Reported-by: Conor Dooley <conor.dooley-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
> >> Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
> >> Signed-off-by: Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>
> >> ---
> >> I've split these up by github username so folks can take them
> >> independently, as some of these repos have been renamed at github and
> >> thus need more than just a sed to fix them.
> >> ---
> >>  MAINTAINERS | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index d118acdce8b8..c9c396e2d8a0 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -14363,7 +14363,7 @@ L:      linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>  S:     Supported
> >>  W:     https://nilfs.sourceforge.io/
> >>  W:     https://nilfs.osdn.jp/
> >> -T:     git git://github.com/konis/nilfs2.git
> >> +T:     git https://github.com/konis/nilfs2.git
> >>  F:     Documentation/filesystems/nilfs2.rst
> >>  F:     fs/nilfs2/
> >>  F:     include/trace/events/nilfs2.h
> >> --
> >> 2.38.0
> >>
> >
> > Ah, that's right, it needs to be fixed.
> >
> > I'll pick this up unless it's decided to apply similar fixes all at once.
> > Thank you.
>
> It's easier on my end if you just pick it up.  Just note the
> "git://github -> https://github.com" typo.  I can send a v2 if you want,
> but IMO it's trival enough to just fix up.
>
> Thanks!
>
> >
> > Ryusuke Konishi

Ah, thanks.   I will fix that typo (the omission of ''.com") myself.

Ryusuke Konishi
