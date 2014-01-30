From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/1] nilfs2: add mount option that reduces super block
 writes
Date: Thu, 30 Jan 2014 06:59:38 +0100
Message-ID: <52E9EA4A.4040102@gmx.net>
References: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>	<cover.1391048231.git.andreas.rohner@gmx.net> <20140130.142941.55837481.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140130.142941.55837481.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On 2014-01-30 06:29, Ryusuke Konishi wrote:
> Hi Andreas,
> On Thu, 30 Jan 2014 03:46:59 +0100, Andreas Rohner wrote:
>> Hi,
>>
>> This is only a hacky proof of concept implementation and probably 
>> full of nasty bugs. I also havn't really tested it. I was 
>> just interested how hard it would be to implement Clemens' suggestion 
>> of writing the super block only at umount time and do a linear scan 
>> of all the segments in case of file system failure.
>> The linear scan is only performed if the file system wasn't shut down 
>> properly. So for normal operation there shouldn't be any slowdown.
> 
> This premise is not acceptable.
> We have to avoid long mount time even after unexpected power failures.

It is only activated by the mount option bad_ftl. So the user has to
chose it explicitly. The user wouldn't activate it if he/she uses a 4 TB
hard drive. The user also wouldn't activate it if he/she uses a modern
SSD with a decent FTL. It would only make sense to activate it for
crappy SD-Cards.

> I prefer some sort of way which combines binary search of segment
> summary blocks and partial linear scan of logs. 

For a binary search the segments have to be sorted at some granularity
(groups). I think this would hinder more sophisticated GC policies. That
seems to be a high price just so that the super block is not updated so
often.

> I don't know the latency of recent SSDs, however we should estimate
> the latency of disk I/O about 5ms~20ms per a separate block (in the
> case of hard drives).  So the maximum number of scans of segment
> summary blocks seems to be roughly 10~100 times.
> 
> Regards,
> Ryusuke Konishi
> 
>>
>> I repurposed the ss_pad field of nilfs_segment_summary to contain the 
>> crc seed, because I needed a way to distinguish left over segments 
>> from previous nilfs2 volumes from real segments that are part of the 
>> current file system. 
>>
>> I don't really expect it to be merged or anything. Maybe it can spark 
>> a discussion. Maybe somebody could try it out on an old SD-Card and 
>> time the mount command or something.
>>
>> I tested it on a virtual machine. It seemed to recover fine when I 
>> killed the VM and mounted it again. Clearly more testing is 
>> necessary...
>>
>> br,
>> Andreas Rohner
>>
>> ---
>> Andreas Rohner (1):
>>   nilfs2: add mount option that reduces super block writes
>>
>>  fs/nilfs2/segbuf.c        |  3 ++-
>>  fs/nilfs2/segment.c       |  3 ++-
>>  fs/nilfs2/super.c         | 10 +++++++--
>>  fs/nilfs2/the_nilfs.c     | 54 ++++++++++++++++++++++++++++++++++++++++++++---
>>  include/linux/nilfs2_fs.h |  4 +++-
>>  5 files changed, 66 insertions(+), 8 deletions(-)
>>
>> -- 
>> 1.8.5.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
