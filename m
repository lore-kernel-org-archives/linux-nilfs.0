From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/9] nilfs2: implementation of cost-benefit GC policy
Date: Tue, 10 Mar 2015 21:37:50 +0100
Message-ID: <54FF561E.7030409@gmx.net>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>	<20150225.091804.1850885506186316087.konishi.ryusuke@lab.ntt.co.jp> <20150310.142119.813265940569588216.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150310.142119.813265940569588216.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

Thanks for your thorough review.

On 2015-03-10 06:21, Ryusuke Konishi wrote:
> Hi Andreas,
>=20
> I looked through whole kernel patches and a part of util patches.
> Overall comments are as follows:
>=20
> [Algorithm]
> As for algorithm, it looks about OK except for the starvation
> countermeasure.  The stavation countermeasure looks adhoc/hacky, but
> it's good that it doesn't change kernel/userland interface; we may be
> able to replace it with better ways in a future or in a revised
> version of this patchset.
>=20
> (1) Drawback of the starvation countermeasure
>     The patch 9/9 looks to make the execution time of chcp operation
>     worse since it will scan through sufile to modify live block
>     counters.  How much does it prolong the execution time ?

I'll do some tests, but I haven't noticed any significant performance
drop. The GC basically does the same thing, every time it selects
segments to reclaim.

>     In a use case of nilfs, many snapshots are created and they are
>     automatically changed back to plain checkpoints because old
>     snapshots are thinned out over time.  The patch 9/9 may impact on
>     such usage.
>
> (2) Compatibility
>     What will happen in the following case:
>     1. Create a file system, use it with the new module, and
>        create snapshots.
>     2. Mount it with an old module, and release snapshot with "chcp c=
p"
>     3. Mount it with the new module, and cleanerd runs gc with
>        cost benefit or greedy policy.

Some segments could be subject to starvation. But it would probably onl=
y
affect a small number of segments and it could be fixed by "chcp ss
<CP>; chcp cp <CP>".

> (3) Durability against unexpected power failures (just a note)
>     The current patchset looks not to cause starvation issue even whe=
n
>     unexpected power failure occurs during or after executing "chcp
>     cp" because nilfs_ioctl_change_cpmode() do changes in a
>     transactional way with nilfs_transaction_begin/commit.
>     We should always think this kind of situtation to keep consistenc=
y.
>=20
> [Coding Style]
> (4) This patchset has several coding style issues. Please fix them an=
d
>     re-check with the latest checkpatch script (script/checkpatch.pl)=
=2E

I'll fix that. Sorry.

