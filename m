From: Edgard Pineda <epineda.contact-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cannot mount nilfs2 partition after io error in raid5
Date: Mon, 22 Feb 2010 16:20:15 -0300
Message-ID: <d5c85db51002221120i4e1e3164x70d8c3e9bce2581e@mail.gmail.com>
References: <d5c85db51002220844k1fdd5f03pdd2fd97f61a10fa7@mail.gmail.com>
	 <20100223.022556.192697952.ryusuke@osrg.net>
	 <d5c85db51002220943j30e1be50xacba39fe3077f0df@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:in-reply-to:references
         :date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=K2eoOAIB6J0QC8o62GKxqCJv3AeCAQvYjndZGuhnIKU=;
        b=P2GbGiqx+LaeLEX6W2WTeqFrnsStHF7YsPunvAKFZVdI1NWpAuorAZTEnWUvqsxZS/
         l12Qa/ojP9gstzxBZncFnUpEs4TAIcMOjQN7k7L5KP/tjvTPuims75BtuTjyx8x704zg
         QBFNaDb3p08y7+XiKXUODjUt95zThzujt+Qwk=
In-Reply-To: <d5c85db51002220943j30e1be50xacba39fe3077f0df-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2010/2/22 Edgard Pineda <epineda.contact-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2010/2/22 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
>> Hi,
>> On Mon, 22 Feb 2010 13:44:46 -0300, Edgard Pineda wrote:
>>> Hi,
>>>
>>> I just had a 4 harddrives in raid5 with nilfs2 (kernel 2.6.32 and
>>> nilfs-utils 2.0.15) and I've got a power cut, then I rebuilt the
>>> array, but when I tried to mount the nilfs2 partition I've got:
>>> "NILFS: Can't find nilfs on dev md0" (in dmesg) after execute
>>> "mount.nilfs2: Error while mounting /dev/md0 on disk: Invalid
>>> argument".
>>>
>>> Any idea? can I mount as "read only" to rescue some files? any tool=
s
>>> to "see" the files and fix the partition?
>>>
>>> Regards,
>>> Edgard.
>>
>> Umm.., sounds serious. =A0The message "NILFS: Can't find nilfs on xx=
x"
>> is output when both of the two super blocks are broken.
>>
>> Can you dump the partition with hd command?
>>
>> # hd /dev/md0 | less
>>
>> If the partition is not filled yet, it would look like this:
>>
>> 00000000 =A000 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00 =A0|.=
=2E..............|
>> *
>> 00000400 =A002 00 00 00 00 00 34 34 =A000 01 00 00 7b 93 80 d4 =A0|.=
=2E....44....{...|
>> 00000410 =A050 09 11 38 02 00 00 00 =A017 11 00 00 00 00 00 00 =A0|P=
=2E.8............|
>> 00000420 =A000 5e 8f 8b 08 00 00 00 =A001 00 00 00 00 00 00 00 =A0|.=
^..............|
>> 00000430 =A000 08 00 00 05 00 00 00 =A079 00 00 00 00 00 00 00 =A0|.=
=2E......y.......|
>> 00000440 =A025 70 00 00 00 00 00 00 =A00e 00 00 00 00 00 00 00 =A0|%=
p..............|
>> 00000450 =A000 88 88 00 00 00 00 00 =A0bb fb 7c 4b 00 00 00 00 =A0|.=
=2E........|K....|
>> 00000460 =A071 d4 7f 4b 00 00 00 00 =A085 d4 7f 4b 00 00 00 00 =A0|q=
=2E.K.......K....|
>> 00000470 =A003 00 32 00 01 00 01 00 =A0bb fb 7c 4b 00 00 00 00 =A0|.=
=2E2.......|K....|
>> 00000480 =A000 4e ed 00 00 00 00 00 =A000 00 00 00 0b 00 00 00 =A0|.=
N..............|
>> 00000490 =A080 00 20 00 c0 00 10 00 =A08f d2 a7 e6 99 7a 41 e8 =A0|.=
=2E ..........zA.|
>> 000004a0 =A0ae 88 26 e1 48 0c a5 f4 =A000 00 00 00 00 00 00 00 =A0|.=
=2E&.H...........|
>> 000004b0 =A000 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00 =A0|.=
=2E..............|
>> *
>> 00001000 =A0dd 21 ee fe 80 ad 4e a1 =A011 fa af 1e 38 00 07 00 =A0|.=
!....N.....8...|
>> 00001010 =A000 00 00 00 00 00 00 00 =A0bb fb 7c 4b 00 00 00 00 =A0|.=
=2E........|K....|
>> ...
>>
>>
>> where "34 34" at offset 0x0406 is the magic number of NILFS.
>>
>> Regards,
>> Ryusuke Konishi
>>
>
> :( I think I lost the files...
>
> I get:
> 00000000 =A0fc 00 0f 13 26 36 42 48 =A04d 49 46 41 3d 3c 3b 31 =A0|..=
=2E.&6BHMIFA=3D<;1|
> 00000010 =A028 14 03 fc 00 0f 12 2a =A039 45 4e 4f 4c 46 3f 3c =A0|(.=
=2E....*9ENOLF?<|
> 00000020 =A03b 39 2b 21 14 03 fd 00 =A00f 03 21 28 3a 3f 45 47 =A0|;9=
+!......!(:?EG|
> 00000030 =A043 41 3c 3b 34 29 25 13 =A003 fc 00 0e 19 29 39 43 =A0|CA=
<;4)%......)9C|
> 00000040 =A048 49 48 40 3c 3a 34 2a =A017 02 00 fd 00 0c 13 27 =A0|HI=
H@<:4*.......'|
> 00000050 =A02a 3b 42 44 3f 35 37 36 =A02d 28 12 fc 00 0c 0b 19 =A0|*;=
BD?576-(......|
> 00000060 =A022 2c 37 3f 44 3d 3a 33 =A028 18 0f fc 00 04 10 22 =A0|",=
7?D=3D:3(......"|
> 00000070 =A029 35 38 fe 3c 02 37 2a =A01e fb 00 09 12 25 28 2b =A0|)5=
8.<.7*.....%(+|
> 00000080 =A035 3b 39 2e 27 12 fc 00 =A008 10 1c 28 29 28 2e 2c =A0|5;=
9.'......()(.,|
> 00000090 =A024 11 fc 00 06 0a 18 26 =A027 26 27 15 fb 00 04 13 =A0|$.=
=2E....&'&'.....|
> 000000a0 =A024 27 1f 11 fb 00 03 12 =A027 28 13 fc 00 03 12 26 =A0|$'=
=2E.....'(.....&|
> 000000b0 =A026 16 fd 00 00 13 15 22 =A027 1a 13 12 12 1e 24 26 =A0|&.=
=2E...."'.....$&|
> 000000c0 =A024 24 26 28 21 22 20 41 =A060 70 78 77 77 fe 75 1b =A0|$$=
&(!" A`pxww.u.|
> 000000d0 =A077 76 78 77 76 78 75 77 =A077 75 78 74 75 75 77 75 =A0|wv=
xwvxuwwuxtuuwu|
> 000000e0 =A078 75 76 77 79 78 77 77 =A075 78 78 76 fd 78 12 76 =A0|xu=
vwyxwwuxxv.x.v|
> 000000f0 =A078 77 77 78 79 79 77 78 =A078 77 78 78 76 78 77 78 =A0|xw=
wxyywxxwxxvxwx|
> 00000100 =A078 76 fe 78 0b 79 78 77 =A078 79 79 78 79 77 78 79 =A0|xv=
=2Ex.yxwxyyxywxy|
> 00000110 =A078 fd 79 0d 76 78 79 7a =A077 79 78 7a 78 77 79 7a =A0|x.=
y.vxyzwyxzxwyz|
> 00000120 =A079 77 fe 79 01 78 77 fe =A079 04 7a 79 77 7a 79 fe =A0|yw=
=2Ey.xw.y.zywzy.|
> 00000130 =A07a 00 7b fd 7a 00 7b fe =A07a 01 7b 78 fe 7a ff 79 =A0|z.=
{.z.{.z.{x.z.y|
> 00000140 =A001 77 79 fe 7a ff 7b 00 =A07a fe 7b fe 79 12 7a 7b =A0|.w=
y.z.{.z.{.y.z{|
> 00000150 =A07b 79 79 7b 7b 7a 7a 7b =A079 7a 7b 7b 7a 7a 79 79 =A0|{y=
y{{zz{yz{{zzyy|
> 00000160 =A07a fe 7b ff 7a fd 7b fe =A07a fc 7b 03 7c 7b 7b 7a =A0|z.=
{.z.{.z.{.|{{z|
> 00000170 =A0fe 7b ff 7c 04 79 7b 7b =A07c 7b fe 7c 00 7b fe 7c =A0|.{=
=2E|.y{{|{.|.{.||
> 00000180 =A012 7b 7d 7c 7d 7c 7d 7c =A07c 7a 7d 7d 7c 7d 7c 7b =A0|.{=
}|}|}||z}}|}|{|
>
> ...

sorry I forgot to show the content of /dev/md0 from offset 0x0400:

00000400  01 7f 80 fc 7f f9 80 03  7f 7e 7f 80 fe 7f fd 7f  |.........~=
=2E.....|
00000410  03 7e 7f 80 80 fa 7f ff  7e fa 7f fe 7e 02 7f 80  |.~......~.=
=2E.~...|
00000420  7e fe 7f 05 7e 7f 7f 80  7f 80 fd 7f 00 7e fd 7f  |~...~.....=
=2E..~..|
00000430  ff 7e 03 7f 7e 7f 7f fe  7e ff 7f fc 7e 00 7d fd  |.~..~...~.=
=2E.~.}.|
00000440  7e 03 7d 7e 7d 7e fb 7f  08 7e 7f 7e 7f 7f 7e 7f  |~.}~}~...~=
=2E~..~.|
00000450  7f 7e fb 7f ff 7e fe 7f  00 7d fe 7f fe 80 01 7f  |.~...~...}=
=2E.....|
00000460  7e fe 7f 01 7e 7f fe 7e  fe 7f 01 7e 7d fc 7e 01  |~...~..~..=
=2E~}.~.|
00000470  7f 7e 01 7f 7e fe 7d fe  7f ff 7e ff 7f fc 7e 00  |.~..~.}...=
~...~.|
00000480  7f fe 7e 02 7f 7e 7f fe  7e 04 7d 7e 7e 7d 7d fb  |..~..~..~.=
}~~}}.|
00000490  7e 00 7d fe 7e 00 7d fe  7e fe 7d 02 7e 7d 7c f8  |~.}.~.}.~.=
}.~}|.|
000004a0  7e ff 7d fe 7e fe 7d 00  7e fd 7d 05 7e 7d 7e 7d  |~.}.~.}.~.=
}.~}~}|
000004b0  7d 7c fe 7e fe 7d 00 7e  fe 7d 05 7e 7d 7d 7c 7d  |}|.~.}.~.}=
=2E~}}|}|
000004c0  7e fe 7d fe 7c 09 7d 7e  7d 7d 7e 7d 7d 7e 7e 7d  |~.}.|.}~}}=
~}}~~}|
000004d0  fe 7d 06 7e 7d 7d 7c 7e  7d 7e fd 7d ff 7e 05 7c  |.}.~}}|~}~=
=2E}.~.||
000004e0  7d 7c 7c 7d 7c f8 7d fd  7c 07 7d 7c 7d 7c 7d 7d  |}||}|.}.|.=
}|}|}}|


>
> but is there some tool to search for traces of files? or to rebuild
> the superblock?
>
> :(
>
> Than you any way...
>
> Regards,
> Edgard.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
