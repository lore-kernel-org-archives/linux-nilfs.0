From: Randall Mason <clashthebunny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: how to convert a root partition (ext4) to nilfs
Date: Thu, 23 Dec 2010 09:53:49 -0500
Message-ID: <AANLkTin2uPnq9wmRC2+fnV0ULCTnr7biQ3y4FQkxs+9u@mail.gmail.com>
References: <S1752760Ab0LWM0J/20101223122609Z+814@vger.kernel.org> <20101223125138.254030@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101223125138.254030-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: _ <aeneuman-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Are you sure you want to do this?=A0 Is this just a test system?=A0 Wil=
l
you keep backups for when file system corruption occurs?

Make sure your initramfs has the nilfs kernel module in it.

Boot to a live CD that has nilfs support.=A0 Mount your ext4 partition
at /ext4 and your nilfs partition at /nilfs.

do either:
rsync -avH --progress /ext4 /nilfs
or
cd /ext4; tar cf -=A0 . | (cd /nilfs; tar xpf - )

Then, edit your grub in your boot partition to have your nilfs
partition in the root=3D line and change the root mount point in your
/etc/fstab to point to the nilfs partition too.

This is a fairly difficult thing to try, so good luck!

Randall Mason


On Thu, Dec 23, 2010 at 7:51 AM, _ <aeneuman-hi6Y0CQ0nG0@public.gmane.org> wrote:
>
> hello,
>
> i hope my question isn't too foolish, but i really
> couldn't find a consistent how-to on the net.
> how can i 'convert' a existing root partition to
> nilfs?
>
> during my install of a current ubuntu derivative (10.10)
> i had a mounted empty partition with nilfs but the installer
> (respectively gparted) could not handle this partition. so
> i was forced select another filesytem (ext4) for my root
> partition.
>
> now i wonder how i can 'convert' this root partition to nilfs,
> respectively how can i accomplish a direct installation to
> a nilfs formated partition on my next install.
>
> i installed /boot on a separate partition (ext4) to have no/less
> problems with grub.
>
> thanks for your help in advance.
> stefan
>
> end
> --
> Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
> belohnen Sie mit bis zu 100,- Euro! https://freundschaftswerbung.gmx.=
de
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
