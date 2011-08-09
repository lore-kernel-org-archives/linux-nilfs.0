From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_cleanerd using a lot of disk-write bandwidth
Date: Tue, 9 Aug 2011 17:19:01 +0200
Message-ID: <201108091719.01585.dexen.devries@gmail.com>
References: <94b06fe504b540199f338f9bd4ed890f@mail.shatteredsilicon.net> <201108091303.54968.dexen.devries@gmail.com> <4ef54cf8b3d0b2725aa1788d98ffbbe5@mail.shatteredsilicon.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=2brPHrWb5YcYCjx+11jExRt/O1q/m0SDyTcJ3xxlknY=;
        b=EONL7CT1bfAvRyBFPyKHnUOL+2gCmAL+VyD6dvXLgR89PW6Azg/aGybYKAa+nRB6fB
         NmLyvvajCKdzrbEUCecxY7eWQnok9MbZPZmUbZaA/zlvAFIPy5OATpfAIv+e18csZXkV
         MjKPD1juwNa5BJV1b+9HFIlPnIEC7fBhdPCd4=
In-Reply-To: <4ef54cf8b3d0b2725aa1788d98ffbbe5-tp2ajI7sM87MEvS+BUbURm2TqnkC6wfpXqFh9Ls21Oc@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tuesday 09 of August 2011 14:25:07 you wrote:
>  Interesting. I still think something should be done to minimize the
>  amount of writes required. How about something like the following.
>  Divide situations into 3 classes (thresholds should be adjustable in
>  nilfs_cleanerd.conf):
>=20
>  1) Free space good (e.g. space >=3D 25%)
>  Don't do any garbage collection at all, unless an entire block conta=
ins
>  only garbage.
>=20
>  2) Free space low (e.g. 10% < space < 25%)
>  Run GC as now, with the nice/ionice applied. Only GC blocks where
>  $block_free_space_percent >=3D $disk_free_space_percent. So as the d=
isk
>  space starts to decrease, the number of blocks that get considered f=
or
>  GC increase, too.
>=20
>  3) Free space critical (e.g. space < 10%)
>  As 2) but start decreasing niceness/ioniceness (niceness by 3 for ev=
ery
>  1% drop in free space, so for example:
>  10% - 19
>  ...
>  7% - 10
>  ...
>  4% - 1
>  3% - -2
>  ...
>  1% - -8
>=20
>  This would give a very gradual increase in GC aggressiveness that wo=
uld
>  both minimize unnecessary writes that shorted flash life and provide=
 a
>  softer landing in terms of performance degradation as space starts t=
o
>  run out.
>=20
>  The other idea that comes to mind on top of this is to GC blocks in
>  order of % of space in the block being reclaimable. That would allow=
 for
>  the minimum number of blocks to always be GC-ed to get the free spac=
e
>  above the required threshold.
>=20
>  Thoughts?


Could end up being too slow. A 2TB filesystem has about 260'000 segment=
s (given=20
the default size of 8MB). cleanerd already takes quite a bit of CPU pow=
er  at=20
times.

Also, cleanerd can do a lot of HDD seeks, if some parts of metadata are=
n't in=20
cache. Performing some 260'000 seeks on a harddrive would take anywhere=
 from=20
1000 to 3000 seconds; that not very interactive. Actually, it gets dang=
erously=20
close to an hour.

However, if the cleanerd did not have to follow this exact algorithm, b=
ut=20
instead id something roughly similar (heueristics rather than algorithm=
), it=20
could be good enough.

Possibly related, I'd love if cleanerd tented to do some mild de-fragme=
ntation=20
of files. Not necessarily full-blown, exact defragmentation, just placi=
ng quite=20
stuff close together.


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
