From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: improve the performance of fdatasync()
Date: Tue, 23 Sep 2014 13:11:19 +0200
Message-ID: <54215557.2010505@gmx.net>
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

Very nice script to test this!

> We can use dumpseg command to confirm that the datasync segment is
> actually made or how recovery has done after mount.

I already tested this before I sent in my patch. I used a virtual
machine and just killed the process after the fdatasync(). After the
rollforward NILFS reports the correct number of blocks salvaged and the
md5sum of the file is correct.

I will test it again with dumpseg the way you suggested.

br,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
