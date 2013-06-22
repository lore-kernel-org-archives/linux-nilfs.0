From: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Subject: Re: cleaner optimization and online defragmentation: status update
Date: Sat, 22 Jun 2013 20:18:53 +0200
Message-ID: <51C5EA8D.7010500@student.tuwien.ac.at>
References: <51C0A731.9060509@student.tuwien.ac.at> <1371626223.2221.25.camel@slavad-ubuntu> <51C177A4.3030204@student.tuwien.ac.at> <2F76977A-589B-47EB-8818-382477099600@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2F76977A-589B-47EB-8818-382477099600-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

First of all thanks for looking into it.

On 2013-06-22 17:31, Vyacheslav Dubeyko wrote:
> What benchmarking tool do you plan to use? I think that it needs to use
> well-known and widely used tool. Otherwise, it is impossible to check
> your results independently and to trust of your results.

Of course. The ones you suggested are fine.

> Yes, I think that "Greedy" and "Cost/Benefit" policies can be used as GC
> policies for the case of NILFS2. But, currently, you don't suggest proper
> basis for such policies realization. As I understand, "Greedy" policy should
> select such segments that contain as lesser valid blocks as possible. Valid
> blocks means blocks that will be moved by GC. The "Cost/Benefit" policy
> should select segment which has required (calculated by formula range)
> correlation between valid and invalid blocks in segment.
> 
> You are using the su_nblocks field. As I understand, the su_nblocks keeps
> number of blocks in all partial segments that are located in full segment.
> So, from my point of view, this value hasn't relation with valid/invalid blocks
> correlation. It means that from the su_nblocks point of view segments are
> practically identical. Because, usually, allocation policy tries to fill segment
> by partial segments till a segment capacity. So, if to compare your implementation
> and "timestamp" GC policy then "timestamp" policy is better.

I know, I changed that in my kernel patch. su_nblocks now contains the
number of valid blocks. Every time something gets deleted I decrement
su_nblocks. But this could be problematic and I will probably change
that and add a new attribute like su_valid_nblocks or something.


> Moreover, current realization of segment allocation algorithm is efficient for the
> case of GC "timestamp" policy. But the efficiency of this allocation algorithm degrades
> significantly for the case of proper realization of "Greedy" and "Cost/Benefit" GC policies.

I don't think so. The segment allocation algorithm is just a linear
search starting from 0. But sooner or later the segments will wrap
around and the oldest segments are at the end of the list. "timestamp"
cannot help you here.

> First of all, I am thinking now and I will think that defragmentation should be
> a part of GC activity. Usually, from my point of view, users choose NILFS2
> because of using flash storage (SSD and so on). So, GC is a consequence of
> log-structured nature of NILFS2. But it needs to think about flash aging, anyway.
> Because activity of GC or other auxiliary subsystems should take into account
> NAND flash wear-leveling. If activity of auxiliary subsystems will be significant
> then NAND flash will fail soon without any clear reasons from an user's
> viewpoint.
>> You can easily test it with the tool filefrag, which shows you the
>> extents of a file. On my test system I have created a file with 100
>> extents and defragmented it down to 9. The nilfs-defrag tool also checks
>> if a file is already defragmented or partially defragmented and only
>> defragments the fragmented parts of a file. So it is better than a
>> simple "cp frag_file defrag_file" ;).
>>
> 
> I reckon that "cp" command will be better if copying is necessary operation.
> 
>>From my point of view, the utility is a bad way. Defragmentation should be a part
> of file system activity. Anyway, we have GC that is moving blocks. So, namely
> GC activity should be corrected with the purpose of defragmentation during
> blocks moving. When you make utility that to copy blocks then you increase
> GC activity because of necessity to clean segments are processed by
> defragmenting utility. User should have transparent defragmenting feature
> of file system without necessity to use any special utility. Moreover, if fragmentation
> is a reason of GC activity or nature of internal file system operations then such
> activity should be corrected by defragmentation logic.

I agree. I thought about doing more defragmentation in the GC, but it is
expensive to get all the extent information needed. This could result in
extra overhead. Anyway the defrag tool is just a proof of concept
implementation. I could easily implement it in the cleaner.

> 
> So, I have such remarks about defragmentation utility:
> 
> (1) The defragmentation utility receives as input a path to the file. So, it means that
> an user should detect and choose files that are needed in defragmentation. But if I have
> many files (100,000 - 1,000,000) then it will be really time-consuming and complex
> operation. A better way can be a daemon that scans state of files in background and
> to process defragmenting. But we have GC daemon yet. So, from the architectural point
> of view, namely GC is the proper place for defragmenting activity.

Yes it's just a first attempt. Since the tool is very efficient, and
defragments only when it's necessary you could write a shell script:

IFS=$'\n'
for f in $(find /); do
    nilfs-defrag "$f"
done


> (2) Some files can be rarely accessed and it doesn't make sense to defragment such files.
> But how an user can detect files that really needs in defragmenting by simple and fast
> way?

Yes but the user knows best, which files he wants defragmented. How
should the GC know which files need to be defragmented?

> (3) In your approach the defragmentation utility doubles GC activity in clearing of segments.
> Factually, the utility marks blocks as dirty and then segctor thread copies these blocks in
> new segments. So, as a result, GC should clear these source segments, anyway. But you
> can't predict moments of time when GC will work. As a result, nilfs_cleanerd can fragment
> another files from source segments during defragmenting of some big file. And, moreover,
> nilfs_cleanerd can fragment other parts of big file during defragmentation activity.

Maybe, but it is not as bad as you make it sound. Ultimately the segctor
separates GC inodes and normal file operations. It's not like the
fragmentation could get much worse. But it's probably true, that it
could not improve.

I also check the THE_NILFS_GC_RUNNING bit in the kernel code, so that
the defragmentation will fail if the cleaner is running.

> (4) Your approach is using as basis peculiarities of segctor's algorithms. I mean that segctor
> processes all dirty blocks of one dirty file and only after to begin processing of another one.
> But if algorithm of segctor will change then the defragmentation utility will fragment files
> instead of defragmenting. And fragmenting of files will take place in the case when several
> segctor threads will work simultaneously (currently, we have only one segctor thread but this
> situation can change potentially). Currently, segctor and nilfs_cleanerd can work
> simultaneously. It is not rarely case when users to force to work nilfs_cleanerd without any
> sleeping timeout. So, simultaneous working of segctor and nilfs_cleanerd will end in
> fragmentation.

Even if you had multiple segctors, I think it would be quite strange if
they shared dirty files. I think its not a peculiarity, but a reasonable
assumption, that the file system doesn't try extra hard to fragment your
files.

> (5) Factually, real defragmentation is done by segctor. It means that end of working of
> defragmentation utility doesn't mean the end of defragmentation. Because real point of
> start of defragmentation will be sync or umount operation. So, I can request defragmentation
> of file with 100 - 500 GB in size and, then, I can try to make umount operation immediately after
> defragmentation utility execution ending. How long will I wait the end of such umount? I think that
> a user will treat such long umount as file system bug because defragmentation utility ended
> execution before start of umount.

The tool is smart enough not to mark the whole file as dirty, but only
the parts that are fragmented. If you happen to have a machine with 500
GB of RAM that could happen, but as soon as one segment worth of blocks
accumulated the fs can start writing it out and I think it does. Its
practically the same as if you copied a 500 GB file. As soon as the
cache is full it starts writing it to disk. Nothing special about the
defrag tool here.

Thanks, that you took the time to look through my code :)

Best regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
