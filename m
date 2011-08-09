From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_cleanerd using a lot of disk-write bandwidth
Date: Tue, 9 Aug 2011 13:03:54 +0200
Message-ID: <201108091303.54968.dexen.devries@gmail.com>
References: <94b06fe504b540199f338f9bd4ed890f@mail.shatteredsilicon.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=EYo7tqabS3WNuZiPDMJLJGLIDEEXsW/TfLlUNGcbxLc=;
        b=R/7w4TEzB0xU2ncpaeIpCaqIFXQbFAFTSRH8ca4sdfTIfYfHJ3fD/vSZsZt3obXOOR
         8yxi3SxWCbX/kgiYEDbgc/4xif6KCWORmL+MmxjTUbM25q0mWmBCYaorVdnDS0zJclmq
         YyOo8rpTYsjnuHIq0Z6F2ippnL1vMWQ6EIUqQ=
In-Reply-To: <94b06fe504b540199f338f9bd4ed890f-tp2ajI7sM87MEvS+BUbURm2TqnkC6wfpXqFh9Ls21Oc@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Gordan,


On Tuesday 09 of August 2011 12:18:12 you wrote:
>  I'm seeing nilfs_cleanerd using a lot of disk write bandwidth accord=
ing
>  to iotop. It seems to be performing approximately equal amounts of r=
eads
>  and writes when it is running. Reads I can understand, but why is it
>  writing so much in order to garbage collect? Should it not be just
>  trying to mark blocks as free? The disk I/O r/w symmetry implies tha=
t it
>  is trying to do something like defragment the file system. Is there =
a
>  way to configure this behaviour in some way? The main use-case I hav=
e
>  for nilfs is cheap flash media that suffers from terrible random-wri=
te
>  performance, but on such media this many writes are going to cause m=
edia
>  failure very quickly. What can be done about this?


I'm not a NILFS2 developer, so don't rely too much on the following rem=
arks!

NILFS2 consider filesystem as a (wrapped around) list of segments, by d=
efault=20
each 8MB. Those segments contain both file data and metadata.

cleanerd operates on whole segments; normally either 2 or 4 in one pass=
=20
(depending on remaining free space). It seems to me a segment is reclai=
med=20
when there is any amount of garbage in it, no matter how small. Thus yo=
u see,=20
in some cases, about as much of read as of write.

One way could be be to make cleanerd configurable so it doesn't reclaim=
=20
segments that have only very little garbage in them. That would probabl=
y be a=20
trade-off between wasted diskspace and lessened bandwidth use.

As for wearing flash media down, I believe NILFS2 is still very good fo=
r them,=20
because it tends to write in large chunks -- much larger than the origi=
nal=20
512B sector -- and not over-write once written areas (untill reclaimed =
by=20
cleanerd, often much, much later). Once the flash' large erase unit is =
erased,=20
NILFS2 append-writes to it, but not over-writes already written data. W=
hich=20
means the flash is erased almost as little as possible.


Regards,
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
