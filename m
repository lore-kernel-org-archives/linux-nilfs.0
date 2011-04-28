From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Regarding ``problem with nilfs_cleanerd - part 2'' and
 ``Nilfs_cleanerd err=-17''
Date: Thu, 28 Apr 2011 10:36:04 +0900 (JST)
Message-ID: <20110428.103604.170006726.ryusuke@osrg.net>
References: <loom.20110427T111017-105@post.gmane.org>
	<20110427.204042.153209394.ryusuke@osrg.net>
	<loom.20110427T140022-700@post.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110427T140022-700-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 27 Apr 2011 12:29:20 +0000 (UTC), Ivan Telichko wrote:
> > How was the output of lssu command ?
> 
> Here: http://pastebin.com/DUn8UuvS
> 
> No difference between segments with
> duplicates and normal ones in that output.
> Only thing I can see here is that GC stopped
> at segment 1363.

Yeah, there are no erroneous segments.

Uum, after all, two nilfs_cleanerd instances seem to have caused this
duplication.  I will reconsider protection against the situation where
two or more cleaner daemons are invoked accidentaly.

> Is there any additional information I can
> provide? Partition is filling up and will be
> unusable in several days. I can keep image
> of it if needed.

OK, please reuse the partition for yourself.  We could get enough
information to narrow down the problem.

Thank you for your cooperation.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
