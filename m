From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: KASAN: use-after-free in nilfs_mdt_destroy
Date: Mon, 15 Aug 2022 19:02:14 +0100
Message-ID: <YvqKJppIL4lVCn9+@ZenIV>
References: <CAO4S-mficMz1mQW06EuCF+o11+mRDiCpufqVfoHkcRbQbs8kVw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GcrNBmy4B7oYPvzC1iQ3x9irNnquUnomstD6AlIWDjo=; b=mbnFdPKHRrDIndSjpd0B0OjzRe
        GQl31o3UikiEGn6BQe9miqqX9F802O9C06p1/OSyBKP51WOUacxGnUx7z4T6ckelwcCtMvcfR8mrK
        5hlTPVvydm+RDOa9tDO1fR4GyEKa0taddTbbOtN5/DLk48AvbH65vleCk4EEsitm3rRsQJ7GinDca
        +MVUzc6eoN087h/COD/d3Eq28QKnb/gPmfW6dDXn2WMm++zYS6VfFmA4IuYw7kJRXaJvVMKKgpTB6
        hl+hfewNBspeJQSXz/fNRpARhUvZzAJWJM8RAbwMeI7f2gU4yfGTRikkZem3Jys2K6TVQXNv/BNYI
        +TUm5M8A==;
Content-Disposition: inline
In-Reply-To: <CAO4S-mficMz1mQW06EuCF+o11+mRDiCpufqVfoHkcRbQbs8kVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiacheng Xu <578001344xu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Mon, Aug 15, 2022 at 10:03:21PM +0800, Jiacheng Xu wrote:

> Patch:
> Fix this bug by moving the assignment of inode->i_private before
> security_inode_alloc.
> An ad-hoc patch is proposed:
> https://patchwork.kernel.org/project/linux-fsdevel/patch/20211011030956.2459172-1-mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/

... and that looks like utter bollocks.  Why does security_inode_alloc()
look at ->i_private?  Which LSM is involved?