> patch 2:
> WARNING: Prefer kmalloc_array over kmalloc with multiply
> #85: FILE: fs/nilfs2/sufile.c:1192:
> +    mc->mc_mods =3D kmalloc(capacity * sizeof(struct nilfs_sufile_mo=
d),
>=20
> patch 5,6:
> WARNING: 'aquired' may be misspelled - perhaps 'acquired'?
> #60:=20
> the same semaphore has to be aquired. So if the DAT-Entry belongs to
>=20
> WARNING: 'aquired' may be misspelled - perhaps 'acquired'?
> #46:=20
> be aquired, which blocks the entire SUFILE and effectively turns
>=20
> WARNING: 'aquired' may be misspelled - perhaps 'acquired'?
> #53:=20
> afore mentioned lock only needs to be aquired, if the cache is full
>=20
> (5) sub_sizeof macro:
>     The same definition exists as offsetofend() in vfio.h,
>     and a patch to move it to stddef.h is now proposed.
>=20
>     Please use the same name, and redefine it only if it's not
>     defined:
>=20
> #ifndef offsetofend
> #define offsetofend(TYPE, MEMBER) \
>         (offsetof(TYPE, MEMBER) + sizeof(((TYPE *)0)->MEMBER))
> #endif

Ok I'll change that.

> [Implementation]
> (6) b_blocknr
>     Please do not use bh->b_blocknr to store disk block number.  This
>     field is used to keep virtual block number except for DAT files.
>     It is only replaced to an actual block number during calling
>     submit_bh().  Keep this policy.

As far as I can tell, this is only true for blocks of GC inodes and nod=
e
blocks. All other buffer_heads are always mapped to on disk blocks by
nilfs_get_block(). I only added the mapping in nilfs_segbuf_submit_bh()
to correctly set the value in b_blocknr to the new location.

>     In segment constructor context, you can calculate the disk block
>     number from the start disk address of the segment and the block
>     index (offset) in the segment.

If I understand you correctly, this approach would give me the on disk
location inside of the segment that is currently constructed. But I nee=
d
to know the previous on disk location of the buffer_head. I have to
decrement the counter for the previous segment.

> (7) sufile mod cache
>     Consider gathering the cache into nilfs_sufile_info struct and
>     stopping to pass it via argument of bmap/sufile/dat interface
>     functions.  It's hacky, and decreases readability of programs, an=
d
>     is bloating changes of this patchset over multiple function
>     blocks.

If I use a global structure, I have to protect it with a lock. Since
almost any operation has to modify the counters in the SUFILE, this
would serialize the whole file system.

>     The cache should be well designed. It's important to balance the
>     performance and locality/transparency of the feature.  For
>     instance, it can be implemented with radix-tree of objects in
>     which each object has a vector of 2^k cache entries.

I'll look into that.

>     I think the cache should be written back to the sufile buffers
>     only within segment construction context. At least, it should be
>     written back in the context in which a transaction lock is held.
>=20
>     In addition, introducing a new bmap lock dependency,
>     nilfs_sufile_lock_key, is undesireble. You should avoid it
>     by delaying the writeback of cache entries to sufile.

The cache could end up using a lot of memory. In the worst case one
entry per block.

> (8) Changes to the sufile must be finished before dirty buffer
>     collection of sufile.
>     All mark_buffer_dirty() calls to sufile must be finished
>     before or in NILFS_ST_SUFILE stage of nilfs_segctor_collect_block=
s().
>=20
>     (You can write fixed figures to sufile after the collection phase
>      of sufile by preparatory marking buffer dirty before the
>      colection phase.)
>
>     In the current patchset, sufile mod cache can be flushed in
>     nilfs_segctor_update_palyload_blocknr(), which comes after the
>     dirty buffer collection phase.

This is a hard problem. I have to count the blocks added in the
NILFS_ST_DAT stage. I don't know, which SUFILE blocks I have to mark in
advance. I'll have to think about this.

> (9) cpfile is also excluded in the dead block counting like sufile
>     cpfile is always changed and written back along with sufile and d=
at.
>     So, cpfile must be excluded from the dead block counting.
>     Otherwise, sufile change can trigger cpfile changes, and it in tu=
rn
>     triggers sufile.

I don't quite understand your example. How exactly can a sufile change
trigger a cpfile change and how can this turn into an infinite loop?

Thanks,
Andreas Rohner

>     This also helps to simplify nilfs_dat_commit_end() that the patch=
set
>     added two arguments for the dead block counting in the patchset.
>     I mean, "dead" argument and "count_blocks" argument can be unifie=
d by
>     changing meaning of the "dead" argument.
>=20
>=20
> I will add detail comments for patches tonight or another day.
>=20
> Regards,
> Ryusuke Konishi
>=20
> On Wed, 25 Feb 2015 09:18:04 +0900 (JST), Ryusuke Konishi wrote:
>> Hi Andreas,
>>
>> Thank you for posting this proposal!
>>
>> I would like to have time to review this series through, but please
>> wait for several days. (This week I'm quite busy until weekend)
>>
>> Thanks,
>> Ryusuke Konishi
>>
>> On Tue, 24 Feb 2015 20:01:35 +0100, Andreas Rohner wrote:
>>> Hi everyone!
>>>
>>> One of the biggest performance problems of NILFS is its
>>> inefficient Timestamp GC policy. This patch set introduces two new =
GC
>>> policies, namely Cost-Benefit and Greedy.
>>>
>>> The Cost-Benefit policy is nothing new. It has been around for a lo=
ng
>>> time with log-structured file systems [1]. But it relies on accurat=
e
>>> information, about the number of live blocks in a segment. NILFS
>>> currently does not provide the necessary information. So this patch=
 set
>>> extends the entries in the SUFILE to include a counter for the numb=
er of
>>> live blocks. This counter is decremented whenever a file is deleted=
 or
>>> overwritten.
>>>
>>> Except for some tricky parts, the counting of live blocks is quite
>>> trivial. The problem is snapshots. At any time, a checkpoint can be
>>> turned into a snapshot or vice versa. So blocks that are reclaimabl=
e at
>>> one point in time, are protected by a snapshot a moment later.
>>>
>>> This patch set does not try to track snapshots at all. Instead it u=
ses a
>>> heuristic approach to prevent the worst case scenario. The performa=
nce
>>> is still significantly better than timestamp for my benchmarks.
>>>
>>> The worst case scenario is, the following:
>>>
>>> 1. Segment 1 is written
>>> 2. Snapshot is created
>>> 3. GC tries to reclaim Segment 1, but all blocks are protected
>>>    by the Snapshot. The GC has to set the number of live blocks
>>>    to maximum to avoid reclaiming this Segment again in the near fu=
ture.
>>> 4. Snapshot is deleted
>>> 5. Segment 1 is reclaimable, but its counter is so high, that the G=
C
>>>    will never try to reclaim it again.
>>>
>>> To prevent this kind of starvation I use another field in the SUFIL=
E
>>> entry, to store the number of blocks that are protected by a snapsh=
ot.
>>> This value is just a heuristic and it is usually set to 0. Only if =
the
>>> GC reclaims a segment, it is written to the SUFILE entry. The GC ha=
s to
>>> check for snapshots anyway, so we get this information for free. By
>>> storing this information in the SUFILE we can avoid starvation in t=
he
>>> following way:
>>>
>>> 1. Segment 1 is written
>>> 2. Snapshot is created
>>> 3. GC tries to reclaim Segment 1, but all blocks are protected
>>>    by the Snapshot. The GC has to set the number of live blocks
>>>    to maximum to avoid reclaiming this Segment again in the near fu=
ture.
>>> 4. GC sets the number of snapshot blocks in Segment 1 in the SUFILE
>>>    entry
>>> 5. Snapshot is deleted
>>> 6. On Snapshot deletion we walk through every entry in the SUFILE a=
nd
>>>    reduce the number of live blocks to half, if the number of snaps=
hot
>>>    blocks is bigger than half of the maximum.
>>> 7. Segment 1 is reclaimable and the number of live blocks entry is =
at
>>>    half the maximum. The GC will try to reclaim this segment as soo=
n as
>>>    there are no other better choices.
>>>
>>> BENCHMARKS:
>>> -----------
>>>
>>> My benchmark is quite simple. It consists of a process, that replay=
s
>>> real NFS traces at a faster speed. It thereby creates relatively
>>> realistic patterns of file creation and deletions. At the same time
>>> multiple snapshots are created and deleted in parallel. I use a 100=
GB
>>> partition of a Samsung SSD:
>>>
>>> WITH SNAPSHOTS EVERY 5 MINUTES:
>>> -------------------------------------------------------------------=
-
>>>                 Execution time       Wear (Data written to disk)
>>> Timestamp:      100%                 100%
>>> Cost-Benefit:   80%                  43%
>>>
>>> NO SNAPSHOTS:
>>> -------------------------------------------------------------------=
--
>>>                 Execution time       Wear (Data written to disk)
>>> Timestamp:      100%                 100%
>>> Cost-Benefit:   70%                  45%
>>>
>>> I plan on adding more benchmark results soon.
>>>
>>> Best regards,
>>> Andreas Rohner
>>>
>>> [1] Mendel Rosenblum and John K. Ousterhout. The design and impleme=
nta-
>>>     tion of a log-structured file system. ACM Trans. Comput. Syst.,
>>>     10(1):26=E2=80=9352, February 1992.
>>>
>>> Andreas Rohner (9):
>>>   nilfs2: refactor nilfs_sufile_updatev()
>>>   nilfs2: add simple cache for modifications to SUFILE
>>>   nilfs2: extend SUFILE on-disk format to enable counting of live b=
locks
>>>   nilfs2: add function to modify su_nlive_blks
>>>   nilfs2: add simple tracking of block deletions and updates
>>>   nilfs2: use modification cache to improve performance
>>>   nilfs2: add additional flags for nilfs_vdesc
>>>   nilfs2: improve accuracy and correct for invalid GC values
>>>   nilfs2: prevent starvation of segments protected by snapshots
>>>
>>>  fs/nilfs2/bmap.c          |  84 +++++++-
>>>  fs/nilfs2/bmap.h          |  14 +-
>>>  fs/nilfs2/btree.c         |   4 +-
>>>  fs/nilfs2/cpfile.c        |   5 +
>>>  fs/nilfs2/dat.c           |  95 ++++++++-
>>>  fs/nilfs2/dat.h           |   8 +-
>>>  fs/nilfs2/direct.c        |   4 +-
>>>  fs/nilfs2/inode.c         |  24 ++-
>>>  fs/nilfs2/ioctl.c         |  27 ++-
>>>  fs/nilfs2/mdt.c           |   5 +-
>>>  fs/nilfs2/page.h          |   6 +-
>>>  fs/nilfs2/segbuf.c        |   6 +
>>>  fs/nilfs2/segbuf.h        |   3 +
>>>  fs/nilfs2/segment.c       | 155 +++++++++++++-
>>>  fs/nilfs2/segment.h       |   3 +
>>>  fs/nilfs2/sufile.c        | 533 ++++++++++++++++++++++++++++++++++=
+++++++++---
>>>  fs/nilfs2/sufile.h        |  97 +++++++--
>>>  fs/nilfs2/the_nilfs.c     |   4 +
>>>  fs/nilfs2/the_nilfs.h     |  23 ++
>>>  include/linux/nilfs2_fs.h | 122 ++++++++++-
>>>  20 files changed, 1126 insertions(+), 96 deletions(-)
>>>
>>> --=20
>>> 2.3.0
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-nil=
fs" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
