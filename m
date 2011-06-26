From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 per directory quota
Date: Sun, 26 Jun 2011 13:46:28 +0200
Message-ID: <201106261346.31869.dexen.devries@gmail.com>
References: <4E070070.1060502@linuxsystems.it>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=AoRIKDnbLlMq00mLvt0QAbh+3uxNa40WHwjQ0Jcz1GI=;
        b=ldI+yJZDsHv4DU7IAKW7UNslpOaPtC8USRqDqp/w9/q/b6aRwNhGCjnO3Au4K3P4P1
         SdUMOZXJBZj+JoyMQE8qa9tt5KvK0+EsLHz+H/rLXhcqoARtKAyMGG15BJZUmaWJP56f
         bVZcJW7ux41WH7LOao1kq8k0OMJeXkrUSAb78=
In-Reply-To: <4E070070.1060502-DEeHIYRtcplPMsqi6aon0Q@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Niccol=F2,


On Sunday 26 June 2011 11:48:32 you wrote:
> I read nilfs2 does support per directory quota, but I didn't find how=
 to
> achieve it: the few peoples who need directory quota do use xfs.

casually looking through NILFS2 sources, I don't see quota support, but=
 I may=20
be wrong there. Why isn't XFS a viable option for you, if I may?


> Can you please give me some more info? Is nilfs2 still too much immat=
ure
> for a production environment?

I'm using it under light-to medium load for a few months now, both on d=
esktops=20
and test server. In v2.6.39 it seems rock solid -- but that's just hear=
-say=20
evidence.

On caveat applies: under certain workload, current implementation suffe=
r from=20
high file fragmentation. That workload for me is Bitcoin, which modifie=
s a lot=20
of data in Berkley DB with pagesize 4kB. Also, BDB in Bitcoin issues fs=
ync()=20
or similar after every disk write, which creates lots of checkpoints, e=
ating=20
up diskspace with metadata.

But that's an extreme case; for general use NILFS2 is a-OK.


Regards,
--=20
dexen deVries

> (...) I never use more than 800Mb of RAM. I am running Linux,
> a browser and a terminal.
rjbond3rd in http://news.ycombinator.com/item?id=3D2692529
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
