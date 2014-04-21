From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 0/9] nilfs2: introduce functionality of creation of
 sysfs groups and attributes
Date: Mon, 21 Apr 2014 16:14:23 +0400
Message-ID: <1398082463.2212.3.camel@slavad-CELSIUS-H720>
References: <1397837240.2178.51.camel@slavad-CELSIUS-H720>
	 <20140421.011825.85418432.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=Q663jhbQeKgM1LlvyNwDeKCqwaPQIslCYm/NeOxCr+E=;
	b=hNhvKM6S7TxfjQQ18uS2Vbyk5D+CUFd1aOukUe/1Sdt+WfxGGniScZCfXNsbLAdDk/KhsWuuhBlZpcavTpulQj2+nbJFjIBr6hm2oTDbbp4qj2VkkwPj2ugVZdjdwNq5;
In-Reply-To: <20140421.011825.85418432.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ryusuke,

On Mon, 2014-04-21 at 01:18 +0900, Ryusuke Konishi wrote:

[snip]
> 
> Thank you for posting this series.
> 
> I am thinking of sending this series to upstream.
> 
> For that end, please clarify the motivation, the background, or the
> issue what this series tries to solve within the cover letter ([PATCH
> 0/n]).  I will refer to it when I will send the series to upstream.
> 

OK. I'll do it.

> Also, it's preferable to include a brief overview of this sysfs
> interface in a Documentation file.
> 
> Some filesystems describe their sysfs interface in
> Documentation/ABI/testing/sysfs-fs-xxx.  Even though this sysfs
> interface has description of ABI in README files, I think
> documentation should be added in a similar manner to other
> filesystems.
> 

Yes, I agree. It makes sense. I'll add the description.

> You chose "nilfs" instead of "nilfs2" as the filesystem name.  This
> may lead to discussion, but I also prefer "nilfs" because we
> intentionally use the name "nilfs" in userland as the name separated
> from implementation and this is the name of interface for users and
> userland tools.
> 
> One my question is about the "device" name.  Is it guaranteed that
> every device has canonical single node name?  What will happen for
> devices such as /dev/mapper/xxx?
> 

I need to check it. I am not ready to answer right now.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
