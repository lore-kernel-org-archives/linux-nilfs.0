From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS2 and data integrity
Date: Fri, 05 Apr 2013 10:16:09 +0400
Message-ID: <1365142569.2075.14.camel@slavad-ubuntu>
References: <201304051545.16927.onlyjob@member.fsf.org>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=DOGzN9ih9/K78BVtV75v+X37/l6OCDcIlOND1KkWjpM=;
	b=FyOm4ayXyin9U4MPNhRvP4qp7JJWSvHIGXKfxUZbdE1gPxJpVl5zBE81F9oe+HZTZKs01b+KrD8ziIrVGPvz1+md/Mh1tn/6bc0LFvWocWge77oj7BNmORPYM4g9HNp7;
In-Reply-To: <201304051545.16927.onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dmitry Smirnov <onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dmitry,

On Fri, 2013-04-05 at 15:45 +1100, Dmitry Smirnov wrote:
> Dear NILFS team,
> 
> Let me thank you sincerely for fantastic and very special file system.
> 
> Until now I've been using it successfully for years without any issues
> except for minor inconvenience from slow `nilfs_cleanerd`.
> 
> I'd like to share the details of the incident when recently I experienced
> data corruption on NILFS2 partition followed by unfortunate adding of
> unreliable "SAMSUNG HD204UI" HDD to underlying "mdadm" array.
> 
> The notorious HDD [1][2] occasionally corrupts data on write
> so later read returns wrong data. There is no way to avoid such corruption
> in first place. Detection is also difficult because as you may know in Linux
> there is no block-level integrity checking yet.
> However NILFS2 suffers the most from that particular type of corruption because
> `nilfs_cleanerd` moves unmodified data around and therefore amplifies the
> damage.
> 
> First I noticed corruption on some archives that were OK some weeks ago and
> didn't change since (according to last modification date). As time passed
> more damage was found in files that didn't suppose to change.
> Finally the root cause of corruption was identified and bad HDD was promptly
> removed from array. That's when I thought that the issue was resolved but
> few days later NILFS2 re-mounted itself as read-only and logged the following
> to "/var/log/kern.log":
> 
> 	Mar 24 11:38:14 deblabr kernel: [191771.927806] NILFS: bad btree node (blocknr=1919583732): level = 193, flags = 0x90, nchildren = 35672
> 	Mar 24 11:38:14 deblabr kernel: [191771.927812] NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken bmap (inode number=444589)
> 	Mar 24 11:38:14 deblabr kernel: [191771.927812] 
> 	Mar 24 11:38:14 deblabr kernel: [191772.126584] Remounting filesystem read-only
> 	Mar 24 11:38:15 deblabr kernel: [191772.174965] NILFS: bad btree node (blocknr=1919583732): level = 193, flags = 0x90, nchildren = 35672
> 	Mar 24 11:38:15 deblabr kernel: [191772.174972] NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken bmap (inode number=444589)
> 	Mar 24 11:38:15 deblabr kernel: [191772.174972] 
> 	Mar 24 11:38:15 deblabr kernel: [191772.175255] NILFS: bad btree node (blocknr=1919583732): level = 193, flags = 0x90, nchildren = 35672
> 	Mar 24 11:38:15 deblabr kernel: [191772.175258] NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken bmap (inode number=444589)
> 

First of all, I think that it needs to distinguish two issues in your
e-mail. The first one is the issue with Samsung HDD and the second is
the issue with "bad b-tree node".

Yes, I think that you are really right about necessity to check data
integrity during segctor and nilfs_cleanerd activity.

The issue with "bad b-tree node" is reported by many guys. But it is not
not easy to reproduce the issue for 4 KB block size on my side.
Currently, I can reproduce the issue on NILFS2 volume with 1 KB block
size. And I am deeply inside investigation of the issue in such
environment. But it is possible that such use-case can be a 1 KB block
size related. Currently, I doubt that we have one reason for "bad b-tree
node" issue.

> As far as I understand the issue, corruption in data is not detected until
> one or more "btree" nodes got corrupted as well. I reproduced the problem
> on isolated "bad" HDD.
> In this case I first copied some data to NILFS2 partition and verified
> its integrity. As I was adding more data `nilfs_cleanerd` activated
> and as expected corrupted some of the data. Eventually it failed to continue:
> 
> 	Mar 31 01:17:30 deblabr kernel: [759042.984783] NILFS: bad btree node (blocknr=938583): level = 192, flags = 0x73, nchildren = 49956
> 	Mar 31 01:17:30 deblabr kernel: [759042.984850] NILFS: GC failed during preparation: cannot read source blocks: err=-5
> 
> Also file system was re-mounted read-only:
> 
> 	Mar 30 19:56:59 deblabr kernel: [739821.894963] NILFS: bad btree node (blocknr=1086570306): level = 239, flags = 0xe2, nchildren = 10392
> 	Mar 30 19:56:59 deblabr kernel: [739821.894969] NILFS error (device dm-0): nilfs_bmap_last_key: broken bmap (inode number=1225452)
> 	Mar 30 19:56:59 deblabr kernel: [739821.894969] 
> 	Mar 30 19:56:59 deblabr kernel: [739821.894971] Remounting filesystem read-only
> 	Mar 30 19:56:59 deblabr kernel: [739821.894973] NILFS warning (device dm-0): nilfs_truncate_bmap: failed to truncate bmap (ino=1225452, err=-5)
> 
> (please ignore time stamp as those logs were taken from two different
>  attempts to reproduce).
> 
> With read-only NILFS2 and some corrupted btree nodes I know no other way
> to recover than to restore all the data to freshly formatted partition
> as the lack of `fsck` tool do not allow to repair damaged file system.
> 
> I think there are some lessons we can learn from this:
> 
>  * Data integrity is very important.
> 
>  * On unreliable media `nilfs_cleanerd` can amplify the damage from corruption
>    similar to what may happen on other file systems during defragmentation.
> 
>  * To avoid the unnecessary damage it would be nice if `nilfs_cleanerd` could
>    check data integrity on read and stop with corresponding message logged in
>    case of corruption.
> 

Thank you for your opinion. It is really important direction of NILFS2
driver improvement.

>  * `fsck` could be helpful to repair corrupted btree nodes.
> 

Yes, fsck is very important tool. I began implementation of fsck.nilfs2.
But, currently, I haven't enough time for further implementation.
Anyway, I am going to continue to implement this tool.

Thanks,
Vyacheslav Dubeyko.

>  * Btrfs have a strategic advantage over NILFS2 in regards to data integrity
>    checking.
> 
> Having said that I'd like to note that in my experience NILFS2 *perfectly*
> recovers from unclean shut down or unexpected reset. This problem happened
> only because NILFS2 put too much trust to underlying media.
> 
> Thank you.
> 
> All the best,
>  Dmitry
> 
> [1]: http://rctnotes.blogspot.com.au/2011/02/samsung-2-tb-hd204ui-firmware-bug.html
> [2]: http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlocks
> 
> ---
> 
> If any remedy is tested under controlled scientific conditions and
> proved to be effective, it will cease to be alternative and will simply
> become medicine. So-called alternative medicine either hasn't been
> tested or it has failed its tests.
>         -- Richard Dawkins, 2007
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
