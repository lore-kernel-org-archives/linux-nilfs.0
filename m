From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Tue, 30 Oct 2012 17:49:25 +0400
Message-ID: <1351604965.2069.13.camel@slavad-ubuntu>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	 <CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=TtJ/tg1LKhOcNRqMZNQvMLg8AfTfM2V5nFRG96oK8qc=;
	b=RFiGc95mHiTaT6ySv6eZlqOEKnN68uDuAMQliuVIoHfLKi32ix6XkvcPGiRuw20NEDhnunOOemT1ov3CYzVk86YgK/TlqPhCgmBqOMHchynF4YtkRxAnIP/JUAysSOgp;
In-Reply-To: <CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Tue, 2012-10-30 at 16:20 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9=
 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 wro=
te:
> Good time of the day!
>=20
> I'v got a nilfs2 partition on a 1TB md RAID1 partition composed of tw=
o
> HDD's. Kernel 3.5.3, userspace utils v2.1.1. Gentoo linux
> distribution.
> Just updated utils to 2.1.4 but no failure since.
>=20
> After power shutdown, mount takes about several hours.
>=20

What about RAID1 consistency? Could you describe more about your RAID
configuration?

> For the first time I thought that it won't mount at all and tried to
> use fsck tool, found somewhere in the internet(don't really remember)=
=2E
> It reported that superblock is ok.

So, I am implementing the fsck tool for NILFS2. I guess that you take
sources from NILFS2 e-mail list.=20

> Than I commented the check in the source file and the default number
> of blocks to check appeared to be too small. It failed to find the
> next superblock. I've increased the number, but increasing it to *100
> didn't help.

Sorry, I can't understand about what sources you are talking. Could you
describe more details about what and where you commented?

> So, probably the reserved SB is too far from away and it takes too
> long to find it.
>=20

If you try to find the second superblock then it is placed in the begin
of last 4 KB of the volume. Your device size is 1000202649600 bytes.

> Does anybody knows, how can it be speed up? I know, UPS is a solution=
,
> but I consider it be a bug.
>=20

Could you share more details about situation during mount operations? I
mean: (1) NILFS2-related messages in the system log; (2) "ps ax" output=
;
(3) maybe "top" output can be useful also; (4) "mount" output before
trying to mount NILFS2 volume.

Currently, your situation is unclear and, first of all, it needs to
understand what do you have. It needs to have more info before any
advices.

With the best regards,
Vyacheslav Dubeyko.

> nilfs-tune -l /dev/md0
> nilfs-tune 2.1.1
> Filesystem volume name:   (none)
> Filesystem UUID:          9adc7cf2-4c04-4030-91d9-fae9a19ded03
> Filesystem magic number:  0x3434
> Filesystem revision #:    2.0
> Filesystem features:      (none)
> Filesystem state:         invalid or mounted
> Filesystem OS type:       Linux
> Block size:               4096
> Filesystem created:       Wed Feb 29 20:32:28 2012
> Last mount time:          Fri Oct 26 23:54:26 2012
> Last write time:          Mon Oct 29 20:05:34 2012
> Mount count:              11
> Maximum mount count:      50
> Reserve blocks uid:       0 (user root)
> Reserve blocks gid:       0 (group root)
> First inode:              11
> Inode size:               128
> DAT entry size:           32
> Checkpoint size:          192
> Segment usage size:       16
> Number of segments:       119233
> Device size:              1000202649600
> First data block:         1
> # of blocks per segment:  2048
> Reserved segments %:      5
> Last checkpoint #:        1003256
> Last block address:       160163840
> Last sequence #:          3416007
> Free blocks count:        53164032
> Commit interval:          0
> # of blks to create seg:  0
> CRC seed:                 0xc2316108
> CRC check sum:            0x56f9857c
> CRC check data size:      0x00000118
>=20
> --------------------------------------------------
> Aleksandrov Sergey Vasil'evich
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
