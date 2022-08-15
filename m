From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: KASAN: use-after-free in nilfs_mdt_destroy
Date: Mon, 15 Aug 2022 19:23:51 +0100
Message-ID: <YvqPN2T3Q8pfnCoV@ZenIV>
References: <CAO4S-mficMz1mQW06EuCF+o11+mRDiCpufqVfoHkcRbQbs8kVw@mail.gmail.com>
 <YvqKJppIL4lVCn9+@ZenIV>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Peq9JtWu1E4wR6oLY4ARrrcqindLx2FfBvAEgWzQ1g0=; b=w2tLn6ETVYP0VvljwROUi5c9Q/
        rveWi+fG4t0fVcKB8q1gaZj8w72ZcqqAKvJDoLctt58naFC32aD+X4WKR+yk4FIlBv/57aq3IMObi
        6jS7VEFtjnk4FEMuwQ8+Fjy8laYEJZy6EcLFItyiTPh5qAGwOMKYiQ6KeIQKxCsNKd2oY6u19eCRm
        pR2Hzxb627+lWtmepjuPenaVX0DcWRc5KKJNlIxPNAzsI6C9Lino+xxMTUciyHL/wKO+9SgnbZbvI
        YEg3IuCRpq7nZ2tZ9dWcU9PJPGY179wOkToWpHf9rdYl4q/9kHG57Ze0zJ4QSdhMVDEFbqJTVyy6e
        BlseRfMA==;
Content-Disposition: inline
In-Reply-To: <YvqKJppIL4lVCn9+@ZenIV>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiacheng Xu <578001344xu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Mon, Aug 15, 2022 at 07:02:14PM +0100, Al Viro wrote:
> On Mon, Aug 15, 2022 at 10:03:21PM +0800, Jiacheng Xu wrote:
> 
> > Patch:
> > Fix this bug by moving the assignment of inode->i_private before
> > security_inode_alloc.
> > An ad-hoc patch is proposed:
> > https://patchwork.kernel.org/project/linux-fsdevel/patch/20211011030956.2459172-1-mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/
> 
> ... and that looks like utter bollocks.  Why does security_inode_alloc()
> look at ->i_private?  Which LSM is involved?

OK, I see...  The role of security_inode_alloc() here is that it's
a possible cause of failure.  And yes, dealing with that class of
bugs here might be better.

However, *IF* we go that way, why not move that thing to the
very end?  Just prior to
        this_cpu_inc(nr_inodes);

Sure, nilfs2 steps only into uninitialized ->i_private.
Who's to say that we won't run into somebody deciding that e.g.
inode->i_data.private_data is worth a look?

Just move the call of security_inode_alloc() down to immediately
before the nr_inode increment, with explanation along the lines
of

"In case of security_inode_alloc() failure the inode is passed to
->destroy_inode(); doing security_inode_alloc() last makes for
easier life for ->destroy_inode() instances - they can rely upon
the rest of inode_init_always() having been done.  It's not
just a theoretical problem - nilfs2 has actually stepped into that
[reference to report]"
