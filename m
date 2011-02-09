From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Checking actually used space on NILFS
Date: Wed, 9 Feb 2011 16:25:55 +0100
Message-ID: <201102091625.55553.dexen.devries@gmail.com>
References: <201102091333.39072.dexen.devries@gmail.com> <20110210.001303.24922676.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        bh=yB6J//Gk+H7M9pKLOWqjysJjyF7Kybmn+3FTmtp1ZSI=;
        b=VxoXXQcfcUUbr6kLeeksvNIxUehsFRqmocGvGU2kwwMHwxQt+6Bnpc1L5NTpZTCizG
         oJyGVvIHQEeY61+U5IiPzxuEo+jkAoSqfHfE6Hm3DFl9sDoA9sjFGWwtkvGG++XOg82G
         Vb/VC/TTKCoSqHEJdwBLbUJeoUgjmJcCDN44g=
In-Reply-To: <20110210.001303.24922676.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wednesday, February 09, 2011 04:13:03 pm you wrote:
> > is there a reasonably easy way to check the size of the current (mo=
st
> > recent) content of the NILFS filesystem?
>=20
> The current nilfs doesn't have an effiecient way to do that.
> So, the easy way is using 'du -s':
>=20
>  # du -s /nilfs-mount-point

that's true, but it relies on
1) user being able to see all the allocated files (and even root won't =
see some=20
allocated files, for example if they have been unlinked but are still h=
eld open=20
by a process), and
2) disk having low seek times

>=20
> We need adding API (ioctl) to get extended space information and may
> need minor disk format change for that.


The `lscp' lists, under NBLKINC, the incremental count of blocks added =
by this=20
particular checkpoint. As far as I understand, if one summed up all NBL=
KINCs=20
of all checkpoints, the actual number of allocated blocks would result.=
=20
However, that seems to work only when no checkpoints have been ever rem=
oved...

Would it be possible to change the semantics of NBLKINC (and possibly t=
he on-
disk structure) to report increment from the last existing checkpoint r=
ather=20
than just any (existing or not) previous checkpoint? I assume that'd ma=
ke the=20
NBLKINC summing up a viable way of counting used space (at least with g=
ood=20
approximation).


@Ryusuke:
apologies for direct reply, I've forgotten to put mailing list's addres=
 in To=20
field.


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
