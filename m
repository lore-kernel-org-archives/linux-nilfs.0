From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cannot mount nilfs2 partition after io error in raid5
Date: Tue, 23 Feb 2010 02:25:56 +0900 (JST)
Message-ID: <20100223.022556.192697952.ryusuke@osrg.net>
References: <d5c85db51002220844k1fdd5f03pdd2fd97f61a10fa7@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d5c85db51002220844k1fdd5f03pdd2fd97f61a10fa7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: epineda.contact-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 22 Feb 2010 13:44:46 -0300, Edgard Pineda wrote:
> Hi,
> 
> I just had a 4 harddrives in raid5 with nilfs2 (kernel 2.6.32 and
> nilfs-utils 2.0.15) and I've got a power cut, then I rebuilt the
> array, but when I tried to mount the nilfs2 partition I've got:
> "NILFS: Can't find nilfs on dev md0" (in dmesg) after execute
> "mount.nilfs2: Error while mounting /dev/md0 on disk: Invalid
> argument".
> 
> Any idea? can I mount as "read only" to rescue some files? any tools
> to "see" the files and fix the partition?
> 
> Regards,
> Edgard.

Umm.., sounds serious.  The message "NILFS: Can't find nilfs on xxx"
is output when both of the two super blocks are broken.

Can you dump the partition with hd command?

# hd /dev/md0 | less

If the partition is not filled yet, it would look like this:

00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000400  02 00 00 00 00 00 34 34  00 01 00 00 7b 93 80 d4  |......44....{...|
00000410  50 09 11 38 02 00 00 00  17 11 00 00 00 00 00 00  |P..8............|
00000420  00 5e 8f 8b 08 00 00 00  01 00 00 00 00 00 00 00  |.^..............|
00000430  00 08 00 00 05 00 00 00  79 00 00 00 00 00 00 00  |........y.......|
00000440  25 70 00 00 00 00 00 00  0e 00 00 00 00 00 00 00  |%p..............|
00000450  00 88 88 00 00 00 00 00  bb fb 7c 4b 00 00 00 00  |..........|K....|
00000460  71 d4 7f 4b 00 00 00 00  85 d4 7f 4b 00 00 00 00  |q..K.......K....|
00000470  03 00 32 00 01 00 01 00  bb fb 7c 4b 00 00 00 00  |..2.......|K....|
00000480  00 4e ed 00 00 00 00 00  00 00 00 00 0b 00 00 00  |.N..............|
00000490  80 00 20 00 c0 00 10 00  8f d2 a7 e6 99 7a 41 e8  |.. ..........zA.|
000004a0  ae 88 26 e1 48 0c a5 f4  00 00 00 00 00 00 00 00  |..&.H...........|
000004b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00001000  dd 21 ee fe 80 ad 4e a1  11 fa af 1e 38 00 07 00  |.!....N.....8...|
00001010  00 00 00 00 00 00 00 00  bb fb 7c 4b 00 00 00 00  |..........|K....|
...


where "34 34" at offset 0x0406 is the magic number of NILFS.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
