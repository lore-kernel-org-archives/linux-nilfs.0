From: Dmitry Smirnov <onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Subject: NILFS2 and data integrity
Date: Fri, 5 Apr 2013 15:45:16 +1100
Message-ID: <201304051545.16927.onlyjob@member.fsf.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:subject:date:user-agent:mime-version
         :content-type:content-transfer-encoding:message-id;
        bh=G0/5+rElM2n9toy5rSItMRaarlbbO6oPJPsIv0+VTNk=;
        b=0kyB0XUJ0rFYsIflY73KOp0SpjxhyyBedB+SnVxIEODLYOsaNqjyNH4LOowArWf4Di
         Jk9AmVh/U7T6YWUgohdC0SY1WQwvNk/FW7GqOg1irou3CJ0puQGDh7yj/uFqEol4ekwE
         mu7JOVhUrhuVk2JkTsY8A2VvdZ1aoUk71VzeBxyOcemSpn1toO7d4AcZagNizHC5G9Di
         utYZCfJamr+leCDEnnWIJr5C+SUgT8FuGR9bHcNMUo4nxhYl5ZkHvMLQVE6R5L/iTnsz
         Fa+6TRuQgZu6D8waJoCs0UY/QdXMukFUqyA7gL/3ssTltrj8430HgcLWGlWFWuN5LdUR
         dl1w==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Dear NILFS team,

Let me thank you sincerely for fantastic and very special file system.

Until now I've been using it successfully for years without any issues
except for minor inconvenience from slow `nilfs_cleanerd`.

I'd like to share the details of the incident when recently I experienced
data corruption on NILFS2 partition followed by unfortunate adding of
unreliable "SAMSUNG HD204UI" HDD to underlying "mdadm" array.

The notorious HDD [1][2] occasionally corrupts data on write
so later read returns wrong data. There is no way to avoid such corruption
in first place. Detection is also difficult because as you may know in Linux
there is no block-level integrity checking yet.
However NILFS2 suffers the most from that particular type of corruption because
`nilfs_cleanerd` moves unmodified data around and therefore amplifies the
damage.

First I noticed corruption on some archives that were OK some weeks ago and
didn't change since (according to last modification date). As time passed
more damage was found in files that didn't suppose to change.
Finally the root cause of corruption was identified and bad HDD was promptly
removed from array. That's when I thought that the issue was resolved but
few days later NILFS2 re-mounted itself as read-only and logged the following
to "/var/log/kern.log":

	Mar 24 11:38:14 deblabr kernel: [191771.927806] NILFS: bad btree node (blocknr=1919583732): level = 193, flags = 0x90, nchildren = 35672
	Mar 24 11:38:14 deblabr kernel: [191771.927812] NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken bmap (inode number=444589)
	Mar 24 11:38:14 deblabr kernel: [191771.927812] 
	Mar 24 11:38:14 deblabr kernel: [191772.126584] Remounting filesystem read-only
	Mar 24 11:38:15 deblabr kernel: [191772.174965] NILFS: bad btree node (blocknr=1919583732): level = 193, flags = 0x90, nchildren = 35672
	Mar 24 11:38:15 deblabr kernel: [191772.174972] NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken bmap (inode number=444589)
	Mar 24 11:38:15 deblabr kernel: [191772.174972] 
	Mar 24 11:38:15 deblabr kernel: [191772.175255] NILFS: bad btree node (blocknr=1919583732): level = 193, flags = 0x90, nchildren = 35672
	Mar 24 11:38:15 deblabr kernel: [191772.175258] NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken bmap (inode number=444589)

As far as I understand the issue, corruption in data is not detected until
one or more "btree" nodes got corrupted as well. I reproduced the problem
on isolated "bad" HDD.
In this case I first copied some data to NILFS2 partition and verified
its integrity. As I was adding more data `nilfs_cleanerd` activated
and as expected corrupted some of the data. Eventually it failed to continue:

	Mar 31 01:17:30 deblabr kernel: [759042.984783] NILFS: bad btree node (blocknr=938583): level = 192, flags = 0x73, nchildren = 49956
	Mar 31 01:17:30 deblabr kernel: [759042.984850] NILFS: GC failed during preparation: cannot read source blocks: err=-5

Also file system was re-mounted read-only:

	Mar 30 19:56:59 deblabr kernel: [739821.894963] NILFS: bad btree node (blocknr=1086570306): level = 239, flags = 0xe2, nchildren = 10392
	Mar 30 19:56:59 deblabr kernel: [739821.894969] NILFS error (device dm-0): nilfs_bmap_last_key: broken bmap (inode number=1225452)
	Mar 30 19:56:59 deblabr kernel: [739821.894969] 
	Mar 30 19:56:59 deblabr kernel: [739821.894971] Remounting filesystem read-only
	Mar 30 19:56:59 deblabr kernel: [739821.894973] NILFS warning (device dm-0): nilfs_truncate_bmap: failed to truncate bmap (ino=1225452, err=-5)

(please ignore time stamp as those logs were taken from two different
 attempts to reproduce).

With read-only NILFS2 and some corrupted btree nodes I know no other way
to recover than to restore all the data to freshly formatted partition
as the lack of `fsck` tool do not allow to repair damaged file system.

I think there are some lessons we can learn from this:

 * Data integrity is very important.

 * On unreliable media `nilfs_cleanerd` can amplify the damage from corruption
   similar to what may happen on other file systems during defragmentation.

 * To avoid the unnecessary damage it would be nice if `nilfs_cleanerd` could
   check data integrity on read and stop with corresponding message logged in
   case of corruption.

 * `fsck` could be helpful to repair corrupted btree nodes.

 * Btrfs have a strategic advantage over NILFS2 in regards to data integrity
   checking.

Having said that I'd like to note that in my experience NILFS2 *perfectly*
recovers from unclean shut down or unexpected reset. This problem happened
only because NILFS2 put too much trust to underlying media.

Thank you.

All the best,
 Dmitry

[1]: http://rctnotes.blogspot.com.au/2011/02/samsung-2-tb-hd204ui-firmware-bug.html
[2]: http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlocks

---

If any remedy is tested under controlled scientific conditions and
proved to be effective, it will cease to be alternative and will simply
become medicine. So-called alternative medicine either hasn't been
tested or it has failed its tests.
        -- Richard Dawkins, 2007
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
