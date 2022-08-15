From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [vs] KASAN: use-after-free in nilfs_mdt_destroy
Date: Mon, 15 Aug 2022 13:36:47 +0200
Message-ID: <Yvovz7FKlHLNpNaf@kroah.com>
References: <34e8df4a.848e1.182a1264256.Coremail.stitch@zju.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660563411;
        bh=RUBiTWx88xXU8yVcchK6WhGJDZzS2sucOuvbvrU6PCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PYjXdOsnUKk4hznS7izxVtlOe9jlzlaaCOwjeezkoF3yvYL4Of8MdwQJ1bRSGTWZT
         tTzBs7X1inlH2WfwUEs70J6DYbdy4+mxDVgOeaxVVmvS9bnetCmRkyC53j2MQlvX1D
         mzbGirEHEAgCHcXTA8doQ1UfGeL9FO4BY9mN3cGc=
Content-Disposition: inline
In-Reply-To: <34e8df4a.848e1.182a1264256.Coremail.stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?6K645ZiJ6K+a?= <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
Cc: security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-distros-DYwG1KUNWo0m4/wLoHy/Wg@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 15, 2022 at 06:56:55PM +0800, 许嘉诚 wrote:
> Hi developers,
> 
> We may found a flaw in the fs module which can lead to UAF write or DoS.
> We would appreciate a CVE ID if this is a security issue.

As our documentation states, us at security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org do not assign
CVEs or deal with them at all.

> 
> HEAD commit: 3d7cb6b04c3f Linux-5.19
> git tree: upstream 
> console output:https://drive.google.com/file/d/1PoH9PUdMilsrKtq1oGHu_shM3dggNFAB/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1wgIUDwP5ho29AM-K7HhysSTfWFpfXYkG/view?usp=sharing
> syz repro: https://drive.google.com/file/d/19N1Xh8TVoSUr_2J8j-bWXktL21SvRx_9/view?usp=sharing
> C reproducer: https://drive.google.com/file/d/1R1rYseY7JBDCSfLAP4pjSCoMVgkr7l5b/view?usp=sharing
> 
> Description
> In alloc_inode, inode_init_always could return -NOMEM if
> security_inode_alloc fails. In its error handling, i_callback and
> nilfs_free_inode will be called. However, because inode->i_private is
> not initialized due to the failure of security_inode_alloc, the function
> nilfs_is_metadata_file_inode can return true and nilfs_mdt_destroy will
> 
> 
> be executed to lead to GPF bug.
> 
> 
> 
> 
> Someone found the similar problem: https://groups.google.com/g/syzkaller-bugs/c/z2WroC3_BSw.

Great, can you work on this in public on that thread then?  Have you
tested the proposed patch that is provided there to see if it solves it
or not?

> Fix this bug by moving the assignment of inode->i_private before security_inode_alloc.

That's what the existing patch looks to do, does that work?

And again, as this is public, why notify us and not just work to solve
this in public with the developers involved?

thanks,

greg k-h
