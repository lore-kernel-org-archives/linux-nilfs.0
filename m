From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix data loss in mmap page write for hole
 blocks
Date: Tue, 29 Mar 2011 00:30:45 +0900 (JST)
Message-ID: <20110329.003045.13958921.ryusuke@osrg.net>
References: <1301240873-12035-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<201103281015.50533.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103281015.50533.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 28 Mar 2011 10:15:50 +0200, dexen deVries wrote:
> Hi,
> 
> On Sunday 27 of March 2011 17:47:53 Ryusuke wrote:
> > From the result of a function test of mmap, mmap write to shared pages
> > turned out to be broken for hole blocks.  It doesn't write out filled
> > blocks and the data will be lost after umount.  This is due to a bug
> > that the target file is not queued for log writer when filling hole
> > blocks. (...)
> 
> recently I've experienced a few times data loss & hang of several applications 
> with ktorrent running. It seems the transfered files were mostly empty after 
> reboot. Related to this regression & fix?

I don't know your applications actually do what.  If you find mmap
calls for file IOs in strace analysis, this issue seems the likely
cause.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
