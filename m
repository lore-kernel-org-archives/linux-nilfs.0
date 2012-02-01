From: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Odd problem starting nilfs_cleanerd due to an eMMC misbehaviour
Date: Wed, 1 Feb 2012 10:06:42 +0400
Message-ID: <20120201060641.GS2267@home.lan>
References: <20120126135203.GM2267@home.lan> <201201281353.00537.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=BM5E1MypjglK4WE1eqojRLoy8SBQERfMoIN0pM7k1X8=;
        b=WfubusUWfZt/7D/rizHiergMrEagljQlUo0JDMHGCo5fvTHAL+VuRecGEJ3pGYVBZk
         U2cESTfletjYo4S65cH5ekuerVJ7rd2Tnkz5YFHMMM95oyr12rSQUqmO/H7C82YdWkJ4
         xeHB9ByFDkkfmd1ffgizMU0zOBX3EHeFIE2N0=
Content-Disposition: inline
In-Reply-To: <201201281353.00537.Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Sat, Jan 28, 2012 at 01:53:00PM +0100, Martin Steigerwald wrote:
> > [ 5671.580366] mmcblk0: error -110 transferring data, sector 155632=
78, nr 122, card status 0x200900
> > [ 5671.603701] end_request: I/O error, dev mmcblk0, sector 15563278
>=20
> Well I think thats clear: Thats an I/O error when trying to access th=
e MMC=20
> flash. I think the cleaner shouldn=B4t hang on it, but aside from tha=
t I do=20
> not see a NILFS issue here.

Well, please consider my message as a bugreport against the cleaner,
i.e. "defect/featurerequest: if the cleaner daemon stops due to I/O
errors, output an informational message suggesting to 1. Fully power
off the media and reboot 2. In case it doesn't help, try another
controller."

I'm not sure if the facility to mark bad blocks and skip them is
needed on modern devices, so it's not clear if that's reasonable to
expect it from NILFS.

As to the fsck, it would be very nice to have at least some very basic
utility, probably even doing only diagnostic output. And with Debian
on NILFS rootfs i had to substitute it with /bin/true because Debian
expects a usable fsck for its root.

> As to the exact nature of the MMC error I have no idea. Maybe searchi=
ng=20
> for parts of the dmesg message does help.

Probably some glitch in the embedded controller, dmesg had no
interesting related data.

> I have I/O errors sometimes with the internal card reader on my Think=
Pad=20
> T520 with Kingston Ultimate SD cards which work perfectly well with a=
n=20
> external USB card reader. I reported these to bugzilla.kernel.org aft=
er I=20
> noticed that some similar sounding issue was reported there as well.

I wonder if that might be related to the power supply voltage. I think
external cardreaders always use 5V for the card but the internal can
vary it and if the card's descriptor permits lower voltages, it goes
for the lowest; similar reasoning applies to the frequency.

Also some cards are more prone to RF interference than the others. At
OpenMoko we had reports of I/O errors occuring simultaneously with the
GSM activity. I guess laptop's insides have enough sources of
interference too.
=20
--=20
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software=
!
mailto:fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
