From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Regarding ``problem with nilfs_cleanerd - part 2'' and
 ``Nilfs_cleanerd err=-17''
Date: Wed, 27 Apr 2011 20:40:42 +0900 (JST)
Message-ID: <20110427.204042.153209394.ryusuke@osrg.net>
References: <loom.20110426T231606-740@post.gmane.org>
	<20110427.154007.255390385.ryusuke@osrg.net>
	<loom.20110427T111017-105@post.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110427T111017-105-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 27 Apr 2011 09:27:59 +0000 (UTC), Ivan Telichko wrote:
> > Is there dumpseg data of the segment 1718 and 1719 ?
> 
> I put them here: http://pastebin.com/8aHrkv7V

Thanks, Ivan.

> > If the duplicated block exists, it will look like:
> > 
> >       finfo
> >         ino = 97606, cno = 281, nblocks = xx, ndatblk = xx
> >           ...
> >           vblocknr = xxxxxxx, blkoff = 14, blocknr = xxxxxxxx
> >           ...
> > 
> 
> The first block in segment 1718 looks exactly like this. Is it wrong,
> even if segments are different?

Yes, it's wrong.

Although garbage collection makes such situation transiently during
migration of live blocks, one of these segments must be marked invalid
on sufile (segment usage file).

I'm guessing a retry of writeback or garbage collection failure causes
this inconsistent situation.

How was the output of lssu command ?
 
> Also, I tried to change mc_nsegments_per_clean to 3 in
> nilfs_cleanerd.conf. After that, cleanerd started and worked for
> some time, but then died again. Now duplicate blocks were found
> in segments 1363 and 1364. No free space was created in the
> process.

Yes, decreasing mc_nsegments_per_clean may hide the error, but it
won't resolve the inconsistency.


Thanks,
Ryusuke Konishi

> ---
> 
> Regards,
>    Ivan Telichko
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
