From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: fix issue with flush kernel thread after
 remount in RO mode because of driver's internal error or metadata corruption
Date: Thu, 18 Apr 2013 17:59:10 +0400
Message-ID: <1366293550.2545.2.camel@slavad-ubuntu>
References: <1366186416.2113.5.camel@slavad-ubuntu>
	 <20130417125701.9fc97738f85f015e3ace1106@linux-foundation.org>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=azaYWZ+N53nlfMYT1ZDPPfRQ5NL80JlzZ2bXGWMwaHw=;
	b=lgDgMvXTupCpFarU57+7J/yIRg6UHyUaILar+neTa+BnomWi8xIJvGp2E3FdpJCSuduV2l0XuyaTfXJCoe505+4bDkEJDUc8Cx7YcVxm98NYOSSP1MxwbLg4BlLc0BPw;
In-Reply-To: <20130417125701.9fc97738f85f015e3ace1106-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>, ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>, Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>, Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>, Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, 2013-04-17 at 12:57 -0700, Andrew Morton wrote:
> On Wed, 17 Apr 2013 12:13:36 +0400 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> > +	BUG_ON(!test_bit(PG_locked, &page->flags));
> 
> The fs should be using PageLocked() here.

Yes, I agree. Please, find correction patch below.

With the best regards,
Vyacheslav Dubeyko.
---
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: fix using of PageLocked() in nilfs_clear_dirty_page()

This patch changes test_bit(PG_locked, &page->flags) on PageLocked().

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 fs/nilfs2/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 2a2187f..a1db80f 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -407,7 +407,7 @@ void nilfs_clear_dirty_page(struct page *page, bool silent)
 	struct inode *inode = page->mapping->host;
 	struct super_block *sb = inode->i_sb;
 
-	BUG_ON(!test_bit(PG_locked, &page->flags));
+	BUG_ON(!PageLocked(page));
 
 	if (!silent) {
 		nilfs_warning(sb, __func__,
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
