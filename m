From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 1/3] nilfs2: fix disorder of
 nilfs_write_super in nilfs_sync_fs
Date: Sat, 18 Jul 2009 00:34:13 +0900 (JST)
Message-ID: <20090718.003413.96409854.ryusuke@osrg.net>
References: <1247821968-31232-1-git-send-email-jir@unicus.jp>
	<1247821968-31232-2-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1247821968-31232-2-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Fri, 17 Jul 2009 18:12:46 +0900, Jiro SEKIBA wrote:
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> 
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
>  	return err;
>  }
>  
> -- 
> 1.5.6.5

Yes, right.

Writing back the super-block should be moved after log writing.
A recent vfs cleanup made room for this change.

Ryusuke Konishi
