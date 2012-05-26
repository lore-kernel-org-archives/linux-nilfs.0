From: Kenneth Langga <klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Sun, 27 May 2012 00:43:43 +0800
Message-ID: <CAHmELnVQfYO8sbJFnmVHX+iHWXiDF-Vav1i28Y0rdzwmoTaowg@mail.gmail.com>
References: <CAHmELnWvFNdiePs=mQJ=nqfsxJ_49zxawa9jncE-RJ2-omYHOg@mail.gmail.com>
 <20120525180649.GA1236@heethoofdje.13thmonkey.org> <CAHmELnVyRNGn1gda0Sw53YCSOAYMm5JUonebi-9NxaFBP7Uidw@mail.gmail.com>
 <20120526144932.GG18110@csmith-bm.vm.bytemark.co.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        bh=wdghLx0YsLfmatIST9NIxtVq/m7YlNOwBZ21Hmdiyp4=;
        b=TGdTHeDi8t+m5XiwbETkVG0sC/HGtYIh/6ZhfsEVGLfcMaHhfRWu43XCVh7USz8Qz6
         /wIZJsTA88aIAOf4NuOm5dGBqfZSUIEMtdRaL5eIypVm33X/miREct39cJD7gk1sJKM3
         zl1uUw5dPUow9gfAS0CFrr/jrha+iPFDxsmSuqb5Cfiuw9n8qHwd1uMs7bMHkbp5gJg1
         t9MyKUODzkE5ayWctUTO1bwLBTUpyJKJh62CcHY1eWW62IYr3B3UYEIpeslC4OQaKlLv
         NFd6Rc9xADNFLyHA/KAPCpqvTcR6FyydPRpm8NZ1b3zuGPM5zraoUn9QdzF+Z9jaap7J
         v72g==
In-Reply-To: <20120526144932.GG18110-Ng8wz+J301SNY5Lh21HnMTHS2PGA244I9dF7HbQ/qKg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I see, I'll follow what you said. Thanks. Btw, what could be the
source of the error so that I may avoid it in the future? And would
deleting the offending file (if the error is tied to one) also remove
the error?

On Sat, May 26, 2012 at 10:49 PM, Christian Smith
<csmith-r5H9PUQoNxUga4AWyxku7ULnMzgEhdHr@public.gmane.org> wrote:
> On Sat, May 26, 2012 at 02:15:41AM +0800, Kenneth Langga wrote:
>> It's a 3TB harddisk. Could that be the reason?
>>
>> Right now, it's mounted read-only. Is it safe to make it read/write
>> again? And can I run nilfs-clean on it and maybe the error would be
>> gone?
>>
>
> You should be able to remount read/write, as you'll still have your
> old snapshots or checkpoints to mount from instead if it all goes
> wrong.
>
> In my experience, though, once the clearner fails to be able to
> clean segments due to logical errors, it's game over and a
> backup/mkfs/restore is needed. =C2=A0But then, I mostly run NIFLS on
> small slow SDD, so that's no great hardship. We desperately need
> a fsck to handle scenarios like that.
>
> I can't see the size of the disk being a problem. All the data
> pointers are 64-bit, so should comfortably handle 3TB.
>
> In short, try read-write, but be prepared to reformat.
>
> Also, if you're using a 3TB disk for NILFS to store media
> files, I'd perhaps suggest against it, if not for the reason
> that backup/restore on that much data will take an age. I
> currently stick to nilfs for my root filesystems, leaving
> big and/or personal data on more stable, less cutting edge
> filesystems.
>
> Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
