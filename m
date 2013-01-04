From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Fri, 4 Jan 2013 15:46:13 +0300
Message-ID: <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com>
References: <20121129210650.GA4028@wloczykij> <1354255744.2090.3.camel@slavad-ubuntu> <20121130073219.GB4028@wloczykij> <1356415552.2052.11.camel@slavad-ubuntu> <20130103214913.GE2080@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=AMgCo/ZcyeU+A/7nljtrObBMSft16LkmvBObI4h+1c4=;
	b=RTBQjO7cEkQsCxPGhzafmv36eJb11XswoM7avPbBoyAwzUagzXGwQ/5ObpxA+5XfePK4tJ/7F9hK0MLxxdRkGemB8Rgndol/1CUuuzazMH+UReLMAAqnkdPggIQ9YK4m;
In-Reply-To: <20130103214913.GE2080@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Jan 4, 2013, at 12:49 AM, Piotr Szymaniak wrote:

> On Tue, Dec 25, 2012 at 10:05:52AM +0400, Vyacheslav Dubeyko wrote:
>> Hi Piotr,
>>=20
>> On Fri, 2012-11-30 at 08:32 +0100, Piotr Szymaniak wrote:
>>> On Fri, Nov 30, 2012 at 10:09:04AM +0400, Vyacheslav Dubeyko wrote:
>>>> Hi,
>>>>=20
>>>> On Thu, 2012-11-29 at 22:06 +0100, Piotr Szymaniak wrote:
>>>>> Hello.
>>>>>=20
>>>>> Doing some work today (system update, kernel update, rsync rootfs=
 with
>>>>> external drive) I noticed some unwanted behaviour:
>>>>> maszn ~ # touch afile
>>>>> touch: cannot touch =E2=80=98afile=E2=80=99: System plik=C3=B3w w=
y=C5=82=C4=85cznie do odczytu
>>>>>                        it's Read only filesystem
>>>>>=20
>>>>> dmesg shows a lot (1812 in the log) of:
>>>>> [ 8288.319012] NILFS: bad btree node (blocknr=3D26229286): level =
=3D 178,
>>>>> flags =3D 0x0, nchildren =3D 0
>>>>> [ 8288.319017] NILFS error (device sda2): nilfs_bmap_lookup_conti=
g:
>>>>> broken bmap (inode number=3D102230)
>>>>>=20
>>>>> After mount -o remount,rw /
>>>>> [ 8384.734024] segctord starting. Construction interval =3D 300 s=
econds,
>>>>> CP frequency < 30 seconds
>>>>> [ 8384.734028] NILFS warning: mounting fs with errors
>>>>>=20
>>>>> Never happend before and it looks like it works fine now (using v=
anilla
>>>>> kernel 3.6.4).
>>>>>=20
>>>>> After a reboot (to vanilla kernel 3.6.8) dmesg shows:
>>>>> [    6.046883] segctord starting. Construction interval =3D 300 s=
econds,
>>>>> CP frequency < 30 seconds
>>>>> [    6.046884] NILFS warning: mounting fs with errors
>>>>>=20
>>>>> I don't like the "errors" part...
>>>>>=20
>>=20
>> Did you have any snapshots on this volume or not?
>=20
> No, only checkpoints (just checked).
>=20

Ok. It means that snapshots don't play any role for the issue.

> Also, got this issue again. A *lot* of:
> Jan 03 22:36:38 [kernel] [  953.289973] NILFS: bad btree node
> (blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
> Jan 03 22:36:38 [kernel] [  953.289976] NILFS error (device sda2):
> nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
> Jan 03 22:36:38 [kernel] [  953.289976]=20
> Jan 03 22:36:38 [kernel] [  953.290248] NILFS: bad btree node
> (blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
> Jan 03 22:36:38 [kernel] [  953.290251] NILFS error (device sda2):
> nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
> Jan 03 22:36:38 [kernel] [  953.290251]=20
> Jan 03 22:36:38 [kernel] [  953.290523] NILFS: bad btree node
> (blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
> Jan 03 22:36:38 [kernel] [  953.290526] NILFS error (device sda2):
> nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
>=20
> Then I remounted rw and tried again (i was rsyncing my whole rootfs t=
o
> another drive):

So, the issue was occurred not because of using rsync. Am I correct? I =
simply remember that rsync was used in another report about this issue =
also.

> Jan 03 22:38:15 [kernel] [ 1050.290134] segctord starting. Constructi=
on
> interval =3D 300 seconds, CP frequency < 30 seconds
> Jan 03 22:38:15 [kernel] [ 1050.290135] NILFS warning: mounting fs wi=
th
> errors
> Jan 03 22:38:15 [nilfs_cleanerd] start
> Jan 03 22:38:15 [nilfs_cleanerd] pause (clean check)
> Jan 03 22:38:40 [kernel] [ 1075.157346] NILFS: bad btree node
> (blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
> Jan 03 22:38:40 [kernel] [ 1075.157351] NILFS error (device sda2):
> nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
> Jan 03 22:38:40 [kernel] [ 1075.157351]=20
> Jan 03 22:38:40 [kernel] [ 1075.157352] Remounting filesystem read-on=
ly
> Jan 03 22:38:40 [kernel] [ 1075.159162] NILFS: bad btree node
> (blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
> Jan 03 22:38:40 [kernel] [ 1075.159168] NILFS error (device sda2):
> nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
> Jan 03 22:38:40 [kernel] [ 1075.159168]=20
> Jan 03 22:38:40 [kernel] [ 1075.161003] NILFS: bad btree node
> (blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
> Jan 03 22:38:40 [kernel] [ 1075.161019] NILFS error (device sda2):
> nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
>=20
> But, thanks to rsync I got a (corupted?) file that causes the problem=
=2E
> It's some /var/tmp/kdecache-$USER/foo.kcache. copying this file to
> another place ends with readonly.
>=20

So, maybe the nature of /var/tmp/kdecache-$USER/foo.kcache is a reason =
of the issue. It is a very interesting detail. Could you share more det=
ails about this file? I mean size, creation time, modification time, ow=
ner, rights and so on. Moreover, could you share more details about you=
r hardware environment? I mean CPU and RAM details.

I think that it can be very interesting to know about how this file is =
distributed on the volume. Could you get by means of dumpseg informatio=
n about  several last segments? I don't know how many it needs for unde=
rstanding but maybe about 10 can be enough for the beginning.

Thanks,
Vyacheslav Dubeyko.

>=20
> Piotr Szymaniak.
> --=20
>  - Chyba nie jest pan jednym z tych roniacych lzy liberalow?
>  - Odmawiam odpowiedzi, poniewaz moglaby zostac wykorzystana przeciwk=
o
> mnie - odparlem.  Taksiarz  wydal  prychniecie oznaczajace dlaczego-j=
a-
> zawsze-trafiam-na-takich-cwaniakow... ale zamknal sie.
>  -- Stephen King, "The Breathing Method"

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
