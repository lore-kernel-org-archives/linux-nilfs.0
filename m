From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] mkfs: check sizes of important structs at build time
Date: Sat, 4 Jan 2014 17:52:35 +0300
Message-ID: <EF28F22A-C43F-41C9-A5B9-8597C5879E3E@dubeyko.com>
References: <1388842171-16105-1-git-send-email-mitake.hitoshi@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=rTx43pRfIHmcLB22uVMZmylt5CK9rOvcgc0AoGojnNY=;
	b=bWb2AuvKkpSC9OM2zXH6u7LHJLr7sEgQnlM1wvWax5k59VA8z2NgDh/JFXIQ7HqT17LGFA6DIJHzPtvjvsL85r0/6HicHAmoYwdahbU/BMOemVLin3Gdx3KXoU5rRDFX;
In-Reply-To: <1388842171-16105-1-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>


On Jan 4, 2014, at 4:29 PM, Hitoshi Mitake wrote:

> Current nilfs_check_ondisk_sizes() checks sizes of important structs
> at run time. The checking should be done at build time. This patch
> adds a new macro, BUILD_BUG_ON(), for this purpose. It is similar to
> static_assert() of C++11. If an argument is true, the macro causes a
> bulid error.
> 
> Below is an example of BUILD_BUG_ON(). When the checked conditions are
> true like below:
> 
> /* intentional change for testing BUILD_BUG_ON() */
> 
> static __attribute__((used)) void nilfs_check_ondisk_sizes(void)
> {
> 	BUILD_BUG_ON(sizeof(struct nilfs_inode) > NILFS_MIN_BLOCKSIZE);

So, why do we need to have function for the case of checking on compilation
phase?

I suppose that we need to have some run-time check anyway. Your approach
is correct for the current state of the code. But I feel a necessity in run-time check
anyway. Maybe it looks like a paranoia. :) Maybe it needs to extend checking
in this place.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
