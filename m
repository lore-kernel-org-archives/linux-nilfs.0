From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sat, 18 Jan 2014 07:55:19 +0900 (JST)
Message-ID: <20140118.075519.43661574.konishi.ryusuke@lab.ntt.co.jp>
References: <1389787304.3913.28.camel@slavad-ubuntu>
	<20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
	<1389866912.2565.44.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389866912.2565.44.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

On Thu, 16 Jan 2014 14:08:32 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> On Thu, 2014-01-16 at 00:23 +0900, Ryusuke Konishi wrote:
> 
>> 
>> By the way, do you have any nice idea to stop periodical update of
>> superblocks?
>> 
> 
> Yes, I think too that such suggestion is valuable for NILFS2. But I
> suppose that the problem is more complex. I mean a situation with
> write-able snapshots. If we will have write-able snapshots then it means
> necessity to have independent version of some superblock's  fields
> (s_last_cno, s_last_pseg, s_last_seq, s_mtime, s_wtime, s_mnt_count,
> s_state, s_c_interval, s_feature_compat_ro, s_feature_incompat). For
> example, snapshot can be made before xafile creation on a volume and
> write-able snapshot should continue to live without possibility to xattr
> creation, and so on.

OK, please tell me what do you suppose about the writable snapshot.

Do you think we should keep multiple branches or concurrently
mountable namespaces on one device ?

I prefer to maintain only one super root block per partition even if
we support writable snapshots.  Otherwise, I think we should use
multiple partitions to simplify the design.

I mean keeping multiple branches in one super root block with a DAT
file and a sufile in such a case.  Maintaining multiple DAT files and
sufiles on one device seems too complex to me.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
