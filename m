From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 doesn't garbage collect checkpoints for me
Date: Wed, 1 Jun 2011 10:03:24 +0200
Message-ID: <201106011003.24656.dexen.devries@gmail.com>
References: <BANLkTim4BBKwFJUzbnsKw0_Ru2k8ZW3MYw@mail.gmail.com> <20110527.133803.215389018.ryusuke@osrg.net> <BANLkTinnpFyrxeO2_DF5gXLgas2WLdqw4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=eDBZ+D2vwNNcSbeoVyw+sfYkp8Jq/SrM+0NTAdrHNFk=;
        b=vYX63oZ0//VNNcOc0g942uyPXlZX608qDrnplwNTRbRUwv4bIAPxiv78id04u5+SjS
         fAzhn4iknK0EMQeM67Ml3R/PoU5egEnfCfvr/wrV6/WAe5DOcq3YefkzBi5Uq9a/OUHr
         4EOMWJXcp/ccRQhNQXnS0i2FsWvjBGuwDBNMI=
In-Reply-To: <BANLkTinnpFyrxeO2_DF5gXLgas2WLdqw4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dima,


On Wednesday 01 of June 2011 00:08:52 you wrote:
> (...)
> now my next problem, nilfs interacts rather badly with nbd(...)

What's the reason for nbd here anyway? Thought you wanted to access a f=
lash=20
memory card...?

You may want to play with `sync', `fua' and `flush' options of nbd-serv=
er, if=20
you can still ensure reliable operation.


You may want to increase /proc/sys/vm/min_free_kbytes; if some proces e=
at up=20
most of the 256MB of RAM, it's it that leak memory and should be shot b=
y OOM=20
;-)


regards,
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
