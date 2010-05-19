From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Segment magic number invalid
Date: Thu, 20 May 2010 01:14:55 +0900 (JST)
Message-ID: <20100520.011455.32954390.ryusuke@osrg.net>
References: <AANLkTimfmJU5h4pS23eKpjLNV_c6d4YEBHNmBdcy-r4g@mail.gmail.com>
	<20100517.162614.107743625.ryusuke@osrg.net>
	<871vd8dms5.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <871vd8dms5.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 19 May 2010 22:49:30 +0900, Jiro SEKIBA wrote:
> > > Actually, I now wonder what could have gone wrong in my case. I wasn't
> > > doing any disk intensive task and the machine wasn't suspended to ram
> > > during the course.
> > 
> > This problem can happen if the block device doesn't support "write
> > barrier" properly.  Unfortunately, such devices are not uncommon even
> > now.
> > 
> > I feel we should do something for it.
> 
> How abou updating one of super blocks when super block update needed?
> 
> I'm hoping that even "write barrier" is not supported, back up super block
> likely points valid older log.
> 
> In case latest super block, which has greater CP, points invalid log,
> try to search log from the other super block that has older log and
> roll forwad the log until it finds newer super root.
> 
> Futher more, because each super block is less frequently updated,
> it may address low-end consumer flash super block hot-spot issue.

Seems a nice solution.

And it looks feasible now since the patch titled "nilfs2: use
checkpoint number instead of timestamp to select super block" made it
easy.

The secondary super block is written to disk along with the primary
one, but less frequently.  So it can be implemented by changing spec
of the dupsb argument of nilfs_commit_super to "other one" from "both
(dupsb)".

Can you make draft patches?

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
