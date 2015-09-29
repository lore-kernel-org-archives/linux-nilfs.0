From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 14/17] fs/nilfs2: remove unnecessary new_valid_dev check
Date: Tue, 29 Sep 2015 23:51:24 +0900
Message-ID: <560AA56C.4020209@lab.ntt.co.jp>
References: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
 <1443450823-5692-1-git-send-email-bywxiaobai@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443450823-5692-1-git-send-email-bywxiaobai-9Onoh4P/yGk@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yaowei Bai <bywxiaobai-9Onoh4P/yGk@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015/09/28 23:33, Yaowei Bai wrote:
> As new_valid_dev always returns 1, so !new_valid_dev check is not
> needed, remove it.
> 
> Signed-off-by: Yaowei Bai <bywxiaobai-9Onoh4P/yGk@public.gmane.org>

Acked-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

> ---
>   fs/nilfs2/namei.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index 37dd6b0..c9a1a49 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -120,9 +120,6 @@ nilfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t rdev)
>   	struct nilfs_transaction_info ti;
>   	int err;
>   
> -	if (!new_valid_dev(rdev))
> -		return -EINVAL;
> -
>   	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
>   	if (err)
>   		return err;
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
