From: Edgard Pineda <epineda.contact-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cannot mount nilfs2 partition after io error in raid5
Date: Mon, 22 Feb 2010 14:43:57 -0300
Message-ID: <d5c85db51002220943j30e1be50xacba39fe3077f0df@mail.gmail.com>
References: <d5c85db51002220844k1fdd5f03pdd2fd97f61a10fa7@mail.gmail.com>
	 <20100223.022556.192697952.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:in-reply-to:references
         :date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=OsworeGyYUmDZfC6FGayX7xjbBAbiuJ8lFdqyzY4R3U=;
        b=DgGTdxwGC5ln2IjdiboAhe8R+0M75UjDMMacD/yUFj7m7zFvP8oUtl3L2PYHkxU12Y
         AZ2nCOvjuEapms636GsDxsd5VSjESO6oI1+XNTA2BbjW9WwOlXTPhxGXMdwlFLZh+GwF
         lLTj7D87dTJa8ALyA3ld9Qhsw8uYR89EIq60o=
In-Reply-To: <20100223.022556.192697952.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2010/2/22 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> Hi,
> On Mon, 22 Feb 2010 13:44:46 -0300, Edgard Pineda wrote:
>> Hi,
>>
>> I just had a 4 harddrives in raid5 with nilfs2 (kernel 2.6.32 and
>> nilfs-utils 2.0.15) and I've got a power cut, then I rebuilt the
>> array, but when I tried to mount the nilfs2 partition I've got:
>> "NILFS: Can't find nilfs on dev md0" (in dmesg) after execute
>> "mount.nilfs2: Error while mounting /dev/md0 on disk: Invalid
>> argument".
>>
>> Any idea? can I mount as "read only" to rescue some files? any tools
>> to "see" the files and fix the partition?
>>
>> Regards,
>> Edgard.
>
> Umm.., sounds serious. =A0The message "NILFS: Can't find nilfs on xxx=
"
> is output when both of the two super blocks are broken.
>
> Can you dump the partition with hd command?
>
> # hd /dev/md0 | less
>
> If the partition is not filled yet, it would look like this:
>
> 00000000 =A000 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00 =A0|..=
=2E.............|
> *
> 00000400 =A002 00 00 00 00 00 34 34 =A000 01 00 00 7b 93 80 d4 =A0|..=
=2E...44....{...|
> 00000410 =A050 09 11 38 02 00 00 00 =A017 11 00 00 00 00 00 00 =A0|P.=
=2E8............|
> 00000420 =A000 5e 8f 8b 08 00 00 00 =A001 00 00 00 00 00 00 00 =A0|.^=
=2E.............|
> 00000430 =A000 08 00 00 05 00 00 00 =A079 00 00 00 00 00 00 00 =A0|..=
=2E.....y.......|
> 00000440 =A025 70 00 00 00 00 00 00 =A00e 00 00 00 00 00 00 00 =A0|%p=
=2E.............|
> 00000450 =A000 88 88 00 00 00 00 00 =A0bb fb 7c 4b 00 00 00 00 =A0|..=
=2E.......|K....|
> 00000460 =A071 d4 7f 4b 00 00 00 00 =A085 d4 7f 4b 00 00 00 00 =A0|q.=
=2EK.......K....|
> 00000470 =A003 00 32 00 01 00 01 00 =A0bb fb 7c 4b 00 00 00 00 =A0|..=
2.......|K....|
> 00000480 =A000 4e ed 00 00 00 00 00 =A000 00 00 00 0b 00 00 00 =A0|.N=
=2E.............|
> 00000490 =A080 00 20 00 c0 00 10 00 =A08f d2 a7 e6 99 7a 41 e8 =A0|..=
 ..........zA.|
> 000004a0 =A0ae 88 26 e1 48 0c a5 f4 =A000 00 00 00 00 00 00 00 =A0|..=
&.H...........|
> 000004b0 =A000 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00 =A0|..=
=2E.............|
> *
> 00001000 =A0dd 21 ee fe 80 ad 4e a1 =A011 fa af 1e 38 00 07 00 =A0|.!=
=2E...N.....8...|
> 00001010 =A000 00 00 00 00 00 00 00 =A0bb fb 7c 4b 00 00 00 00 =A0|..=
=2E.......|K....|
> ...
>
>
> where "34 34" at offset 0x0406 is the magic number of NILFS.
>
> Regards,
> Ryusuke Konishi
>

:( I think I lost the files...

I get:
00000000  fc 00 0f 13 26 36 42 48  4d 49 46 41 3d 3c 3b 31  |....&6BHMI=
=46A=3D<;1|
00000010  28 14 03 fc 00 0f 12 2a  39 45 4e 4f 4c 46 3f 3c  |(......*9E=
NOLF?<|
00000020  3b 39 2b 21 14 03 fd 00  0f 03 21 28 3a 3f 45 47  |;9+!......=
!(:?EG|
00000030  43 41 3c 3b 34 29 25 13  03 fc 00 0e 19 29 39 43  |CA<;4)%...=
=2E..)9C|
00000040  48 49 48 40 3c 3a 34 2a  17 02 00 fd 00 0c 13 27  |HIH@<:4*..=
=2E....'|
00000050  2a 3b 42 44 3f 35 37 36  2d 28 12 fc 00 0c 0b 19  |*;BD?576-(=
=2E.....|
00000060  22 2c 37 3f 44 3d 3a 33  28 18 0f fc 00 04 10 22  |",7?D=3D:3=
(......"|
00000070  29 35 38 fe 3c 02 37 2a  1e fb 00 09 12 25 28 2b  |)58.<.7*..=
=2E..%(+|
00000080  35 3b 39 2e 27 12 fc 00  08 10 1c 28 29 28 2e 2c  |5;9.'.....=
=2E()(.,|
00000090  24 11 fc 00 06 0a 18 26  27 26 27 15 fb 00 04 13  |$......&'&=
'.....|
000000a0  24 27 1f 11 fb 00 03 12  27 28 13 fc 00 03 12 26  |$'......'(=
=2E....&|
000000b0  26 16 fd 00 00 13 15 22  27 1a 13 12 12 1e 24 26  |&......"'.=
=2E...$&|
000000c0  24 24 26 28 21 22 20 41  60 70 78 77 77 fe 75 1b  |$$&(!" A`p=
xww.u.|
000000d0  77 76 78 77 76 78 75 77  77 75 78 74 75 75 77 75  |wvxwvxuwwu=
xtuuwu|
000000e0  78 75 76 77 79 78 77 77  75 78 78 76 fd 78 12 76  |xuvwyxwwux=
xv.x.v|
000000f0  78 77 77 78 79 79 77 78  78 77 78 78 76 78 77 78  |xwwxyywxxw=
xxvxwx|
00000100  78 76 fe 78 0b 79 78 77  78 79 79 78 79 77 78 79  |xv.x.yxwxy=
yxywxy|
00000110  78 fd 79 0d 76 78 79 7a  77 79 78 7a 78 77 79 7a  |x.y.vxyzwy=
xzxwyz|
00000120  79 77 fe 79 01 78 77 fe  79 04 7a 79 77 7a 79 fe  |yw.y.xw.y.=
zywzy.|
00000130  7a 00 7b fd 7a 00 7b fe  7a 01 7b 78 fe 7a ff 79  |z.{.z.{.z.=
{x.z.y|
00000140  01 77 79 fe 7a ff 7b 00  7a fe 7b fe 79 12 7a 7b  |.wy.z.{.z.=
{.y.z{|
00000150  7b 79 79 7b 7b 7a 7a 7b  79 7a 7b 7b 7a 7a 79 79  |{yy{{zz{yz=
{{zzyy|
00000160  7a fe 7b ff 7a fd 7b fe  7a fc 7b 03 7c 7b 7b 7a  |z.{.z.{.z.=
{.|{{z|
00000170  fe 7b ff 7c 04 79 7b 7b  7c 7b fe 7c 00 7b fe 7c  |.{.|.y{{|{=
=2E|.{.||
00000180  12 7b 7d 7c 7d 7c 7d 7c  7c 7a 7d 7d 7c 7d 7c 7b  |.{}|}|}||z=
}}|}|{|

=2E..

but is there some tool to search for traces of files? or to rebuild
the superblock?

:(

Than you any way...

Regards,
Edgard.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
