From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: urgent help need! disk partition info lost
Date: Wed, 4 Nov 2009 23:26:45 +0200
Message-ID: <ee5afd760911041326g77cab1d9r90f55657dc11a789@mail.gmail.com>
References: <856033f20911021106u771f823dkb48395958ad83a37@mail.gmail.com>
	<ee5afd760911021138p25f34ca4gcb66547812cb858e@mail.gmail.com>
	<856033f20911021320w68e11498w4d5619ce5d586e80@mail.gmail.com>
	<856033f20911021527j3dbe86bcy37e9da592e1f0d5d@mail.gmail.com>
	<ee5afd760911031014l5bd4899ble3b6522e758bfb8d@mail.gmail.com>
	<856033f20911031148o4d856a59vc711d1053ac9d1bc@mail.gmail.com>
	<ee5afd760911031336g122fc338r8d2879a48d5e11d6@mail.gmail.com>
	<856033f20911031823m715b1f91q818e9c78cda9315d@mail.gmail.com>
	<ee5afd760911041046s70ada5d6w686ce83814b3e9e6@mail.gmail.com>
	<856033f20911041131n54c420fuf16b10fefb343188@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2073688211=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <856033f20911041131n54c420fuf16b10fefb343188-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

--===============2073688211==
Content-Type: multipart/alternative; boundary=001485f9221487d08504779244e4

--001485f9221487d08504779244e4
Content-Type: text/plain; charset=ISO-8859-1

just thought of something. You searched with standard (little, I think)
endianess
i.e. the image from my mail to you.
 try the image from YOUR main superblock:
0002 0000 0000 3434
and see if the backup copy surfaces.

jan.

