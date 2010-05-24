From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: uuid for nilfs partition?
Date: Tue, 25 May 2010 00:33:45 +0900 (JST)
Message-ID: <20100525.003345.115737304.ryusuke@osrg.net>
References: <4BFA8D5B.6000700@daliverse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BFA8D5B.6000700-RrB2l6sP9Nll57MIdRCFDg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dlarge-RrB2l6sP9Nll57MIdRCFDg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 24 May 2010 09:29:47 -0500, Darien Large wrote:
> I'm using nilfs2 for my /home directory, under Ubuntu 10.04 with kernel 
> 2.6.32-22. I love it, but I'm having trouble mounting it through fstab 
> consistently. How can I set a UUID for an nilfs volume? I've been unable 
> to do so using any of the linux tools I'm aware of.
> 
> --Darien Large

UUID is set when creating nilfs volume with mkfs.nilfs2 (or mkfs -t
nilfs2).  But, the current standard mount program does not identify
the UUID of nilfs partitions.

Unfortunately, no UUID (nor label) tool is yet available for nilfs
though it's not time-consuming job.

The problem is that we were not able to promote nilfs to such standard
tools yet.  Recently we had discussion on the procedure to do this,
but sorry, it seems still take a while by the time it becomes
available commonly.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
