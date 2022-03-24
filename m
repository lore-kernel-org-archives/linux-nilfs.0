From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -next v2] fs: Fix some kernel-doc comments
Date: Thu, 24 Mar 2022 12:38:54 +0900
Message-ID: <CAKFNMokxqD1ouhaNf5KeMD3gEO32QOBJUdSEZbWHmmi2Oj9s+Q@mail.gmail.com>
References: <20220324024215.63479-1-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vZfjREZ8FUx9c4b2sjgAYGes5irtI27++mGowWVmjkw=;
        b=ntKuFibhVve4a7LxVr5qFm2l6asluhgUYiBbNXbbG519O8SWFGDkD48XG9bR/K+3C2
         mikBUfGDpYgGA1Q22jX6mDTMzaEE3x0LgrJ1wAZ35rXzLbQkp3BNwkT3jzpfuRJ0Pu8X
         uHdmq0tJX5aJp7+ZxA0XizGLdFf9QNeWEnHtPu1XcfL/aZRsUwF9J4L7o/s9/5VcbsCe
         xzMzMGLC3zDLco+k+bPJmunRD6jNStzHhm/8A4QfRjqvOUaWRaKOMA6Pq4bylynz3aK9
         0SJARn8TGmcY+nF/wosRM1wjEKhBb1rD3P2dw4WX24Qpiv4reZyGHOIjuKiFaxHp7riA
         vJXA==
In-Reply-To: <20220324024215.63479-1-yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

On Thu, Mar 24, 2022 at 11:42 AM Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> The description of @flags in nilfs_dirty_inode() kernel-doc
> comment is missing, and some functions had kernel-doc that
> used a hash instead of a colon to separate the parameter
> name from the one line description.
>
> Fix them to remove some warnings found by running scripts/kernel-doc,
> which is caused by using 'make W=1'.
>
> fs/nilfs2/inode.c:73: warning: Function parameter or member 'inode' not
> described in 'nilfs_get_block'
> fs/nilfs2/inode.c:73: warning: Function parameter or member 'blkoff' not
> described in 'nilfs_get_block'
> fs/nilfs2/inode.c:73: warning: Function parameter or member 'bh_result'
> not described in 'nilfs_get_block'
> fs/nilfs2/inode.c:73: warning: Function parameter or member 'create' not
> described in 'nilfs_get_block'
> fs/nilfs2/inode.c:145: warning: Function parameter or member 'file' not
> described in 'nilfs_readpage'
> fs/nilfs2/inode.c:145: warning: Function parameter or member 'page' not
> described in 'nilfs_readpage'
> fs/nilfs2/inode.c:968: warning: Function parameter or member 'flags' not
> described in 'nilfs_dirty_inode'
>
> Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
>
> --Changes in v2:
> Modified description of @flags in nilfs_dirty_inode() kernel-doc comment
>
>  fs/nilfs2/inode.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

Will apply, thanks!

Ryusuke Konishi
