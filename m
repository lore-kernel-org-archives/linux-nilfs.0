From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: urgent help need! disk partition info lost
Date: Thu, 5 Nov 2009 17:18:42 +0200
Message-ID: <ee5afd760911050718t4eca6855kdf70fcc7f2014bf8@mail.gmail.com>
References: <856033f20911021106u771f823dkb48395958ad83a37@mail.gmail.com>
	<ee5afd760911031014l5bd4899ble3b6522e758bfb8d@mail.gmail.com>
	<856033f20911031148o4d856a59vc711d1053ac9d1bc@mail.gmail.com>
	<ee5afd760911031336g122fc338r8d2879a48d5e11d6@mail.gmail.com>
	<856033f20911031823m715b1f91q818e9c78cda9315d@mail.gmail.com>
	<ee5afd760911041046s70ada5d6w686ce83814b3e9e6@mail.gmail.com>
	<856033f20911041131n54c420fuf16b10fefb343188@mail.gmail.com>
	<ee5afd760911041326g77cab1d9r90f55657dc11a789@mail.gmail.com>
	<856033f20911041719w12410864hdbdb8d5e6aed2070@mail.gmail.com>
	<856033f20911041957n7c88e5afvb60b6de9ee42bce7@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1559590019=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <856033f20911041957n7c88e5afvb60b6de9ee42bce7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============1559590019==
Content-Type: multipart/alternative; boundary=0014852f58d21ca3400477a13ea3

--0014852f58d21ca3400477a13ea3
Content-Type: text/plain; charset=ISO-8859-1

Paul,
I have been doing some research in between things today
here is some proposition I came up with, please check my math
and thinking and do some more sleuthing. Please ask if anything
is not clear:

The math has been done on my trusted calc package for emacs
hence the 16# for the base in front.

16#3D7C00000    device size according to you
16#3D7800000    device size according to superblock (at 16#420)
------------- -
16#000400000    this agrees with the partition base address of the second
                             superblock which lives at 16#400400 according
to you
                             also the start address of segment 0 indexes
from here

>mmcblk0: starts at address 00400400,  and the nilfs segment 0 starts
>at address 00401000.

if at least in this line you send me, the addresses are from 00000 of the
device.

So I am inclined to believe that the original(before the accident)
start address of the nilfs partition was at 16#400000 of the device.


Then this holds true according to nilfs2_fs.h:
/*
 * bytes offset of secondary super block
 */
#define NILFS_SB2_OFFSET_BYTES(devsize)    ((((devsize) >> 12) - 1) << 12)

so:
16#3D7800000    device size according to superblock (16#420)
16#000001000    and blank the ls 000 but they are 0 already
------------ -
16#3D77FF000    should be the place of the 2nd superblock in the original
partition
16#000400000    index of the original partition (believed to be)
------------ +
16#3D7BFF000    should be the place in the device where the 2nd superblock
lives.
                              (or maybe I should say the 3rd)

This whole proposition is off course grounded in the belief that the first
superblock
with the error flag set is written in error and should be discarded.
Although it might refer to real additional data because it has more
checkpoints than the 2nd
that you found. But I would rather discard those and retrieve the older
checkpoint.
Both superblocks were created in the same login session by the way.

So could you make an efford to find the 3rd superblock or send me the 3
blocks around the
place I indicated, to see what happened there.

Jan de Kruyf.

"Enthusiasm beats facts anytime"
------------------------------------------


