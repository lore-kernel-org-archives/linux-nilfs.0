From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: improve the performance of fdatasync()
Date: Tue, 23 Sep 2014 21:47:01 +0900 (JST)
Message-ID: <20140923.214701.237540042662663531.konishi.ryusuke@lab.ntt.co.jp>
References: <1411462018-5780-1-git-send-email-andreas.rohner@gmx.net>
	<20140923.195012.716508926019147354.konishi.ryusuke@lab.ntt.co.jp>
	<542164C1.7090504@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=rOhMoCaHu0Vknh6RA9HuhQi78HoZMX/4uFa6LGTBKTk=;
        b=TmiyQYvXJBQ/SbhdtVpO5nRSzcxXSTERLYzoLGxI6bRHklP9hU8BBPQcK724RH6CHQ
         um+pKdN5d9oB1w+k9a84ND7uIaQcENw7HPHRTp40mMIxwdCS4873hBLOdsGlqxzMbdly
         9fU42xd+OEI/aoyQVX/aWa/eHSQV273lpeVoK0QRBOm8Qeq6EW0QoW/ybGN+b81tFigp
         K+RbsqnXE/Xyxca15Tg7pdv22WKfS6GUkVe8hy8GcS5O3eZHi5Gr2thkDt7nMveX0BAo
         9nqN8r11I7Eb4GXDINx9XOaPRx/5cZN8kiZitcuvdDT8AXb7tjlWqQW9Px3IFkgEx1Lv
         fUoA==
In-Reply-To: <542164C1.7090504-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 23 Sep 2014 14:17:05 +0200, Andreas Rohner wrote:
> On 2014-09-23 12:50, Ryusuke Konishi wrote:
>> On Tue, 23 Sep 2014 10:46:58 +0200, Andreas Rohner wrote:
>>> Support for fdatasync() has been implemented in NILFS2 for a long time,
>>> but whenever the corresponding inode is dirty the implementation falls
>>> back to a full-flegded sync(). Since every write operation has to update
>>> the modification time of the file, the inode will almost always be dirty
>>> and fdatasync() will fall back to sync() most of the time. But this
>>> fallback is only necessary for a change of the file size and not for
>>> a change of the various timestamps.
>>>
>>> This patch adds a new flag NILFS_I_INODE_SYNC to differentiate between
>>> those two situations.
>>>
>>>  * If it is set the file size was changed and a full sync is necessary.
>>>  * If it is not set then only the timestamps were updated and
>>>    fdatasync() can go ahead.
>>>
>>> There is already a similar flag I_DIRTY_DATASYNC on the VFS layer with
>>> the exact same semantics. Unfortunately it cannot be used directly,
>>> because NILFS2 doesn't implement write_inode() and doesn't clear the VFS
>>> flags when inodes are written out. So the VFS writeback thread can
>>> clear I_DIRTY_DATASYNC at any time without notifying NILFS2. So
>>> I_DIRTY_DATASYNC has to be mapped onto NILFS_I_INODE_SYNC in
>>> nilfs_update_inode().
>>>
>>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> 
>> I now sent this to Andrew.
>> 
>> The datasync segments that this patch creates more frequently, will
>> cause rollforward recovery after a crash or a power failure.
>> 
>> So, please test also that the recovery works properly for fdatasync()
>> and reset.  The situation can be simulated, for example, by using
>> "reboot -nfh":
>> 
>>  # dd if=/dev/zero of=/nilfs/test bs=4k count=1 seek=9999
>>  # dd if=/dev/urandom of=/nilfs/test bs=8k count=1 seek=50 conv=fdatasync,notrunc,nocreat
>>  # reboot -nfh
>> 
>> We can use dumpseg command to confirm that the datasync segment is
>> actually made or how recovery has done after mount.
> 
> I tested it using your script, but I duplicated the second line twice
> with different values for seek and added a md5sum at the end. So in
> total 6 blocks were written with fdatasync().
> 
> The checksum before the reboot was: 66500bd6c7a1f89ed860cd7203f5c6e8
> 
> The last lines of the output of dumpseg after reboot:
> 
>   partial segment: blocknr = 26, nblocks = 3
>     creation time = 2014-09-23 12:02:56
>     nfinfo = 1
>     finfo
>       ino = 12, cno = 3, nblocks = 2, ndatblk = 2
>         vblocknr = 16385, blkoff = 100, blocknr = 27
>         vblocknr = 16386, blkoff = 101, blocknr = 28
>   partial segment: blocknr = 29, nblocks = 3
>     creation time = 2014-09-23 12:02:56
>     nfinfo = 1
>     finfo
>       ino = 12, cno = 3, nblocks = 2, ndatblk = 2
>         vblocknr = 16387, blkoff = 120, blocknr = 30
>         vblocknr = 16389, blkoff = 121, blocknr = 31
>   partial segment: blocknr = 32, nblocks = 3
>     creation time = 2014-09-23 12:02:56
>     nfinfo = 1
>     finfo
>       ino = 12, cno = 3, nblocks = 2, ndatblk = 2
>         vblocknr = 16390, blkoff = 140, blocknr = 33
>         vblocknr = 16391, blkoff = 141, blocknr = 34
> 
> The output of dmesg for the rollforward:
> 
> [  110.701337] NILFS warning: mounting unchecked fs
> [  110.833196] NILFS (device sdb): salvaged 6 blocks
> [  110.837311] segctord starting. Construction interval = 5 seconds, CP
> frequency < 30 seconds
> [  110.878959] NILFS: recovery complete.
> [  110.882674] segctord starting. Construction interval = 5 seconds, CP
> frequency < 30 seconds
> 
> The checksum after rollforward: 66500bd6c7a1f89ed860cd7203f5c6e8
> 
> Works like a charm :)

Thank you, it looks perfect so far.


By the way, if you are interested in improving this sort of bad
implemetation, please consider improving inode allocator that we can
see at nilfs_ifile_create_inode().

It always searches free inode from ino=0.  It doesn't use the
knowledge of the last allocated inode number (inumber) nor any
locality of close-knit inodes such as a file and the directory that
contains it.

A simple strategy is to start finding a free inode from (inumber of
the parent directory) + 1, but this may not work efficiently if the
namespace has multiple active directories, and requires that inumbers
of directories are suitably dispersed.  On the other hands, it
increases the number of disk read and also increases the number of
inode blocks to be written out if inodes are allocated too discretely.

The optimal strategy may differ from that of other file systems
because inode blocks are not allocated to static places in nilfs.  For
example, it may be better if we gather inodes of frequently accessed
directories into the first valid inode block (on ifile) for nilfs.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
