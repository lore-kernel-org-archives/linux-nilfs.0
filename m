From: Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: urgent help need! disk partition info lost
Date: Mon, 2 Nov 2009 18:27:29 -0500
Message-ID: <856033f20911021527j3dbe86bcy37e9da592e1f0d5d@mail.gmail.com>
References: <856033f20911021106u771f823dkb48395958ad83a37@mail.gmail.com>
	<ee5afd760911021138p25f34ca4gcb66547812cb858e@mail.gmail.com>
	<856033f20911021320w68e11498w4d5619ce5d586e80@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <856033f20911021320w68e11498w4d5619ce5d586e80-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

just want to add that I've always been using 1 partition on this
device, it's actually /dev/mmcblk0p1. But hexedit /dev/mmcblk0p1
doesn't show that 34 34 at line begining with 0x400, only hexedit
/dev/mmcblk0 shows it. Not sure if this is a problem.

Any help is greatly appreciated!


On 11/2/09, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Thanks for the tips. When I first used the SD card, I used fdisk to
> create the partition.
>
> The device is /dev/mmcblk0, and hexedit -d -s /dev/mmcblk0 shows that
> at the line 0x0400, it is indeed 34 34. What should I do then?
>
> I tried gparted, but apparently it has no support for nilfs2.
>
> Regards,
> Paul Liu
>
> On 11/2/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Did you first format this card with fdisk?
>> did you give it the exact same info this time around?
>>
>> Can you read /dev/'sdcard' ? (sdcard being the device in the dev
>> directory
>> where the card lives)
>>
>> If yes can you run hexedit -s /dev/sdcard1  in a terminal as root?
>> and go to address 0400 - 04B0 to see if nilfs still exists?
>>
>> be very careful no to save any data in hexedit, it will definitely and
>> finally
>> destoy your data.
>>
>> 0400 looks vagely like this:
>> 00000400   02 00 00 00 00 00 34 34  00 01 00 00 D3 56 F0 B9
>> ......44.....V..
>> 00000410   39 BF D9 73 02 00 00 00  CA 02 00 00 00 00 00 00
>> 9..s............
>> 00000420   00 B4 66 65 01 00 00 00  01 00 00 00 00 00 00 00
>> ..fe............
>> 00000430   00 08 00 00 05 00 00 00  01 00 00 00 00 00 00 00
>> ................
>> 00000440   01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> ................
>> 00000450   00 48 16 00 00 00 00 00  73 95 DC 4A 00 00 00 00
>> .H......s..J....
>> 00000460   00 00 00 00 00 00 00 00  73 95 DC 4A 00 00 00 00
>> ........s..J....
>> 00000470   00 00 32 00 01 00 01 00  73 95 DC 4A 00 00 00 00
>> ..2.....s..J....
>> 00000480   00 4E ED 00 00 00 00 00  00 00 00 00 0B 00 00 00
>> .N..............
>> 00000490   80 00 20 00 C0 00 10 00  4C 73 DD 3D 01 EC 45 85  ..
>> .....Ls.=..E.
>> 000004A0   94 28 44 42 3D F6 EF EC  56 61 72 36 34 00 00 00
>> .(DB=...Var64...
>> 000004B0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> ................
>> 000004C0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> ................
>>
>> the 34 34 in the top line say this is nilfs.
>>
>>
>> cheers
>>
>> jan de kruyf
>>
>>
>>
>>
>> On Mon, Nov 2, 2009 at 9:06 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> Due to some careless handling of my laptop, the SD card popped out
>>> when the machine is still running. When I put it back in and reboot
>>> the machine, it says "partition table error". I then ran fdisk and
>>> recreated the single partition. Then I can no longer mount the nilfs2
>>> partition that was on the SD card!
>>>
>>> Can any one help to me recover the file system? I believe all data are
>>> still there, but just some bits and pieces are missing for the mount
>>> to work. Any help is greatly appreciated!
>>>
>>> PS: I've a deadline to meet in 4 hours, not sure if I can get my stuff
>>> back in time... so help please!
>>>
>>> --
>>> Regards,
>>> Paul Liu
>>>
>>> Yale Haskell Group
>>> http://www.haskell.org/yale
>>> _______________________________________________
>>> users mailing list
>>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>>> https://www.nilfs.org/mailman/listinfo/users
>>>
>>
>
>
> --
> Regards,
> Paul Liu
>
> Yale Haskell Group
> http://www.haskell.org/yale
>


-- 
Regards,
Paul Liu

Yale Haskell Group
http://www.haskell.org/yale
