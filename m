From: Dima Tisnek <dimaqq-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 doesn't garbage collect checkpoints for me
Date: Wed, 1 Jun 2011 10:32:07 -0700
Message-ID: <BANLkTimhLPM3TU1uw10Ub5t-GEW_s-B_tQ@mail.gmail.com>
References: <BANLkTim4BBKwFJUzbnsKw0_Ru2k8ZW3MYw@mail.gmail.com>
	<20110527.133803.215389018.ryusuke@osrg.net>
	<BANLkTinnpFyrxeO2_DF5gXLgas2WLdqw4Q@mail.gmail.com>
	<201106011003.24656.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=aT//21RJJQpbdw24W/ky0crITn+0AOXOKvf8w/aZ130=;
        b=ORCbMIcLgwbfVU/iBknNE8SERgxQnZ3iTTccsKjtHugf7PRM6ZGIUic3SWqw7HDD0n
         xLvemw/7BUgYo2xqelTyjpaye2MLXr05WUv898ohuoiGQ8rAO5XxaX4QeAp2Aa9ngtRF
         6g/rzfsQurKXZT69knLKckx/kgfo06RcckWvc=
In-Reply-To: <201106011003.24656.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I'm trying to analyze how different filesystems, settings and user
mode settings interact with write amplification and write endurance on
flash.

Thus I need to get details of every write that fs issues to the
underlying block device.

I copied/wrote my own nbd server in python that logs writes and then I
analyze that against some flash model, e.g.:
block1,block2,block3 -> 1 sector 1 erase
block1,timeout,block2 -> 1 sector 2 erases
block1,block2,block1 again -> 1 sector 2 erases

I'm still working on these models, as different flashes clearly work
differently and there's often no way to find out exactly how, for now
I assume reasonably dumb flash. I'm running nbd server in the host and
nbd client in the guest (virtual) os, as I want to keep server
separate from test memory pressure. My current test memory usage is
<40M used, 7M free, few M buffers, 200M cached, so I think I solved
memory issues.

I'll post the detailed results in my blog when I make sense of them
and make sure I did everything correctly.
My critical workload is a lot of small transactions that hits flash
much harder than large files or few large transactions. I use sqlite,
it sync's at least once per transaction. Think regular user app like
firefox.

In short:
ext3/ext4 with journal are actually quite reasonable -- most used
erase sector gets 1 erase per transaction.
ext4 without journal is only 0.5x total bytes written, but less safe
ext4 sripe/stride size =3D=3D erase block size doesn't help anything
nilfs is very promising wrt write endurance, but total written bytes is=
 7x more
nilfs and btrfs are too raw for production use

d.

On 1 June 2011 01:03, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Dima,
>
>
> On Wednesday 01 of June 2011 00:08:52 you wrote:
>> (...)
>> now my next problem, nilfs interacts rather badly with nbd(...)
>
> What's the reason for nbd here anyway? Thought you wanted to access a=
 flash
> memory card...?
>
> You may want to play with `sync', `fua' and `flush' options of nbd-se=
rver, if
> you can still ensure reliable operation.
>
>
> You may want to increase /proc/sys/vm/min_free_kbytes; if some proces=
 eat up
> most of the 256MB of RAM, it's it that leak memory and should be shot=
 by OOM
> ;-)
>
>
> regards,
> --
> dexen deVries
>
> [[[=E2=86=93][=E2=86=92]]]
>
> For example, if the first thing in the file is:
> =C2=A0 <?kzy irefvba=3D"1.0" rapbqvat=3D"ebg13"?>
> an XML parser will recognize that the document is stored in the tradi=
tional
> ROT13 encoding.
>
> (( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
