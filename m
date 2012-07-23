From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: read error on superblock
Date: Mon, 23 Jul 2012 13:37:52 +0400
Message-ID: <1343036272.1974.16.camel@slavad-ubuntu-11>
References: <19753282.RhzHOQAfKG@coil>
	 <1343035048.1974.6.camel@slavad-ubuntu-11>  <1473809.3VOqpg65Ko@coil>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=8b0B1ltVfpa0DfygapRQT1YkZ1U/giKpzMN/73p/zzM=;
	b=P4tjmVLgMaw8O68qcQwoHqUlZrTb4GV9CINPDPSVuxFOXiUm2Pa+Yg4S8yMLm//ve1+1QV1zerrhgV/88ZCky52yMHlSOXABXQ8UedWUpSuk3FC82JRhBkzQ8Dl+LoeV;
In-Reply-To: <1473809.3VOqpg65Ko@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dexen,

On Mon, 2012-07-23 at 11:24 +0200, dexen deVries wrote:
> Hi Vyacheslaw,
> 
> 
> On Monday 23 of July 2012 13:17:28 you wrote:
> > It exits second superblock at the end of NILFS volume. But it can be not
> > in fully synchronous state with primary ones (as I guess).
> > Theoretically, it is possible to copy secondary superblock on the place
> > of primary. But I am afraid that the NILFS volume can be in inconsistent
> > state anyway.
> 
> any hints how to locate the superblock? what offset to look at, and what's the 
> magic number(s)?

Usually, secondary superblock is located in the last block (4 KB) of the
volume. In nilfs2_fs.h exists such

#define NILFS_SB2_OFFSET_BYTES(devsize) ((((devsize) >> 12) - 1) << 12)

which define placement of the secondary superblock (devsize is size of
the device in bytes).

Magic number of NILFS2 is 0x3434. It is located on 0x0006 bytes offset
from superblock's begin. 

> 
> > Do you sure that this volume doesn't contain another damaged sectors?
> 
> 
> in my case, that doesn't matter: all the data i want to recover is either in 
> Git (which does internal consistency checks) or in MySQL, which also does 
> /some/ consistency checks.
> 
> 
> Cheers,

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
