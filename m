From: Dima Tisnek <dimaqq-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 doesn't garbage collect checkpoints for me
Date: Wed, 1 Jun 2011 11:21:07 -0700
Message-ID: <BANLkTinsZZeRDmQR8sAWrqUP1N4UK5ktAA@mail.gmail.com>
References: <BANLkTim4BBKwFJUzbnsKw0_Ru2k8ZW3MYw@mail.gmail.com>
	<201106011003.24656.dexen.devries@gmail.com>
	<BANLkTimhLPM3TU1uw10Ub5t-GEW_s-B_tQ@mail.gmail.com>
	<201106011934.30725.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=rTkPQ8xf/HXNYIbIWMg6NTEWl77J5u5wn9Axk33ppv8=;
        b=DzDdcHxxzupY9ElSJR/7gje2czC3GkFAkAQ3DmVZMpRX0T9fogvQsKldoTxOZLfEZw
         bqZcZ2PsEkwmxAmyXQ56BXgLYab+QmYUUZ+qIRgT6BPvv5bteae2v8vLJ0VLJ92yALFG
         LWr/biJW4n1T07DJK0/bME0v8dawq+yW//vlw=
In-Reply-To: <201106011934.30725.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks for the tip, bkltrace seems to give me what I want and much more=
!

(iostat doesn't give me block address)

On 1 June 2011 10:34, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Dima,
>
>
> On Wednesday 01 June 2011 19:32:07 you wrote:
>> I'm trying to analyze how different filesystems, settings and user
>> mode settings interact with write amplification and write endurance =
on
>> flash.
>>
>> Thus I need to get details of every write that fs issues to the
>> underlying block device.
>
> Have you considered either of:
>
>
> # iostat -d -k 1
>
> http://linux.die.net/man/8/blktrace
>
>
> --
> dexen deVries
>
> ``One can't proceed from the informal to the formal by formal means.'=
'
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
