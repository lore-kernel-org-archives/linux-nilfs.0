From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [syzbot] KASAN: use-after-free Read in nilfs_segctor_confirm
Date: Mon, 3 Oct 2022 00:52:18 +0900
Message-ID: <CAKFNMom7Z_5QWaGTG-=C67n0aT__nu4Wfs=Tsa3jgpXQMtWkEA@mail.gmail.com>
References: <3b7a3398-0826-04de-f805-c926b39e7d35@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vjeLG2XTrGNkMtJovXcIe08FMWx6adqZPyqcWpGEYZU=;
        b=XS0E4dEy/uW5hV/GqUalKvHGucERBmvC0l6QwKX8jlI4p8bc0BiM8WZeytuKzwfL39
         zPjoD0RHV6BWH7SgQ5H4a4ThrDq08jlr4P9zJhZM5lN9MbO2LEks1Hi/maT+LKtWHAvs
         IItu68qvujotO/hlBYPGhLCjtGhujSMNAiPu+xSrBXdIdrZQgCC6fmJ7rFipYybKce/O
         67e8kM1PcSyDlwHjPU/z9ZbOy7M62RIRcZ8RKe+2JHzCcxygC+e16mv7TdGpDXOnno4r
         5u3seElxMo2fGYK/W1+ts10uupIQDk4Y5tOMo1MWx1A18ohRNWBsMFQWpGUYpiBIHmlZ
         5shQ==
In-Reply-To: <3b7a3398-0826-04de-f805-c926b39e7d35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 000000000000219dcd05e9f95ed9-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, syzbot <syzbot+b8c672b0e22615c80fe0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>

On Sun, Oct 2, 2022 at 6:25 PM Khalid Masum wrote:
>
> Hi all,
>
> The reproducer triggers the same bug in upstream 6.0-rc7 as well.
>
>
> Thanks,
>
>    -- Khalid Masum

It looks like this and a few similar issues are caused by duplicate
inode allocation with the same inode number
as the root inode on a corrupted disk image.

I'm now digging into the issue and trying to fix it.

Thanks,
Ryusuke Konishi
