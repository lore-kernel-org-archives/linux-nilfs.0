From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Nilfs2 kernel tree location
Date: Sun, 8 Jul 2012 03:09:36 +0900
Message-ID: <CAKFNMokwTUkzQRAjN9t7s96O_LXQmDYPj3+GwNTzRMSTSFPr-A@mail.gmail.com>
References: <CAE7QK4NbSf1r+_dL7jjMaGfdymmjKMJhpSApXwxaG-3PND8JEA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=fIQvhnsP3W3iftgVH1DLTH/Eiv6zVavrcIW3kkpqRR8=;
        b=APFl7VA9n1mucvCOLZx01MhCMUAd/L6BPNG4fZHrttCSrKdOdRlP9cvCIblF6so3ZF
         joxkmo2/qH6/kN3PoAYNa0ytG1QTKpCXis05uMhe6OojxY8m7Dk4vuCxam0ZrhQvSjNe
         sTBy8qfeFnyFhdGpjgpPOVDqiJBq0D0qNV5o+DGkcq16ST16CMB3Q/CdXpcrORqM0mwg
         zzh6RE5vZh1D3mEC8mUBG6zERqAuMMFrjQOjyntWlj82YQSFavBOleRld92Q/YQy/JSh
         dATCl6J50+WUzFvYbaHBX40ZUF6fWyARHdnV6K2aebDrbClFSxNNPi2gYJ3nhjQvm6Ez
         dzBQ==
In-Reply-To: <CAE7QK4NbSf1r+_dL7jjMaGfdymmjKMJhpSApXwxaG-3PND8JEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vibi sreenivasan <mail.vibi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
2012/7/7 vibi sreenivasan:
> Hi,
> Can anyone please tell me the location of nilfs2 kernel tree.
> I checked in the Maintainers file in linux kernel. It said the location
> is git git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
> which is not existing.
>
> Please let me know where the latest development to nilfs2 are checked in.

Sorry for the inconvenience.

  git://github.com/konis/nilfs2.git

is the current tree, but the development of  the kernel code is
not so active now because I don't have enough time these days.

The git tree in the kernel.org should be restored.  It's another
to do for me.

Thanks,
Ryusuke Konishi

> Thanks in advance.
>
> Vibi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
