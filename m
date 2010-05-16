From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [CFD] disk format fixing
Date: Mon, 17 May 2010 02:25:40 +0900 (JST)
Message-ID: <20100517.022540.171394303.ryusuke@osrg.net>
References: <87aash3rrm.wl%jir@sekiba.com>
	<87pr0v7vs8.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87pr0v7vs8.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 16 May 2010 23:42:31 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> I'd like to summarize the comments so far for disk fomat fix.
> Please correct it if it's wrong or missing something.
> 
> 
> I've started this thread to fix disk format of nilfs2 at the point
> everybody thinks it's ok, strip "experimental", encourage developing
> user land tools and different implementation like on NetBSD.
> 
> So far, we have been talking disk format from two aspects,
> spuer block and rest of disk.  That's simply because most of user land tools
> care only super block and rest of disk are much more controversial
> than super block.  I'd like to summarize from those aspects.
> 
> - Super block format
> 
> Super blocks are frequently updated hotspot of nilfs2.  This is not good
> for low-end flash device for wearing point of view.  To address this problem,
> suggested introducing new mount option that makes less updates super blocks.
> 
> At this point, super block format itself is unchanged, still oloder
> nilfs implementation can find correct latest log in case of unclean mount.
> 
> - Rest of disk
> 
> * directory indexing
> There is long term controversial discussion about directory indexing.
> One is on memory indexing, the other is on disk indexing.  We have not
> reached a resolution, but at least agreed "unchange for now".
> So, disk format point of view, it'll be fixed for nilfs2.
> However it is a subject to change for future nilfs2 or nilfs3 or so.
> ~~
> 
> There are more missing features that should be in a modern filesystem,
> like xattr or posix acls, check ToDo list in following url:
> http://www.nilfs.org/en/current_status.html
> 
> You may not have to know disk format but if you feel functions which 
> are not in nilfs2, but mandatory to support, please state so.
> Then we can start that the how those functions can be implmented in nilfs2
> from disk format point of view.  Otherwise, any functions that requires disk
> format change will be not supported in near future or forever "experimental".
> 
> thanks,
> 
> regards,
> -- 
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

I believe part of the features like xattr (posix ACL) or atime can be
implemented later without breaking disk format compatibility (for both
forward and backward compatibility).

This sort of extension should be allowed, I think, even after the
"experimental" flag is dropped.  So, it doesn't mean fully-freezing
the disk format.  Am I on the right track?

On the other hand, the change I proposed for minimizing frequency of
super block updates may impose performance penalty or restrictions on
older implementations.  Also, it may have impact on user land tools
and the boot loader.  So, I think this one should be addressed before
dropping the "experimental" flag.

I have an idea to decrease the number of blocks written to disk also
for osync writes.  This will require adding a flag on segment headers
and a new recovery method, so let me confirm the impact.  Or, I will
insert check code preliminarily to properly reject unclean status by a
newer implementation.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
