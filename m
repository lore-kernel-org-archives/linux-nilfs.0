From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Sun, 14 Oct 2012 18:55:59 +0400
Message-ID: <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
References: <20121010073912.GA28032@wloczykij> <1349870593.1889.107.camel@slavad-ubuntu> <20121010220331.GA27763@wloczykij> <1349938258.1908.3.camel@slavad-ubuntu> <20121011092300.GB27763@wloczykij> <1349950320.1908.11.camel@slavad-ubuntu> <20121011180332.GE27763@wloczykij> <1350025832.2026.43.camel@slavad-ubuntu> <20121012103119.GF27763@wloczykij> <1350040053.2026.47.camel@slavad-ubuntu> <20121012114043.GG27763@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=vJoRC+LRhIPzyBn84NWLV/1OpkRChtm1b51TELUO/9o=;
	b=jKByTC9AJFBYGSyAhKVzowf+r5suKJBwxdj83iU2zJZWdVBJwGJtxkb/WPnLJ8R3FgjpW/uzRLLILK+EsNO/qbncg3o2hYYTXOlXrsvf0Tpz6X2ikp2woqd7+DP+acbu;
In-Reply-To: <20121012114043.GG27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Oct 12, 2012, at 3:40 PM, Piotr Szymaniak wrote:

> On Fri, Oct 12, 2012 at 03:07:33PM +0400, Vyacheslav Dubeyko wrote:
>> On Fri, 2012-10-12 at 12:31 +0200, Piotr Szymaniak wrote:
>>=20
>>> How to dump second superblock?
>>> Number of segments:	  922
>>> Device size:		  7741636608
>>>=20
>>> Should I dump last 4096 bytes of device size?
>>>=20
>>=20
>> Yes, as I can understand, dump of last 4096 bytes of device size sho=
uld contain second superblock.
>=20
> Attached.
>=20
> Piotr Szymaniak.
> --=20
> Szczeg=C3=B3lnie ponurzy byli ludzie w prosektorium. Spogl=C4=85dali =
na mnie
> badawczym wzrokiem, jakby si=C4=99 dziwili, dlaczego jeszcze =C5=BCyj=
=C4=99,
> i chcieli oceni=C4=87, ile wa=C5=BC=C4=99, ile mam krwi do wypompowan=
ia i tre=C5=9Bci
> w jelitach do usuni=C4=99cia.
>  -- Jacek Hugo=E2=80=91Bader, =E2=80=9EW rajskiej dolinie w=C5=9Br=C3=
=B3d zielska=E2=80=9D
> <secondary-sb.out.bz2>

I have compared primary and secondary superblocks and discovered some d=
ifferences:

Primary SB:
> Filesystem created:       Fri Aug  3 08:37:06 2012
> Last mount time:          Thu Jan  1 01:00:01 1970
> Last write time:          Thu Jan  1 01:00:01 1970


Secondary SB:
=46ilesystem created: 0x501b7192
Last mount time: 0x1
Last write time: 0x5073495e

It is possible to see strange difference in last write time. I mean tha=
t in secondary superblock last write time contains real time that was u=
pdated after filesystem creation. If Raspberry Pi doesn't have RTC then=
 it is not so clear how the last write time was updated and only in sec=
ondary superblock.

Primary superblock:
> Mount count:              56

=2E..
> Number of segments:       922
> Device size:              7741636608
=2E..
> Last checkpoint #:        1873
> Last block address:       734128
> Last sequence #:          358
> Free blocks count:        1150976

Secondary superblock:
Mount count: 56
=2E..
Number of segments: 922
Device size: 7741636608
=2E..
Last checkpoint #: 1884
Last block address: 734512
Last sequence #: 358
=46ree blocks count: 1150976

So, we have identical mount counts, free blocks count, last sequence. B=
ut last checkpoint and last block address are different in primary and =
secondary superblocks.

Primary SB:
> Filesystem state:         invalid or mounted

