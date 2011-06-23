From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Removed checkpoints are still subject to protection period
Date: Thu, 23 Jun 2011 19:13:05 +0900 (JST)
Message-ID: <20110623.191305.31456687.ryusuke@osrg.net>
References: <201106221259.40135.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106221259.40135.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> On Wed, 22 Jun 2011 12:59:40 +0200, dexen deVries wrote:
> > Hi,
> > 
> > 
> > steps to reproduce:
> >  * create empty filesystem, mount, ensure nilfs_cleanerd is running on it
> >  * configure the nilfs_cleanerd for protection period 3600 (seconds)
> >  * create a bunch of files
> >  * delete the files
> >  * the nilfs_cleanerd does not reclaim space, because checkpoints are protected for 3600 seconds (the expected behavior)
> >  * remove all the snapshots with rmcp
> >  * the problem: the nilfs_cleanerd still does not reclaim space -- it considers the deleted checkpoints as still protected for the duration of 3600 seconds
> >  * once 3600 seconds passes, nilfs_cleanerd normally reclaims space
> > 
> > Expected behavior: cleanerd reclaims diskspace of deleted checkpoints regardless of protection period.
> > Rationale: there's no user-visible way of accessing deleted checkpoints, so there is no point in keeping them 'round.
> >  * remove all the snapshots with rmcp
> 
> should be:
>  * remove all the checkpoints with rmcp 

Yes, we know these issues and I feel rmcp and cleanerd should
coordinate better.  I'll think of them for nilfs-utils-2.1 though I
cannot make any guaranttes now.

Thank you for devoted feedbacks,

Ryusuke Konishi

> tested with linux v3.0-rc4, nilfs-utils v2.0.23
> 
> 
> Regards,
> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> For example, if the first thing in the file is:
>    <?kzy irefvba="1.0" rapbqvat="ebg13"?>
> an XML parser will recognize that the document is stored in the traditional ROT13 encoding.
> 
> (( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
