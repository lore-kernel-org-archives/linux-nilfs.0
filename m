From: Edgard Pineda <epineda.contact-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cannot mount nilfs2 partition after io error in raid5
Date: Mon, 22 Feb 2010 18:10:57 -0300
Message-ID: <d5c85db51002221310o864e35evd5462d4b4aa53f54@mail.gmail.com>
References: <d5c85db51002220844k1fdd5f03pdd2fd97f61a10fa7@mail.gmail.com>
	 <20100223.022556.192697952.ryusuke@osrg.net>
	 <d5c85db51002221149g2c01e7ecwbca5ffaf59471b6f@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:in-reply-to:references
         :date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=9fPxLrwx8FQj4WYjJv+3bwzn6Mog428HCJKaxaaijSI=;
        b=eUkG2vCDjpWWUsKoSSZMcr9NZdMpaH/SeFIw0B9SaVmOr+tTkx/jcjW7ro/XeQTaUa
         J+WzuLFvqepJDBSls46qw5+owox2DBClcaSwXCeoISosJ0Of08IIwVJWf4SdFal9Y8oD
         Qpppu7BahG0Sb5a4u0q29LyzksQ+0X6qJhR60=
In-Reply-To: <d5c85db51002221149g2c01e7ecwbca5ffaf59471b6f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2010/2/22 Edgard Pineda <epineda.contact-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> RESOLVED!! thank you a lot Ryusuke! the problem was the re-creation o=
f

well... sorry, not all resolved at all... when I tried the devices
order combinations there are 4 combinations with which when I try to
mount in read only mode I got  "warning: broken superblock. using
spare superblock.", and other 2 combination where I only got "warning:
Checksum error in segment payload".

Then my problem now is how I can detect which of these 2 combination
is the correct and how I can fix the checksum error in segment
payload??

When mounting with the following command:

mount -t nilfs2 -r /dev/md0 /mnt/d1

I got in dmesg:

NILFS: INFO: recovery required for readonly filesystem.
NILFS: write access will be enabled during recovery.
NILFS: warning: Checksum error in segment payload.
NILFS: error searching super root.

And the partition don't get mounted.

any ideas?

Regards,
Edgard.

> my raid5 array with 1 missing device in other server: I had to try
> many combinations creating the array, for example:
>
> mdadm --create /dev/md0 --assume-clean --level=3D5 --raid-devices=3D4
> /dev/sdb1 /dev/sdc1 /dev/sdd1 missing
> then...
> mdadm --stop /dev/md0
> mdadm --create /dev/md0 --assume-clean --level=3D5 --raid-devices=3D4
> /dev/sdb1 /dev/sdd1 /dev/sdc1 missing
> then...
> mdadm --stop /dev/md0
> mdadm --create /dev/md0 --assume-clean --level=3D5 --raid-devices=3D4
> /dev/sdb1 /dev/sdd1 /dev/sdc1 missing
>
> Finally with "hd /dev/md0 | less" I got:
>
> 00000000 =A000 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00 =A0|..=
=2E.............|
> *
> 00000400 =A002 00 00 00 00 00 34 34 =A000 01 00 00 94 f1 52 4b =A0|..=
=2E...44......RK|
> 00000410 =A0e6 94 e9 bd 02 00 00 00 =A044 75 05 00 00 00 00 00 =A0|..=
=2E.....Du......|
> 00000420 =A000 00 16 a2 ba 02 00 00 =A001 00 00 00 00 00 00 00 =A0|..=
=2E.............|
> 00000430 =A000 08 00 00 05 00 00 00 =A050 ef 02 00 00 00 00 00 =A0|..=
=2E.....P.......|
> 00000440 =A000 f8 c1 1e 00 00 00 00 =A068 4d 09 00 00 00 00 00 =A0|..=
=2E.....hM......|
> 00000450 =A000 e8 c7 27 00 00 00 00 =A098 f6 4a 4a 00 00 00 00 =A0|..=
=2E'......JJ....|
> 00000460 =A05f ea 0b 4b 00 00 00 00 =A02e 17 2c 4b 00 00 00 00 =A0|_.=
=2EK......,K....|
> 00000470 =A009 00 32 00 00 00 01 00 =A098 f6 4a 4a 00 00 00 00 =A0|..=
2.......JJ....|
> 00000480 =A000 4e ed 00 00 00 00 00 =A000 00 00 00 0b 00 00 00 =A0|.N=
=2E.............|
> 00000490 =A080 00 20 00 c0 00 10 00 =A048 55 07 21 83 15 41 bc =A0|..=
 .....HU.!..A.|
> 000004a0 =A0a1 bf 15 04 c9 27 77 98 =A000 00 00 00 00 00 00 00 =A0|..=
=2E..'w.........|
> 000004b0 =A000 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00 =A0|..=
=2E.............|
> *
> 00001000 =A01a 08 ef 53 b1 23 1e af =A011 fa af 1e 38 00 10 00 =A0|..=
=2ES.#......8...|
> 00001010 =A036 75 05 00 00 00 00 00 =A0a5 64 de 4a 00 00 00 00 =A0|6u=
=2E......d.J....|
> 00001020 =A000 08 00 00 00 00 00 00 =A0ff 07 00 00 01 00 00 00 =A0|..=
=2E.............|
> 00001030 =A0c0 7f 00 00 00 00 00 00 =A09b 35 00 00 00 00 00 00 =A0|..=
=2E......5......|
> 00001040 =A046 02 00 00 00 00 00 00 =A0f7 07 00 00 f7 07 00 00 =A0|F.=
=2E.............|
> 00001050 =A0e4 15 19 01 00 00 00 00 =A0ba 1c 00 00 00 00 00 00 =A0|..=
=2E.............|
> 00001060 =A0e5 15 19 01 00 00 00 00 =A0bb 1c 00 00 00 00 00 00 =A0|..=
=2E.............|
>
> references about linux raid5:
> http://ubuntuforums.org/archive/index.php/t-410136.html
> http://www.intelligentedu.com/how_to_recover_from_a_broken_raid5.html
>
> Regards,
> Edgard.
>
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
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
