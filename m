From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Tue, 8 Jan 2013 16:22:46 +0300
Message-ID: <CC608A22-9D8F-4347-B54F-06C85176B6E5@dubeyko.com>
References: <50A5737C.2040805@li.ru> <201211160313.AA04185@capsicum.lab.ntt.co.jp> <50A65588.3000205@li.ru> <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com> <20121127151924.GW4028@wloczykij> <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com> <20121128142116.GY4028@wloczykij> <1354113560.2017.11.camel@slavad-ubuntu> <20121128205943.GZ4028@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=2il47pwDP/hJ5DEVBVU3NgKUnRIvCm5OjdQ/bG0kDos=;
	b=oxcqwK+XexQ6Lf+n8s/MyVG/41siIOXwZbC3xsd/bcoRREsFHrO/A+lknkjwf37hCXqvgBKKfVykopU5xZylRJmpI1zrktpsvdDTzAINH62NXuZzyH1u3HfOrtcb1oNO;
In-Reply-To: <20121128205943.GZ4028@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Nov 28, 2012, at 11:59 PM, Piotr Szymaniak wrote:

> On Wed, Nov 28, 2012 at 06:39:20PM +0400, Vyacheslav Dubeyko wrote:
>> On Wed, 2012-11-28 at 15:21 +0100, Piotr Szymaniak wrote:
>>> On Tue, Nov 27, 2012 at 08:43:01PM +0300, Vyacheslav Dubeyko wrote:
>>>> Could you describe the path of issue reproducing? What filesystem
>>>> operations took place near before the issue?
>>>=20
>>> Reproduce: Use a computer with nilfs2? No idea... I notice this iss=
ue
>>> from time to time. I suppose it's more visible when the system is i=
dle
>>> and then I notice a lot of CPU load without any reason (also as I w=
rote
>>> before - it stops immediately after runnig sync).
>>>=20
>>=20

I have reproduced the issue by chance. The reproducibility of the issue=
 is 100%.

The reproducing path is:
1. Generate some file about 100 - 500 GB (for example, by: "dd if=3D/de=
v/zero of=3D<file_name> bs=3D1048576 count=3D102400"). The size of the =
file defines the duration of the issue reproducibility.
2. Try to execute "rm", "truncate" or "dd" command. In the case of "dd"=
 it needs to use without notrunc option (for example, "dd if=3D/dev/ura=
ndom of=3D<file_name> bs=3D1024 seek=3D51200 count=3D10").
3. As a result you can see flush kernel thread that uses 60 - 100 % of =
CPU time during 5 - 40 minutes:

top - 23:48:53 up  6:11, 15 users,  load average: 1.71, 1.16, 1.81
Tasks: 226 total,   3 running, 223 sleeping,   0 stopped,   0 zombie
Cpu(s):  5.3%us, 94.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, =
 0.0%st
Mem:   7640788k total,  3991784k used,  3649004k free,    28196k buffer=
s
Swap:  1952764k total,        0k used,  1952764k free,  3126224k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND   =
                                                                       =
                                           =20
12358 root      20   0 99484  668  544 R   97  0.0   0:55.27 dd        =
                                                                       =
                                           =20
 3027 root      20   0     0    0    0 R   87  0.0  31:46.94 flush-8:32

I suspect the nilfs_mdt_write_page() but I need a more time for the iss=
ue investigation.

With the best regards,
Vyacheslav Dubeyko.

>> Ok. Could you share output of "top" and "ps ax" for the case of issu=
e
>> reproducing? These outputs can be helpful for beginning of analysis.
>=20
> Already attached [1] "ps ax" output before. Don't know if top can get
> something usefull here, but I can try to "catch" it.
>=20
> [1] http://www.spinics.net/lists/linux-nilfs/msg01481.html
>=20
> Piotr Szymaniak.
> --=20
> Moim jedynym bogiem jest w=C3=B3dka.  Moi =C5=9Bwi=C4=99ci to marki, =
franki i dolary.
> Jedyna =C5=9Bwi=C4=85tynia,  kt=C3=B3r=C4=85 odwiedzam,  to pochwa ko=
biety. A m=C3=B3j sakrament
> to pieprzenie.
>  -- Nelson DeMille, "The Lion's Game"

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
