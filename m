From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/9] nilfs2: implementation of cost-benefit GC policy
Date: Sat, 14 Mar 2015 13:24:25 +0100
Message-ID: <55042879.90701@gmx.net>
References: <20150225.091804.1850885506186316087.konishi.ryusuke@lab.ntt.co.jp>	<20150310.142119.813265940569588216.konishi.ryusuke@lab.ntt.co.jp>	<54FF561E.7030409@gmx.net> <20150312.215431.324210374799651841.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150312.215431.324210374799651841.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

Thank you very much for your detailed review and feedback. I agree with
all of your points and I will start working on a rewrite immediately.

On 2015-03-12 13:54, Ryusuke Konishi wrote:
> Hi Andreas,
>=20
> On Tue, 10 Mar 2015 21:37:50 +0100, Andreas Rohner wrote:
>> Hi Ryusuke,
>>
>> Thanks for your thorough review.
>>
>> On 2015-03-10 06:21, Ryusuke Konishi wrote:
>>> Hi Andreas,
>>>
>>> I looked through whole kernel patches and a part of util patches.
>>> Overall comments are as follows:
>>>
>>> [Algorithm]
>>> As for algorithm, it looks about OK except for the starvation
>>> countermeasure.  The stavation countermeasure looks adhoc/hacky, bu=
t
>>> it's good that it doesn't change kernel/userland interface; we may =
be
>>> able to replace it with better ways in a future or in a revised
>>> version of this patchset.
>>>
>>> (1) Drawback of the starvation countermeasure
>>>     The patch 9/9 looks to make the execution time of chcp operatio=
n
>>>     worse since it will scan through sufile to modify live block
>>>     counters.  How much does it prolong the execution time ?
>>
>> I'll do some tests, but I haven't noticed any significant performanc=
e
>> drop. The GC basically does the same thing, every time it selects
>> segments to reclaim.
>=20
> GC is performed in background by an independent process.  What I'm
> care about it that NILFS_IOCTL_CHANGE_CPMODE ioctl is called from
> command line interface or application.  They differ in this meaning.
>=20
> Was a worse case senario considered in the test ?
>=20
> For example:
> 1. Fill a TB class drive with data file(s), and make a snapshot on it=
=2E
> 2. Run one pass GC to update snapshot block counts.
> 3. And do "chcp cp"
>=20
> If we don't observe noticeable delay on this class of drive, then I
> think we can put the problem off.

Yesterday I did a worst case test as you suggested. I used an old 1 TB
hard drive I had lying around. This was my setup:

1. Write a 850GB file
2. Create a snapshot
3. Delete the file
4. Let GC run through all segments
5. Verify with lssu that the GC has updated all SUFILE entries
6. Drop the page cache
7. chcp cp

The following results are with the page cache dropped immediately befor=
e
each call:

1. chcp ss
real	0m1.337s
user	0m0.017s
sys	0m0.030s

2. chcp cp
real	0m6.377s
user	0m0.023s
sys	0m0.053s

The following results are without the drop of the page cache:

1. chcp ss
real	0m0.137s
user	0m0.010s
sys	0m0.000s

2. chcp cp
real	0m0.016s
user	0m0.010s
sys	0m0.007s

There are 119233 segments in my test. Each SUFILE entry uses 32 bytes.
So the worst case for 1 TB with 8 MB segments would be 3.57 MB of rando=
m
reads and one 3.57 MB continuous write. You only get 6.377s because my
hard drive is so slow. You wouldn't notice any difference on a modern
SSD. Furthermore the SUFILE is also scanned by the segment allocation
algorithm and the GC, so it is very likely already in the page cache.

>>>     In a use case of nilfs, many snapshots are created and they are
>>>     automatically changed back to plain checkpoints because old
>>>     snapshots are thinned out over time.  The patch 9/9 may impact =
on
>>>     such usage.
>>>
>>> (2) Compatibility
>>>     What will happen in the following case:
>>>     1. Create a file system, use it with the new module, and
>>>        create snapshots.
>>>     2. Mount it with an old module, and release snapshot with "chcp=
 cp"