On Wed, Nov 4, 2009 at 9:31 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I'm using nilfs 2.0.15, slackware current, kernel 2.6.28, on Acer
> Aspire One model A101,  which uses Atom CPU.
>
> I failed to find the superblock towards the end of either mmcblk0 or
> mmcblk0p1, but a search of hex string 0200000000003434 reveals that:
>
> mmcblk0: starts at address 00400400,  and the nilfs segment 0 starts
> at address 00401000.
>
> mmcblk0p1: starts at address 003FE400, and the nilfs segment 0 starts
> at 003FF000.
>
> I hope my SD card is not messing up itself by rearranging the blocks!
>
> Regards,
> Paul Liu
>
> On 11/4/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Hallo,
> > here we go again. As a matter of interest, what version of nilfs and what
> > distribution are you running? And what processor?
> > your endiannes confused me at first.
> >
> > glad you fixed your hexedit
> >
> > I have looked at some numbers in the superblock and they look ok. I do
> > wonder if you have the garbage collector running.
> >
> > now for the second superblock. Please pay attention to the exact place of
> > it. Because it is of vital
> > importance if it in in partition 1 or in the root of the disk.
> >
> > the first superblock sits as you observed in the root. The flags say
> amongst
> > others that it was unmounted cleanly but errors were detected.
> >
> > see  nilfs2_fs.h - NILFS2 on-disk structures and common declarations. in
> the
> > distribution.
> > /**
> >  * struct nilfs_super_block - structure of super block on disk
> >  */
> > struct nilfs_super_block {
> > ....
> > translates bit for bit to what you see written in the super block on
> disk.
> >
> > Here is an example from a partition of mine on how to discover the
> > superblock copy
> > it should read the same as the 1st but in your case it might not.
> > It is a leftshift - subtract 1 - right shift algorithm.
> > go in hexedit to the last data with ">" (shift .)
> > note the address of the last byte (the size of the partion)
> > in mine:
> > 6566B3F0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > ................
> > or the status line might give it
> > the address of the copy is now at 6566A000
> > i.e. 6566B has 1 subtracted from it and the 3 least significant digits
> have
> > been zeroed.
> >
> > so please dump yours, see if the algorithm works on the 1st part or on
> the
> > root or both,
> > so we know where it is.
> > And check if it is exactly the same as the first one you send me
> > "0000400 0002 0000 0000 3434 0100 0000 b209 5b31"
> > etc.
> >
> > the next thing to discover is where the start of (nilfs)segment 0 is.
> > I am not quite sure what is written in it, but the signature is quite
> > distinct.
> > This is what it looks on my machine:
> >
> > 00000FC0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > ................
> > 00000FD0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > ................
> > 00000FE0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > ................
> > 00000FF0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > ................
> > 00001000   C4 1B 47 5B 51 62 19 13  11 FA AF 1E 38 00 10 00
> > ..G[Qb......8...
> > 00001010   FB CE 01 00 00 00 00 00  EE BD F1 4A 00 00 00 00
> > ...........J....
> > 00001020   00 08 00 00 00 00 00 00  FF 07 00 00 32 00 00 00
> > ............2...
> > 00001030   A0 83 00 00 00 00 00 00  EE 0D 00 00 00 00 00 00
> > ................
> > 00001040   07 00 00 00 00 00 00 00  7B 00 00 00 7B 00 00 00
> > ........{...{...
> > 00001050   EA 9E 07 00 00 00 00 00  F8 01 00 00 00 00 00 00
> > ................
> > 00001060   EB 9E 07 00 00 00 00 00  F9 01 00 00 00 00 00 00
> > ................
> > 00001070   EC 9E 07 00 00 00 00 00  FA 01 00 00 00 00 00 00
> > ................
> > 00001080   ED 9E 07 00 00 00 00 00  FB 01 00 00 00 00 00 00
> > ................
> > 00001090   EE 9E 07 00 00 00 00 00  FC 01 00 00 00 00 00 00
> > ................
> > 000010A0   EF 9E 07 00 00 00 00 00  FD 01 00 00 00 00 00 00
> > ................
> > 000010B0   F0 9E 07 00 00 00 00 00  FE 01 00 00 00 00 00 00
> > ................
> > 000010C0   F2 9E 07 00 00 00 00 00  FF 01 00 00 00 00 00 00
> > ................
> > 000010D0   F3 9E 07 00 00 00 00 00  00 02 00 00 00 00 00 00
> > ................
> > 000010E0   F4 9E 07 00 00 00 00 00  01 02 00 00 00 00 00 00
> > ................
> > 000010F0   F5 9E 07 00 00 00 00 00  02 02 00 00 00 00 00 00
> > ................
> > 00001100   F6 9E 07 00 00 00 00 00  03 02 00 00 00 00 00 00
> > ................
> > 00001110   F7 9E 07 00 00 00 00 00  04 02 00 00 00 00 00 00
> > ................
> > 00001120   F8 9E 07 00 00 00 00 00  05 02 00 00 00 00 00 00
> > ................
> > 00001130   F9 9E 07 00 00 00 00 00  06 02 00 00 00 00 00 00
> > ................
> > 00001140   FA 9E 07 00 00 00 00 00  07 02 00 00 00 00 00 00
> > ................
> > 00001150   FB 9E 07 00 00 00 00 00  08 02 00 00 00 00 00 00
> > ................
> > 00001160   FC 9E 07 00 00 00 00 00  09 02 00 00 00 00 00 00
> > ................
> > 00001170   FD 9E 07 00 00 00 00 00  0A 02 00 00 00 00 00 00
> > ................
> > 00001180   FE 9E 07 00 00 00 00 00  0B 02 00 00 00 00 00 00
> > ................
> > 00001190   FF 9E 07 00 00 00 00 00  0C 02 00 00 00 00 00 00
> > ................
> > 000011A0   00 9F 07 00 00 00 00 00  0D 02 00 00 00 00 00 00
> > ................
> > 000011B0   01 9F 07 00 00 00 00 00  0E 02 00 00 00 00 00 00
> > ................
> > 000011C0   02 9F 07 00 00 00 00 00  0F 02 00 00 00 00 00 00
> > ................
> > 000011D0   03 9F 07 00 00 00 00 00  10 02 00 00 00 00 00 00
> > ................
> > 000011E0   04 9F 07 00 00 00 00 00  11 02 00 00 00 00 00 00
> > ................
> >
> > Segment 0 starts at hex 1000 of a nilfs partition as you can see above
> and
> > carries on for quite a while like this.
> >
> > so have a look on your disk if it sits at 1000 of the root partition or
> at
> > 1000 of partition 1.
> >
> > Once we have these things sorted I would say that we are ready to plant
> the
> > _right_ superblock of the 2
> > in the right place and see if the partition is recoqnized by nilfs.
> > Off course we will save the place where we are going to plant that block
> > first.
> >
> > And now back to the birthday party . . . .
> >
> > Cheers,
> >
> > Jan
> >
> >
> >
> > On Wed, Nov 4, 2009 at 4:23 AM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On 11/3/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> > 26 august 98: hexedit 0.9.5 release
> >> > september 2005:
> >> >     - version 1.2.12  this is the one I am running.
> >>
> >> Ah, I must be using the wrong hexedit.. now I've installed the same one
> >> you
> >> use.
> >>
> >> > did I hear that you have always had /dev/mmcblk0p1 in fstab??
> >>
> >> Yes. What I put there is:
> >>
> >> /dev/mmcblk0p1 /home    nilfs2 defaults           1 1
> >>
> >> > hd -n1536 /dev/mmcblk0 >part.start
> >> > hd -s8191 -n1536 /dev/mmcblk0 >part1.start
> >> > an to verify the last line:
> >> > hd -n1536 /dev/mmcblk0p1 >part1a.start
> >>
> >> Here is the output (I use hexdump instead of hd, hopefully they are the
> >> same)
> >>
> >> bash-3.1# cat part.start
> >> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> >> *
> >> 00001b0 0000 0000 0000 0000 0696 6c22 0000 0100
> >> 00001c0 0001 0383 ffd0 0010 0000 dff0 01eb 0000
> >> 00001d0 0000 0000 0000 0000 0000 0000 0000 0000
> >> *
> >> 00001f0 0000 0000 0000 0000 0000 0000 0000 aa55
> >> 0000200 0000 0000 0000 0000 0000 0000 0000 0000
> >> *
> >> 0000400 0002 0000 0000 3434 0100 0000 b209 5b31
> >> 0000410 1183 794c 0002 0000 07af 0000 0000 0000
> >> 0000420 0000 d780 0003 0000 0001 0000 0000 0000
> >> 0000430 0800 0000 0005 0000 090b 000e 0000 0000
> >> 0000440 0710 0035 0000 0000 8502 0008 0000 0000
> >> 0000450 8800 000b 0000 0000 93c1 493c 0000 0000
> >> 0000460 013f 4ae2 0000 0000 2a8f 4aef 0000 0000
> >> 0000470 00a2 0032 0003 0001 93c1 493c 0000 0000
> >> 0000480 4e00 00ed 0000 0000 0000 0000 000b 0000
> >> 0000490 0080 0020 00c0 0010 ed2b 04f5 41cb ae48
> >> 00004a0 7f8a 4849 71ec e7f5 0000 0000 0000 0000
> >> 00004b0 0000 0000 0000 0000 0000 0000 0000 0000
> >> *
> >> 0000600
> >> bash-3.1# cat part1.start
> >> 0001fff 0000 0000 0000 0000 0000 0000 0000 0000
> >> *
> >> 00025ff
> >> bash-3.1# cat part1a.start
> >> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> >> *
> >> 0000600
> >>
> >> Regards,
> >> Paul Liu
> >>
> >> > On Tue, Nov 3, 2009 at 9:48 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> Thanks a lot for the instructions! I'm attaching the mbr and
> partition
> >> >> table with this email.
> >> >>
> >> >> I'm pretty sure I had 1 partition on the card, since my /etc/fstab
> >> >> mounts mmcblk0p1.
> >> >>
> >> >> I think something corrupted my disk first, and then what I've done to
> >> >> the disk after noticing the corruption:
> >> >>
> >> >> 1. fdisk, it says use "w" will correct the error, so I did. But then
> >> >> the one parition is gone.
> >> >> 2. fdisk again, create a single partition, then "w"
> >> >>
> >> >> My mistake was that I didn't create a backup copy of the MBR. A hard
> >> >> lesson learned :(
> >> >>
> >> >> Also, why is that my hexedit doesn't take the "-s" option? It's
> >> >> version 0.9.7, and can't edit bigger than 4.2GB.
> >> >>
> >> >> My SD card is A-DATA brand, class 6, and 16GB.
> >> >>
> >> >> I'm using Linux, and fdisk version (util-linux-ng 2.14.1)
> >> >>
> >> >> Regards,
> >> >> Paul Liu
> >> >>
> >> >> On 11/3/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >> >  hallo,
> >> >> > Almost sounds like you had only the root master-boot-record
> >> /dev/mmcblk0
> >> >> > before and now you have added 1 main partition /dev/mmcblk0p1.
> >> >> >
> >> >> > If (and only if) that is the case we have to undo the the 1st
> >> partition
> >> >> > +
> >> >> > check that no nilfs is overwritten.
> >> >> > and I would have to urgently study fdisk to see exactly what it
> >> >> > writes
> >> >> when
> >> >> > and where.
> >> >> > The last time I did tricks like these is quit a few years ago.
> >> >> >
> >> >> > It is the Linux version of fdisk is it??
> >> >> >
> >> >> > So here is the plan of action:
> >> >> > hexdump the master boot record to file.
> >> >> > like this:
> >> >> >
> >> >> > dd if=/dev/mmcblk0 of=backup-mmcblk0.mbr count=1 bs=512
> >> >> >
> >> >> > then dump any partitions of the device in a format useful as input
> to
> >> >> > sfdisk. For example,
> >> >> >                   % sfdisk -d /dev/mmcblk0  > mmcblk0 .out
> >> >> > sfdisk is a tool provided with the util-linux
> >> >> > package<http://www.kernel.org/pub/linux/utils/util-linux/>.
> >> >> >
> >> >> >
> >> >> > or you could use hexdump to get machine readable or man readable
> >> images.
> >> >> > Here is the man readable version:
> >> >> > hd -n512 /dev/mmcblk0 > backup-mmcblk0.mbr
> >> >> > hd -n512 /dev/mmcblk0p1 >backup-mmcblk0p1.mbr
> >> >> > etc.
> >> >> >
> >> >> > By the way boor records always end with '55 AA'.
> >> >> >
> >> >> > Keep your files in a safe place in case we mess something we can at
> >> >> > least
> >> >> go
> >> >> > back to the present situation.
> >> >> > If you could dd the whole drive to a file, now that would be magic
> >> >> indeed!
> >> >> > but you must have the space on a harddrive.
> >> >> > count=... is the number of sectors in the above line (dd ...) that
> >> >> > you
> >> >> dump
> >> >> > to file.
> >> >> > Hexedit will tell you the number of sectors is you start it with -s
> >> >> option
> >> >> > and then go to the last sector.
> >> >> > DONT stop hexedit with control-x use cntl-c.
> >> >> > DONT use high level or even midlevel tools on a stuffed disk, it
> >> >> > normally
> >> >> > messes more than it solves.
> >> >> > unless of course you really,really know what you are doing.
> >> >> > Fiddling the bytes is in general safe and gives results, if a man
> >> keeps
> >> >> > a
> >> >> > cool head.
> >> >> >
> >> >> > Please send me the fdisk version, the size of the card, and the mbr
> >> dump
> >> >> to
> >> >> > feast my eyes on.
> >> >> >
> >> >> > cheers,
> >> >> >
> >> >> > Jan de kruyf.
> >> >> >
> >> >> >
> >> >> >
> >> >> > On Tue, Nov 3, 2009 at 1:27 AM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >> >
> >> >> >> just want to add that I've always been using 1 partition on this
> >> >> >> device, it's actually /dev/mmcblk0p1. But hexedit /dev/mmcblk0p1
> >> >> >> doesn't show that 34 34 at line begining with 0x400, only hexedit
> >> >> >> /dev/mmcblk0 shows it. Not sure if this is a problem.
> >> >> >>
> >> >> >> Any help is greatly appreciated!
> >> >> >>
> >> >> >>
> >> >> >> On 11/2/09, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >> >> > Thanks for the tips. When I first used the SD card, I used fdisk
> >> >> >> > to
> >> >> >> > create the partition.
> >> >> >> >
> >> >> >> > The device is /dev/mmcblk0, and hexedit -d -s /dev/mmcblk0 shows
> >> that
> >> >> >> > at the line 0x0400, it is indeed 34 34. What should I do then?
> >> >> >> >
> >> >> >> > I tried gparted, but apparently it has no support for nilfs2.
> >> >> >> >
> >> >> >> > Regards,
> >> >> >> > Paul Liu
> >> >> >> >
> >> >> >> > On 11/2/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >> >> >> Did you first format this card with fdisk?
> >> >> >> >> did you give it the exact same info this time around?
> >> >> >> >>
> >> >> >> >> Can you read /dev/'sdcard' ? (sdcard being the device in the
> dev
> >> >> >> >> directory
> >> >> >> >> where the card lives)
> >> >> >> >>
> >> >> >> >> If yes can you run hexedit -s /dev/sdcard1  in a terminal as
> >> >> >> >> root?
> >> >> >> >> and go to address 0400 - 04B0 to see if nilfs still exists?
> >> >> >> >>
> >> >> >> >> be very careful no to save any data in hexedit, it will
> >> >> >> >> definitely
> >> >> and
> >> >> >> >> finally
> >> >> >> >> destoy your data.
> >> >> >> >>
> >> >> >> >> 0400 looks vagely like this:
> >> >> >> >> 00000400   02 00 00 00 00 00 34 34  00 01 00 00 D3 56 F0 B9
> >> >> >> >> ......44.....V..
> >> >> >> >> 00000410   39 BF D9 73 02 00 00 00  CA 02 00 00 00 00 00 00
> >> >> >> >> 9..s............
> >> >> >> >> 00000420   00 B4 66 65 01 00 00 00  01 00 00 00 00 00 00 00
> >> >> >> >> ..fe............
> >> >> >> >> 00000430   00 08 00 00 05 00 00 00  01 00 00 00 00 00 00 00
> >> >> >> >> ................
> >> >> >> >> 00000440   01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >> >> >> >> ................
> >> >> >> >> 00000450   00 48 16 00 00 00 00 00  73 95 DC 4A 00 00 00 00
> >> >> >> >> .H......s..J....
> >> >> >> >> 00000460   00 00 00 00 00 00 00 00  73 95 DC 4A 00 00 00 00
> >> >> >> >> ........s..J....
> >> >> >> >> 00000470   00 00 32 00 01 00 01 00  73 95 DC 4A 00 00 00 00
> >> >> >> >> ..2.....s..J....
> >> >> >> >> 00000480   00 4E ED 00 00 00 00 00  00 00 00 00 0B 00 00 00
> >> >> >> >> .N..............
> >> >> >> >> 00000490   80 00 20 00 C0 00 10 00  4C 73 DD 3D 01 EC 45 85  ..
> >> >> >> >> .....Ls.=..E.
> >> >> >> >> 000004A0   94 28 44 42 3D F6 EF EC  56 61 72 36 34 00 00 00
> >> >> >> >> .(DB=...Var64...
> >> >> >> >> 000004B0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >> >> >> >> ................
> >> >> >> >> 000004C0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >> >> >> >> ................
> >> >> >> >>
> >> >> >> >> the 34 34 in the top line say this is nilfs.
> >> >> >> >>
> >> >> >> >>
> >> >> >> >> cheers
> >> >> >> >>
> >> >> >> >> jan de kruyf
> >> >> >> >>
> >> >> >> >>
> >> >> >> >>
> >> >> >> >>
> >> >> >> >> On Mon, Nov 2, 2009 at 9:06 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
> >> >> >> >>
> >> >> >> >>> Due to some careless handling of my laptop, the SD card popped
> >> out
> >> >> >> >>> when the machine is still running. When I put it back in and
> >> reboot
> >> >> >> >>> the machine, it says "partition table error". I then ran fdisk
> >> and
> >> >> >> >>> recreated the single partition. Then I can no longer mount the
> >> >> nilfs2
> >> >> >> >>> partition that was on the SD card!
> >> >> >> >>>
> >> >> >> >>> Can any one help to me recover the file system? I believe all
> >> data
> >> >> are
> >> >> >> >>> still there, but just some bits and pieces are missing for the
> >> >> >> >>> mount
> >> >> >> >>> to work. Any help is greatly appreciated!
> >> >> >> >>>
> >> >> >> >>> PS: I've a deadline to meet in 4 hours, not sure if I can get
> my
> >> >> stuff
> >> >> >> >>> back in time... so help please!
> >> >> >> >>>
> >> >> >> >>> --
> >> >> >> >>> Regards,
> >> >> >> >>> Paul Liu
> >> >> >> >>>
> >> >> >> >>> Yale Haskell Group
> >> >> >> >>> http://www.haskell.org/yale
> >> >> >> >>> _______________________________________________
> >> >> >> >>> users mailing list
> >> >> >> >>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> >> >> >> >>> https://www.nilfs.org/mailman/listinfo/users
> >> >> >> >>>
> >> >> >> >>
> >> >> >> >
> >> >> >> >
> >> >> >> > --
> >> >> >> > Regards,
> >> >> >> > Paul Liu
> >> >> >> >
> >> >> >> > Yale Haskell Group
> >> >> >> > http://www.haskell.org/yale
> >> >> >> >
> >> >> >>
> >> >> >>
> >> >> >> --
> >> >> >> Regards,
> >> >> >> Paul Liu
> >> >> >>
> >> >> >> Yale Haskell Group
> >> >> >> http://www.haskell.org/yale
> >> >> >> _______________________________________________
> >> >> >> users mailing list
> >> >> >> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> >> >> >> https://www.nilfs.org/mailman/listinfo/users
> >> >> >>
> >> >> >
> >> >>
> >> >>
> >> >> --
> >> >> Regards,
> >> >> Paul Liu
> >> >>
> >> >> Yale Haskell Group
> >> >> http://www.haskell.org/yale
> >> >>
> >> >> _______________________________________________
> >> >> users mailing list
> >> >> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> >> >> https://www.nilfs.org/mailman/listinfo/users
> >> >>
> >> >>
> >> >
> >>
> >>
> >> --
> >> Regards,
> >> Paul Liu
> >>
> >> Yale Haskell Group
> >> http://www.haskell.org/yale
> >> _______________________________________________
> >> users mailing list
> >> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> >> https://www.nilfs.org/mailman/listinfo/users
> >>
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

--001485f9221487d08504779244e4
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

just thought of something. You searched with standard (little, I think) end=
ianess<br>i.e. the image from my mail to you.<br>=A0try the image from YOUR=
 main superblock:<br>0002 0000 0000 3434<br>and see if the backup copy surf=
aces.<br>
<br>jan.<br><br><div class=3D"gmail_quote">On Wed, Nov 4, 2009 at 9:31 PM, =
Paul L <span dir=3D"ltr">&lt;<a href=3D"mailto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua@g=
mail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; p=
adding-left: 1ex;">
I&#39;m using nilfs 2.0.15, slackware current, kernel 2.6.28, on Acer<br>
Aspire One model A101, =A0which uses Atom CPU.<br>
<br>
I failed to find the superblock towards the end of either mmcblk0 or<br>
mmcblk0p1, but a search of hex string 0200000000003434 reveals that:<br>
<br>
mmcblk0: starts at address 00400400, =A0and the nilfs segment 0 starts<br>
at address 00401000.<br>
<br>
mmcblk0p1: starts at address 003FE400, and the nilfs segment 0 starts<br>
at 003FF000.<br>
<br>
I hope my SD card is not messing up itself by rearranging the blocks!<br>
<br>
Regards,<br>
Paul Liu<br>
<div><div></div><div class=3D"h5"><br>
On 11/4/09, Jan de Kruyf &lt;<a href=3D"mailto:jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">jan.=
de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt; Hallo,<br>
&gt; here we go again. As a matter of interest, what version of nilfs and w=
hat<br>
&gt; distribution are you running? And what processor?<br>
&gt; your endiannes confused me at first.<br>
&gt;<br>
&gt; glad you fixed your hexedit<br>
&gt;<br>
&gt; I have looked at some numbers in the superblock and they look ok. I do=
<br>
&gt; wonder if you have the garbage collector running.<br>
&gt;<br>
&gt; now for the second superblock. Please pay attention to the exact place=
 of<br>
&gt; it. Because it is of vital<br>
&gt; importance if it in in partition 1 or in the root of the disk.<br>
&gt;<br>
&gt; the first superblock sits as you observed in the root. The flags say a=
mongst<br>
&gt; others that it was unmounted cleanly but errors were detected.<br>
&gt;<br>
&gt; see =A0nilfs2_fs.h - NILFS2 on-disk structures and common declarations=
. in the<br>
&gt; distribution.<br>
&gt; /**<br>
&gt; =A0* struct nilfs_super_block - structure of super block on disk<br>
&gt; =A0*/<br>
&gt; struct nilfs_super_block {<br>
&gt; ....<br>
&gt; translates bit for bit to what you see written in the super block on d=
isk.<br>
&gt;<br>
&gt; Here is an example from a partition of mine on how to discover the<br>
&gt; superblock copy<br>
&gt; it should read the same as the 1st but in your case it might not.<br>
&gt; It is a leftshift - subtract 1 - right shift algorithm.<br>
&gt; go in hexedit to the last data with &quot;&gt;&quot; (shift .)<br>
&gt; note the address of the last byte (the size of the partion)<br>
&gt; in mine:<br>
&gt; 6566B3F0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; or the status line might give it<br>
&gt; the address of the copy is now at 6566A000<br>
&gt; i.e. 6566B has 1 subtracted from it and the 3 least significant digits=
 have<br>
&gt; been zeroed.<br>
&gt;<br>
&gt; so please dump yours, see if the algorithm works on the 1st part or on=
 the<br>
&gt; root or both,<br>
&gt; so we know where it is.<br>
&gt; And check if it is exactly the same as the first one you send me<br>
&gt; &quot;0000400 0002 0000 0000 3434 0100 0000 b209 5b31&quot;<br>
&gt; etc.<br>
&gt;<br>
&gt; the next thing to discover is where the start of (nilfs)segment 0 is.<=
br>
&gt; I am not quite sure what is written in it, but the signature is quite<=
br>
&gt; distinct.<br>
&gt; This is what it looks on my machine:<br>
&gt;<br>
&gt; 00000FC0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00000FD0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00000FE0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00000FF0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001000 =A0 C4 1B 47 5B 51 62 19 13 =A011 FA AF 1E 38 00 10 00<br>
&gt; ..G[Qb......8...<br>
&gt; 00001010 =A0 FB CE 01 00 00 00 00 00 =A0EE BD F1 4A 00 00 00 00<br>
&gt; ...........J....<br>
&gt; 00001020 =A0 00 08 00 00 00 00 00 00 =A0FF 07 00 00 32 00 00 00<br>
&gt; ............2...<br>
&gt; 00001030 =A0 A0 83 00 00 00 00 00 00 =A0EE 0D 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001040 =A0 07 00 00 00 00 00 00 00 =A07B 00 00 00 7B 00 00 00<br>
&gt; ........{...{...<br>
&gt; 00001050 =A0 EA 9E 07 00 00 00 00 00 =A0F8 01 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001060 =A0 EB 9E 07 00 00 00 00 00 =A0F9 01 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001070 =A0 EC 9E 07 00 00 00 00 00 =A0FA 01 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001080 =A0 ED 9E 07 00 00 00 00 00 =A0FB 01 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001090 =A0 EE 9E 07 00 00 00 00 00 =A0FC 01 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000010A0 =A0 EF 9E 07 00 00 00 00 00 =A0FD 01 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000010B0 =A0 F0 9E 07 00 00 00 00 00 =A0FE 01 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000010C0 =A0 F2 9E 07 00 00 00 00 00 =A0FF 01 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000010D0 =A0 F3 9E 07 00 00 00 00 00 =A000 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000010E0 =A0 F4 9E 07 00 00 00 00 00 =A001 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000010F0 =A0 F5 9E 07 00 00 00 00 00 =A002 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001100 =A0 F6 9E 07 00 00 00 00 00 =A003 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001110 =A0 F7 9E 07 00 00 00 00 00 =A004 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001120 =A0 F8 9E 07 00 00 00 00 00 =A005 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001130 =A0 F9 9E 07 00 00 00 00 00 =A006 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001140 =A0 FA 9E 07 00 00 00 00 00 =A007 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001150 =A0 FB 9E 07 00 00 00 00 00 =A008 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001160 =A0 FC 9E 07 00 00 00 00 00 =A009 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001170 =A0 FD 9E 07 00 00 00 00 00 =A00A 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001180 =A0 FE 9E 07 00 00 00 00 00 =A00B 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 00001190 =A0 FF 9E 07 00 00 00 00 00 =A00C 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000011A0 =A0 00 9F 07 00 00 00 00 00 =A00D 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000011B0 =A0 01 9F 07 00 00 00 00 00 =A00E 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000011C0 =A0 02 9F 07 00 00 00 00 00 =A00F 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000011D0 =A0 03 9F 07 00 00 00 00 00 =A010 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt; 000011E0 =A0 04 9F 07 00 00 00 00 00 =A011 02 00 00 00 00 00 00<br>
&gt; ................<br>
&gt;<br>
&gt; Segment 0 starts at hex 1000 of a nilfs partition as you can see above=
 and<br>
&gt; carries on for quite a while like this.<br>
&gt;<br>
&gt; so have a look on your disk if it sits at 1000 of the root partition o=
r at<br>
&gt; 1000 of partition 1.<br>
&gt;<br>
&gt; Once we have these things sorted I would say that we are ready to plan=
t the<br>
&gt; _right_ superblock of the 2<br>
&gt; in the right place and see if the partition is recoqnized by nilfs.<br=
>
&gt; Off course we will save the place where we are going to plant that blo=
ck<br>
&gt; first.<br>
&gt;<br>
&gt; And now back to the birthday party . . . .<br>
&gt;<br>
&gt; Cheers,<br>
&gt;<br>
&gt; Jan<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On Wed, Nov 4, 2009 at 4:23 AM, Paul L &lt;<a href=3D"mailto:ninegua@g=
mail.com">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt; On 11/3/09, Jan de Kruyf &lt;<a href=3D"mailto:jan.de.kruyf@gmail.=
com">jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt; &gt; 26 august 98: hexedit 0.9.5 release<br>
&gt;&gt; &gt; september 2005:<br>
&gt;&gt; &gt; =A0 =A0 - version 1.2.12 =A0this is the one I am running.<br>
&gt;&gt;<br>
&gt;&gt; Ah, I must be using the wrong hexedit.. now I&#39;ve installed the=
 same one<br>
&gt;&gt; you<br>
&gt;&gt; use.<br>
&gt;&gt;<br>
&gt;&gt; &gt; did I hear that you have always had /dev/mmcblk0p1 in fstab??=
<br>
&gt;&gt;<br>
&gt;&gt; Yes. What I put there is:<br>
&gt;&gt;<br>
&gt;&gt; /dev/mmcblk0p1 /home =A0 =A0nilfs2 defaults =A0 =A0 =A0 =A0 =A0 1 =
1<br>
&gt;&gt;<br>
&gt;&gt; &gt; hd -n1536 /dev/mmcblk0 &gt;part.start<br>
&gt;&gt; &gt; hd -s8191 -n1536 /dev/mmcblk0 &gt;part1.start<br>
&gt;&gt; &gt; an to verify the last line:<br>
&gt;&gt; &gt; hd -n1536 /dev/mmcblk0p1 &gt;part1a.start<br>
&gt;&gt;<br>
&gt;&gt; Here is the output (I use hexdump instead of hd, hopefully they ar=
e the<br>
&gt;&gt; same)<br>
&gt;&gt;<br>
&gt;&gt; bash-3.1# cat part.start<br>
&gt;&gt; 0000000 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt; *<br>
&gt;&gt; 00001b0 0000 0000 0000 0000 0696 6c22 0000 0100<br>
&gt;&gt; 00001c0 0001 0383 ffd0 0010 0000 dff0 01eb 0000<br>
&gt;&gt; 00001d0 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt; *<br>
&gt;&gt; 00001f0 0000 0000 0000 0000 0000 0000 0000 aa55<br>
&gt;&gt; 0000200 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt; *<br>
&gt;&gt; 0000400 0002 0000 0000 3434 0100 0000 b209 5b31<br>
&gt;&gt; 0000410 1183 794c 0002 0000 07af 0000 0000 0000<br>
&gt;&gt; 0000420 0000 d780 0003 0000 0001 0000 0000 0000<br>
&gt;&gt; 0000430 0800 0000 0005 0000 090b 000e 0000 0000<br>
&gt;&gt; 0000440 0710 0035 0000 0000 8502 0008 0000 0000<br>
&gt;&gt; 0000450 8800 000b 0000 0000 93c1 493c 0000 0000<br>
&gt;&gt; 0000460 013f 4ae2 0000 0000 2a8f 4aef 0000 0000<br>
&gt;&gt; 0000470 00a2 0032 0003 0001 93c1 493c 0000 0000<br>
&gt;&gt; 0000480 4e00 00ed 0000 0000 0000 0000 000b 0000<br>
&gt;&gt; 0000490 0080 0020 00c0 0010 ed2b 04f5 41cb ae48<br>
&gt;&gt; 00004a0 7f8a 4849 71ec e7f5 0000 0000 0000 0000<br>
&gt;&gt; 00004b0 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt; *<br>
&gt;&gt; 0000600<br>
&gt;&gt; bash-3.1# cat part1.start<br>
&gt;&gt; 0001fff 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt; *<br>
&gt;&gt; 00025ff<br>
&gt;&gt; bash-3.1# cat part1a.start<br>
&gt;&gt; 0000000 0000 0000 0000 0000 0000 0000 0000 0000<br>
&gt;&gt; *<br>
&gt;&gt; 0000600<br>
&gt;&gt;<br>
&gt;&gt; Regards,<br>
&gt;&gt; Paul Liu<br>
&gt;&gt;<br>
&gt;&gt; &gt; On Tue, Nov 3, 2009 at 9:48 PM, Paul L &lt;<a href=3D"mailto:=
ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; Thanks a lot for the instructions! I&#39;m attaching the =
mbr and partition<br>
&gt;&gt; &gt;&gt; table with this email.<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; I&#39;m pretty sure I had 1 partition on the card, since =
my /etc/fstab<br>
&gt;&gt; &gt;&gt; mounts mmcblk0p1.<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; I think something corrupted my disk first, and then what =
I&#39;ve done to<br>
&gt;&gt; &gt;&gt; the disk after noticing the corruption:<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; 1. fdisk, it says use &quot;w&quot; will correct the erro=
r, so I did. But then<br>
&gt;&gt; &gt;&gt; the one parition is gone.<br>
&gt;&gt; &gt;&gt; 2. fdisk again, create a single partition, then &quot;w&q=
uot;<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; My mistake was that I didn&#39;t create a backup copy of =
the MBR. A hard<br>
&gt;&gt; &gt;&gt; lesson learned :(<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; Also, why is that my hexedit doesn&#39;t take the &quot;-=
s&quot; option? It&#39;s<br>
&gt;&gt; &gt;&gt; version 0.9.7, and can&#39;t edit bigger than 4.2GB.<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; My SD card is A-DATA brand, class 6, and 16GB.<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; I&#39;m using Linux, and fdisk version (util-linux-ng 2.1=
4.1)<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; Regards,<br>
&gt;&gt; &gt;&gt; Paul Liu<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; On 11/3/09, Jan de Kruyf &lt;<a href=3D"mailto:jan.de.kru=
yf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt; &gt;&gt; &gt; =A0hallo,<br>
&gt;&gt; &gt;&gt; &gt; Almost sounds like you had only the root master-boot=
-record<br>
&gt;&gt; /dev/mmcblk0<br>
&gt;&gt; &gt;&gt; &gt; before and now you have added 1 main partition /dev/=
mmcblk0p1.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; If (and only if) that is the case we have to undo th=
e the 1st<br>
&gt;&gt; partition<br>
&gt;&gt; &gt;&gt; &gt; +<br>
&gt;&gt; &gt;&gt; &gt; check that no nilfs is overwritten.<br>
&gt;&gt; &gt;&gt; &gt; and I would have to urgently study fdisk to see exac=
tly what it<br>
&gt;&gt; &gt;&gt; &gt; writes<br>
&gt;&gt; &gt;&gt; when<br>
&gt;&gt; &gt;&gt; &gt; and where.<br>
&gt;&gt; &gt;&gt; &gt; The last time I did tricks like these is quit a few =
years ago.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; It is the Linux version of fdisk is it??<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; So here is the plan of action:<br>
&gt;&gt; &gt;&gt; &gt; hexdump the master boot record to file.<br>
&gt;&gt; &gt;&gt; &gt; like this:<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; dd if=3D/dev/mmcblk0 of=3Dbackup-mmcblk0.mbr count=
=3D1 bs=3D512<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; then dump any partitions of the device in a format u=
seful as input to<br>
&gt;&gt; &gt;&gt; &gt; sfdisk. For example,<br>
&gt;&gt; &gt;&gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 % sfdisk -d /dev=
/mmcblk0 =A0&gt; mmcblk0 .out<br>
&gt;&gt; &gt;&gt; &gt; sfdisk is a tool provided with the util-linux<br>
&gt;&gt; &gt;&gt; &gt; package&lt;<a href=3D"http://www.kernel.org/pub/linu=
x/utils/util-linux/" target=3D"_blank">http://www.kernel.org/pub/linux/util=
s/util-linux/</a>&gt;.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; or you could use hexdump to get machine readable or =
man readable<br>
&gt;&gt; images.<br>
&gt;&gt; &gt;&gt; &gt; Here is the man readable version:<br>
&gt;&gt; &gt;&gt; &gt; hd -n512 /dev/mmcblk0 &gt; backup-mmcblk0.mbr<br>
&gt;&gt; &gt;&gt; &gt; hd -n512 /dev/mmcblk0p1 &gt;backup-mmcblk0p1.mbr<br>
&gt;&gt; &gt;&gt; &gt; etc.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; By the way boor records always end with &#39;55 AA&#=
39;.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; Keep your files in a safe place in case we mess some=
thing we can at<br>
&gt;&gt; &gt;&gt; &gt; least<br>
&gt;&gt; &gt;&gt; go<br>
&gt;&gt; &gt;&gt; &gt; back to the present situation.<br>
&gt;&gt; &gt;&gt; &gt; If you could dd the whole drive to a file, now that =
would be magic<br>
&gt;&gt; &gt;&gt; indeed!<br>
&gt;&gt; &gt;&gt; &gt; but you must have the space on a harddrive.<br>
&gt;&gt; &gt;&gt; &gt; count=3D... is the number of sectors in the above li=
ne (dd ...) that<br>
&gt;&gt; &gt;&gt; &gt; you<br>
&gt;&gt; &gt;&gt; dump<br>
&gt;&gt; &gt;&gt; &gt; to file.<br>
&gt;&gt; &gt;&gt; &gt; Hexedit will tell you the number of sectors is you s=
tart it with -s<br>
&gt;&gt; &gt;&gt; option<br>
&gt;&gt; &gt;&gt; &gt; and then go to the last sector.<br>
&gt;&gt; &gt;&gt; &gt; DONT stop hexedit with control-x use cntl-c.<br>
&gt;&gt; &gt;&gt; &gt; DONT use high level or even midlevel tools on a stuf=
fed disk, it<br>
&gt;&gt; &gt;&gt; &gt; normally<br>
&gt;&gt; &gt;&gt; &gt; messes more than it solves.<br>
&gt;&gt; &gt;&gt; &gt; unless of course you really,really know what you are=
 doing.<br>
&gt;&gt; &gt;&gt; &gt; Fiddling the bytes is in general safe and gives resu=
lts, if a man<br>
&gt;&gt; keeps<br>
&gt;&gt; &gt;&gt; &gt; a<br>
&gt;&gt; &gt;&gt; &gt; cool head.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; Please send me the fdisk version, the size of the ca=
rd, and the mbr<br>
&gt;&gt; dump<br>
&gt;&gt; &gt;&gt; to<br>
&gt;&gt; &gt;&gt; &gt; feast my eyes on.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; cheers,<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; Jan de kruyf.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; On Tue, Nov 3, 2009 at 1:27 AM, Paul L &lt;<a href=
=3D"mailto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; just want to add that I&#39;ve always been using=
 1 partition on this<br>
&gt;&gt; &gt;&gt; &gt;&gt; device, it&#39;s actually /dev/mmcblk0p1. But he=
xedit /dev/mmcblk0p1<br>
&gt;&gt; &gt;&gt; &gt;&gt; doesn&#39;t show that 34 34 at line begining wit=
h 0x400, only hexedit<br>
&gt;&gt; &gt;&gt; &gt;&gt; /dev/mmcblk0 shows it. Not sure if this is a pro=
blem.<br>
&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; Any help is greatly appreciated!<br>
&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; On 11/2/09, Paul L &lt;<a href=3D"mailto:ninegua=
@gmail.com">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; Thanks for the tips. When I first used the =
SD card, I used fdisk<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; to<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; create the partition.<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; The device is /dev/mmcblk0, and hexedit -d =
-s /dev/mmcblk0 shows<br>
&gt;&gt; that<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; at the line 0x0400, it is indeed 34 34. Wha=
t should I do then?<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; I tried gparted, but apparently it has no s=
upport for nilfs2.<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; Regards,<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; Paul Liu<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; On 11/2/09, Jan de Kruyf &lt;<a href=3D"mai=
lto:jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Did you first format this card with fdi=
sk?<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; did you give it the exact same info thi=
s time around?<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Can you read /dev/&#39;sdcard&#39; ? (s=
dcard being the device in the dev<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; directory<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; where the card lives)<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; If yes can you run hexedit -s /dev/sdca=
rd1 =A0in a terminal as<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; root?<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; and go to address 0400 - 04B0 to see if=
 nilfs still exists?<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; be very careful no to save any data in =
hexedit, it will<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; definitely<br>
&gt;&gt; &gt;&gt; and<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; finally<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; destoy your data.<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 0400 looks vagely like this:<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000400 =A0 02 00 00 00 00 00 34 34 =
=A000 01 00 00 D3 56 F0 B9<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ......44.....V..<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000410 =A0 39 BF D9 73 02 00 00 00 =
=A0CA 02 00 00 00 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 9..s............<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000420 =A0 00 B4 66 65 01 00 00 00 =
=A001 00 00 00 00 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ..fe............<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000430 =A0 00 08 00 00 05 00 00 00 =
=A001 00 00 00 00 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ................<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000440 =A0 01 00 00 00 00 00 00 00 =
=A000 00 00 00 00 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ................<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000450 =A0 00 48 16 00 00 00 00 00 =
=A073 95 DC 4A 00 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; .H......s..J....<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000460 =A0 00 00 00 00 00 00 00 00 =
=A073 95 DC 4A 00 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ........s..J....<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000470 =A0 00 00 32 00 01 00 01 00 =
=A073 95 DC 4A 00 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ..2.....s..J....<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000480 =A0 00 4E ED 00 00 00 00 00 =
=A000 00 00 00 0B 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; .N..............<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 00000490 =A0 80 00 20 00 C0 00 10 00 =
=A04C 73 DD 3D 01 EC 45 85 =A0..<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; .....Ls.=3D..E.<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 000004A0 =A0 94 28 44 42 3D F6 EF EC =
=A056 61 72 36 34 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; .(DB=3D...Var64...<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 000004B0 =A0 00 00 00 00 00 00 00 00 =
=A000 00 00 00 00 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ................<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; 000004C0 =A0 00 00 00 00 00 00 00 00 =
=A000 00 00 00 00 00 00 00<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; ................<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; the 34 34 in the top line say this is n=
ilfs.<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; cheers<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; jan de kruyf<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; On Mon, Nov 2, 2009 at 9:06 PM, Paul L =
&lt;<a href=3D"mailto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<b=
r>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Due to some careless handling of my=
 laptop, the SD card popped<br>
&gt;&gt; out<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; when the machine is still running. =
When I put it back in and<br>
&gt;&gt; reboot<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; the machine, it says &quot;partitio=
n table error&quot;. I then ran fdisk<br>
&gt;&gt; and<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; recreated the single partition. The=
n I can no longer mount the<br>
&gt;&gt; &gt;&gt; nilfs2<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; partition that was on the SD card!<=
br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Can any one help to me recover the =
file system? I believe all<br>
&gt;&gt; data<br>
&gt;&gt; &gt;&gt; are<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; still there, but just some bits and=
 pieces are missing for the<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; mount<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; to work. Any help is greatly apprec=
iated!<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; PS: I&#39;ve a deadline to meet in =
4 hours, not sure if I can get my<br>
&gt;&gt; &gt;&gt; stuff<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; back in time... so help please!<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; --<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Regards,<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Paul Liu<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Yale Haskell Group<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; <a href=3D"http://www.haskell.org/y=
ale" target=3D"_blank">http://www.haskell.org/yale</a><br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; ___________________________________=
____________<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; users mailing list<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; <a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">=
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; <a href=3D"https://www.nilfs.org/ma=
ilman/listinfo/users" target=3D"_blank">https://www.nilfs.org/mailman/listi=
nfo/users</a><br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; --<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; Regards,<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; Paul Liu<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; Yale Haskell Group<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; <a href=3D"http://www.haskell.org/yale" tar=
get=3D"_blank">http://www.haskell.org/yale</a><br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; --<br>
&gt;&gt; &gt;&gt; &gt;&gt; Regards,<br>
&gt;&gt; &gt;&gt; &gt;&gt; Paul Liu<br>
&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; Yale Haskell Group<br>
&gt;&gt; &gt;&gt; &gt;&gt; <a href=3D"http://www.haskell.org/yale" target=
=3D"_blank">http://www.haskell.org/yale</a><br>
&gt;&gt; &gt;&gt; &gt;&gt; _______________________________________________<=
br>
&gt;&gt; &gt;&gt; &gt;&gt; users mailing list<br>
&gt;&gt; &gt;&gt; &gt;&gt; <a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users@nilfs.o=
rg</a><br>
&gt;&gt; &gt;&gt; &gt;&gt; <a href=3D"https://www.nilfs.org/mailman/listinf=
o/users" target=3D"_blank">https://www.nilfs.org/mailman/listinfo/users</a>=
<br>
&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; --<br>
&gt;&gt; &gt;&gt; Regards,<br>
&gt;&gt; &gt;&gt; Paul Liu<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; Yale Haskell Group<br>
&gt;&gt; &gt;&gt; <a href=3D"http://www.haskell.org/yale" target=3D"_blank"=
>http://www.haskell.org/yale</a><br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; _______________________________________________<br>
&gt;&gt; &gt;&gt; users mailing list<br>
&gt;&gt; &gt;&gt; <a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br=
>
&gt;&gt; &gt;&gt; <a href=3D"https://www.nilfs.org/mailman/listinfo/users" =
target=3D"_blank">https://www.nilfs.org/mailman/listinfo/users</a><br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; --<br>
&gt;&gt; Regards,<br>
&gt;&gt; Paul Liu<br>
&gt;&gt;<br>
&gt;&gt; Yale Haskell Group<br>
&gt;&gt; <a href=3D"http://www.haskell.org/yale" target=3D"_blank">http://w=
ww.haskell.org/yale</a><br>
&gt;&gt; _______________________________________________<br>
&gt;&gt; users mailing list<br>
&gt;&gt; <a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
&gt;&gt; <a href=3D"https://www.nilfs.org/mailman/listinfo/users" target=3D=
"_blank">https://www.nilfs.org/mailman/listinfo/users</a><br>
&gt;&gt;<br>
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

--001485f9221487d08504779244e4--

--===============2073688211==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============2073688211==--
