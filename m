From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 0/2] nilfs2: asynchronous super block updates
Date: Wed, 09 Jun 2010 10:36:17 +0900 (JST)
Message-ID: <20100609.103617.27788002.ryusuke@osrg.net>
References: <1276035358-24284-1-git-send-email-jir@unicus.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1276035358-24284-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Wed,  9 Jun 2010 07:15:56 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This is revised patch series to update super block asynchronously.
> 
> First patch separates super block validity check from nilfs_commit_super,
> and moved the function into callers.
> 
> Second patch introduces nilfs_write_log_cursor to advance log cursor
> for one of super blocks.  This patch also define a macro that generates
> inline function to update information both super blocks for convenience.

Ahh, this series doesn't apply as is.

Could you rebase it onto the for-next branch ?

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
