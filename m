From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 1/3] nilfs2: fix disorder of
 nilfs_write_super in nilfs_sync_fs
Date: Sun, 19 Jul 2009 19:53:58 +0900 (JST)
Message-ID: <20090719.195358.55746341.ryusuke@osrg.net>
References: <1247981182-14831-1-git-send-email-jir@unicus.jp>
	<1247981182-14831-2-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1247981182-14831-2-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org

Hi,
On Sun, 19 Jul 2009 14:26:20 +0900, Jiro SEKIBA wrote:
> fix disorder of nilfs_write_super in nilfs_sync_fs.
> commiting super block must be the end of the function
> so that every chanages are reflected.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---
>  fs/nilfs2/super.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 8e2ec43..ba69601 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -388,11 +388,12 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
>  {
>  	int err = 0;
>  
> -	nilfs_write_super(sb);
> -
>  	/* This function is called when super block should be written back */
>  	if (wait)
>  		err = nilfs_construct_segment(sb);
> +
> +	nilfs_write_super(sb);
> +

I read callers of the sync_fs callback, and I felt that
nilfs_sync_fs() would rather call nilfs_commit_super() directly.

nilfs_write_super is written to handle periodic callback,
and it moderates frequency of actual write back.

Is sync_fs called periodically or frequently?

If neither was, I think it's only necessary to do:

    down_write(&nilfs->ns_sem);
    if (sb->s_dirt)
        nilfs_commit_super(NILFS_SB(sb), 1);
    up_write(&nilfs->ns_sem);

Note that ->sync_fs() is not called for read-only filesystems.

The recent migration of write_super into sync_fs made this
transformation possible.

Thanks,
Ryusuke Konishi

>  	return err;
>  }
>  
> -- 
> 1.5.6.5
> 
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