On Thu, Nov 5, 2009 at 5:57 AM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> BTW, I checked the other disk that I have nilfs2 installed, the two
> super blocks indeed are one at the beginning, and one at the end of
> the partition.
>
> Very strange that this isn't the case on /dev/mmcblk0. Indeed I
> started using nilfs version 2.0.5 on it, then later upgraded to
> 2.0.15, not sure if in between something caused this problem.
>
>
> On 11/4/09, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > I think it might be the "hexdump" utility that I used. It by default
> > groups things by word, so in little endian it'd say 0002 but the
> > actual byte sequence is 02 00.
> >
> > I re-dump the following in byte sequence using od.
> >
> > first superblock
> >
> > 000400 02 00 00 00 00 00 34 34 00 01 00 00 09 b2 31 5b
> > 000410 83 11 4c 79 02 00 00 00 af 07 00 00 00 00 00 00
> > 000420 00 00 80 d7 03 00 00 00 01 00 00 00 00 00 00 00
> > 000430 00 08 00 00 05 00 00 00 0b 09 0e 00 00 00 00 00
> > 000440 10 07 35 00 00 00 00 00 02 85 08 00 00 00 00 00
> > 000450 00 88 0b 00 00 00 00 00 c1 93 3c 49 00 00 00 00
> > 000460 3f 01 e2 4a 00 00 00 00 8f 2a ef 4a 00 00 00 00
> > 000470 a2 00 32 00 03 00 01 00 c1 93 3c 49 00 00 00 00
> > 000480 00 4e ed 00 00 00 00 00 00 00 00 00 0b 00 00 00
> > 000490 80 00 20 00 c0 00 10 00 2b ed f5 04 cb 41 48 ae
> > 0004a0 8a 7f 49 48 ec 71 f5 e7 00 00 00 00 00 00 00 00
> > 0004b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >
> > backup copy of the super block (actually different from the above)
> >
> > 400400 02 00 00 00 00 00 34 34 00 01 00 00 09 b2 31 5b
> > 400410 86 db 83 b3 02 00 00 00 af 07 00 00 00 00 00 00
> > 400420 00 00 80 d7 03 00 00 00 01 00 00 00 00 00 00 00
> > 400430 00 08 00 00 05 00 00 00 08 09 0e 00 00 00 00 00
> > 400440 00 00 35 00 00 00 00 00 02 85 08 00 00 00 00 00
> > 400450 00 88 0b 00 00 00 00 00 c1 93 3c 49 00 00 00 00
> > 400460 3f 01 e2 4a 00 00 00 00 fe 24 ef 4a 00 00 00 00
> > 400470 a2 00 32 00 00 00 01 00 c1 93 3c 49 00 00 00 00
> > 400480 00 4e ed 00 00 00 00 00 00 00 00 00 0b 00 00 00
> > 400490 80 00 20 00 c0 00 10 00 2b ed f5 04 cb 41 48 ae
> > 4004a0 8a 7f 49 48 ec 71 f5 e7 00 00 00 00 00 00 00 00
> > 4004b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >
> > The address is the absolute index into the root partition
> > /dev/mmcblk0, whose total size is 0x3D7C00000. So the backup copy of
> > the super block is not something at the end of the disk.
> >
> > The first partition /dev/mmcblk0p1 indexes into the root parition by
> > 8192 bytes.
> >
> > Regards,
> > Paul Liu
> >
> > On 11/4/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> just thought of something. You searched with standard (little, I think)
> >> endianess
> >> i.e. the image from my mail to you.
> >>  try the image from YOUR main superblock:
> >> 0002 0000 0000 3434
> >> and see if the backup copy surfaces.
> >>
> >> jan.
> >>
> >> On Wed, Nov 4, 2009 at 9:31 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> I'm using nilfs 2.0.15, slackware current, kernel 2.6.28, on Acer
> >>> Aspire One model A101,  which uses Atom CPU.
> >>>
> >>> I failed to find the superblock towards the end of either mmcblk0 or
> >>> mmcblk0p1, but a search of hex string 0200000000003434 reveals that:
> >>>
> >>> mmcblk0: starts at address 00400400,  and the nilfs segment 0 starts
> >>> at address 00401000.
> >>>
> >>> mmcblk0p1: starts at address 003FE400, and the nilfs segment 0 starts
> >>> at 003FF000.
> >>>
> >>> I hope my SD card is not messing up itself by rearranging the blocks!
> >>>
> >>> Regards,
> >>> Paul Liu
> >>>
> >>> On 11/4/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>> > Hallo,
> >>> > here we go again. As a matter of interest, what version of nilfs and
> >>> > what
> >>> > distribution are you running? And what processor?
> >>> > your endiannes confused me at first.
> >>> >
> >>> > glad you fixed your hexedit
> >>> >
> >>> > I have looked at some numbers in the superblock and they look ok. I
> do
> >>> > wonder if you have the garbage collector running.
> >>> >
> >>> > now for the second superblock. Please pay attention to the exact
> place
> >>> > of
> >>> > it. Because it is of vital
> >>> > importance if it in in partition 1 or in the root of the disk.
> >>> >
> >>> > the first superblock sits as you observed in the root. The flags say
> >>> amongst
> >>> > others that it was unmounted cleanly but errors were detected.
> >>> >
> >>> > see  nilfs2_fs.h - NILFS2 on-disk structures and common declarations.
> >>> > in
> >>> the
> >>> > distribution.
> >>> > /**
> >>> >  * struct nilfs_super_block - structure of super block on disk
> >>> >  */
> >>> > struct nilfs_super_block {
> >>> > ....
> >>> > translates bit for bit to what you see written in the super block on
> >>> disk.
> >>> >
> >>> > Here is an example from a partition of mine on how to discover the
> >>> > superblock copy
> >>> > it should read the same as the 1st but in your case it might not.
> >>> > It is a leftshift - subtract 1 - right shift algorithm.
> >>> > go in hexedit to the last data with ">" (shift .)
> >>> > note the address of the last byte (the size of the partion)
> >>> > in mine:
> >>> > 6566B3F0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >>> > ................
> >>> > or the status line might give it
> >>> > the address of the copy is now at 6566A000
> >>> > i.e. 6566B has 1 subtracted from it and the 3 least significant
> digits
> >>> have
> >>> > been zeroed.
> >>> >
> >>> > so please dump yours, see if the algorithm works on the 1st part or
> on
> >>> the
> >>> > root or both,
> >>> > so we know where it is.
> >>> > And check if it is exactly the same as the first one you send me
> >>> > "0000400 0002 0000 0000 3434 0100 0000 b209 5b31"
> >>> > etc.
> >>> >
> >>> > the next thing to discover is where the start of (nilfs)segment 0 is.
> >>> > I am not quite sure what is written in it, but the signature is quite
> >>> > distinct.
> >>> > This is what it looks on my machine:
> >>> >
> >>> > 00000FC0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >>> > ................
> >>> > 00000FD0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >>> > ................
> >>> > 00000FE0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >>> > ................
> >>> > 00000FF0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >>> > ................
> >>> > 00001000   C4 1B 47 5B 51 62 19 13  11 FA AF 1E 38 00 10 00
> >>> > ..G[Qb......8...
> >>> > 00001010   FB CE 01 00 00 00 00 00  EE BD F1 4A 00 00 00 00
> >>> > ...........J....
> >>> > 00001020   00 08 00 00 00 00 00 00  FF 07 00 00 32 00 00 00
> >>> > ............2...
> >>> > 00001030   A0 83 00 00 00 00 00 00  EE 0D 00 00 00 00 00 00
> >>> > ................
> >>> > 00001040   07 00 00 00 00 00 00 00  7B 00 00 00 7B 00 00 00
> >>> > ........{...{...
> >>> > 00001050   EA 9E 07 00 00 00 00 00  F8 01 00 00 00 00 00 00
> >>> > ................
> >>> > 00001060   EB 9E 07 00 00 00 00 00  F9 01 00 00 00 00 00 00
> >>> > ................
> >>> > 00001070   EC 9E 07 00 00 00 00 00  FA 01 00 00 00 00 00 00
> >>> > ................
> >>> > 00001080   ED 9E 07 00 00 00 00 00  FB 01 00 00 00 00 00 00
> >>> > ................
> >>> > 00001090   EE 9E 07 00 00 00 00 00  FC 01 00 00 00 00 00 00
> >>> > ................
> >>> > 000010A0   EF 9E 07 00 00 00 00 00  FD 01 00 00 00 00 00 00
> >>> > ................
> >>> > 000010B0   F0 9E 07 00 00 00 00 00  FE 01 00 00 00 00 00 00
> >>> > ................
> >>> > 000010C0   F2 9E 07 00 00 00 00 00  FF 01 00 00 00 00 00 00
> >>> > ................
> >>> > 000010D0   F3 9E 07 00 00 00 00 00  00 02 00 00 00 00 00 00
> >>> > ................
> >>> > 000010E0   F4 9E 07 00 00 00 00 00  01 02 00 00 00 00 00 00
> >>> > ................
> >>> > 000010F0   F5 9E 07 00 00 00 00 00  02 02 00 00 00 00 00 00
> >>> > ................
> >>> > 00001100   F6 9E 07 00 00 00 00 00  03 02 00 00 00 00 00 00
> >>> > ................
> >>> > 00001110   F7 9E 07 00 00 00 00 00  04 02 00 00 00 00 00 00
> >>> > ................
> >>> > 00001120   F8 9E 07 00 00 00 00 00  05 02 00 00 00 00 00 00
> >>> > ................
> >>> > 00001130   F9 9E 07 00 00 00 00 00  06 02 00 00 00 00 00 00
> >>> > ................
> >>> > 00001140   FA 9E 07 00 00 00 00 00  07 02 00 00 00 00 00 00
> >>> > ................
> >>> > 00001150   FB 9E 07 00 00 00 00 00  08 02 00 00 00 00 00 00
> >>> > ................
> >>> > 00001160   FC 9E 07 00 00 00 00 00  09 02 00 00 00 00 00 00
> >>> > ................
> >>> > 00001170   FD 9E 07 00 00 00 00 00  0A 02 00 00 00 00 00 00
> >>> > ................
> >>> > 00001180   FE 9E 07 00 00 00 00 00  0B 02 00 00 00 00 00 00
> >>> > ................
> >>> > 00001190   FF 9E 07 00 00 00 00 00  0C 02 00 00 00 00 00 00
> >>> > ................
> >>> > 000011A0   00 9F 07 00 00 00 00 00  0D 02 00 00 00 00 00 00
> >>> > ................
> >>> > 000011B0   01 9F 07 00 00 00 00 00  0E 02 00 00 00 00 00 00
> >>> > ................
> >>> > 000011C0   02 9F 07 00 00 00 00 00  0F 02 00 00 00 00 00 00
> >>> > ................
> >>> > 000011D0   03 9F 07 00 00 00 00 00  10 02 00 00 00 00 00 00
> >>> > ................
> >>> > 000011E0   04 9F 07 00 00 00 00 00  11 02 00 00 00 00 00 00
> >>> > ................
> >>> >
> >>> > Segment 0 starts at hex 1000 of a nilfs partition as you can see
> above
> >>> and
> >>> > carries on for quite a while like this.
> >>> >
> >>> > so have a look on your disk if it sits at 1000 of the root partition
> >>> > or
> >>> at
> >>> > 1000 of partition 1.
> >>> >
> >>> > Once we have these things sorted I would say that we are ready to
> >>> > plant
> >>> the
> >>> > _right_ superblock of the 2
> >>> > in the right place and see if the partition is recoqnized by nilfs.
> >>> > Off course we will save the place where we are going to plant that
> >>> > block
> >>> > first.
> >>> >
> >>> > And now back to the birthday party . . . .
> >>> >
> >>> > Cheers,
> >>> >
> >>> > Jan
> >>> >
> >>> >
> >>> >
> >>> > On Wed, Nov 4, 2009 at 4:23 AM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>> >
> >>> >> On 11/3/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>> >> > 26 august 98: hexedit 0.9.5 release
> >>> >> > september 2005:
> >>> >> >     - version 1.2.12  this is the one I am running.
> >>> >>
> >>> >> Ah, I must be using the wrong hexedit.. now I've installed the same
> >>> >> one
> >>> >> you
> >>> >> use.
> >>> >>
> >>> >> > did I hear that you have always had /dev/mmcblk0p1 in fstab??
> >>> >>
> >>> >> Yes. What I put there is:
> >>> >>
> >>> >> /dev/mmcblk0p1 /home    nilfs2 defaults           1 1
> >>> >>
> >>> >> > hd -n1536 /dev/mmcblk0 >part.start
> >>> >> > hd -s8191 -n1536 /dev/mmcblk0 >part1.start
> >>> >> > an to verify the last line:
> >>> >> > hd -n1536 /dev/mmcblk0p1 >part1a.start
> >>> >>
> >>> >> Here is the output (I use hexdump instead of hd, hopefully they are
> >>> >> the
> >>> >> same)
> >>> >>
> >>> >> bash-3.1# cat part.start
> >>> >> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> >>> >> *
> >>> >> 00001b0 0000 0000 0000 0000 0696 6c22 0000 0100
> >>> >> 00001c0 0001 0383 ffd0 0010 0000 dff0 01eb 0000
> >>> >> 00001d0 0000 0000 0000 0000 0000 0000 0000 0000
> >>> >> *
> >>> >> 00001f0 0000 0000 0000 0000 0000 0000 0000 aa55
> >>> >> 0000200 0000 0000 0000 0000 0000 0000 0000 0000
> >>> >> *
> >>> >> 0000400 0002 0000 0000 3434 0100 0000 b209 5b31
> >>> >> 0000410 1183 794c 0002 0000 07af 0000 0000 0000
> >>> >> 0000420 0000 d780 0003 0000 0001 0000 0000 0000
> >>> >> 0000430 0800 0000 0005 0000 090b 000e 0000 0000
> >>> >> 0000440 0710 0035 0000 0000 8502 0008 0000 0000
> >>> >> 0000450 8800 000b 0000 0000 93c1 493c 0000 0000
> >>> >> 0000460 013f 4ae2 0000 0000 2a8f 4aef 0000 0000
> >>> >> 0000470 00a2 0032 0003 0001 93c1 493c 0000 0000
> >>> >> 0000480 4e00 00ed 0000 0000 0000 0000 000b 0000
> >>> >> 0000490 0080 0020 00c0 0010 ed2b 04f5 41cb ae48
> >>> >> 00004a0 7f8a 4849 71ec e7f5 0000 0000 0000 0000
> >>> >> 00004b0 0000 0000 0000 0000 0000 0000 0000 0000
> >>> >> *
> >>> >> 0000600
> >>> >> bash-3.1# cat part1.start
> >>> >> 0001fff 0000 0000 0000 0000 0000 0000 0000 0000
> >>> >> *
> >>> >> 00025ff
> >>> >> bash-3.1# cat part1a.start
> >>> >> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> >>> >> *
> >>> >> 0000600
> >>> >>
> >>> >> Regards,
> >>> >> Paul Liu
> >>> >>
> >>> >> > On Tue, Nov 3, 2009 at 9:48 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>> >> >
> >>> >> >> Thanks a lot for the instructions! I'm attaching the mbr and
> >>> partition
> >>> >> >> table with this email.
> >>> >> >>
> >>> >> >> I'm pretty sure I had 1 partition on the card, since my
> /etc/fstab
> >>> >> >> mounts mmcblk0p1.
> >>> >> >>
> >>> >> >> I think something corrupted my disk first, and then what I've
> done
> >>> >> >> to
> >>> >> >> the disk after noticing the corruption:
> >>> >> >>
> >>> >> >> 1. fdisk, it says use "w" will correct the error, so I did. But
> >>> >> >> then
> >>> >> >> the one parition is gone.
> >>> >> >> 2. fdisk again, create a single partition, then "w"
> >>> >> >>
> >>> >> >> My mistake was that I didn't create a backup copy of the MBR. A
> >>> >> >> hard
> >>> >> >> lesson learned :(
> >>> >> >>
> >>> >> >> Also, why is that my hexedit doesn't take the "-s" option? It's
> >>> >> >> version 0.9.7, and can't edit bigger than 4.2GB.
> >>> >> >>
> >>> >> >> My SD card is A-DATA brand, class 6, and 16GB.
> >>> >> >>
> >>> >> >> I'm using Linux, and fdisk version (util-linux-ng 2.14.1)
> >>> >> >>
> >>> >> >> Regards,
> >>> >> >> Paul Liu
> >>> >> >>
> >>> >> >> On 11/3/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>> >> >> >  hallo,
> >>> >> >> > Almost sounds like you had only the root master-boot-record
> >>> >> /dev/mmcblk0
> >>> >> >> > before and now you have added 1 main partition /dev/mmcblk0p1.
> >>> >> >> >
> >>> >> >> > If (and only if) that is the case we have to undo the the 1st
> >>> >> partition
> >>> >> >> > +
> >>> >> >> > check that no nilfs is overwritten.
> >>> >> >> > and I would have to urgently study fdisk to see exactly what it
> >>> >> >> > writes
> >>> >> >> when
> >>> >> >> > and where.
> >>> >> >> > The last time I did tricks like these is quit a few years ago.
> >>> >> >> >
> >>> >> >> > It is the Linux version of fdisk is it??
> >>> >> >> >
> >>> >> >> > So here is the plan of action:
> >>> >> >> > hexdump the master boot record to file.
> >>> >> >> > like this:
> >>> >> >> >
> >>> >> >> > dd if=/dev/mmcblk0 of=backup-mmcblk0.mbr count=1 bs=512
> >>> >> >> >
> >>> >> >> > then dump any partitions of the device in a format useful as
> >>> >> >> > input
> >>> to
> >>> >> >> > sfdisk. For example,
> >>> >> >> >                   % sfdisk -d /dev/mmcblk0  > mmcblk0 .out
> >>> >> >> > sfdisk is a tool provided with the util-linux
> >>> >> >> > package<http://www.kernel.org/pub/linux/utils/util-linux/>.
> >>> >> >> >
> >>> >> >> >
> >>> >> >> > or you could use hexdump to get machine readable or man
> readable
> >>> >> images.
> >>> >> >> > Here is the man readable version:
> >>> >> >> > hd -n512 /dev/mmcblk0 > backup-mmcblk0.mbr
> >>> >> >> > hd -n512 /dev/mmcblk0p1 >backup-mmcblk0p1.mbr
> >>> >> >> > etc.
> >>> >> >> >
> >>> >> >> > By the way boor records always end with '55 AA'.
> >>> >> >> >
> >>> >> >> > Keep your files in a safe place in case we mess something we
> can
> >>> >> >> > at
> >>> >> >> > least
> >>> >> >> go
> >>> >> >> > back to the present situation.
> >>> >> >> > If you could dd the whole drive to a file, now that would be
> >>> >> >> > magic
> >>> >> >> indeed!
> >>> >> >> > but you must have the space on a harddrive.
> >>> >> >> > count=... is the number of sectors in the above line (dd ...)
> >>> >> >> > that
> >>> >> >> > you
> >>> >> >> dump
> >>> >> >> > to file.
> >>> >> >> > Hexedit will tell you the number of sectors is you start it
> with
> >>> >> >> > -s
> >>> >> >> option
> >>> >> >> > and then go to the last sector.
> >>> >> >> > DONT stop hexedit with control-x use cntl-c.
> >>> >> >> > DONT use high level or even midlevel tools on a stuffed disk,
> it
> >>> >> >> > normally
> >>> >> >> > messes more than it solves.
> >>> >> >> > unless of course you really,really know what you are doing.
> >>> >> >> > Fiddling the bytes is in general safe and gives results, if a
> >>> >> >> > man
> >>> >> keeps
> >>> >> >> > a
> >>> >> >> > cool head.
> >>> >> >> >
> >>> >> >> > Please send me the fdisk version, the size of the card, and the
> >>> >> >> > mbr
> >>> >> dump
> >>> >> >> to
> >>> >> >> > feast my eyes on.
> >>> >> >> >
> >>> >> >> > cheers,
> >>> >> >> >
> >>> >> >> > Jan de kruyf.
> >>> >> >> >
> >>> >> >> >
> >>> >> >> >
> >>> >> >> > On Tue, Nov 3, 2009 at 1:27 AM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>> >> >> > wrote:
> >>> >> >> >
> >>> >> >> >> just want to add that I've always been using 1 partition on
> >>> >> >> >> this
> >>> >> >> >> device, it's actually /dev/mmcblk0p1. But hexedit
> >>> >> >> >> /dev/mmcblk0p1
> >>> >> >> >> doesn't show that 34 34 at line begining with 0x400, only
> >>> >> >> >> hexedit
> >>> >> >> >> /dev/mmcblk0 shows it. Not sure if this is a problem.
> >>> >> >> >>
> >>> >> >> >> Any help is greatly appreciated!
> >>> >> >> >>
> >>> >> >> >>
> >>> >> >> >> On 11/2/09, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>> >> >> >> > Thanks for the tips. When I first used the SD card, I used
> >>> >> >> >> > fdisk
> >>> >> >> >> > to
> >>> >> >> >> > create the partition.
> >>> >> >> >> >
> >>> >> >> >> > The device is /dev/mmcblk0, and hexedit -d -s /dev/mmcblk0
> >>> >> >> >> > shows
> >>> >> that
> >>> >> >> >> > at the line 0x0400, it is indeed 34 34. What should I do
> >>> >> >> >> > then?
> >>> >> >> >> >
> >>> >> >> >> > I tried gparted, but apparently it has no support for
> nilfs2.
> >>> >> >> >> >
> >>> >> >> >> > Regards,
> >>> >> >> >> > Paul Liu
> >>> >> >> >> >
> >>> >> >> >> > On 11/2/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>> >> >> >> >> Did you first format this card with fdisk?
> >>> >> >> >> >> did you give it the exact same info this time around?
> >>> >> >> >> >>
> >>> >> >> >> >> Can you read /dev/'sdcard' ? (sdcard being the device in
> the
> >>> dev
> >>> >> >> >> >> directory
> >>> >> >> >> >> where the card lives)
> >>> >> >> >> >>
> >>> >> >> >> >> If yes can you run hexedit -s /dev/sdcard1  in a terminal
> as
> >>> >> >> >> >> root?
> >>> >> >> >> >> and go to address 0400 - 04B0 to see if nilfs still exists?
> >>> >> >> >> >>
> >>> >> >> >> >> be very careful no to save any data in hexedit, it will
> >>> >> >> >> >> definitely
> >>> >> >> and
> >>> >> >> >> >> finally
> >>> >> >> >> >> destoy your data.
> >>> >> >> >> >>
> >>> >> >> >> >> 0400 looks vagely like this:
> >>> >> >> >> >> 00000400   02 00 00 00 00 00 34 34  00 01 00 00 D3 56 F0 B9
> >>> >> >> >> >> ......44.....V..
> >>> >> >> >> >> 00000410   39 BF D9 73 02 00 00 00  CA 02 00 00 00 00 00 00
> >>> >> >> >> >> 9..s............
> >>> >> >> >> >> 00000420   00 B4 66 65 01 00 00 00  01 00 00 00 00 00 00 00
> >>> >> >> >> >> ..fe............
> >>> >> >> >> >> 00000430   00 08 00 00 05 00 00 00  01 00 00 00 00 00 00 00
> >>> >> >> >> >> ................
> >>> >> >> >> >> 00000440   01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >>> >> >> >> >> ................
> >>> >> >> >> >> 00000450   00 48 16 00 00 00 00 00  73 95 DC 4A 00 00 00 00
> >>> >> >> >> >> .H......s..J....
> >>> >> >> >> >> 00000460   00 00 00 00 00 00 00 00  73 95 DC 4A 00 00 00 00
> >>> >> >> >> >> ........s..J....
> >>> >> >> >> >> 00000470   00 00 32 00 01 00 01 00  73 95 DC 4A 00 00 00 00
> >>> >> >> >> >> ..2.....s..J....
> >>> >> >> >> >> 00000480   00 4E ED 00 00 00 00 00  00 00 00 00 0B 00 00 00
> >>> >> >> >> >> .N..............
> >>> >> >> >> >> 00000490   80 00 20 00 C0 00 10 00  4C 73 DD 3D 01 EC 45 85
> >>> >> >> >> >> ..
> >>> >> >> >> >> .....Ls.=..E.
> >>> >> >> >> >> 000004A0   94 28 44 42 3D F6 EF EC  56 61 72 36 34 00 00 00
> >>> >> >> >> >> .(DB=...Var64...
> >>> >> >> >> >> 000004B0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >>> >> >> >> >> ................
> >>> >> >> >> >> 000004C0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >>> >> >> >> >> ................
> >>> >> >> >> >>
> >>> >> >> >> >> the 34 34 in the top line say this is nilfs.
> >>> >> >> >> >>
> >>> >> >> >> >>
> >>> >> >> >> >> cheers
> >>> >> >> >> >>
> >>> >> >> >> >> jan de kruyf
> >>> >> >> >> >>
> >>> >> >> >> >>
> >>> >> >> >> >>
> >>> >> >> >> >>
> >>> >> >> >> >> On Mon, Nov 2, 2009 at 9:06 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>> wrote:
> >>> >> >> >> >>
> >>> >> >> >> >>> Due to some careless handling of my laptop, the SD card
> >>> >> >> >> >>> popped
> >>> >> out
> >>> >> >> >> >>> when the machine is still running. When I put it back in
> >>> >> >> >> >>> and
> >>> >> reboot
> >>> >> >> >> >>> the machine, it says "partition table error". I then ran
> >>> >> >> >> >>> fdisk
> >>> >> and
> >>> >> >> >> >>> recreated the single partition. Then I can no longer mount
> >>> >> >> >> >>> the
> >>> >> >> nilfs2
> >>> >> >> >> >>> partition that was on the SD card!
> >>> >> >> >> >>>
> >>> >> >> >> >>> Can any one help to me recover the file system? I believe
> >>> >> >> >> >>> all
> >>> >> data
> >>> >> >> are
> >>> >> >> >> >>> still there, but just some bits and pieces are missing for
> >>> >> >> >> >>> the
> >>> >> >> >> >>> mount
> >>> >> >> >> >>> to work. Any help is greatly appreciated!
> >>> >> >> >> >>>
> >>> >> >> >> >>> PS: I've a deadline to meet in 4 hours, not sure if I can
> >>> >> >> >> >>> get
> >>> my
> >>> >> >> stuff
> >>> >> >> >> >>> back in time... so help please!
> >>> >> >> >> >>>
> >>> >> >> >> >>> --
> >>> >> >> >> >>> Regards,
> >>> >> >> >> >>> Paul Liu
> >>> >> >> >> >>>
> >>> >> >> >> >>> Yale Haskell Group
> >>> >> >> >> >>> http://www.haskell.org/yale
> >>> >> >> >> >>> _______________________________________________
> >>> >> >> >> >>> users mailing list
> >>> >> >> >> >>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> >>> >> >> >> >>> https://www.nilfs.org/mailman/listinfo/users
> >>> >> >> >> >>>
> >>> >> >> >> >>
> >>> >> >> >> >
> >>> >> >> >> >
> >>> >> >> >> > --
> >>> >> >> >> > Regards,
> >>> >> >> >> > Paul Liu
> >>> >> >> >> >
> >>> >> >> >> > Yale Haskell Group
> >>> >> >> >> > http://www.haskell.org/yale
> >>> >> >> >> >
> >>> >> >> >>
> >>> >> >> >>
> >>> >> >> >> --
> >>> >> >> >> Regards,
> >>> >> >> >> Paul Liu
> >>> >> >> >>
> >>> >> >> >> Yale Haskell Group
> >>> >> >> >> http://www.haskell.org/yale
> >>> >> >> >> _______________________________________________
> >>> >> >> >> users mailing list
> >>> >> >> >> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> >>> >> >> >> https://www.nilfs.org/mailman/listinfo/users
> >>> >> >> >>
> >>> >> >> >
> >>> >> >>
> >>> >> >>
> >>> >> >> --
> >>> >> >> Regards,
> >>> >> >> Paul Liu
> >>> >> >>
> >>> >> >> Yale Haskell Group
> >>> >> >> http://www.haskell.org/yale
> >>> >> >>
> >>> >> >> _______________________________________________
> >>> >> >> users mailing list
> >>> >> >> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> >>> >> >> https://www.nilfs.org/mailman/listinfo/users
> >>> >> >>
> >>> >> >>
> >>> >> >
> >>> >>
> >>> >>
> >>> >> --
> >>> >> Regards,
> >>> >> Paul Liu
> >>> >>
> >>> >> Yale Haskell Group
> >>> >> http://www.haskell.org/yale
> >>> >> _______________________________________________
> >>> >> users mailing list
> >>> >> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> >>> >> https://www.nilfs.org/mailman/listinfo/users
> >>> >>
> >>> >
> >>>
> >>>
> >>> --
> >>> Regards,
> >>> Paul Liu
> >>>
> >>> Yale Haskell Group
> >>> http://www.haskell.org/yale
> >>> _______________________________________________
> >>> users mailing list
> >>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> >>> https://www.nilfs.org/mailman/listinfo/users
> >>>
> >>
> >
> >
> > --
> > Regards,
> > Paul Liu
> >
> > Yale Haskell Group
> > http://www.haskell.org/yale
> >
>
>
> --
> Regards,
> Paul Liu
>
> Yale Haskell Group
> http://www.haskell.org/yale
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>

--0014852f58d21ca3400477a13ea3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Paul,<br>I have been doing some research in between things today<br>here is=
 some proposition I came up with, please check my math<br>and thinking and =
do some more sleuthing. Please ask if anything<br>is not clear:<br><br>The =
math has been done on my trusted calc package for emacs<br>
hence the 16# for the base in front.<br><br>16#3D7C00000=A0=A0=A0 device si=
ze according to you<br>16#3D7800000=A0=A0=A0 device size according to super=
block (at 16#420)<br>------------- -<br>16#000400000=A0=A0=A0 this agrees w=
ith the partition base address of the second <br>
=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 superblock which lives at 16#400400 according to you<br>=A0=A0=A0=
 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 a=
lso the start address of segment 0 indexes from here<br><br>&gt;mmcblk0: st=
arts at address 00400400,=A0 and the nilfs segment 0 starts<br>
&gt;at address 00401000.<br><br>if at least in this line you send me, the a=
ddresses are from 00000 of the device.<br><br>So I am inclined to believe t=
hat the original(before the accident) <br>start address of the nilfs partit=
ion was at 16#400000 of the device.<br>
<br>=A0 <br>Then this holds true according to nilfs2_fs.h:<br>/*<br>=A0* by=
tes offset of secondary super block<br>=A0*/<br>#define NILFS_SB2_OFFSET_BY=
TES(devsize)=A0=A0=A0 ((((devsize) &gt;&gt; 12) - 1) &lt;&lt; 12)<br><br>so=
:<br>16#3D7800000=A0=A0=A0 device size according to superblock (16#420)<br>
16#000001000=A0=A0=A0 and blank the ls 000 but they are 0 already<br>------=
------ -<br>16#3D77FF000=A0=A0=A0 should be the place of the 2nd superblock=
 in the original partition<br>16#000400000=A0=A0=A0 index of the original p=
artition (believed to be)<br>
------------ +<br>16#3D7BFF000=A0=A0=A0 should be the place in the device w=
here the 2nd superblock lives.<br>=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (or maybe I should say the 3r=
d)<br><br>This whole proposition is off course grounded in the belief that =
the first superblock<br>
with the error flag set is written in error and should be discarded.<br>Alt=
hough it might refer to real additional data because it has more checkpoint=
s than the 2nd <br>that you found. But I would rather discard those and ret=
rieve the older checkpoint.<br>
Both superblocks were created in the same login session by the way.<br><br>=
So could you make an efford to find the 3rd superblock or send me the 3 blo=
cks around the<br>place I indicated, to see what happened there.<br><br>
Jan de Kruyf.<br><br>&quot;Enthusiasm beats facts anytime&quot;<br>--------=
----------------------------------<br><br><br><div class=3D"gmail_quote">On=
 Thu, Nov 5, 2009 at 5:57 AM, Paul L <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">BTW, I checked th=
e other disk that I have nilfs2 installed, the two<br>
super blocks indeed are one at the beginning, and one at the end of<br>
the partition.<br>
<br>
Very strange that this isn&#39;t the case on /dev/mmcblk0. Indeed I<br>
started using nilfs version 2.0.5 on it, then later upgraded to<br>
2.0.15, not sure if in between something caused this problem.<br>
<div><div></div><div class=3D"h5"><br>
<br>
On 11/4/09, Paul L &lt;<a href=3D"mailto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua@gmail.c=
om</a>&gt; wrote:<br>
&gt; I think it might be the &quot;hexdump&quot; utility that I used. It by=
 default<br>
&gt; groups things by word, so in little endian it&#39;d say 0002 but the<b=
r>
&gt; actual byte sequence is 02 00.<br>
&gt;<br>
&gt; I re-dump the following in byte sequence using od.<br>
&gt;<br>
&gt; first superblock<br>
&gt;<br>
&gt; 000400 02 00 00 00 00 00 34 34 00 01 00 00 09 b2 31 5b<br>
&gt; 000410 83 11 4c 79 02 00 00 00 af 07 00 00 00 00 00 00<br>
&gt; 000420 00 00 80 d7 03 00 00 00 01 00 00 00 00 00 00 00<br>
&gt; 000430 00 08 00 00 05 00 00 00 0b 09 0e 00 00 00 00 00<br>
&gt; 000440 10 07 35 00 00 00 00 00 02 85 08 00 00 00 00 00<br>
&gt; 000450 00 88 0b 00 00 00 00 00 c1 93 3c 49 00 00 00 00<br>
&gt; 000460 3f 01 e2 4a 00 00 00 00 8f 2a ef 4a 00 00 00 00<br>
&gt; 000470 a2 00 32 00 03 00 01 00 c1 93 3c 49 00 00 00 00<br>
&gt; 000480 00 4e ed 00 00 00 00 00 00 00 00 00 0b 00 00 00<br>
&gt; 000490 80 00 20 00 c0 00 10 00 2b ed f5 04 cb 41 48 ae<br>
&gt; 0004a0 8a 7f 49 48 ec 71 f5 e7 00 00 00 00 00 00 00 00<br>
&gt; 0004b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>
&gt;<br>
&gt; backup copy of the super block (actually different from the above)<br>
&gt;<br>
&gt; 400400 02 00 00 00 00 00 34 34 00 01 00 00 09 b2 31 5b<br>
&gt; 400410 86 db 83 b3 02 00 00 00 af 07 00 00 00 00 00 00<br>
&gt; 400420 00 00 80 d7 03 00 00 00 01 00 00 00 00 00 00 00<br>
&gt; 400430 00 08 00 00 05 00 00 00 08 09 0e 00 00 00 00 00<br>
&gt; 400440 00 00 35 00 00 00 00 00 02 85 08 00 00 00 00 00<br>
&gt; 400450 00 88 0b 00 00 00 00 00 c1 93 3c 49 00 00 00 00<br>
&gt; 400460 3f 01 e2 4a 00 00 00 00 fe 24 ef 4a 00 00 00 00<br>
&gt; 400470 a2 00 32 00 00 00 01 00 c1 93 3c 49 00 00 00 00<br>
&gt; 400480 00 4e ed 00 00 00 00 00 00 00 00 00 0b 00 00 00<br>
&gt; 400490 80 00 20 00 c0 00 10 00 2b ed f5 04 cb 41 48 ae<br>
&gt; 4004a0 8a 7f 49 48 ec 71 f5 e7 00 00 00 00 00 00 00 00<br>
&gt; 4004b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>
&gt;<br>
&gt; The address is the absolute index into the root partition<br>
&gt; /dev/mmcblk0, whose total size is 0x3D7C00000. So the backup copy of<b=
r>
&gt; the super block is not something at the end of the disk.<br>
&gt;<br>
&gt; The first partition /dev/mmcblk0p1 indexes into the root parition by<b=
r>
&gt; 8192 bytes.<br>
&gt;<br>
&gt; Regards,<br>
&gt; Paul Liu<br>
&gt;<br>
&gt; On 11/4/09, Jan de Kruyf &lt;<a href=3D"mailto:jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org"=
>jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt; just thought of something. You searched with standard (little, I t=
hink)<br>
&gt;&gt; endianess<br>
&gt;&gt; i.e. the image from my mail to you.<br>
&gt;&gt; =A0try the image from YOUR main superblock:<br>
&gt;&gt; 0002 0000 0000 3434<br>
&gt;&gt; and see if the backup copy surfaces.<br>
&gt;&gt;<br>
&gt;&gt; jan.<br>
&gt;&gt;<br>
&gt;&gt; On Wed, Nov 4, 2009 at 9:31 PM, Paul L &lt;<a href=3D"mailto:nineg=
ua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt;<br>
&gt;&gt;&gt; I&#39;m using nilfs 2.0.15, slackware current, kernel 2.6.28, =
on Acer<br>
&gt;&gt;&gt; Aspire One model A101, =A0which uses Atom CPU.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I failed to find the superblock towards the end of either mmcb=
lk0 or<br>
&gt;&gt;&gt; mmcblk0p1, but a search of hex string 0200000000003434 reveals=
 that:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; mmcblk0: starts at address 00400400, =A0and the nilfs segment =
0 starts<br>
&gt;&gt;&gt; at address 00401000.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; mmcblk0p1: starts at address 003FE400, and the nilfs segment 0=
 starts<br>
&gt;&gt;&gt; at 003FF000.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I hope my SD card is not messing up itself by rearranging the =
blocks!<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Regards,<br>
&gt;&gt;&gt; Paul Liu<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; On 11/4/09, Jan de Kruyf &lt;<a href=3D"mailto:jan.de.kruyf@gm=
ail.com">jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt;&gt; &gt; Hallo,<br>
&gt;&gt;&gt; &gt; here we go again. As a matter of interest, what version o=
f nilfs and<br>
&gt;&gt;&gt; &gt; what<br>
&gt;&gt;&gt; &gt; distribution are you running? And what processor?<br>
&gt;&gt;&gt; &gt; your endiannes confused me at first.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; glad you fixed your hexedit<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; I have looked at some numbers in the superblock and they =
look ok. I do<br>
&gt;&gt;&gt; &gt; wonder if you have the garbage collector running.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; now for the second superblock. Please pay attention to th=
e exact place<br>
&gt;&gt;&gt; &gt; of<br>
&gt;&gt;&gt; &gt; it. Because it is of vital<br>
&gt;&gt;&gt; &gt; importance if it in in partition 1 or in the root of the =
disk.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; the first superblock sits as you observed in the root. Th=
e flags say<br>
&gt;&gt;&gt; amongst<br>
&gt;&gt;&gt; &gt; others that it was unmounted cleanly but errors were dete=
cted.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; see =A0nilfs2_fs.h - NILFS2 on-disk structures and common=
 declarations.<br>
&gt;&gt;&gt; &gt; in<br>
&gt;&gt;&gt; the<br>
&gt;&gt;&gt; &gt; distribution.<br>
&gt;&gt;&gt; &gt; /**<br>
&gt;&gt;&gt; &gt; =A0* struct nilfs_super_block - structure of super block =
on disk<br>
&gt;&gt;&gt; &gt; =A0*/<br>
&gt;&gt;&gt; &gt; struct nilfs_super_block {<br>
&gt;&gt;&gt; &gt; ....<br>
&gt;&gt;&gt; &gt; translates bit for bit to what you see written in the sup=
er block on<br>
&gt;&gt;&gt; disk.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; Here is an example from a partition of mine on how to dis=
cover the<br>
&gt;&gt;&gt; &gt; superblock copy<br>
&gt;&gt;&gt; &gt; it should read the same as the 1st but in your case it mi=
ght not.<br>
&gt;&gt;&gt; &gt; It is a leftshift - subtract 1 - right shift algorithm.<b=
r>
&gt;&gt;&gt; &gt; go in hexedit to the last data with &quot;&gt;&quot; (shi=
ft .)<br>
&gt;&gt;&gt; &gt; note the address of the last byte (the size of the partio=
n)<br>
&gt;&gt;&gt; &gt; in mine:<br>
&gt;&gt;&gt; &gt; 6566B3F0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; or the status line might give it<br>
&gt;&gt;&gt; &gt; the address of the copy is now at 6566A000<br>
&gt;&gt;&gt; &gt; i.e. 6566B has 1 subtracted from it and the 3 least signi=
ficant digits<br>
&gt;&gt;&gt; have<br>
&gt;&gt;&gt; &gt; been zeroed.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; so please dump yours, see if the algorithm works on the 1=
st part or on<br>
&gt;&gt;&gt; the<br>
&gt;&gt;&gt; &gt; root or both,<br>
&gt;&gt;&gt; &gt; so we know where it is.<br>
&gt;&gt;&gt; &gt; And check if it is exactly the same as the first one you =
send me<br>
&gt;&gt;&gt; &gt; &quot;0000400 0002 0000 0000 3434 0100 0000 b209 5b31&quo=
t;<br>
&gt;&gt;&gt; &gt; etc.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; the next thing to discover is where the start of (nilfs)s=
egment 0 is.<br>
&gt;&gt;&gt; &gt; I am not quite sure what is written in it, but the signat=
ure is quite<br>
&gt;&gt;&gt; &gt; distinct.<br>
&gt;&gt;&gt; &gt; This is what it looks on my machine:<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; 00000FC0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00000FD0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00000FE0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00000FF0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001000 =A0 C4 1B 47 5B 51 62 19 13 =A011 FA AF 1E 38 00=
 10 00<br>
&gt;&gt;&gt; &gt; ..G[Qb......8...<br>
&gt;&gt;&gt; &gt; 00001010 =A0 FB CE 01 00 00 00 00 00 =A0EE BD F1 4A 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ...........J....<br>
&gt;&gt;&gt; &gt; 00001020 =A0 00 08 00 00 00 00 00 00 =A0FF 07 00 00 32 00=
 00 00<br>
&gt;&gt;&gt; &gt; ............2...<br>
&gt;&gt;&gt; &gt; 00001030 =A0 A0 83 00 00 00 00 00 00 =A0EE 0D 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001040 =A0 07 00 00 00 00 00 00 00 =A07B 00 00 00 7B 00=
 00 00<br>
&gt;&gt;&gt; &gt; ........{...{...<br>
&gt;&gt;&gt; &gt; 00001050 =A0 EA 9E 07 00 00 00 00 00 =A0F8 01 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001060 =A0 EB 9E 07 00 00 00 00 00 =A0F9 01 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001070 =A0 EC 9E 07 00 00 00 00 00 =A0FA 01 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001080 =A0 ED 9E 07 00 00 00 00 00 =A0FB 01 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001090 =A0 EE 9E 07 00 00 00 00 00 =A0FC 01 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000010A0 =A0 EF 9E 07 00 00 00 00 00 =A0FD 01 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000010B0 =A0 F0 9E 07 00 00 00 00 00 =A0FE 01 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000010C0 =A0 F2 9E 07 00 00 00 00 00 =A0FF 01 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000010D0 =A0 F3 9E 07 00 00 00 00 00 =A000 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000010E0 =A0 F4 9E 07 00 00 00 00 00 =A001 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000010F0 =A0 F5 9E 07 00 00 00 00 00 =A002 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001100 =A0 F6 9E 07 00 00 00 00 00 =A003 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001110 =A0 F7 9E 07 00 00 00 00 00 =A004 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001120 =A0 F8 9E 07 00 00 00 00 00 =A005 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001130 =A0 F9 9E 07 00 00 00 00 00 =A006 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001140 =A0 FA 9E 07 00 00 00 00 00 =A007 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001150 =A0 FB 9E 07 00 00 00 00 00 =A008 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001160 =A0 FC 9E 07 00 00 00 00 00 =A009 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001170 =A0 FD 9E 07 00 00 00 00 00 =A00A 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001180 =A0 FE 9E 07 00 00 00 00 00 =A00B 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 00001190 =A0 FF 9E 07 00 00 00 00 00 =A00C 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000011A0 =A0 00 9F 07 00 00 00 00 00 =A00D 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000011B0 =A0 01 9F 07 00 00 00 00 00 =A00E 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000011C0 =A0 02 9F 07 00 00 00 00 00 =A00F 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000011D0 =A0 03 9F 07 00 00 00 00 00 =A010 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt; 000011E0 =A0 04 9F 07 00 00 00 00 00 =A011 02 00 00 00 00=
 00 00<br>
&gt;&gt;&gt; &gt; ................<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; Segment 0 starts at hex 1000 of a nilfs partition as you =
can see above<br>
&gt;&gt;&gt; and<br>
&gt;&gt;&gt; &gt; carries on for quite a while like this.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; so have a look on your disk if it sits at 1000 of the roo=
t partition<br>
&gt;&gt;&gt; &gt; or<br>
&gt;&gt;&gt; at<br>
&gt;&gt;&gt; &gt; 1000 of partition 1.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; Once we have these things sorted I would say that we are =
ready to<br>
&gt;&gt;&gt; &gt; plant<br>
&gt;&gt;&gt; the<br>
&gt;&gt;&gt; &gt; _right_ superblock of the 2<br>
&gt;&gt;&gt; &gt; in the right place and see if the partition is recoqnized=
 by nilfs.<br>
&gt;&gt;&gt; &gt; Off course we will save the place where we are going to p=
lant that<br>
&gt;&gt;&gt; &gt; block<br>
&gt;&gt;&gt; &gt; first.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; And now back to the birthday party . . . .<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; Cheers,<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; Jan<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; On Wed, Nov 4, 2009 at 4:23 AM, Paul L &lt;<a href=3D"mai=
lto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; On 11/3/09, Jan de Kruyf &lt;<a href=3D"mailto:jan.de=
.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt;&gt; &gt;&gt; &gt; 26 august 98: hexedit 0.9.5 release<br>
&gt;&gt;&gt; &gt;&gt; &gt; september 2005:<br>
&gt;&gt;&gt; &gt;&gt; &gt; =A0 =A0 - version 1.2.12 =A0this is the one I am=
 running.<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; Ah, I must be using the wrong hexedit.. now I&#39;ve =
installed the same<br>
&gt;&gt;&gt; &gt;&gt; one<br>
&gt;&gt;&gt; &gt;&gt; you<br>
&gt;&gt;&gt; &gt;&gt; use.<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt; did I hear that you have always had /dev/mmcblk0=
p1 in fstab??<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; Yes. What I put there is:<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; /dev/mmcblk0p1 /home =A0 =A0nilfs2 defaults =A0 =A0 =
=A0 =A0 =A0 1 1<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt; hd -n1536 /dev/mmcblk0 &gt;part.start<br>
&gt;&gt;&gt; &gt;&gt; &gt; hd -s8191 -n1536 /dev/mmcblk0 &gt;part1.start<br=
>
&gt;&gt;&gt; &gt;&gt; &gt; an to verify the last line:<br>
&gt;&gt;&gt; &gt;&gt; &gt; hd -n1536 /dev/mmcblk0p1 &gt;part1a.start<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; Here is the output (I use hexdump instead of hd, hope=
fully they are<br>
&gt;&gt;&gt; &gt;&gt; the<br>
&gt;&gt;&gt; &gt;&gt; same)<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; bash-3.1# cat part.start<br>
&gt;&gt;&gt; &gt;&gt; 0000000 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; *<br>
&gt;&gt;&gt; &gt;&gt; 00001b0 0000 0000 0000 0000 0696 6c22 0000 0100<br>
&gt;&gt;&gt; &gt;&gt; 00001c0 0001 0383 ffd0 0010 0000 dff0 01eb 0000<br>
&gt;&gt;&gt; &gt;&gt; 00001d0 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; *<br>
&gt;&gt;&gt; &gt;&gt; 00001f0 0000 0000 0000 0000 0000 0000 0000 aa55<br>
&gt;&gt;&gt; &gt;&gt; 0000200 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; *<br>
&gt;&gt;&gt; &gt;&gt; 0000400 0002 0000 0000 3434 0100 0000 b209 5b31<br>
&gt;&gt;&gt; &gt;&gt; 0000410 1183 794c 0002 0000 07af 0000 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; 0000420 0000 d780 0003 0000 0001 0000 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; 0000430 0800 0000 0005 0000 090b 000e 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; 0000440 0710 0035 0000 0000 8502 0008 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; 0000450 8800 000b 0000 0000 93c1 493c 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; 0000460 013f 4ae2 0000 0000 2a8f 4aef 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; 0000470 00a2 0032 0003 0001 93c1 493c 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; 0000480 4e00 00ed 0000 0000 0000 0000 000b 0000<br>
&gt;&gt;&gt; &gt;&gt; 0000490 0080 0020 00c0 0010 ed2b 04f5 41cb ae48<br>
&gt;&gt;&gt; &gt;&gt; 00004a0 7f8a 4849 71ec e7f5 0000 0000 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; 00004b0 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; *<br>
&gt;&gt;&gt; &gt;&gt; 0000600<br>
&gt;&gt;&gt; &gt;&gt; bash-3.1# cat part1.start<br>
&gt;&gt;&gt; &gt;&gt; 0001fff 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; *<br>
&gt;&gt;&gt; &gt;&gt; 00025ff<br>
&gt;&gt;&gt; &gt;&gt; bash-3.1# cat part1a.start<br>
&gt;&gt;&gt; &gt;&gt; 0000000 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt;&gt; &gt;&gt; *<br>
&gt;&gt;&gt; &gt;&gt; 0000600<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; Regards,<br>
&gt;&gt;&gt; &gt;&gt; Paul Liu<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt; On Tue, Nov 3, 2009 at 9:48 PM, Paul L &lt;<a hr=
ef=3D"mailto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; Thanks a lot for the instructions! I&#39;m a=
ttaching the mbr and<br>
&gt;&gt;&gt; partition<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; table with this email.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; I&#39;m pretty sure I had 1 partition on the=
 card, since my /etc/fstab<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; mounts mmcblk0p1.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; I think something corrupted my disk first, a=
nd then what I&#39;ve done<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; to<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; the disk after noticing the corruption:<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; 1. fdisk, it says use &quot;w&quot; will cor=
rect the error, so I did. But<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; then<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; the one parition is gone.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; 2. fdisk again, create a single partition, t=
hen &quot;w&quot;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; My mistake was that I didn&#39;t create a ba=
ckup copy of the MBR. A<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; hard<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; lesson learned :(<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; Also, why is that my hexedit doesn&#39;t tak=
e the &quot;-s&quot; option? It&#39;s<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; version 0.9.7, and can&#39;t edit bigger tha=
n 4.2GB.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; My SD card is A-DATA brand, class 6, and 16G=
B.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; I&#39;m using Linux, and fdisk version (util=
-linux-ng 2.14.1)<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; Regards,<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; Paul Liu<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; On 11/3/09, Jan de Kruyf &lt;<a href=3D"mail=
to:jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; =A0hallo,<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; Almost sounds like you had only the roo=
t master-boot-record<br>
&gt;&gt;&gt; &gt;&gt; /dev/mmcblk0<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; before and now you have added 1 main pa=
rtition /dev/mmcblk0p1.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; If (and only if) that is the case we ha=
ve to undo the the 1st<br>
&gt;&gt;&gt; &gt;&gt; partition<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; +<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; check that no nilfs is overwritten.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; and I would have to urgently study fdis=
k to see exactly what it<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; writes<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; when<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; and where.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; The last time I did tricks like these i=
s quit a few years ago.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; It is the Linux version of fdisk is it?=
?<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; So here is the plan of action:<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; hexdump the master boot record to file.=
<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; like this:<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; dd if=3D/dev/mmcblk0 of=3Dbackup-mmcblk=
0.mbr count=3D1 bs=3D512<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; then dump any partitions of the device =
in a format useful as<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; input<br>
&gt;&gt;&gt; to<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; sfdisk. For example,<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 % s=
fdisk -d /dev/mmcblk0 =A0&gt; mmcblk0 .out<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; sfdisk is a tool provided with the util=
-linux<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; package&lt;<a href=3D"http://www.kernel=
.org/pub/linux/utils/util-linux/" target=3D"_blank">http://www.kernel.org/p=
ub/linux/utils/util-linux/</a>&gt;.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; or you could use hexdump to get machine=
 readable or man readable<br>
&gt;&gt;&gt; &gt;&gt; images.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; Here is the man readable version:<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; hd -n512 /dev/mmcblk0 &gt; backup-mmcbl=
k0.mbr<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; hd -n512 /dev/mmcblk0p1 &gt;backup-mmcb=
lk0p1.mbr<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; etc.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; By the way boor records always end with=
 &#39;55 AA&#39;.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; Keep your files in a safe place in case=
 we mess something we can<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; at<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; least<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; go<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; back to the present situation.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; If you could dd the whole drive to a fi=
le, now that would be<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; magic<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; indeed!<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; but you must have the space on a harddr=
ive.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; count=3D... is the number of sectors in=
 the above line (dd ...)<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; that<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; you<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; dump<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; to file.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; Hexedit will tell you the number of sec=
tors is you start it with<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; -s<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; option<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; and then go to the last sector.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; DONT stop hexedit with control-x use cn=
tl-c.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; DONT use high level or even midlevel to=
ols on a stuffed disk, it<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; normally<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; messes more than it solves.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; unless of course you really,really know=
 what you are doing.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; Fiddling the bytes is in general safe a=
nd gives results, if a<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; man<br>
&gt;&gt;&gt; &gt;&gt; keeps<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; a<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; cool head.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; Please send me the fdisk version, the s=
ize of the card, and the<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; mbr<br>
&gt;&gt;&gt; &gt;&gt; dump<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; to<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; feast my eyes on.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; cheers,<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; Jan de kruyf.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; On Tue, Nov 3, 2009 at 1:27 AM, Paul L =
&lt;<a href=3D"mailto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt; wrote:<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; just want to add that I&#39;ve alwa=
ys been using 1 partition on<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; this<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; device, it&#39;s actually /dev/mmcb=
lk0p1. But hexedit<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; /dev/mmcblk0p1<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; doesn&#39;t show that 34 34 at line=
 begining with 0x400, only<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; hexedit<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; /dev/mmcblk0 shows it. Not sure if =
this is a problem.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Any help is greatly appreciated!<br=
>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; On 11/2/09, Paul L &lt;<a href=3D"m=
ailto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; Thanks for the tips. When I fi=
rst used the SD card, I used<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; fdisk<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; to<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; create the partition.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; The device is /dev/mmcblk0, an=
d hexedit -d -s /dev/mmcblk0<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; shows<br>
&gt;&gt;&gt; &gt;&gt; that<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; at the line 0x0400, it is inde=
ed 34 34. What should I do<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; then?<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; I tried gparted, but apparentl=
y it has no support for nilfs2.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; Regards,<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; Paul Liu<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; On 11/2/09, Jan de Kruyf &lt;<=
a href=3D"mailto:jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wro=
te:<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Did you first format this =
card with fdisk?<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; did you give it the exact =
same info this time around?<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Can you read /dev/&#39;sdc=
ard&#39; ? (sdcard being the device in the<br>
&gt;&gt;&gt; dev<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; directory<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; where the card lives)<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; If yes can you run hexedit=
 -s /dev/sdcard1 =A0in a terminal as<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; root?<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; and go to address 0400 - 0=
4B0 to see if nilfs still exists?<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; be very careful no to save=
 any data in hexedit, it will<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; definitely<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; and<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; finally<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; destoy your data.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 0400 looks vagely like thi=
s:<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000400 =A0 02 00 00 00 0=
0 00 34 34 =A000 01 00 00 D3 56 F0 B9<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ......44.....V..<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000410 =A0 39 BF D9 73 0=
2 00 00 00 =A0CA 02 00 00 00 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 9..s............<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000420 =A0 00 B4 66 65 0=
1 00 00 00 =A001 00 00 00 00 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ..fe............<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000430 =A0 00 08 00 00 0=
5 00 00 00 =A001 00 00 00 00 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ................<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000440 =A0 01 00 00 00 0=
0 00 00 00 =A000 00 00 00 00 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ................<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000450 =A0 00 48 16 00 0=
0 00 00 00 =A073 95 DC 4A 00 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; .H......s..J....<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000460 =A0 00 00 00 00 0=
0 00 00 00 =A073 95 DC 4A 00 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ........s..J....<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000470 =A0 00 00 32 00 0=
1 00 01 00 =A073 95 DC 4A 00 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ..2.....s..J....<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000480 =A0 00 4E ED 00 0=
0 00 00 00 =A000 00 00 00 0B 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; .N..............<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000490 =A0 80 00 20 00 C=
0 00 10 00 =A04C 73 DD 3D 01 EC 45 85<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ..<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; .....Ls.=3D..E.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 000004A0 =A0 94 28 44 42 3=
D F6 EF EC =A056 61 72 36 34 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; .(DB=3D...Var64...<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 000004B0 =A0 00 00 00 00 0=
0 00 00 00 =A000 00 00 00 00 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ................<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 000004C0 =A0 00 00 00 00 0=
0 00 00 00 =A000 00 00 00 00 00 00 00<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ................<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; the 34 34 in the top line =
say this is nilfs.<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; cheers<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; jan de kruyf<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; On Mon, Nov 2, 2009 at 9:0=
6 PM, Paul L &lt;<a href=3D"mailto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>=
&gt;<br>
&gt;&gt;&gt; wrote:<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Due to some careless h=
andling of my laptop, the SD card<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; popped<br>
&gt;&gt;&gt; &gt;&gt; out<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; when the machine is st=
ill running. When I put it back in<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; and<br>
&gt;&gt;&gt; &gt;&gt; reboot<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; the machine, it says &=
quot;partition table error&quot;. I then ran<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; fdisk<br>
&gt;&gt;&gt; &gt;&gt; and<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; recreated the single p=
artition. Then I can no longer mount<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; the<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; nilfs2<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; partition that was on =
the SD card!<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Can any one help to me=
 recover the file system? I believe<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; all<br>
&gt;&gt;&gt; &gt;&gt; data<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; are<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; still there, but just =
some bits and pieces are missing for<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; the<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; mount<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; to work. Any help is g=
reatly appreciated!<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; PS: I&#39;ve a deadlin=
e to meet in 4 hours, not sure if I can<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; get<br>
&gt;&gt;&gt; my<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; stuff<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; back in time... so hel=
p please!<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; --<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Regards,<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Paul Liu<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Yale Haskell Group<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; <a href=3D"http://www.=
haskell.org/yale" target=3D"_blank">http://www.haskell.org/yale</a><br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; ______________________=
_________________________<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; users mailing list<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; <a href=3D"mailto:user=
s@nilfs.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; <a href=3D"https://www=
.nilfs.org/mailman/listinfo/users" target=3D"_blank">https://www.nilfs.org/=
mailman/listinfo/users</a><br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; --<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; Regards,<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; Paul Liu<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; Yale Haskell Group<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt; <a href=3D"http://www.haskell.=
org/yale" target=3D"_blank">http://www.haskell.org/yale</a><br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; --<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Regards,<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Paul Liu<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Yale Haskell Group<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; <a href=3D"http://www.haskell.org/y=
ale" target=3D"_blank">http://www.haskell.org/yale</a><br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ___________________________________=
____________<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; users mailing list<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; <a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">=
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; <a href=3D"https://www.nilfs.org/ma=
ilman/listinfo/users" target=3D"_blank">https://www.nilfs.org/mailman/listi=
nfo/users</a><br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; --<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; Regards,<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; Paul Liu<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; Yale Haskell Group<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; <a href=3D"http://www.haskell.org/yale" targ=
et=3D"_blank">http://www.haskell.org/yale</a><br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; ____________________________________________=
___<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; users mailing list<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; <a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users@nil=
fs.org</a><br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt; <a href=3D"https://www.nilfs.org/mailman/lis=
tinfo/users" target=3D"_blank">https://www.nilfs.org/mailman/listinfo/users=
</a><br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; --<br>
&gt;&gt;&gt; &gt;&gt; Regards,<br>
&gt;&gt;&gt; &gt;&gt; Paul Liu<br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;&gt; Yale Haskell Group<br>
&gt;&gt;&gt; &gt;&gt; <a href=3D"http://www.haskell.org/yale" target=3D"_bl=
ank">http://www.haskell.org/yale</a><br>
&gt;&gt;&gt; &gt;&gt; _______________________________________________<br>
&gt;&gt;&gt; &gt;&gt; users mailing list<br>
&gt;&gt;&gt; &gt;&gt; <a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a=
><br>
&gt;&gt;&gt; &gt;&gt; <a href=3D"https://www.nilfs.org/mailman/listinfo/use=
rs" target=3D"_blank">https://www.nilfs.org/mailman/listinfo/users</a><br>
&gt;&gt;&gt; &gt;&gt;<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; --<br>
&gt;&gt;&gt; Regards,<br>
&gt;&gt;&gt; Paul Liu<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Yale Haskell Group<br>
&gt;&gt;&gt; <a href=3D"http://www.haskell.org/yale" target=3D"_blank">http=
://www.haskell.org/yale</a><br>
&gt;&gt;&gt; _______________________________________________<br>
&gt;&gt;&gt; users mailing list<br>
&gt;&gt;&gt; <a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
&gt;&gt;&gt; <a href=3D"https://www.nilfs.org/mailman/listinfo/users" targe=
t=3D"_blank">https://www.nilfs.org/mailman/listinfo/users</a><br>
&gt;&gt;&gt;<br>
&gt;&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; Regards,<br>
&gt; Paul Liu<br>
&gt;<br>
&gt; Yale Haskell Group<br>
&gt; <a href=3D"http://www.haskell.org/yale" target=3D"_blank">http://www.h=
askell.org/yale</a><br>
&gt;<br>
<br>
<br>
</div></div>--<br>
<div><div></div><div class=3D"h5">Regards,<br>
Paul Liu<br>
<br>
Yale Haskell Group<br>
<a href=3D"http://www.haskell.org/yale" target=3D"_blank">http://www.haskel=
l.org/yale</a><br>
_______________________________________________<br>
users mailing list<br>
<a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
<a href=3D"https://www.nilfs.org/mailman/listinfo/users" target=3D"_blank">=
https://www.nilfs.org/mailman/listinfo/users</a><br>
</div></div></blockquote></div><br>

--0014852f58d21ca3400477a13ea3--

--===============1559590019==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1559590019==--
