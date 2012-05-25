From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Fri, 25 May 2012 20:06:49 +0200
Message-ID: <20120525180649.GA1236@heethoofdje.13thmonkey.org>
References: <CAHmELnWvFNdiePs=mQJ=nqfsxJ_49zxawa9jncE-RJ2-omYHOg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHmELnWvFNdiePs=mQJ=nqfsxJ_49zxawa9jncE-RJ2-omYHOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenneth Langga <klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Kenneth.

On Fri, May 25, 2012 at 10:30:40PM +0800, Kenneth Langga wrote:
> NILFS: bad btree node (blocknr=111560943): level = 242, flags = 0x3f,
> nchildren = 23369
> NILFS error (device sdc2): nilfs_bmap_lookup_contig: broken bmap
> (inode number=19696)
> 
> What is the correct course of action for this type of error? And what
> would have caused this?

What struck me is the very high level and the absurt number of number of
children. That can't be good. AFAIR NiLFS only has say upto 3 (or 4?) levels
in its B-tree. It *could* be failing in rebalancing or more likely pointing to
garbage?

Cheers,
Reinoud

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
