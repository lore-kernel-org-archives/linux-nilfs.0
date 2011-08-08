From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Applying nice/ionice to nilfs-cleanerd
Date: Mon, 8 Aug 2011 10:09:31 +0200
Message-ID: <201108081009.31334.dexen.devries@gmail.com>
References: <28d103cbef1f8ebb3a7b458509e53c4d@mail.shatteredsilicon.net> <20110808.082319.114757823.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=UEmAcXhwl0HVc+Zic4OaJGwfZdhhb3EkA09T1riSW30=;
        b=espZx4fmZhU0I5vB82GORkd9eKavwHXh40l6agnFQwPEGTwFstIOq6DuET9yq/vZtM
         JBWi7XRYWnUs7ShNuARdl4BVhGoVn6FGJeypXdjiMqvUGCKHXSy1JZcl292mJ4Eo7ab+
         BrSgDYxntRJHIQ6yM7N2GCqOUHF0YPEwWkYCg=
In-Reply-To: <20110808.082319.114757823.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Monday 08 of August 2011 01:23:19 you wrote:
> At present, you have to manually invoke the cleanerd through the
> nice/ionice commands or to run renice/ionice later specifying the
> process ID of the cleanerd.
>=20
> One way to make this convenient is introducing new directives in
> /etc/nilfs_cleanerd.conf as follows:
>=20
>  # Scheduling priority.
>  nice 19    # niceness -20~19
>=20
>  # IO scheduling class.
>  # Supported classes are default, idle, best-effort, and realtime.
>  ionice_class  idle
>=20
>  # IO scheduling priority.
>  # 0-7 is valid for best-effort and realtime classes.
>  ionice_data   5
>=20
> Do you think these extensions make sense ?


it would be nice (hehe) to be able to temporarily lower cleanerd priori=
ty when=20
watching a movie or building software.=20

However, may be a downside to /always/ running cleanerd niced and ionic=
ed.  I=20
believe that currently cleanerd's activity slows other processes down a=
 lot=20
when filesystem is almost full -- which means that it oftet won't becom=
e truly=20
full, because clearned will free enough space for other processes to be=
 able=20
to complete their work. If, on the other hand, cleanerd was highly nice=
d and=20
ioniced, it could end up being starved of CPU and disk bandwidth and no=
t=20
freeing enough free space, which could cause other processes to exhaust=
 free=20
space on filesystem and abord when not able to write to filesystem.

Perhaps it would be enough to have cleanerd automatically switch priori=
ty=20
based on available free space. For example, if I had
min_clean_segments      10%
max_clean_segments      12%

then also have
min_clean_segments_low_prio	8%

low_prio_nice 19
normal_prio_nice 0

low_prio_ionice_class idle
normal_prio_ionice_class realtime

which woud mean, `use low priority (nice & ionice) when there's at leas=
t 8% of=20
free segments; if there's less use higher priority' -- so cleanerd woul=
d=20
reclaim free space more aggressively when there's little free space lef=
t.


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
