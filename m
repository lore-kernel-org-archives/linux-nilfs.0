From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sat, 18 Jan 2014 12:45:49 +0100
Message-ID: <52DA696D.6010206@gmx.net>
References: <W9375626839227141389894521@atl4webmail02>	<1389940315.2731.16.camel@slavad-ubuntu> <20140118.104703.356941870.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140118.104703.356941870.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014-01-18 02:47, Ryusuke Konishi wrote:
> On Fri, 17 Jan 2014 10:31:55 +0400, Vyacheslav Dubeyko wrote:
>> On Thu, 2014-01-16 at 17:48 +0000, Mark Trumpold wrote:
>>> Hello All,
>>>
>>> I am wondering what the impact of in-place writes of the
>>> superblock has on SSDs in terms of wear?
>>>
>>> I've been stress testing our system which uses Nilfs, and
>>> recently I had a SSD fail with the classic messages indicating
>>> low level media problems -- and also implicating Nilfs as trying
>>> to locate a superblock (I think).
>>>
>>> Following is a partial dmesg list: 
>>>
>>> [    7.630382] Sense Key : Medium Error [current] [descriptor]
>>> [    7.630385] Descriptor sense data with sense descriptors (in hex):
>>> [    7.630386]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
>>> [    7.630394]         05 ff 0e 58 
>>> [    7.630397] sd 0:0:0:0: [sda]  
>>> [    7.630399] Add. Sense: Unrecovered read error - auto reallocate failed
>>> [    7.630401] sd 0:0:0:0: [sda] CDB: 
>>> [    7.630402] Read(10): 28 00 05 ff 0e 54 00 00 08 00
>>> [    7.630409] end_request: I/O error, dev sda, sector 100601432
>>> [    7.635326] NILFS warning: I/O error on loading last segment
>>> [    7.635329] NILFS: error searching super root.
>>>
>>>
>>
>> I don't think that this issue is related to superblocks. Because I can't
>> see in your output the magic signature of NILFS2. For example, I have
>> such first 16 bytes in superblock:
>>
>> 00000400  02 00 00 00 00 00 34 34  18 01 00 00 52 85 db 71  |......44....R..q|
>>
>> Of course, I don't know your partition table details but I doubt that
>> sector 100601432 is a superblock sector. Moreover, you have error
>> messages that inform about troubles with loading last segment during
>> super root searching.
>>
>> We have on NILFS2 only two blocks that live under in-place update
>> policy. An update frequency is not so high. So, I suppose that any FTL
>> can easily provide good wear leveling support for superblocks. But, of
>> course, in-place update is not good policy for flash-based devices,
>> anyway.
>>
>> Maybe, I misunderstand something in your output. But I suppose that
>> during stress-testing you can discover I/O error in any part of volume.
>> Because it is really hard to predict when you will exhaust spare pool of
>> erase blocks.
> 
> Rather, the issue on the flash devices may come from the current
> immature garbage collection algorithm.  The current cleanerd only
> supports the timestamp-based GC policy which always tries to move the
> oldest segment first and even moves segments full of live blocks,
> thereby shortens the lifetime of flash devices. :-(
> 
> Actually, this is a high-priority todo, and now I am inclined to
> consider it with the group concept of segments.

Hi,

I am currently working on the garbage collector. I have implemented the
cost-benefit and greedy policies. It is quite a big change and I was
reluctant to submit a patch until I thoroughly tested it. I have
substantially redesigned it since last time I wrote about it on the
mailinglist. Now it seems to be very stable and the results are quite
promising.

The following results [1] are from my "ultimate" benchmark. It runs on
an AMD Phenom II X6 1090T processor with 8GB Ram and a Samsung SSD 840
with a 100GB partition for NILFS2. I used the Lair62 NFS traces form the
IOTTA Repository [2] to get a realistic and reproducible benchmark:

This is what the benchmark does:

1. Create a 20GB file of static data
2a. Start replaying the Lair62 NFS traces
2b. In parallel turn random checkpoints into snapshots every 5 minutes,
keep a list of the snapshots and turn them back into checkpoints after
15 minutes, so there are at most 3 snapshots present at the same time.

Timestamp is so slow, because it needlessly copies the 20GB static data
around over and over again, which can be seen because of the periodic
drops in performance. The other policies ignore the static data and
never move it. This is also evident if you compare the amount of data
written to the device [3] (compare /proc/diskstats before and after the
benchmark).

If you are interested I could clean up my code and submit a patch set
for review. I am sure there are lots of things, that need to be changed,
but maybe it can give you some ideas...

It would also be possible, to improve timestamp by allowing the cleaner
to abort if there is nothing to gain from cleaning a particular segment.
Instead it could just updated the su_lastmod in the SUFILE without doing
anything else. This would be a fairly simple change. I could provide a
patch for that too.

Regards,
Andreas Rohner

[1] https://www.dropbox.com/s/3ued8g5xaktnpbq/replay_parallel_ssd_line.pdf
[2] http://iotta.snia.org/historical_section?tracetype_id=2
[3]
https://www.dropbox.com/s/nwfixlzzzvf93v2/replay_parallel_stats_write.pdf
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
