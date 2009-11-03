From: Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: urgent help need! disk partition info lost
Date: Tue, 3 Nov 2009 14:48:42 -0500
Message-ID: <856033f20911031148o4d856a59vc711d1053ac9d1bc@mail.gmail.com>
References: <856033f20911021106u771f823dkb48395958ad83a37@mail.gmail.com>
	<ee5afd760911021138p25f34ca4gcb66547812cb858e@mail.gmail.com>
	<856033f20911021320w68e11498w4d5619ce5d586e80@mail.gmail.com>
	<856033f20911021527j3dbe86bcy37e9da592e1f0d5d@mail.gmail.com>
	<ee5afd760911031014l5bd4899ble3b6522e758bfb8d@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016369207090fb5e604777cc80b
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <ee5afd760911031014l5bd4899ble3b6522e758bfb8d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

--0016369207090fb5e604777cc80b
Content-Type: text/plain; charset=ISO-8859-1

Thanks a lot for the instructions! I'm attaching the mbr and partition
table with this email.

I'm pretty sure I had 1 partition on the card, since my /etc/fstab
mounts mmcblk0p1.

I think something corrupted my disk first, and then what I've done to
the disk after noticing the corruption:

1. fdisk, it says use "w" will correct the error, so I did. But then
the one parition is gone.
2. fdisk again, create a single partition, then "w"

