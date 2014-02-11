From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 1/1] nilfs2: add mount option that reduces super block
 writes
Date: Tue, 11 Feb 2014 15:07:48 +0100
Message-ID: <52FA2EB4.6030401@gmx.net>
References: <cover.1391359219.git.andreas.rohner@gmx.net>	<cover.1391359219.git.andreas.rohner@gmx.net>	<dd489a00bca481cea1cb69e755ed5db5b186a5e5.1391359219.git.andreas.rohner@gmx.net> <20140211.213138.107755196.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140211.213138.107755196.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On 2014-02-11 13:31, Ryusuke Konishi wrote:
> Hi Andreas,
> On Sun,  2 Feb 2014 17:50:09 +0100, Andreas Rohner wrote:
>> This patch introduces a mount option bad_ftl that disables the
>> periodic overwrites of the super block to make the file system better
>> suitable for bad flash memory with a bad FTL. The super block is only
>> written at umount time. So if there is a unclean shutdown the file
>> system needs to be recovered by a linear scan of all segment summary
>> blocks.
>>
>> The linear scan is only necessary if the file system wasn't umounted
>> properly. So the normal mount time is not affected.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> 
> 
> Do we really need to add the third crc in segument summary headers ?
> After all, we need to do a full check for a log with a super root
> block to validate it.

I need a way to quickly decide if a segment could be potentially valid
without reading in more blocks. The third crc is there, to make sure,
that the segment is not a valid segment of a previous instance of NILFS2
on the same volume. Such a previous instance would have used a different
crc seed. I only keep a limited number of history entries. This history
could be easily filled up with old segments from a previous instance and
the recovery would fail.

I tried to use the ss_sumsum crc for that purpose, but for that I have
to read in on average 5 to 8 extra blocks per segment. I cannot read
ahead these blocks, so the whole search is slowed down.

> This patch also seems to be using the nature that headers which have a
> NILFS_SS_SR flag sometimes appear at the head of segments.  But this
> is not guranteed.  Is this condition eliminable?

It uses that fact, but it does not rely on it. If there is a recent
segment with NILFS_SS_SR flag at the top it will use that and leave the
rest to the normal recovery function. But if none is found, it will scan
all partial segments for the NILFS_SS_SR flag. This is done in
nilfs_search_partial_log_cursor.

> The measurement results are very interesting (thanks for the effort),
> but they look to rely on a few these ellipsis techniques for reducing
> recovery time.

We could easily increase the security by increasing the
NILFS_SEG_HISTORY_DEPTH, without reducing the performance. The
performance is mainly determined by how fast the device can read in the
segment summary blocks.

It just scans all the segment summary blocks of all segments and keeps a
history of the most promising candidates for recovery. After that the
candidates are processed further, including a full crc check and search
for partial segments with the NILFS_SS_SR flag if necessary.

Best regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
