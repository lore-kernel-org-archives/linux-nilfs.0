From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Applying nice/ionice to nilfs-cleanerd
Date: Mon, 8 Aug 2011 12:27:54 +0200
Message-ID: <201108081227.54922.dexen.devries@gmail.com>
References: <28d103cbef1f8ebb3a7b458509e53c4d@mail.shatteredsilicon.net> <201108081009.31334.dexen.devries@gmail.com> <20110808.192014.264198882.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=LWIiIPI1SMNfl5TqxXM75AtQttCXTFLHY1jBL1xoG/w=;
        b=S80glxeITBSa/VoZ4GBlB8l1btcad6kqrmCj03mQmBu66lmdGEYoUSPKu25VjIn54N
         YlxkdZQ9+gY/CQbYfa3ug9mg9k31I/GoVNc908qdjDPeiVo779D5XtLEYFg4NPwFZWqa
         23dz+pl6tdenE8IBRh7kNF3d8FcLmwKQZYInw=
In-Reply-To: <20110808.192014.264198882.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Monday 08 of August 2011 12:20:14 you wrote:
> (..snip..)
> Your worry and idea are ok, but this enhancement looks rather confusi=
ng.
>=20
> Users would misunderstand switching by the min_clean_segments_low_pri=
o
> threshold.
>=20
> We already have mc_cleaning_interval and mc_nsegments_per_clean which
> are applied when the number of clean segments is LESS than
> min_clean_segments.  OTOH, the low_prio_xx parameters are applied whe=
n
> the number of clean segments is LARGER than the
> min_clean_segments_low_prio.  The comparision should be inverted.


agreed.


> And, we already have min_clean_segments threashold.  Why not just add
> mc_nice and mc_ionice as below (rather than introduce the new
> threthold) ?
>=20
>  # Sheduing priority
>  # if clean segments < min_clean_segments.
>  mc_nice				-5
>=20
>  # IO sheduing class and priority
>  # if clean segments < min_clean_segments.
>  mc_ionice			realtime

switching to faster free-space reclaimation already increases load on t=
he=20
computer. If this also switched cleanerd to higher priority at the same=
=20
moment, the load increase could be sharp and unpleaseant. The idea was =
to have=20
three levels of cleanerd operation, rather than two.

1) slow operation
2) fast operation -- when less than min_clean_segments is available
3) fast & aggressive (high nice and ionice priority) -- when there's ev=
en less=20
free space available

=2E..with the hope that the 3rd level would rarely ever be reached, bec=
ause the=20
2nd level would suffice most of the time.


Cheers,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

=46or example, if the first thing in the file is:
   <?kzy irefvba=3D"1.0" rapbqvat=3D"ebg13"?>
an XML parser will recognize that the document is stored in the traditi=
onal=20
ROT13 encoding.

(( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
