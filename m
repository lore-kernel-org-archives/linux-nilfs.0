From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] Fixed a bug that cp count get wrong on
 errors when deleting series of cp
Date: Sat, 04 Jul 2009 03:00:39 +0900 (JST)
Message-ID: <20090704.030039.31628845.ryusuke@osrg.net>
References: <87zlbmxq4e.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <87zlbmxq4e.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
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

Hi Sekiba-san,
On Fri, 03 Jul 2009 15:00:33 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi, 
> 
> This is a patch to fix a bug that checkpoint count get wrong
> on errors when deleting series of checkpoints.
> 
> Thanks,
> 
> Regards
> -- 
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> 
>  Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Thank you for sending this!

This patch fixes possible mismatch between the number of checkpoints
and the count stored in the header block of cpfile.

Later, I will apply this to a series for 2.6.31-rc, and send it to
Linus before 2.6.31-rc3 or so.

Regards,
Ryusuke Konishi
 
> ---
>  fs/nilfs2/cpfile.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
> index 7d49813..aec942c 100644
> --- a/fs/nilfs2/cpfile.c
> +++ b/fs/nilfs2/cpfile.c
> @@ -307,7 +307,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
>  		ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
>  		if (ret < 0) {
>  			if (ret != -ENOENT)
> -				goto out_header;
> +				break;
>  			/* skip hole */
>  			ret = 0;
>  			continue;
> @@ -340,7 +340,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
>  					continue;
>  				printk(KERN_ERR "%s: cannot delete block\n",
>  				       __func__);
> -				goto out_header;
> +				break;
>  			}
>  		}
>  
> @@ -358,7 +358,6 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
>  		kunmap_atomic(kaddr, KM_USER0);
>  	}
>  
> - out_header:
>  	brelse(header_bh);
>  
>   out_sem:
> -- 
> 1.5.6.5
> 
> 
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
