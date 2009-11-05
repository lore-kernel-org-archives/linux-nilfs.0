From: Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [SPAM] Re: urgent help need! disk partition info lost
Date: Thu, 5 Nov 2009 13:02:18 -0500
Message-ID: <856033f20911051002x79461f91o60e07f651a24f7c4@mail.gmail.com>
References: <856033f20911021106u771f823dkb48395958ad83a37@mail.gmail.com>
	<856033f20911031148o4d856a59vc711d1053ac9d1bc@mail.gmail.com>
	<ee5afd760911031336g122fc338r8d2879a48d5e11d6@mail.gmail.com>
	<856033f20911031823m715b1f91q818e9c78cda9315d@mail.gmail.com>
	<ee5afd760911041046s70ada5d6w686ce83814b3e9e6@mail.gmail.com>
	<856033f20911041131n54c420fuf16b10fefb343188@mail.gmail.com>
	<ee5afd760911041326g77cab1d9r90f55657dc11a789@mail.gmail.com>
	<856033f20911041719w12410864hdbdb8d5e6aed2070@mail.gmail.com>
	<856033f20911041957n7c88e5afvb60b6de9ee42bce7@mail.gmail.com>
	<ee5afd760911050718t4eca6855kdf70fcc7f2014bf8@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <ee5afd760911050718t4eca6855kdf70fcc7f2014bf8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Wow, that is some good calculation, thanks!

But unfortunately, the data around 3D7BFF00 doesn't look like a super
block at all.
I did a search of the string  02 00 00 00 00 00 34 34 00 01 00 00 on
the entire disk, only two places showed up.

Also strangely the blocks towards end of the disk are all filled with
data, but from 0x0 to 0x400000 are all 0s except of course the MBR.

I wonder if there is some kind of wrapping around? What could have caused it?

Regards,
Paul Liu

