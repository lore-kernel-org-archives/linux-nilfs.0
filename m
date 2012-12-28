From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Which version of nilfs do you use?
Date: Fri, 28 Dec 2012 10:14:49 +0400
Message-ID: <1356675289.2126.10.camel@slavad-ubuntu>
References: <AAEC3976-3D79-4170-B1DC-2A04499392DE@gmail.com>
	 <1902997.ayblf9kj7g@coil> <BB9A0F28-A902-4FE4-BA58-A66EA93290F8@gmail.com>
	 <20121228.115843.568913897223506746.hermes@ceres.dti.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=m9iOLODhCRzuP/mCqE4kmq+ZN6zyrWu2HWxuZktOfH8=;
	b=cxd7E4sHHGhkZJG9s48Cwgjs2m2eQwc4ZvJNDHgfZhsKZDS6e4cxBjn1JCdMbadOXcYZydn71T6UJ32V5K3mbkokfpRBLIZDMTvMGcTBdsktCi5slv+HYPPYgy066j6H;
In-Reply-To: <20121228.115843.568913897223506746.hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2012-12-28 at 11:58 +0900, ARAI Shun-ichi wrote:
> In <BB9A0F28-A902-4FE4-BA58-A66EA93290F8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>;
>    Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote
>    as Subject "Re: Which version of nilfs do you use?":
> 
> > There is more than 2TB of data and a large number of databases, tables in our MySQL service. The conventional cold backup methods can not meet our needs. So we are trying to find some other methods.
> 
> I posted report mail about the "bad btree node" error in 2012-11-30,
> I told about VirtualBox.
> When I met the error first, virtual disk file (approx. 16GB) was in
> NILFS FS.
> 
> Zhang's DB is large. Perhaps there are files which has large size, I think.
> And these files are updated frequently.
> 
> Can the common point (file size, update) cause inconsistency?

I think that it can be a synchronization issue. But it needs to
investigate the situation more deeply. As I can see, it is using 8 CPUs
in the case of the issue and it takes place frequent update. So, it can
be a ground for good issue reproducibility, from my point of view.

With the best regards,
Vyacheslav Dubeyko.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
