From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] nilfs2: remove BKL uses
Date: Mon, 5 Jul 2010 16:50:23 +0200
Message-ID: <201007051650.23761.arnd@arndb.de>
References: <1278220928-28121-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278220928-28121-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Blunck <jblunck-l3A5Bk7waGM@public.gmane.org>

On Sunday 04 July 2010, Ryusuke Konishi wrote:
> Nilfs has BKL uses in its put_super and remount functions, but none of
> them are necessary, just came from earlier push downs.  This
> eliminates the BKL uses from nilfs.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This looks good, but there is a another patch series pushing the BKL
into the get_sb and fill_super operations, which should be the final
pushdown for file systems. I wonder if there is a way to find a
shortcut on this so we don't need to add it first just to have you
go through the effort of removing it again.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
