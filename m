From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix warning in nilfs_writepage()
Date: Thu, 25 Apr 2013 13:46:10 -0700
Message-ID: <20130425134610.d26f087c0db29d0703736db3@linux-foundation.org>
References: <20130425074947.GB11880@elgon.mountain>
	<1366882715.3181.11.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366882715.3181.11.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kbuild-JC7UmRfGjtg@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On Thu, 25 Apr 2013 13:38:35 +0400 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:

> On Thu, 2013-04-25 at 10:49 +0300, Dan Carpenter wrote:
> > [ It's weird that kbuild didn't catch this ].
> > 
> > Hello Vyacheslav Dubeyko,
> > 
> > The patch bb594c4767b0: "nilfs2: fix issue with flush kernel thread
> > after remount in RO mode because of driver's internal error or
> > metadata corruption" from Apr 18, 2013, leads to the following 
> > warning:
> > "fs/nilfs2/inode.c:211 nilfs_writepage()
> > 	 error: we previously assumed 'inode' could be null (see line 195)"
> > 
> 
> Please, find below the patch with fix.
> 
> Thanks,
> Vyacheslav Dubeyko.
> --
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH] nilfs2: fix warning in nilfs_writepage()
> 
> The patch fixes warning: "fs/nilfs2/inode.c:211 nilfs_writepage() error: we previously assumed 'inode' could be null (see line 195)".

The changelog doesn't tell us what tool emitted the warning.  Was it sparse?

> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -192,7 +192,7 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
>  	struct inode *inode = page->mapping->host;
>  	int err;
>  
> -	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
> +	if (inode->i_sb->s_flags & MS_RDONLY) {
>  		/*
>  		 * It means that filesystem was remounted in read-only
>  		 * mode because of error or metadata corruption. But we

I'll going to fix up the patch description and subject.  In particular,
the objective of this patch isn't really to fix a warning - it's to
remove some unneeded code.  The warning merely alerted us to its
presence.

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: nilfs2: remove unneeded test in nilfs_writepage()

page->mapping->host cannot be NULL in nilfs_writepage(), so remove the
unneeded test.

The fixes the sparse warning: "fs/nilfs2/inode.c:211 nilfs_writepage()
error: we previously assumed 'inode' could be null (see line 195)".

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 fs/nilfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/inode.c~nilfs2-fix-warning-in-nilfs_writepage fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-fix-warning-in-nilfs_writepage
+++ a/fs/nilfs2/inode.c
@@ -192,7 +192,7 @@ static int nilfs_writepage(struct page *
 	struct inode *inode = page->mapping->host;
 	int err;
 
-	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
+	if (inode->i_sb->s_flags & MS_RDONLY) {
 		/*
 		 * It means that filesystem was remounted in read-only
 		 * mode because of error or metadata corruption. But we
_

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
