From: Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>
Subject: Re: nilfs2 not garbage collecting
Date: Mon, 6 Aug 2012 15:48:29 +0200
Message-ID: <CANku=gjx=ivRLts-N90hsTMQR4CTf8EcPBEq4K6k30_iZnPP1g@mail.gmail.com>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com>
	<CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ@mail.gmail.com>
	<F50BDE9A-4863-49CC-AC87-EEDC5B854E9C@dubeyko.com>
	<CANku=gjkTr-nYq8RxTUCVK9YU+xTjHyPbktB86BUpeuMwMBC4A@mail.gmail.com>
	<D99F26AB-309D-4325-A87C-DBF0F7BA6360@dubeyko.com>
	<20120806114820.GY1478@wloczykij>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=Oggzc5s6pBlFjDiHIje3cDf6zMvvM46+8S88lZy6C3o=;
        b=xtBcBEET4ss7ePTYwPRXnHFlYgLN8n+XWqrugEEv/56e226FcaU6mmrtRd6zwnYzgy
         d9/3doSuXEj87EATSwRv/n7ozW8Rvgi2sBsrsAiiO/iXhrPo0HwMc+cNDi11Q38RJcZf
         FZK4E0y5QUAv7ZgKl9prwQv3AePhi4RU6UDfsMQqgljZwxXny5aRVLZ1gFwoYhJxLk29
         siv+2hG/BvyW+J30Tt3C+2yjuNbsd607cG8ruCIR++qsGaUm5zgSR3uYUOSzC702kwPz
         sEwN6s5S6G16McUnCmGembzWe8jIngNI3e4Ehxlvn6db1VOTN7Ue0Zi/Ec42Pbz4Mrmr
         FnlA==
In-Reply-To: <20120806114820.GY1478@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>
> Iirc there was some issue with nilfs_cleanerd and timeshifting (and
> here we have cp 305344 10 years before 305343). But I think it was
> solved, so maybe you have (old)  nilfs-utils without the patch?
>
> Piotr Szymaniak.

I'm not sure. I'm using nilfs tools as provided by ArchLinux package
nilfs-utils-2.1.4-1:
http://www.archlinux.org/packages/core/i686/nilfs-utils/
That package provides nilfs_cleanerd, mount.nilfs2 and the other
nilfs-related tools.
The nilfs kernel module
(/usr/lib/modules/3.4.7-1-ARCH/kernel/fs/nilfs2/nilfs2.ko.gz) is
instead provided by linux 3.4.7-1 package:
http://www.archlinux.org/packages/core/i686/linux/

These packages seems up to date. They don't seem to apply any patch though.

Anyway I've always had this issue with the system date (since before
creating the filesystem): the date gets set by NTP as soon as the
system connects to internet, and this didn't ever cause any trouble to
the filesystem.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
