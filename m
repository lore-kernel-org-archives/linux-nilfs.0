From: gianluca <gianlucarenzi-RMR/+jklkADqD7ZJT3/+rDUZDU+1vuVT@public.gmane.org>
Subject: Re: Hello list!
Date: Wed, 12 Feb 2014 15:16:12 +0100
Message-ID: <52FB822C.1060208@eurekelettronica.it>
References: <52FB49EA.30004@eurekelettronica.it> <CAFvQSYTuM7Zjfz47UGU3KnTgH1iSRWiiZ3iSqXUiu7MKFnOmFA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFvQSYTuM7Zjfz47UGU3KnTgH1iSRWiiZ3iSqXUiu7MKFnOmFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 02/12/2014 02:04 PM, Clemens Eisserer wrote:
> Hi Gianluca,
>
>> What about the wear-leveling of this configuration of the eMMC devic=
e?
>
> Actually nilfs2 is by design as friendly to flash devices with a weak
> controller as possible.
> It only performs sequential writes, yielding a perfectly equal
> distribution of writes across the device.
> Nilfs2 even overwrites static data which won't be written to when
> using other filesystems - which is great for devices supporting only
> dynamic wear leveling (usually SD, mmc, emmc, ...).
>

Ok. good news to me.

> However, there is one issue left - the (two) superblocks are written
> to periodically in short intervals.
> There is currently an ongoing discussion about this and Andreas has
> posted an experimental patch which works well on my raspberry pi.
>

What patch? Can you give some additional info? I am running kernel=20
3.12.2 vanilla.

>> Can you point me on some tools, utilities to check out this issue?
>
> What I did to observe the write-patterns of various file-systems was
> to create a ram-disk using BUSE: https://github.com/acozzette/BUSE
> It delivers an example-program which can be modified to log each
> write-access, which I imported as CSV into LibreOffice for
> visualization.

can you explain better?

Regards,
--=20
            ,,,
           (o o)
=3D=3D=3D=3D=3D=3DoOO=3D=3D(_)=3D=3DOOo=3D=3D=3D=3D=3D=3D

Gianluca Renzi
R&D
phone: +39.0542.609120
fax:   +39.0542.609212

       .oooO  Oooo.
=3D=3D=3D=3D=3D=3D(   )=3D=3D(   )=3D=3D=3D=3D=3D=3D=3D
        \ (    ) /
         \_)  (_/

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
  \ source code!  /
   ---------------
     =C2=AF\_(".)_/=C2=AF
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
