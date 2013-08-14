From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 1/2] nilfs2: remove double bio_put() in
 nilfs_end_bio_write() for BIO_EOPNOTSUPP error
Date: Wed, 14 Aug 2013 16:45:45 -0700
Message-ID: <20130814164545.41be4873a71f321cc1ae3b16@linux-foundation.org>
References: <1376401833.2274.9.camel@slavad-ubuntu>
	<20130814.015148.316894835.konishi.ryusuke@lab.ntt.co.jp>
	<20130814160001.3fa9e4dabb7dca81dab31e87@linux-foundation.org>
	<20130815.084112.220043622.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130815.084112.220043622.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, DanCarpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 15 Aug 2013 08:41:12 +0900 (JST) Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:

> On Wed, 14 Aug 2013 16:00:01 -0700, Andrew Morton wrote:
> > On Wed, 14 Aug 2013 01:51:48 +0900 (JST) Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> > 
> >> On Tue, 13 Aug 2013 17:50:33 +0400, Vyacheslav Dubeyko wrote:
> >> > From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> >> > Subject: [PATCH v3 1/2] nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
> >> > 
> >> > This patch removes double call of bio_put() in nilfs_end_bio_write()
> >> > for the case of BIO_EOPNOTSUPP error detection. The issue was found
> >> > by Dan Carpenter and he suggests first version of the fix too.
> >> > 
> >> > Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >> > Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> >> > CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> >> 
> >> Acked-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> >> Tested-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> >> 
> >> I tested this patch by inserting a pseudo EOPNOTSUPP error, and this
> >> actually fixed a crach "kernel BUG at fs/bio.c:498!" due to reference
> >> count underflow of bio_put() that nilfs_end_bio_write() induced.
> >> 
> >> 
> >> Andrew, please pick up this bug-fix preferably for this cycle.
> > 
> > Should we apply the fix to earlier kernel versions and if so, how
> > far back in time does it go?
> 
> Yes, I think it should also be applied to earlier versions.
> 
> I looked back ealiear versions.
> 
> This bug, unfortunately, comes from the original version (2.6.30), and
> the patch could be applied to all versions.

OK.  And what about
nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch?
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