>>>     3. Mount it with the new module, and cleanerd runs gc with
>>>        cost benefit or greedy policy.
>>
>> Some segments could be subject to starvation. But it would probably =
only
>> affect a small number of segments and it could be fixed by "chcp ss
>> <CP>; chcp cp <CP>".
>=20
> Ok, let's treat this as a restriction for now.
> If you come up with any good idea, please propose.
>=20
>>> (3) Durability against unexpected power failures (just a note)
>>>     The current patchset looks not to cause starvation issue even w=
hen
>>>     unexpected power failure occurs during or after executing "chcp
>>>     cp" because nilfs_ioctl_change_cpmode() do changes in a
>>>     transactional way with nilfs_transaction_begin/commit.
>>>     We should always think this kind of situtation to keep consiste=
ncy.
>>>
>>> [Coding Style]
>>> (4) This patchset has several coding style issues. Please fix them =
and
>>>     re-check with the latest checkpatch script (script/checkpatch.p=
l).
>>
>> I'll fix that. Sorry.
>>
>>> patch 2:
>>> WARNING: Prefer kmalloc_array over kmalloc with multiply
>>> #85: FILE: fs/nilfs2/sufile.c:1192:
>>> +    mc->mc_mods =3D kmalloc(capacity * sizeof(struct nilfs_sufile_=
mod),
>>>
>>> patch 5,6:
>>> WARNING: 'aquired' may be misspelled - perhaps 'acquired'?
>>> #60:=20
>>> the same semaphore has to be aquired. So if the DAT-Entry belongs t=
o
>>>
>>> WARNING: 'aquired' may be misspelled - perhaps 'acquired'?
>>> #46:=20
>>> be aquired, which blocks the entire SUFILE and effectively turns
>>>
>>> WARNING: 'aquired' may be misspelled - perhaps 'acquired'?
>>> #53:=20
>>> afore mentioned lock only needs to be aquired, if the cache is full
>>>
>>> (5) sub_sizeof macro:
>>>     The same definition exists as offsetofend() in vfio.h,
>>>     and a patch to move it to stddef.h is now proposed.
>>>
>>>     Please use the same name, and redefine it only if it's not
>>>     defined:
>>>
>>> #ifndef offsetofend
>>> #define offsetofend(TYPE, MEMBER) \
>>>         (offsetof(TYPE, MEMBER) + sizeof(((TYPE *)0)->MEMBER))
>>> #endif
>>
>> Ok I'll change that.
>>
>>> [Implementation]
>>> (6) b_blocknr
>>>     Please do not use bh->b_blocknr to store disk block number.  Th=
is
>>>     field is used to keep virtual block number except for DAT files=
=2E
>>>     It is only replaced to an actual block number during calling
>>>     submit_bh().  Keep this policy.
>>
>> As far as I can tell, this is only true for blocks of GC inodes and =
node
>> blocks. All other buffer_heads are always mapped to on disk blocks b=
y
>> nilfs_get_block(). I only added the mapping in nilfs_segbuf_submit_b=
h()
>> to correctly set the value in b_blocknr to the new location.
>>
>=20
> nilfs_get_block() is only used for regular files, directories, and so
> on.  Blocks on metadata files are mapped through
> nilfs_mdt_submit_block().  Anyway, yes, they stores actual disk block
> number in b_blocknr in the current implementation.  But, it is just a
> cutting corner of the current implementation, which comes from the
> reason that we have to set actual disk block numbers when reading
> blocks with vfs/mm functions.
>=20
> Anyway I don't like you touch nilfs_get_block() and
> nilfs_segbuf_submit_bh() in a part of the big patch.  At least, it
> should be a separate patch.  I prefer you take alternative approach
> which does the same thing without b_blocknr.  I would like to help to
> implement the latter approach if you need to know disk block number i=
n
> the patchset.

I agree not using b_blocknr would be preferable.

>>>     In segment constructor context, you can calculate the disk bloc=
k
>>>     number from the start disk address of the segment and the block
>>>     index (offset) in the segment.
>>
>> If I understand you correctly, this approach would give me the on di=
sk
>> location inside of the segment that is currently constructed. But I =
need
>> to know the previous on disk location of the buffer_head. I have to
>> decrement the counter for the previous segment.
>=20
> What does the previous on disk location mean ?
> And, why do you need to know the previous on disk location?
>=20
> If it means reclaiming segment, you don't need to decrement its
> counter because it will be freed.
>=20
> If it means the original block to be overwritten,
> nilfs_dat_commit_end() is called for the block through
> nilfs_bmap_propagate().

Yes I mean the original block to be overwritten.

> If it means the original block of DAT file, it's OK to refer to
> b_blocknr because DAT blocks never store virtual block number by
> design.  I think it should be done in nilfs_btree_propagate_p() and
> nilfs_direct_propagate(), in which no special "end of life" processin=
g
> is done against DAT blocks at present.

I had problems with nilfs_btree_propagate_p(), because of the retry loo=
p
in nilfs_segctor_collect(). In rare cases it will redo the collection,
which messes up the count.

But I think there is a way around that. We would have to flush the
counting cache before entering into the loop in nilfs_segctor_collect()=
=2E
At the start of every iteration of the loop we clear the cache.

>>> (7) sufile mod cache
>>>     Consider gathering the cache into nilfs_sufile_info struct and
>>>     stopping to pass it via argument of bmap/sufile/dat interface
>>>     functions.  It's hacky, and decreases readability of programs, =
and
>>>     is bloating changes of this patchset over multiple function
>>>     blocks.
>>
>> If I use a global structure, I have to protect it with a lock. Since
>> almost any operation has to modify the counters in the SUFILE, this
>> would serialize the whole file system.
>>
>=20
> The lock acquisition will be needed if you write back to buffers on
> SUFILE.  That is the reason why I say you should aggregate the
> writeback to sufile into the segment constructor context.
>=20
> You don't have to suppose a global lock.  You can use bgl_lock, for
> example, if the lock contention really matters.

I agree.

>>>     The cache should be well designed. It's important to balance th=
e
>>>     performance and locality/transparency of the feature.  For
>>>     instance, it can be implemented with radix-tree of objects in
>>>     which each object has a vector of 2^k cache entries.
>>
>> I'll look into that.
>>
>>>     I think the cache should be written back to the sufile buffers
>>>     only within segment construction context. At least, it should b=
e
>>>     written back in the context in which a transaction lock is held=
=2E
>>>
>>>     In addition, introducing a new bmap lock dependency,
>>>     nilfs_sufile_lock_key, is undesireble. You should avoid it
>>>     by delaying the writeback of cache entries to sufile.
>>
>> The cache could end up using a lot of memory. In the worst case one
>> entry per block.
>=20
> Why do you think it matters?  When you modify block counter of
> segments, all the modified SUFILE blocks become dirty and pinned to
> memory.  The cache can be designed better at least than the dirty
> SUFILE buffers.

I never thought about it in that way, but you are absolutely right. The
cache would use less memory, than the dirty SUFILE blocks.

Regards,
Andreas Rohner

> If you care about the need of "shrinker".  We can take other
> techniques such as queuing changes and reflect them to sufile in
> bundle by using workqueue.  Anyway it's a matter of design or
> implementation technique.
>=20
>>> (8) Changes to the sufile must be finished before dirty buffer
>>>     collection of sufile.
>>>     All mark_buffer_dirty() calls to sufile must be finished
>>>     before or in NILFS_ST_SUFILE stage of nilfs_segctor_collect_blo=
cks().
>>>
>>>     (You can write fixed figures to sufile after the collection pha=
se
>>>      of sufile by preparatory marking buffer dirty before the
>>>      colection phase.)
>>>
>>>     In the current patchset, sufile mod cache can be flushed in
>>>     nilfs_segctor_update_palyload_blocknr(), which comes after the
>>>     dirty buffer collection phase.
>>
>> This is a hard problem. I have to count the blocks added in the
>> NILFS_ST_DAT stage. I don't know, which SUFILE blocks I have to mark=
 in
>> advance. I'll have to think about this.
>>
>>> (9) cpfile is also excluded in the dead block counting like sufile
>>>     cpfile is always changed and written back along with sufile and=
 dat.
>>>     So, cpfile must be excluded from the dead block counting.
>>>     Otherwise, sufile change can trigger cpfile changes, and it in =
turn
>>>     triggers sufile.
>>
>> I don't quite understand your example. How exactly can a sufile chan=
ge
>> trigger a cpfile change and how can this turn into an infinite loop?
>>
>=20
> Sorry, it's my misunderstanding.  Since dirty blocks of cpfile is
> collected before sufile, it is possible to avoid the loop by finishin=
g
> all dead block counting on cpfile and flushing it to sufile before or
> in NILFS_ST_SUFILE stage of nilfs_segctor_collect_blocks().
>=20
> Regards,
> Ryusuke Konishi
>=20
>> Thanks,
>> Andreas Rohner
>>
>>>     This also helps to simplify nilfs_dat_commit_end() that the pat=
chset
>>>     added two arguments for the dead block counting in the patchset=
=2E
>>>     I mean, "dead" argument and "count_blocks" argument can be unif=
ied by
>>>     changing meaning of the "dead" argument.
>>>
>>>
>>> I will add detail comments for patches tonight or another day.
>>>
>>> Regards,
>>> Ryusuke Konishi
>>>
>>> On Wed, 25 Feb 2015 09:18:04 +0900 (JST), Ryusuke Konishi wrote:
>>>> Hi Andreas,
>>>>
>>>> Thank you for posting this proposal!
>>>>
>>>> I would like to have time to review this series through, but pleas=
e
>>>> wait for several days. (This week I'm quite busy until weekend)
>>>>
>>>> Thanks,
>>>> Ryusuke Konishi
>>>>
>>>> On Tue, 24 Feb 2015 20:01:35 +0100, Andreas Rohner wrote:
>>>>> Hi everyone!
>>>>>
>>>>> One of the biggest performance problems of NILFS is its
>>>>> inefficient Timestamp GC policy. This patch set introduces two ne=
w GC
>>>>> policies, namely Cost-Benefit and Greedy.
>>>>>
>>>>> The Cost-Benefit policy is nothing new. It has been around for a =
long
>>>>> time with log-structured file systems [1]. But it relies on accur=
ate
>>>>> information, about the number of live blocks in a segment. NILFS
>>>>> currently does not provide the necessary information. So this pat=
ch set
>>>>> extends the entries in the SUFILE to include a counter for the nu=
mber of
>>>>> live blocks. This counter is decremented whenever a file is delet=
ed or
>>>>> overwritten.
>>>>>
>>>>> Except for some tricky parts, the counting of live blocks is quit=
e
>>>>> trivial. The problem is snapshots. At any time, a checkpoint can =
be
>>>>> turned into a snapshot or vice versa. So blocks that are reclaima=
ble at
>>>>> one point in time, are protected by a snapshot a moment later.
>>>>>
>>>>> This patch set does not try to track snapshots at all. Instead it=
 uses a
>>>>> heuristic approach to prevent the worst case scenario. The perfor=
mance
>>>>> is still significantly better than timestamp for my benchmarks.
>>>>>
>>>>> The worst case scenario is, the following:
>>>>>
>>>>> 1. Segment 1 is written
>>>>> 2. Snapshot is created
>>>>> 3. GC tries to reclaim Segment 1, but all blocks are protected
>>>>>    by the Snapshot. The GC has to set the number of live blocks
>>>>>    to maximum to avoid reclaiming this Segment again in the near =
future.
>>>>> 4. Snapshot is deleted
>>>>> 5. Segment 1 is reclaimable, but its counter is so high, that the=
 GC
>>>>>    will never try to reclaim it again.
>>>>>
>>>>> To prevent this kind of starvation I use another field in the SUF=
ILE
>>>>> entry, to store the number of blocks that are protected by a snap=
shot.
>>>>> This value is just a heuristic and it is usually set to 0. Only i=
f the
>>>>> GC reclaims a segment, it is written to the SUFILE entry. The GC =
has to
>>>>> check for snapshots anyway, so we get this information for free. =
By
>>>>> storing this information in the SUFILE we can avoid starvation in=
 the
>>>>> following way:
>>>>>
>>>>> 1. Segment 1 is written
>>>>> 2. Snapshot is created
>>>>> 3. GC tries to reclaim Segment 1, but all blocks are protected
>>>>>    by the Snapshot. The GC has to set the number of live blocks
>>>>>    to maximum to avoid reclaiming this Segment again in the near =
future.
>>>>> 4. GC sets the number of snapshot blocks in Segment 1 in the SUFI=
LE
>>>>>    entry
>>>>> 5. Snapshot is deleted
>>>>> 6. On Snapshot deletion we walk through every entry in the SUFILE=
 and
>>>>>    reduce the number of live blocks to half, if the number of sna=
pshot
>>>>>    blocks is bigger than half of the maximum.
>>>>> 7. Segment 1 is reclaimable and the number of live blocks entry i=
s at
>>>>>    half the maximum. The GC will try to reclaim this segment as s=
oon as
>>>>>    there are no other better choices.
>>>>>
>>>>> BENCHMARKS:
>>>>> -----------
>>>>>
>>>>> My benchmark is quite simple. It consists of a process, that repl=
ays
>>>>> real NFS traces at a faster speed. It thereby creates relatively
>>>>> realistic patterns of file creation and deletions. At the same ti=
me
>>>>> multiple snapshots are created and deleted in parallel. I use a 1=
00GB
>>>>> partition of a Samsung SSD:
>>>>>
>>>>> WITH SNAPSHOTS EVERY 5 MINUTES:
>>>>> -----------------------------------------------------------------=
---
>>>>>                 Execution time       Wear (Data written to disk)
>>>>> Timestamp:      100%                 100%
>>>>> Cost-Benefit:   80%                  43%
>>>>>
>>>>> NO SNAPSHOTS:
>>>>> -----------------------------------------------------------------=
----
>>>>>                 Execution time       Wear (Data written to disk)
>>>>> Timestamp:      100%                 100%
>>>>> Cost-Benefit:   70%                  45%
>>>>>
>>>>> I plan on adding more benchmark results soon.
>>>>>
>>>>> Best regards,
>>>>> Andreas Rohner
>>>>>
>>>>> [1] Mendel Rosenblum and John K. Ousterhout. The design and imple=
menta-
>>>>>     tion of a log-structured file system. ACM Trans. Comput. Syst=
=2E,
>>>>>     10(1):26=E2=80=9352, February 1992.
>>>>>
>>>>> Andreas Rohner (9):
>>>>>   nilfs2: refactor nilfs_sufile_updatev()
>>>>>   nilfs2: add simple cache for modifications to SUFILE
>>>>>   nilfs2: extend SUFILE on-disk format to enable counting of live=
 blocks
>>>>>   nilfs2: add function to modify su_nlive_blks
>>>>>   nilfs2: add simple tracking of block deletions and updates
>>>>>   nilfs2: use modification cache to improve performance
>>>>>   nilfs2: add additional flags for nilfs_vdesc
>>>>>   nilfs2: improve accuracy and correct for invalid GC values
>>>>>   nilfs2: prevent starvation of segments protected by snapshots
>>>>>
>>>>>  fs/nilfs2/bmap.c          |  84 +++++++-
>>>>>  fs/nilfs2/bmap.h          |  14 +-
>>>>>  fs/nilfs2/btree.c         |   4 +-
>>>>>  fs/nilfs2/cpfile.c        |   5 +
>>>>>  fs/nilfs2/dat.c           |  95 ++++++++-
>>>>>  fs/nilfs2/dat.h           |   8 +-
>>>>>  fs/nilfs2/direct.c        |   4 +-
>>>>>  fs/nilfs2/inode.c         |  24 ++-
>>>>>  fs/nilfs2/ioctl.c         |  27 ++-
>>>>>  fs/nilfs2/mdt.c           |   5 +-
>>>>>  fs/nilfs2/page.h          |   6 +-
>>>>>  fs/nilfs2/segbuf.c        |   6 +
>>>>>  fs/nilfs2/segbuf.h        |   3 +
>>>>>  fs/nilfs2/segment.c       | 155 +++++++++++++-
>>>>>  fs/nilfs2/segment.h       |   3 +
>>>>>  fs/nilfs2/sufile.c        | 533 ++++++++++++++++++++++++++++++++=
+++++++++++---
>>>>>  fs/nilfs2/sufile.h        |  97 +++++++--
>>>>>  fs/nilfs2/the_nilfs.c     |   4 +
>>>>>  fs/nilfs2/the_nilfs.h     |  23 ++
>>>>>  include/linux/nilfs2_fs.h | 122 ++++++++++-
>>>>>  20 files changed, 1126 insertions(+), 96 deletions(-)
>>>>>
>>>>> --=20
>>>>> 2.3.0
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-n=
ilfs" in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
