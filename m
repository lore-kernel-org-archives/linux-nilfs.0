From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 2/9] nilfs2: add /sys/fs/nilfs2/<device> group
Date: Wed, 28 May 2014 10:24:55 +0400
Message-ID: <1401258295.2360.2.camel@slavad-CELSIUS-H720>
References: <1398784683.2185.68.camel@slavad-CELSIUS-H720>
	 <20140528.023507.1265249128091142834.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=YyQytKvhWInApLObqFqfvJH9T4QNenwFgLvSJMdd/Tc=;
	b=P9oQT65JUg3lwcC12x+qkvrYaFAVaA256IvCzIkB8poSmsdTiiArDkNEYlOsg7evuPZ7utMz1mMlPPH5rBc5SKmSk9TH4boGUavzUzi/MN77XSg/zFhDn8D0APX6rgbl;
In-Reply-To: <20140528.023507.1265249128091142834.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ryusuke,

On Wed, 2014-05-28 at 02:35 +0900, Ryusuke Konishi wrote:

[snip]
> > diff --git a/Documentation/ABI/testing/sysfs-fs-nilfs2 b/Documentation/ABI/testing/sysfs-fs-nilfs2
> > index 2e2a6df..75996a5 100644
> > --- a/Documentation/ABI/testing/sysfs-fs-nilfs2
> > +++ b/Documentation/ABI/testing/sysfs-fs-nilfs2
> > @@ -14,3 +14,54 @@ KernelVersion:	3.15
> >  Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> >  Description:
> >  		Describe attributes of /sys/fs/nilfs2/features group.
> > +
> > +What:		/sys/fs/nilfs2/<device>/revision
> > +Date:		April 2014
> > +KernelVersion:	3.15
> 
> We are now in the development cycle of 3.15, so the kernel version
> that this series first appears will be at least later than 3.15.  I
> prefer to omit this field at present (like ext4 or f2fs).
> 

OK. It's not principal point. I'll omit it.

[snip]
> > +static
> > +ssize_t nilfs_dev_uuid_show(struct nilfs_dev_attr *attr,
> > +			    struct the_nilfs *nilfs,
> > +			    char *buf)
> > +{
> > +	struct nilfs_super_block **sbp = nilfs->ns_sbp;
> > +
> > +	return snprintf(buf, PAGE_SIZE, "%pUL\n", sbp[0]->s_uuid);
> > +}
> 
> Looks like there is a byte order problem.  The value of uuid file
> didn't match the output of nilfs-tune tool or blkid command.
> 
> nilfs-tune output:
> 
>  Filesystem UUID:        b9e47fee-2507-4499-9d98-49917ba371e5
> 
> /sys/fs/nilfs2/sdb1/uuid:
> 
>  EE7FE4B9-0725-9944-9D98-49917BA371E5
> 
> blkid output:
> 
>  /dev/sdb1: UUID="b9e47fee-2507-4499-9d98-49917ba371e5" TYPE="nilfs2" LABEL="test"
> 
> Can you fix this issue?
> 

Yes, sure. I'll check and fix it.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
