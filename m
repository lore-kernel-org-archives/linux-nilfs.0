From: Hugo Pacheco <hpacheco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs-diff experimental branch
Date: Fri, 10 Oct 2014 09:47:57 -0400
Message-ID: <CAFK5svCFBJ-iXY=BCWMHUg+jHRWN4_W1RVLeOB9VwH-KUmfqEg@mail.gmail.com>
References: <CAFK5svByXZfnaEMsdiMhrC62tgsMxiAbVFmCcp8KG90=oLc-SQ@mail.gmail.com>
	<20141010.005337.27802719.konishi.ryusuke@lab.ntt.co.jp>
	<CAFK5svA8x=fx82YAH3Jp3o6kDSO2M=AYNS9ywuCFyOZeXE1Eww@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=3719HoFjCe5/aqihZ7TuvSQL9SM/x1L21cq9m7ajOY8=;
        b=Ebj+xDNjys0T2Lstc/VXkEPaBZnl/kwNSkoFnwnkPZiX1q93rIM3/RQc8fypi1vovt
         z0cNMNIWpOr9z/+WoFUlTIR+A1sgULZYLQv6c9gUur9lzEJbLhKQ9wDw6EaKXRWxy9hG
         VFhlnA2kLQinUG/qu3mOlex9hXXqW2L6B3mmaGXYTO+aDRUxqU7a0Eza2wXOZoiUUNNG
         IDwe7RJPFy+IcsVINS6wCRCWP34DSFhOICSa8IUhG/WqIqDKbaxe9ZWVfTHYEGPR1cN9
         G9EG4brkhI9j2c2pdMj/GRDWlmCIJUg1QPMdaGsFXJD7RKefZFUchfc8ARu1/AjErkB9
         zkqw==
In-Reply-To: <CAFK5svA8x=fx82YAH3Jp3o6kDSO2M=AYNS9ywuCFyOZeXE1Eww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I am sorry, but I made the gross mistake of forgetting to recompile
the kernel to your modified version.

A day later, running kernel 3.17 compiled from
https://github.com/konis/nilfs2/tree/diffapi-v2 and nilfs-tools
compiled from https://github.com/konis/nilfs-utils/tree/diff-v2,
everything works.

Thank you,
hugo

On Thu, Oct 9, 2014 at 2:22 PM, Hugo Pacheco <hpacheco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Dear Ryusuke-san,
>
> Thank you for the updated code, this was really what I needed.
>
> I have managed to install it successfully on Ubuntu 14.04 by just
> adding CFLAGS='-pthread -lm'.
>
> Using the experimental version with reformatted drives, versioning
> works fine but unfortunately calls to chcp and nilfs-diff either don't
> do anything or hang indefinitely without any error feedback. I am
> sorry for bothering, but do you have any clue of what might be
> happening? I made sure to unistall all the non-experimental
> nilfs-tools beforehand.
>
> Best,
> hugo
>
> On Thu, Oct 9, 2014 at 11:53 AM, Ryusuke Konishi
> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>> Hi,
>> On Wed, 8 Oct 2014 16:53:05 -0400, Hugo Pacheco wrote:
>>> Hi everyone,
>>>
>>> I have been experimenting with the versioning capabilities of nilfs-tools
>>> and it works beautifully, but I have now started wanting to explore the
>>> hottest features only in the experimental branch, namely nilfs-diff.
>>>
>>> I understand that this diff branch has never made it to mainstream, and
>>> probably won't soon, but has anyone succeeded in installing it for a modern
>>> 3.x linux kernel? The latest code available at github seems to require
>>> 2.6.x.
>>>
>>> A more up-to-date picture would be really appreciated.
>>
>> I rebased diff branches and pushed them out to github:
>>
>> nilfs-utils  git://github.com/konis/nilfs-utils.git  (diff-v2 branch)
>> kernel       git://github.com/konis/nilfs2.git       (diffapi-v2 branch)
>>
>> These are still experimental and need disk format change.
>>
>> Regards,
>> Ryusuke Konishi
>
>
>
> --
> www.cs.cornell.edu/~hpacheco



-- 
www.cs.cornell.edu/~hpacheco
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