On 11/5/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Paul,
> I have been doing some research in between things today
> here is some proposition I came up with, please check my math
> and thinking and do some more sleuthing. Please ask if anything
> is not clear:
>
> The math has been done on my trusted calc package for emacs
> hence the 16# for the base in front.
>
> 16#3D7C00000    device size according to you
> 16#3D7800000    device size according to superblock (at 16#420)
> ------------- -
> 16#000400000    this agrees with the partition base address of the second
>                              superblock which lives at 16#400400 according
> to you
>                              also the start address of segment 0 indexes
> from here
>
>>mmcblk0: starts at address 00400400,  and the nilfs segment 0 starts
>>at address 00401000.
>
> if at least in this line you send me, the addresses are from 00000 of the
> device.
>
> So I am inclined to believe that the original(before the accident)
> start address of the nilfs partition was at 16#400000 of the device.
>
>
> Then this holds true according to nilfs2_fs.h:
> /*
>  * bytes offset of secondary super block
>  */
> #define NILFS_SB2_OFFSET_BYTES(devsize)    ((((devsize) >> 12) - 1) << 12)
>
> so:
> 16#3D7800000    device size according to superblock (16#420)
> 16#000001000    and blank the ls 000 but they are 0 already
> ------------ -
> 16#3D77FF000    should be the place of the 2nd superblock in the original
> partition
> 16#000400000    index of the original partition (believed to be)
> ------------ +
> 16#3D7BFF000    should be the place in the device where the 2nd superblock
> lives.
>                               (or maybe I should say the 3rd)
>
> This whole proposition is off course grounded in the belief that the first
> superblock
> with the error flag set is written in error and should be discarded.
> Although it might refer to real additional data because it has more
> checkpoints than the 2nd
> that you found. But I would rather discard those and retrieve the older
> checkpoint.
> Both superblocks were created in the same login session by the way.
>
> So could you make an efford to find the 3rd superblock or send me the 3
> blocks around the
> place I indicated, to see what happened there.
>
> Jan de Kruyf.
>
> "Enthusiasm beats facts anytime"
> ------------------------------------------
>
>
> On Thu, Nov 5, 2009 at 5:57 AM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> BTW, I checked the other disk that I have nilfs2 installed, the two
>> super blocks indeed are one at the beginning, and one at the end of
>> the partition.
>>
>> Very strange that this isn't the case on /dev/mmcblk0. Indeed I
>> started using nilfs version 2.0.5 on it, then later upgraded to
>> 2.0.15, not sure if in between something caused this problem.
>>
>>
>> On 11/4/09, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > I think it might be the "hexdump" utility that I used. It by default
>> > groups things by word, so in little endian it'd say 0002 but the
>> > actual byte sequence is 02 00.
>> >
>> > I re-dump the following in byte sequence using od.
>> >
>> > first superblock
>> >
>> > 000400 02 00 00 00 00 00 34 34 00 01 00 00 09 b2 31 5b
>> > 000410 83 11 4c 79 02 00 00 00 af 07 00 00 00 00 00 00
>> > 000420 00 00 80 d7 03 00 00 00 01 00 00 00 00 00 00 00
>> > 000430 00 08 00 00 05 00 00 00 0b 09 0e 00 00 00 00 00
>> > 000440 10 07 35 00 00 00 00 00 02 85 08 00 00 00 00 00
>> > 000450 00 88 0b 00 00 00 00 00 c1 93 3c 49 00 00 00 00
>> > 000460 3f 01 e2 4a 00 00 00 00 8f 2a ef 4a 00 00 00 00
>> > 000470 a2 00 32 00 03 00 01 00 c1 93 3c 49 00 00 00 00
>> > 000480 00 4e ed 00 00 00 00 00 00 00 00 00 0b 00 00 00
>> > 000490 80 00 20 00 c0 00 10 00 2b ed f5 04 cb 41 48 ae
>> > 0004a0 8a 7f 49 48 ec 71 f5 e7 00 00 00 00 00 00 00 00
>> > 0004b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> >
>> > backup copy of the super block (actually different from the above)
>> >
>> > 400400 02 00 00 00 00 00 34 34 00 01 00 00 09 b2 31 5b
>> > 400410 86 db 83 b3 02 00 00 00 af 07 00 00 00 00 00 00
>> > 400420 00 00 80 d7 03 00 00 00 01 00 00 00 00 00 00 00
>> > 400430 00 08 00 00 05 00 00 00 08 09 0e 00 00 00 00 00
>> > 400440 00 00 35 00 00 00 00 00 02 85 08 00 00 00 00 00
>> > 400450 00 88 0b 00 00 00 00 00 c1 93 3c 49 00 00 00 00
>> > 400460 3f 01 e2 4a 00 00 00 00 fe 24 ef 4a 00 00 00 00
>> > 400470 a2 00 32 00 00 00 01 00 c1 93 3c 49 00 00 00 00
>> > 400480 00 4e ed 00 00 00 00 00 00 00 00 00 0b 00 00 00
>> > 400490 80 00 20 00 c0 00 10 00 2b ed f5 04 cb 41 48 ae
>> > 4004a0 8a 7f 49 48 ec 71 f5 e7 00 00 00 00 00 00 00 00
>> > 4004b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> >
>> > The address is the absolute index into the root partition
>> > /dev/mmcblk0, whose total size is 0x3D7C00000. So the backup copy of
>> > the super block is not something at the end of the disk.
>> >
>> > The first partition /dev/mmcblk0p1 indexes into the root parition by
>> > 8192 bytes.
>> >
>> > Regards,
>> > Paul Liu
>> >
>> > On 11/4/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> just thought of something. You searched with standard (little, I think)
>> >> endianess
>> >> i.e. the image from my mail to you.
>> >>  try the image from YOUR main superblock:
>> >> 0002 0000 0000 3434
>> >> and see if the backup copy surfaces.
>> >>
>> >> jan.
>> >>
>> >> On Wed, Nov 4, 2009 at 9:31 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>
>> >>> I'm using nilfs 2.0.15, slackware current, kernel 2.6.28, on Acer
>> >>> Aspire One model A101,  which uses Atom CPU.
>> >>>
>> >>> I failed to find the superblock towards the end of either mmcblk0 or
>> >>> mmcblk0p1, but a search of hex string 0200000000003434 reveals that:
>> >>>
>> >>> mmcblk0: starts at address 00400400,  and the nilfs segment 0 starts
>> >>> at address 00401000.
>> >>>
>> >>> mmcblk0p1: starts at address 003FE400, and the nilfs segment 0 starts
>> >>> at 003FF000.
>> >>>
>> >>> I hope my SD card is not messing up itself by rearranging the blocks!
>> >>>
>> >>> Regards,
>> >>> Paul Liu
>> >>>
>> >>> On 11/4/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>> > Hallo,
>> >>> > here we go again. As a matter of interest, what version of nilfs and
>> >>> > what
>> >>> > distribution are you running? And what processor?
>> >>> > your endiannes confused me at first.
>> >>> >
>> >>> > glad you fixed your hexedit
>> >>> >
>> >>> > I have looked at some numbers in the superblock and they look ok. I
>> do
>> >>> > wonder if you have the garbage collector running.
>> >>> >
>> >>> > now for the second superblock. Please pay attention to the exact
>> place
>> >>> > of
>> >>> > it. Because it is of vital
>> >>> > importance if it in in partition 1 or in the root of the disk.
>> >>> >
>> >>> > the first superblock sits as you observed in the root. The flags say
>> >>> amongst
>> >>> > others that it was unmounted cleanly but errors were detected.
>> >>> >
>> >>> > see  nilfs2_fs.h - NILFS2 on-disk structures and common
>> >>> > declarations.
>> >>> > in
>> >>> the
>> >>> > distribution.
>> >>> > /**
>> >>> >  * struct nilfs_super_block - structure of super block on disk
>> >>> >  */
>> >>> > struct nilfs_super_block {
>> >>> > ....
>> >>> > translates bit for bit to what you see written in the super block on
>> >>> disk.
>> >>> >
>> >>> > Here is an example from a partition of mine on how to discover the
>> >>> > superblock copy
>> >>> > it should read the same as the 1st but in your case it might not.
>> >>> > It is a leftshift - subtract 1 - right shift algorithm.
>> >>> > go in hexedit to the last data with ">" (shift .)
>> >>> > note the address of the last byte (the size of the partion)
>> >>> > in mine:
>> >>> > 6566B3F0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> >>> > ................
>> >>> > or the status line might give it
>> >>> > the address of the copy is now at 6566A000
>> >>> > i.e. 6566B has 1 subtracted from it and the 3 least significant
>> digits
>> >>> have
>> >>> > been zeroed.
>> >>> >
>> >>> > so please dump yours, see if the algorithm works on the 1st part or
>> on
>> >>> the
>> >>> > root or both,
>> >>> > so we know where it is.
>> >>> > And check if it is exactly the same as the first one you send me
>> >>> > "0000400 0002 0000 0000 3434 0100 0000 b209 5b31"
>> >>> > etc.
>> >>> >
>> >>> > the next thing to discover is where the start of (nilfs)segment 0
>> >>> > is.
>> >>> > I am not quite sure what is written in it, but the signature is
>> >>> > quite
>> >>> > distinct.
>> >>> > This is what it looks on my machine:
>> >>> >
>> >>> > 00000FC0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00000FD0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00000FE0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00000FF0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001000   C4 1B 47 5B 51 62 19 13  11 FA AF 1E 38 00 10 00
>> >>> > ..G[Qb......8...
>> >>> > 00001010   FB CE 01 00 00 00 00 00  EE BD F1 4A 00 00 00 00
>> >>> > ...........J....
>> >>> > 00001020   00 08 00 00 00 00 00 00  FF 07 00 00 32 00 00 00
>> >>> > ............2...
>> >>> > 00001030   A0 83 00 00 00 00 00 00  EE 0D 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001040   07 00 00 00 00 00 00 00  7B 00 00 00 7B 00 00 00
>> >>> > ........{...{...
>> >>> > 00001050   EA 9E 07 00 00 00 00 00  F8 01 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001060   EB 9E 07 00 00 00 00 00  F9 01 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001070   EC 9E 07 00 00 00 00 00  FA 01 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001080   ED 9E 07 00 00 00 00 00  FB 01 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001090   EE 9E 07 00 00 00 00 00  FC 01 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000010A0   EF 9E 07 00 00 00 00 00  FD 01 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000010B0   F0 9E 07 00 00 00 00 00  FE 01 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000010C0   F2 9E 07 00 00 00 00 00  FF 01 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000010D0   F3 9E 07 00 00 00 00 00  00 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000010E0   F4 9E 07 00 00 00 00 00  01 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000010F0   F5 9E 07 00 00 00 00 00  02 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001100   F6 9E 07 00 00 00 00 00  03 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001110   F7 9E 07 00 00 00 00 00  04 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001120   F8 9E 07 00 00 00 00 00  05 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001130   F9 9E 07 00 00 00 00 00  06 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001140   FA 9E 07 00 00 00 00 00  07 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001150   FB 9E 07 00 00 00 00 00  08 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001160   FC 9E 07 00 00 00 00 00  09 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001170   FD 9E 07 00 00 00 00 00  0A 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001180   FE 9E 07 00 00 00 00 00  0B 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 00001190   FF 9E 07 00 00 00 00 00  0C 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000011A0   00 9F 07 00 00 00 00 00  0D 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000011B0   01 9F 07 00 00 00 00 00  0E 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000011C0   02 9F 07 00 00 00 00 00  0F 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000011D0   03 9F 07 00 00 00 00 00  10 02 00 00 00 00 00 00
>> >>> > ................
>> >>> > 000011E0   04 9F 07 00 00 00 00 00  11 02 00 00 00 00 00 00
>> >>> > ................
>> >>> >
>> >>> > Segment 0 starts at hex 1000 of a nilfs partition as you can see
>> above
>> >>> and
>> >>> > carries on for quite a while like this.
>> >>> >
>> >>> > so have a look on your disk if it sits at 1000 of the root partition
>> >>> > or
>> >>> at
>> >>> > 1000 of partition 1.
>> >>> >
>> >>> > Once we have these things sorted I would say that we are ready to
>> >>> > plant
>> >>> the
>> >>> > _right_ superblock of the 2
>> >>> > in the right place and see if the partition is recoqnized by nilfs.
>> >>> > Off course we will save the place where we are going to plant that
>> >>> > block
>> >>> > first.
>> >>> >
>> >>> > And now back to the birthday party . . . .
>> >>> >
>> >>> > Cheers,
>> >>> >
>> >>> > Jan
>> >>> >
>> >>> >
>> >>> >
>> >>> > On Wed, Nov 4, 2009 at 4:23 AM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>> >
>> >>> >> On 11/3/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>> >> > 26 august 98: hexedit 0.9.5 release
>> >>> >> > september 2005:
>> >>> >> >     - version 1.2.12  this is the one I am running.
>> >>> >>
>> >>> >> Ah, I must be using the wrong hexedit.. now I've installed the same
>> >>> >> one
>> >>> >> you
>> >>> >> use.
>> >>> >>
>> >>> >> > did I hear that you have always had /dev/mmcblk0p1 in fstab??
>> >>> >>
>> >>> >> Yes. What I put there is:
>> >>> >>
>> >>> >> /dev/mmcblk0p1 /home    nilfs2 defaults           1 1
>> >>> >>
>> >>> >> > hd -n1536 /dev/mmcblk0 >part.start
>> >>> >> > hd -s8191 -n1536 /dev/mmcblk0 >part1.start
>> >>> >> > an to verify the last line:
>> >>> >> > hd -n1536 /dev/mmcblk0p1 >part1a.start
>> >>> >>
>> >>> >> Here is the output (I use hexdump instead of hd, hopefully they are
>> >>> >> the
>> >>> >> same)
>> >>> >>
>> >>> >> bash-3.1# cat part.start
>> >>> >> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>> >>> >> *
>> >>> >> 00001b0 0000 0000 0000 0000 0696 6c22 0000 0100
>> >>> >> 00001c0 0001 0383 ffd0 0010 0000 dff0 01eb 0000
>> >>> >> 00001d0 0000 0000 0000 0000 0000 0000 0000 0000
>> >>> >> *
>> >>> >> 00001f0 0000 0000 0000 0000 0000 0000 0000 aa55
>> >>> >> 0000200 0000 0000 0000 0000 0000 0000 0000 0000
>> >>> >> *
>> >>> >> 0000400 0002 0000 0000 3434 0100 0000 b209 5b31
>> >>> >> 0000410 1183 794c 0002 0000 07af 0000 0000 0000
>> >>> >> 0000420 0000 d780 0003 0000 0001 0000 0000 0000
>> >>> >> 0000430 0800 0000 0005 0000 090b 000e 0000 0000
>> >>> >> 0000440 0710 0035 0000 0000 8502 0008 0000 0000
>> >>> >> 0000450 8800 000b 0000 0000 93c1 493c 0000 0000
>> >>> >> 0000460 013f 4ae2 0000 0000 2a8f 4aef 0000 0000
>> >>> >> 0000470 00a2 0032 0003 0001 93c1 493c 0000 0000
>> >>> >> 0000480 4e00 00ed 0000 0000 0000 0000 000b 0000
>> >>> >> 0000490 0080 0020 00c0 0010 ed2b 04f5 41cb ae48
>> >>> >> 00004a0 7f8a 4849 71ec e7f5 0000 0000 0000 0000
>> >>> >> 00004b0 0000 0000 0000 0000 0000 0000 0000 0000
>> >>> >> *
>> >>> >> 0000600
>> >>> >> bash-3.1# cat part1.start
>> >>> >> 0001fff 0000 0000 0000 0000 0000 0000 0000 0000
>> >>> >> *
>> >>> >> 00025ff
>> >>> >> bash-3.1# cat part1a.start
>> >>> >> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>> >>> >> *
>> >>> >> 0000600
>> >>> >>
>> >>> >> Regards,
>> >>> >> Paul Liu
>> >>> >>
>> >>> >> > On Tue, Nov 3, 2009 at 9:48 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>> >> >
>> >>> >> >> Thanks a lot for the instructions! I'm attaching the mbr and
>> >>> partition
>> >>> >> >> table with this email.
>> >>> >> >>
>> >>> >> >> I'm pretty sure I had 1 partition on the card, since my
>> /etc/fstab
>> >>> >> >> mounts mmcblk0p1.
>> >>> >> >>
>> >>> >> >> I think something corrupted my disk first, and then what I've
>> done
>> >>> >> >> to
>> >>> >> >> the disk after noticing the corruption:
>> >>> >> >>
>> >>> >> >> 1. fdisk, it says use "w" will correct the error, so I did. But
>> >>> >> >> then
>> >>> >> >> the one parition is gone.
>> >>> >> >> 2. fdisk again, create a single partition, then "w"
>> >>> >> >>
>> >>> >> >> My mistake was that I didn't create a backup copy of the MBR. A
>> >>> >> >> hard
>> >>> >> >> lesson learned :(
>> >>> >> >>
>> >>> >> >> Also, why is that my hexedit doesn't take the "-s" option? It's
>> >>> >> >> version 0.9.7, and can't edit bigger than 4.2GB.
>> >>> >> >>
>> >>> >> >> My SD card is A-DATA brand, class 6, and 16GB.
>> >>> >> >>
>> >>> >> >> I'm using Linux, and fdisk version (util-linux-ng 2.14.1)
>> >>> >> >>
>> >>> >> >> Regards,
>> >>> >> >> Paul Liu
>> >>> >> >>
>> >>> >> >> On 11/3/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>> >> >> >  hallo,
>> >>> >> >> > Almost sounds like you had only the root master-boot-record
>> >>> >> /dev/mmcblk0
>> >>> >> >> > before and now you have added 1 main partition /dev/mmcblk0p1.
>> >>> >> >> >
>> >>> >> >> > If (and only if) that is the case we have to undo the the 1st
>> >>> >> partition
>> >>> >> >> > +
>> >>> >> >> > check that no nilfs is overwritten.
>> >>> >> >> > and I would have to urgently study fdisk to see exactly what
>> >>> >> >> > it
>> >>> >> >> > writes
>> >>> >> >> when
>> >>> >> >> > and where.
>> >>> >> >> > The last time I did tricks like these is quit a few years ago.
>> >>> >> >> >
>> >>> >> >> > It is the Linux version of fdisk is it??
>> >>> >> >> >
>> >>> >> >> > So here is the plan of action:
>> >>> >> >> > hexdump the master boot record to file.
>> >>> >> >> > like this:
>> >>> >> >> >
>> >>> >> >> > dd if=/dev/mmcblk0 of=backup-mmcblk0.mbr count=1 bs=512
>> >>> >> >> >
>> >>> >> >> > then dump any partitions of the device in a format useful as
>> >>> >> >> > input
>> >>> to
>> >>> >> >> > sfdisk. For example,
>> >>> >> >> >                   % sfdisk -d /dev/mmcblk0  > mmcblk0 .out
>> >>> >> >> > sfdisk is a tool provided with the util-linux
>> >>> >> >> > package<http://www.kernel.org/pub/linux/utils/util-linux/>.
>> >>> >> >> >
>> >>> >> >> >
>> >>> >> >> > or you could use hexdump to get machine readable or man
>> readable
>> >>> >> images.
>> >>> >> >> > Here is the man readable version:
>> >>> >> >> > hd -n512 /dev/mmcblk0 > backup-mmcblk0.mbr
>> >>> >> >> > hd -n512 /dev/mmcblk0p1 >backup-mmcblk0p1.mbr
>> >>> >> >> > etc.
>> >>> >> >> >
>> >>> >> >> > By the way boor records always end with '55 AA'.
>> >>> >> >> >
>> >>> >> >> > Keep your files in a safe place in case we mess something we
>> can
>> >>> >> >> > at
>> >>> >> >> > least
>> >>> >> >> go
>> >>> >> >> > back to the present situation.
>> >>> >> >> > If you could dd the whole drive to a file, now that would be
>> >>> >> >> > magic
>> >>> >> >> indeed!
>> >>> >> >> > but you must have the space on a harddrive.
>> >>> >> >> > count=... is the number of sectors in the above line (dd ...)
>> >>> >> >> > that
>> >>> >> >> > you
>> >>> >> >> dump
>> >>> >> >> > to file.
>> >>> >> >> > Hexedit will tell you the number of sectors is you start it
>> with
>> >>> >> >> > -s
>> >>> >> >> option
>> >>> >> >> > and then go to the last sector.
>> >>> >> >> > DONT stop hexedit with control-x use cntl-c.
>> >>> >> >> > DONT use high level or even midlevel tools on a stuffed disk,
>> it
>> >>> >> >> > normally
>> >>> >> >> > messes more than it solves.
>> >>> >> >> > unless of course you really,really know what you are doing.
>> >>> >> >> > Fiddling the bytes is in general safe and gives results, if a
>> >>> >> >> > man
>> >>> >> keeps
>> >>> >> >> > a
>> >>> >> >> > cool head.
>> >>> >> >> >
>> >>> >> >> > Please send me the fdisk version, the size of the card, and
>> >>> >> >> > the
>> >>> >> >> > mbr
>> >>> >> dump
>> >>> >> >> to
>> >>> >> >> > feast my eyes on.
>> >>> >> >> >
>> >>> >> >> > cheers,
>> >>> >> >> >
>> >>> >> >> > Jan de kruyf.
>> >>> >> >> >
>> >>> >> >> >
>> >>> >> >> >
>> >>> >> >> > On Tue, Nov 3, 2009 at 1:27 AM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>> >> >> > wrote:
>> >>> >> >> >
>> >>> >> >> >> just want to add that I've always been using 1 partition on
>> >>> >> >> >> this
>> >>> >> >> >> device, it's actually /dev/mmcblk0p1. But hexedit
>> >>> >> >> >> /dev/mmcblk0p1
>> >>> >> >> >> doesn't show that 34 34 at line begining with 0x400, only
>> >>> >> >> >> hexedit
>> >>> >> >> >> /dev/mmcblk0 shows it. Not sure if this is a problem.
>> >>> >> >> >>
>> >>> >> >> >> Any help is greatly appreciated!
>> >>> >> >> >>
>> >>> >> >> >>
>> >>> >> >> >> On 11/2/09, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>> >> >> >> > Thanks for the tips. When I first used the SD card, I used
>> >>> >> >> >> > fdisk
>> >>> >> >> >> > to
>> >>> >> >> >> > create the partition.
>> >>> >> >> >> >
>> >>> >> >> >> > The device is /dev/mmcblk0, and hexedit -d -s /dev/mmcblk0
>> >>> >> >> >> > shows
>> >>> >> that
>> >>> >> >> >> > at the line 0x0400, it is indeed 34 34. What should I do
>> >>> >> >> >> > then?
>> >>> >> >> >> >
>> >>> >> >> >> > I tried gparted, but apparently it has no support for
>> nilfs2.
>> >>> >> >> >> >
>> >>> >> >> >> > Regards,
>> >>> >> >> >> > Paul Liu
>> >>> >> >> >> >
>> >>> >> >> >> > On 11/2/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>> >> >> >> >> Did you first format this card with fdisk?
>> >>> >> >> >> >> did you give it the exact same info this time around?
>> >>> >> >> >> >>
>> >>> >> >> >> >> Can you read /dev/'sdcard' ? (sdcard being the device in
>> the
>> >>> dev
>> >>> >> >> >> >> directory
>> >>> >> >> >> >> where the card lives)
>> >>> >> >> >> >>
>> >>> >> >> >> >> If yes can you run hexedit -s /dev/sdcard1  in a terminal
>> as
>> >>> >> >> >> >> root?
>> >>> >> >> >> >> and go to address 0400 - 04B0 to see if nilfs still
>> >>> >> >> >> >> exists?
>> >>> >> >> >> >>
>> >>> >> >> >> >> be very careful no to save any data in hexedit, it will
>> >>> >> >> >> >> definitely
>> >>> >> >> and
>> >>> >> >> >> >> finally
>> >>> >> >> >> >> destoy your data.
>> >>> >> >> >> >>
>> >>> >> >> >> >> 0400 looks vagely like this:
>> >>> >> >> >> >> 00000400   02 00 00 00 00 00 34 34  00 01 00 00 D3 56 F0
>> >>> >> >> >> >> B9
>> >>> >> >> >> >> ......44.....V..
>> >>> >> >> >> >> 00000410   39 BF D9 73 02 00 00 00  CA 02 00 00 00 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> 9..s............
>> >>> >> >> >> >> 00000420   00 B4 66 65 01 00 00 00  01 00 00 00 00 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> ..fe............
>> >>> >> >> >> >> 00000430   00 08 00 00 05 00 00 00  01 00 00 00 00 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> ................
>> >>> >> >> >> >> 00000440   01 00 00 00 00 00 00 00  00 00 00 00 00 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> ................
>> >>> >> >> >> >> 00000450   00 48 16 00 00 00 00 00  73 95 DC 4A 00 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> .H......s..J....
>> >>> >> >> >> >> 00000460   00 00 00 00 00 00 00 00  73 95 DC 4A 00 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> ........s..J....
>> >>> >> >> >> >> 00000470   00 00 32 00 01 00 01 00  73 95 DC 4A 00 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> ..2.....s..J....
>> >>> >> >> >> >> 00000480   00 4E ED 00 00 00 00 00  00 00 00 00 0B 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> .N..............
>> >>> >> >> >> >> 00000490   80 00 20 00 C0 00 10 00  4C 73 DD 3D 01 EC 45
>> >>> >> >> >> >> 85
>> >>> >> >> >> >> ..
>> >>> >> >> >> >> .....Ls.=..E.
>> >>> >> >> >> >> 000004A0   94 28 44 42 3D F6 EF EC  56 61 72 36 34 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> .(DB=...Var64...
>> >>> >> >> >> >> 000004B0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> ................
>> >>> >> >> >> >> 000004C0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00
>> >>> >> >> >> >> 00
>> >>> >> >> >> >> ................
>> >>> >> >> >> >>
>> >>> >> >> >> >> the 34 34 in the top line say this is nilfs.
>> >>> >> >> >> >>
>> >>> >> >> >> >>
>> >>> >> >> >> >> cheers
>> >>> >> >> >> >>
>> >>> >> >> >> >> jan de kruyf
>> >>> >> >> >> >>
>> >>> >> >> >> >>
>> >>> >> >> >> >>
>> >>> >> >> >> >>
>> >>> >> >> >> >> On Mon, Nov 2, 2009 at 9:06 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>> wrote:
>> >>> >> >> >> >>
>> >>> >> >> >> >>> Due to some careless handling of my laptop, the SD card
>> >>> >> >> >> >>> popped
>> >>> >> out
>> >>> >> >> >> >>> when the machine is still running. When I put it back in
>> >>> >> >> >> >>> and
>> >>> >> reboot
>> >>> >> >> >> >>> the machine, it says "partition table error". I then ran
>> >>> >> >> >> >>> fdisk
>> >>> >> and
>> >>> >> >> >> >>> recreated the single partition. Then I can no longer
>> >>> >> >> >> >>> mount
>> >>> >> >> >> >>> the
>> >>> >> >> nilfs2
>> >>> >> >> >> >>> partition that was on the SD card!
>> >>> >> >> >> >>>
>> >>> >> >> >> >>> Can any one help to me recover the file system? I believe
>> >>> >> >> >> >>> all
>> >>> >> data
>> >>> >> >> are
>> >>> >> >> >> >>> still there, but just some bits and pieces are missing
>> >>> >> >> >> >>> for
>> >>> >> >> >> >>> the
>> >>> >> >> >> >>> mount
>> >>> >> >> >> >>> to work. Any help is greatly appreciated!
>> >>> >> >> >> >>>
>> >>> >> >> >> >>> PS: I've a deadline to meet in 4 hours, not sure if I can
>> >>> >> >> >> >>> get
>> >>> my
>> >>> >> >> stuff
>> >>> >> >> >> >>> back in time... so help please!
>> >>> >> >> >> >>>
>> >>> >> >> >> >>> --
>> >>> >> >> >> >>> Regards,
>> >>> >> >> >> >>> Paul Liu
>> >>> >> >> >> >>>
>> >>> >> >> >> >>> Yale Haskell Group
>> >>> >> >> >> >>> http://www.haskell.org/yale
>> >>> >> >> >> >>> _______________________________________________
>> >>> >> >> >> >>> users mailing list
>> >>> >> >> >> >>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>> >>> >> >> >> >>> https://www.nilfs.org/mailman/listinfo/users
>> >>> >> >> >> >>>
>> >>> >> >> >> >>
>> >>> >> >> >> >
>> >>> >> >> >> >
>> >>> >> >> >> > --
>> >>> >> >> >> > Regards,
>> >>> >> >> >> > Paul Liu
>> >>> >> >> >> >
>> >>> >> >> >> > Yale Haskell Group
>> >>> >> >> >> > http://www.haskell.org/yale
>> >>> >> >> >> >
>> >>> >> >> >>
>> >>> >> >> >>
>> >>> >> >> >> --
>> >>> >> >> >> Regards,
>> >>> >> >> >> Paul Liu
>> >>> >> >> >>
>> >>> >> >> >> Yale Haskell Group
>> >>> >> >> >> http://www.haskell.org/yale
>> >>> >> >> >> _______________________________________________
>> >>> >> >> >> users mailing list
>> >>> >> >> >> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>> >>> >> >> >> https://www.nilfs.org/mailman/listinfo/users
>> >>> >> >> >>
>> >>> >> >> >
>> >>> >> >>
>> >>> >> >>
>> >>> >> >> --
>> >>> >> >> Regards,
>> >>> >> >> Paul Liu
>> >>> >> >>
>> >>> >> >> Yale Haskell Group
>> >>> >> >> http://www.haskell.org/yale
>> >>> >> >>
>> >>> >> >> _______________________________________________
>> >>> >> >> users mailing list
>> >>> >> >> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>> >>> >> >> https://www.nilfs.org/mailman/listinfo/users
>> >>> >> >>
>> >>> >> >>
>> >>> >> >
>> >>> >>
>> >>> >>
>> >>> >> --
>> >>> >> Regards,
>> >>> >> Paul Liu
>> >>> >>
>> >>> >> Yale Haskell Group
>> >>> >> http://www.haskell.org/yale
>> >>> >> _______________________________________________
>> >>> >> users mailing list
>> >>> >> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>> >>> >> https://www.nilfs.org/mailman/listinfo/users
>> >>> >>
>> >>> >
>> >>>
>> >>>
>> >>> --
>> >>> Regards,
>> >>> Paul Liu
>> >>>
>> >>> Yale Haskell Group
>> >>> http://www.haskell.org/yale
>> >>> _______________________________________________
>> >>> users mailing list
>> >>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>> >>> https://www.nilfs.org/mailman/listinfo/users
>> >>>
>> >>
>> >
>> >
>> > --
>> > Regards,
>> > Paul Liu
>> >
>> > Yale Haskell Group
>> > http://www.haskell.org/yale
>> >
>>
>>
>> --
>> Regards,
>> Paul Liu
>>
>> Yale Haskell Group
>> http://www.haskell.org/yale
>> _______________________________________________
>> users mailing list
>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>> https://www.nilfs.org/mailman/listinfo/users
>>
>


-- 
Regards,
Paul Liu

Yale Haskell Group
http://www.haskell.org/yale
