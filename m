From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: FIBMAP ioctl missing
Date: Fri, 25 Feb 2011 12:45:30 +0100
Message-ID: <201102251245.31148.dexen.devries@gmail.com>
References: <201102242334.38044.dexen.devries@gmail.com> <201102250902.46443.dexen.devries@gmail.com> <20110225.203423.220041947.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        bh=XsmnxviiRwMwbE04YRYgEm1CAZI7RAyTSivBW0z6FcU=;
        b=k0FudSsDuvXrvPp5/B7uKLynEeBssOccNKZ4dMsp2S09DBGV1Pstu4xrXPm5/SOh0t
         2wDqrfM0sJEDJeh4zaaklrlHR33rJKlUZ1tFAQ2Y25tAJHcrc+ywaczPXdta6MrPW2Jt
         2jxn3BhaJcm7eAHtvQx8fhP7GW8zzwXLTj4S0=
In-Reply-To: <20110225.203423.220041947.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Friday 25 of February 2011 12:34:23 you wrote:
> I guess pinning files on the device is possible in some way.  But
> Supporting FIBMAP, which internally means supporting iops->bmap vfs
> interface, sounds more delicate than FIEMAP because it is actually
> used to determine block location for raw-write access.  The swapfile
> is an example of that.
>=20
> Strictly, FIEMAP has the same risk, but in practice, we are using it
> for more harmless purposes such like analyzing fragmentation or givin=
g
> hint to read-ahead tools.

As a sidenote, it seems hdparm has that `--fibmap' subcommand, but it a=
ctually=20
issues FIEMAP rather than FIBMAP ioctl.=20


> If we can safely disable a swapfile on filesystem and we can widely
> share the basic premise that "writing to the block location acquired
> by FIBMAP is a very dangerous thing for log-structured filesystems or
> COW filesystems", we could add it.

Perhaps it would be enough if FIBMAP implementation for NILFS checked i=
f the=20
file has a `pin-it-down' attribute and only then returned anything othe=
r than=20
EINVAL.

Regarding pinning a file to physical location on a device: if a file is=
 part of=20
a snapshot, does its data or metadata ever get moved?

--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

> how does a C compiler get to be that big? what is all that code doing=
?

iterators, string objects, and a full set of C macros that ensure
boundary conditions and improve interfaces.

ron minnich, in response to Charles Forsyth

http://9fans.net/archive/2011/02/90
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
