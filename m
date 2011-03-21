From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Tue, 22 Mar 2011 00:30:19 +0900 (JST)
Message-ID: <20110322.003019.220055781.ryusuke@osrg.net>
References: <20110321.200706.260176646.ryusuke@osrg.net>
	<201103211300.50177.dexen.devries@gmail.com>
	<20110322.000702.112911778.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110322.000702.112911778.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 22 Mar 2011 00:07:02 +0900 (JST), Ryusuke Konishi wrote:
> Also, we can make .nilfs immutable on the latest kernel in which nilfs
> supported lsattr and chattr:
> 
>  # chattr +i .nilfs
>  # rm .nilfs
>  rm: cannot remove `.nilfs': Operation not permitted
> 
> This could be another work around though I don't prefer it.

Unfortunately, this turned out to go wrong since immutable file is not
writable. 

Using a Posix semaphore looks shorter now.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