My mistake was that I didn't create a backup copy of the MBR. A hard
lesson learned :(

Also, why is that my hexedit doesn't take the "-s" option? It's
version 0.9.7, and can't edit bigger than 4.2GB.

My SD card is A-DATA brand, class 6, and 16GB.

I'm using Linux, and fdisk version (util-linux-ng 2.14.1)

Regards,
Paul Liu

On 11/3/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>  hallo,
> Almost sounds like you had only the root master-boot-record /dev/mmcblk0
> before and now you have added 1 main partition /dev/mmcblk0p1.
>
> If (and only if) that is the case we have to undo the the 1st partition +
> check that no nilfs is overwritten.
> and I would have to urgently study fdisk to see exactly what it writes when
> and where.
> The last time I did tricks like these is quit a few years ago.
>
> It is the Linux version of fdisk is it??
>
> So here is the plan of action:
> hexdump the master boot record to file.
> like this:
>
> dd if=/dev/mmcblk0 of=backup-mmcblk0.mbr count=1 bs=512
>
> then dump any partitions of the device in a format useful as input to
> sfdisk. For example,
>                   % sfdisk -d /dev/mmcblk0  > mmcblk0 .out
> sfdisk is a tool provided with the util-linux
> package<http://www.kernel.org/pub/linux/utils/util-linux/>.
>
>
> or you could use hexdump to get machine readable or man readable images.
> Here is the man readable version:
> hd -n512 /dev/mmcblk0 > backup-mmcblk0.mbr
> hd -n512 /dev/mmcblk0p1 >backup-mmcblk0p1.mbr
> etc.
>
> By the way boor records always end with '55 AA'.
>
> Keep your files in a safe place in case we mess something we can at least go
> back to the present situation.
> If you could dd the whole drive to a file, now that would be magic indeed!
> but you must have the space on a harddrive.
> count=... is the number of sectors in the above line (dd ...) that you dump
> to file.
> Hexedit will tell you the number of sectors is you start it with -s option
> and then go to the last sector.
> DONT stop hexedit with control-x use cntl-c.
> DONT use high level or even midlevel tools on a stuffed disk, it normally
> messes more than it solves.
> unless of course you really,really know what you are doing.
> Fiddling the bytes is in general safe and gives results, if a man keeps a
> cool head.
>
> Please send me the fdisk version, the size of the card, and the mbr dump to
> feast my eyes on.
>
> cheers,
>
> Jan de kruyf.
>
>
>
> On Tue, Nov 3, 2009 at 1:27 AM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> just want to add that I've always been using 1 partition on this
>> device, it's actually /dev/mmcblk0p1. But hexedit /dev/mmcblk0p1
>> doesn't show that 34 34 at line begining with 0x400, only hexedit
>> /dev/mmcblk0 shows it. Not sure if this is a problem.
>>
>> Any help is greatly appreciated!
>>
>>
>> On 11/2/09, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > Thanks for the tips. When I first used the SD card, I used fdisk to
>> > create the partition.
>> >
>> > The device is /dev/mmcblk0, and hexedit -d -s /dev/mmcblk0 shows that
>> > at the line 0x0400, it is indeed 34 34. What should I do then?
>> >
>> > I tried gparted, but apparently it has no support for nilfs2.
>> >
>> > Regards,
>> > Paul Liu
>> >
>> > On 11/2/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> Did you first format this card with fdisk?
>> >> did you give it the exact same info this time around?
>> >>
>> >> Can you read /dev/'sdcard' ? (sdcard being the device in the dev
>> >> directory
>> >> where the card lives)
>> >>
>> >> If yes can you run hexedit -s /dev/sdcard1  in a terminal as root?
>> >> and go to address 0400 - 04B0 to see if nilfs still exists?
>> >>
>> >> be very careful no to save any data in hexedit, it will definitely and
>> >> finally
>> >> destoy your data.
>> >>
>> >> 0400 looks vagely like this:
>> >> 00000400   02 00 00 00 00 00 34 34  00 01 00 00 D3 56 F0 B9
>> >> ......44.....V..
>> >> 00000410   39 BF D9 73 02 00 00 00  CA 02 00 00 00 00 00 00
>> >> 9..s............
>> >> 00000420   00 B4 66 65 01 00 00 00  01 00 00 00 00 00 00 00
>> >> ..fe............
>> >> 00000430   00 08 00 00 05 00 00 00  01 00 00 00 00 00 00 00
>> >> ................
>> >> 00000440   01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> >> ................
>> >> 00000450   00 48 16 00 00 00 00 00  73 95 DC 4A 00 00 00 00
>> >> .H......s..J....
>> >> 00000460   00 00 00 00 00 00 00 00  73 95 DC 4A 00 00 00 00
>> >> ........s..J....
>> >> 00000470   00 00 32 00 01 00 01 00  73 95 DC 4A 00 00 00 00
>> >> ..2.....s..J....
>> >> 00000480   00 4E ED 00 00 00 00 00  00 00 00 00 0B 00 00 00
>> >> .N..............
>> >> 00000490   80 00 20 00 C0 00 10 00  4C 73 DD 3D 01 EC 45 85  ..
>> >> .....Ls.=..E.
>> >> 000004A0   94 28 44 42 3D F6 EF EC  56 61 72 36 34 00 00 00
>> >> .(DB=...Var64...
>> >> 000004B0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> >> ................
>> >> 000004C0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> >> ................
>> >>
>> >> the 34 34 in the top line say this is nilfs.
>> >>
>> >>
>> >> cheers
>> >>
>> >> jan de kruyf
>> >>
>> >>
>> >>
>> >>
>> >> On Mon, Nov 2, 2009 at 9:06 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>
>> >>> Due to some careless handling of my laptop, the SD card popped out
>> >>> when the machine is still running. When I put it back in and reboot
>> >>> the machine, it says "partition table error". I then ran fdisk and
>> >>> recreated the single partition. Then I can no longer mount the nilfs2
>> >>> partition that was on the SD card!
>> >>>
>> >>> Can any one help to me recover the file system? I believe all data are
>> >>> still there, but just some bits and pieces are missing for the mount
>> >>> to work. Any help is greatly appreciated!
>> >>>
>> >>> PS: I've a deadline to meet in 4 hours, not sure if I can get my stuff
>> >>> back in time... so help please!
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

--0016369207090fb5e604777cc80b
Content-Type: application/octet-stream; name="mmcblk0.out"
Content-Disposition: attachment; filename="mmcblk0.out"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

IyBwYXJ0aXRpb24gdGFibGUgb2YgL2Rldi9tbWNibGswCnVuaXQ6IHNlY3RvcnMKCi9kZXYvbW1j
YmxrMHAxIDogc3RhcnQ9ICAgICAgIDE2LCBzaXplPSAzMjIzNTUwNCwgSWQ9ODMKL2Rldi9tbWNi
bGswcDIgOiBzdGFydD0gICAgICAgIDAsIHNpemU9ICAgICAgICAwLCBJZD0gMAovZGV2L21tY2Js
azBwMyA6IHN0YXJ0PSAgICAgICAgMCwgc2l6ZT0gICAgICAgIDAsIElkPSAwCi9kZXYvbW1jYmxr
MHA0IDogc3RhcnQ9ICAgICAgICAwLCBzaXplPSAgICAgICAgMCwgSWQ9IDAK
--0016369207090fb5e604777cc80b
Content-Type: application/octet-stream; name="backup-mmcblk0.mbr"
Content-Disposition: attachment; filename="backup-mmcblk0.mbr"
Content-Transfer-Encoding: base64
X-Attachment-Id: file2

AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACWBiJsAAAAAQEAgwPQ/xAA
AADw3+sBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVao=
--0016369207090fb5e604777cc80b
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--0016369207090fb5e604777cc80b--
