From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sat, 18 Jan 2014 10:47:03 +0900 (JST)
Message-ID: <20140118.104703.356941870.konishi.ryusuke@lab.ntt.co.jp>
References: <W9375626839227141389894521@atl4webmail02>
	<1389940315.2731.16.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389940315.2731.16.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Mark Trumpold <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 17 Jan 2014 10:31:55 +0400, Vyacheslav Dubeyko wrote:
> On Thu, 2014-01-16 at 17:48 +0000, Mark Trumpold wrote:
>> Hello All,
>> 
>> I am wondering what the impact of in-place writes of the
>> superblock has on SSDs in terms of wear?
>> 
>> I've been stress testing our system which uses Nilfs, and
>> recently I had a SSD fail with the classic messages indicating
>> low level media problems -- and also implicating Nilfs as trying
>> to locate a superblock (I think).
>> 
>> Following is a partial dmesg list: 
>> 
>> [    7.630382] Sense Key : Medium Error [current] [descriptor]
>> [    7.630385] Descriptor sense data with sense descriptors (in hex):
>> [    7.630386]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
>> [    7.630394]         05 ff 0e 58 
>> [    7.630397] sd 0:0:0:0: [sda]  
>> [    7.630399] Add. Sense: Unrecovered read error - auto reallocate failed
>> [    7.630401] sd 0:0:0:0: [sda] CDB: 
>> [    7.630402] Read(10): 28 00 05 ff 0e 54 00 00 08 00
>> [    7.630409] end_request: I/O error, dev sda, sector 100601432
>> [    7.635326] NILFS warning: I/O error on loading last segment
>> [    7.635329] NILFS: error searching super root.
>> 
>> 
> 
> I don't think that this issue is related to superblocks. Because I can't
> see in your output the magic signature of NILFS2. For example, I have
> such first 16 bytes in superblock:
> 
> 00000400  02 00 00 00 00 00 34 34  18 01 00 00 52 85 db 71  |......44....R..q|
> 
> Of course, I don't know your partition table details but I doubt that
> sector 100601432 is a superblock sector. Moreover, you have error
> messages that inform about troubles with loading last segment during
> super root searching.
> 
> We have on NILFS2 only two blocks that live under in-place update
> policy. An update frequency is not so high. So, I suppose that any FTL
> can easily provide good wear leveling support for superblocks. But, of
> course, in-place update is not good policy for flash-based devices,
> anyway.
> 
> Maybe, I misunderstand something in your output. But I suppose that
> during stress-testing you can discover I/O error in any part of volume.
> Because it is really hard to predict when you will exhaust spare pool of
> erase blocks.

Rather, the issue on the flash devices may come from the current
immature garbage collection algorithm.  The current cleanerd only
supports the timestamp-based GC policy which always tries to move the
oldest segment first and even moves segments full of live blocks,
thereby shortens the lifetime of flash devices. :-(

Actually, this is a high-priority todo, and now I am inclined to
consider it with the group concept of segments.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
