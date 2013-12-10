From: Michael Conrad <mconrad@intellitree.com>
Subject: Re: [PATCH] nilfs2: rework error message subsystem
Date: Tue, 10 Dec 2013 12:14:00 -0500
Message-ID: <52A74BD8.4030508@intellitree.com>
References: <1385993333.3945.3.camel@slavad-ubuntu>	 <20131203162944.8f9ef3a08a3292a1959dd025@linux-foundation.org> <1386138787.4014.17.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1386138787.4014.17.camel@slavad-ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>

On 12/4/2013 1:33 AM, Vyacheslav Dubeyko wrote:
> On Tue, 2013-12-03 at 16:29 -0800, Andrew Morton wrote:
>
> [snip]
>> It converts every printk in nilfs2 into pr_foo_ratelimited (and bloats
>> nilfs2.ko by 5k in the process).  Isn't this rather overkill?
>>
> I have converted not every printk() in nilfs2 but I agree that printk()
> was changed in many places by ratelimited version. So, yes, it can be
> not very good idea. But such replacement was made for code that can emit
> really many count of practically identical error messages. And there are
> situation of sophisticated issues in nilfs2 when huge amount of error
> messages simply hide an important information about the issue. As a
> result, my goal was to reduce amount of repeatable error messages.
>
> So, what could you recommend as possible and proper solution?

I think this will help.  However, the idea I had in mind originally was 
for nilfs to "give up" sooner.

I suspect that my nilfs partition became corrupt for hardware or 
hardware-driver reasons.  So lets ignore that part for now.

With the data on the drive being corrupt, it appeared that nilfs 
encountered an invalid directory (possibly just a long string of NUL 
bytes?) and emitted more than a million errors about invalid structures, 
triggering the soft-lockup watchdog and rebooting the system.  When I 
recompiled my kernel with soft-lockup set to 5 minutes, it simply filled 
my log files.

[10796.519283] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143304192, 
inode=0, rec_len=0, name_len=0

I haven't read the code involved, but what I think should happen is that 
on the very *first* error, it should return an I/O error to userland.  
Also, the partition was set to "errors=remount-ro", so the very first 
error should also make the filesystem read-only, correct?

-Mike
