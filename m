From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: improve the performance of fdatasync()
Date: Tue, 23 Sep 2014 14:17:05 +0200
Message-ID: <542164C1.7090504@gmx.net>
References: <1411462018-5780-1-git-send-email-andreas.rohner@gmx.net> <20140923.195012.716508926019147354.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140923.195012.716508926019147354.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-09-23 12:50, Ryusuke Konishi wrote:
> On Tue, 23 Sep 2014 10:46:58 +0200, Andreas Rohner wrote:
>> Support for fdatasync() has been implemented in NILFS2 for a long time,
>> but whenever the corresponding inode is dirty the implementation falls
>> back to a full-flegded sync(). Since every write operation has to update
>> the modification time of the file, the inode will almost always be dirty
>> and fdatasync() will fall back to sync() most of the time. But this
>> fallback is only necessary for a change of the file size and not for
>> a change of the various timestamps.
>>
>> This patch adds a new flag NILFS_I_INODE_SYNC to differentiate between
>> those two situations.
>>
>>  * If it is set the file size was changed and a full sync is necessary.
>>  * If it is not set then only the timestamps were updated and
>>    fdatasync() can go ahead.
>>
>> There is already a similar flag I_DIRTY_DATASYNC on the VFS layer with
>> the exact same semantics. Unfortunately it cannot be used directly,
>> because NILFS2 doesn't implement write_inode() and doesn't clear the VFS
>> flags when inodes are written out. So the VFS writeback thread can
>> clear I_DIRTY_DATASYNC at any time without notifying NILFS2. So
>> I_DIRTY_DATASYNC has to be mapped onto NILFS_I_INODE_SYNC in
>> nilfs_update_inode().
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> 
> I now sent this to Andrew.
> 
> The datasync segments that this patch creates more frequently, will
> cause rollforward recovery after a crash or a power failure.
> 
> So, please test also that the recovery works properly for fdatasync()
> and reset.  The situation can be simulated, for example, by using
> "reboot -nfh":
> 
>  # dd if=/dev/zero of=/nilfs/test bs=4k count=1 seek=9999
>  # dd if=/dev/urandom of=/nilfs/test bs=8k count=1 seek=50 conv=fdatasync,notrunc,nocreat
>  # reboot -nfh
> 
> We can use dumpseg command to confirm that the datasync segment is
> actually made or how recovery has done after mount.

I tested it using your script, but I duplicated the second line twice
with different values for seek and added a md5sum at the end. So in
total 6 blocks were written with fdatasync().

The checksum before the reboot was: 66500bd6c7a1f89ed860cd7203f5c6e8

The last lines of the output of dumpseg after reboot:

  partial segment: blocknr = 26, nblocks = 3
    creation time = 2014-09-23 12:02:56
    nfinfo = 1
    finfo
      ino = 12, cno = 3, nblocks = 2, ndatblk = 2
        vblocknr = 16385, blkoff = 100, blocknr = 27
        vblocknr = 16386, blkoff = 101, blocknr = 28
  partial segment: blocknr = 29, nblocks = 3
    creation time = 2014-09-23 12:02:56
    nfinfo = 1
    finfo
      ino = 12, cno = 3, nblocks = 2, ndatblk = 2
        vblocknr = 16387, blkoff = 120, blocknr = 30
        vblocknr = 16389, blkoff = 121, blocknr = 31
  partial segment: blocknr = 32, nblocks = 3
    creation time = 2014-09-23 12:02:56
    nfinfo = 1
    finfo
      ino = 12, cno = 3, nblocks = 2, ndatblk = 2
        vblocknr = 16390, blkoff = 140, blocknr = 33
        vblocknr = 16391, blkoff = 141, blocknr = 34

The output of dmesg for the rollforward:

[  110.701337] NILFS warning: mounting unchecked fs
[  110.833196] NILFS (device sdb): salvaged 6 blocks
[  110.837311] segctord starting. Construction interval = 5 seconds, CP
frequency < 30 seconds
[  110.878959] NILFS: recovery complete.
[  110.882674] segctord starting. Construction interval = 5 seconds, CP
frequency < 30 seconds

The checksum after rollforward: 66500bd6c7a1f89ed860cd7203f5c6e8

Works like a charm :)

br,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
