From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] nilfs_cleanerd: make gc safe for duplicate
 invocation
Date: Fri, 29 Apr 2011 17:41:23 +0900 (JST)
Message-ID: <20110429.174123.55733102.ryusuke@osrg.net>
References: <1304065125-9532-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<201104291023.19215.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201104291023.19215.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 29 Apr 2011 10:23:18 +0200, dexen deVries wrote:
> On Friday 29 of April 2011 10:18:45 you wrote:
> > This enlarges the region that a garbage collection lock protects so
> > that indivisible steps of garbage collection do not interleave.
> > (...)
> 
> thanks Ryusuke, it's an important improvement :)

My pleasure :)

I will do a utility release for this in a day or so.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