Secondary SB:
=46ilesystem state: unmounted cleanly.

So, I have such feeling that secondary superblock was flushed during um=
ount but primary superblock was not.

On Oct 13, 2012, at 12:56 AM, Piotr Szymaniak wrote:
On Tue, Oct 09, 2012 at 12:52:39PM +0200, Piotr Szymaniak wrote:
>>> I think that first of all it needs to detect that it is NILFS2 issu=
e but
>>> not hardware or MMC stack issue.
>>=20
>> Will connect some screen via HDMI to check if there's some error msg=
=2E
>> The card should be fine, but I will dd it to disk to check for read
>> errors.
>=20
> Sorry for answering my own mail. Connected Raspberry Pi to a screen a=
nd
> here's the output:
>=20
> # --=20
> segctord starting. Construction interval =3D 300 seconds. CP frequenc=
y < 30 seconds
> NILFS: corrupt root inode.
> List of all partitions:
> b300    7883776 mmchlk0 driver: mmcblk
>  b301       57344 mmcblk0p1 00000000-0000-0000-0000-000000000000
>  b302      262144 mmcblk0p2 00000000-0000-0000-0000-000000000000
>  b303     7560192 mmcblk0p3 00000000-0000-0000-0000-000000000000
> 0800       7816704 sda driver: sd
>  0801     7016688 sda1 00000000-0000-0000-0000-000000000000
> No filesystem could mount root, tried: nilfs2
> Kernel panic - not syncing: VFS: Unable to mount root is on unknown-b=
lock(179,3)
> [<c001537c>] (unwind_backtrace+0x0/0xfc) from [<c0421c2c>] (dump_stac=
k+0x20/0x24)
> [<c0421c2c>] (dump_stack+0x20/0x24) from [<c0421de0>] (panic+0x70/0x1=
a0)
> [<c0421de0>] (panic+0x70/0x1a0) from [<c05d4cf0>] (mount_block_root+0=
x1f4/0x254)
> [<c05d4cf0>] (mount_block_root+0x1f4/0x256) from [<05d4f64>] (mount_r=
oot+0xf0/0x114)
> [<c05d4f64>] (mount_root+0xf0/0x114) from [<c05d50e4>] (prepare_names=
pace+0x15c/0x1c0)
> [<c05d50e4>] (prepare_namespace+0x15c/0x1c0) from [<c05d48dc>] (kerne=
l_init+0x100/0x130)
> [<c05d48dc>] (kernel_init+0x100/0x130) from [<c000f00c>] (kernel_thre=
ad_exit+0x0/0x8)
> # --=20


I think that here we can see consequence but not the reason. The issue =
occurred more earlier during umount or flushing.

Currently, I can't understand what filesystem activity ends with such i=
ssue. Anyway, it needs to reproduce the issue on your side.

On Oct 12, 2012, at 2:31 PM, Piotr Szymaniak wrote:

> On Fri, Oct 12, 2012 at 11:10:32AM +0400, Vyacheslav Dubeyko wrote:
>=20

[snip]

>> Thereby, there is some probability of primary superblock inconsisten=
cy. Could you share raw dump of second superblock that is located at th=
e volume end? Moreover, could you share dumpseg of next segment after l=
ast sequence # (namely, 359) and before of it (namely, 357)?
>=20
> apo ~ # dumpseg /dev/sdd3 359
> segment: segnum =3D 359
>=20
> #357 attached.


So, it is clear that #359 segment is empty. Moreover, #357 segment does=
n't contain ifile block with blkoff =3D 2 as I can see from dumpseg out=
put. Currently, I know that #358 segment contains empty ifile block wit=
h blkoff =3D 2. It needs to find segment which contains not empty block=
 of ifile for blkoff =3D 2. Could you share dumpseg output of all previ=
ous segments (for #358)?

With the best regards,
Vyacheslav Dubeyko.









--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
