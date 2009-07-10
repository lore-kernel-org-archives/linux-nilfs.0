From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: remove redundant super block
 commit
Date: Fri, 10 Jul 2009 20:58:14 +0900 (JST)
Message-ID: <20090710.205814.130975084.ryusuke@osrg.net>
References: <87ljmxruns.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <87ljmxruns.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
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
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Fri, 10 Jul 2009 14:09:27 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> This is a patch to remove redundant super block commit.
> 
> nilfs_write_super will call nilfs_commit_super to store super block
> into block device.  However, nilfs_put_super will call nilfs_commit_super
> right after calling nilfs_write_super.
> So calling nilfs_write_super in nilfs_put_super would be redundant.
> 
> thanks,
> 
> regards,
> -- 
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> 
>  Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Applied. Thanks!

Due to the recent changes on vfs interface, some functions in
fs/nilfs2/super.c has room for cleanup like this.

Further, there is a discussion about eliminating the write_super()
callback in LKML.  The function was periodically called from the vfs
layer to induce a writeback of superblock.  It is now deemed not to be
required if a file system handles the timing.  I feel the writeback
control of the superblock should be revised overall for nilfs.

I would appreciate it if you could help me to do the series of cleanup
jobs.

Thanks,
Ryusuke Konishi
 
> ---
>  fs/nilfs2/super.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index b1d992b..52c089f 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -313,9 +313,6 @@ static void nilfs_put_super(struct super_block *sb)
>  
>  	lock_kernel();
>  
> -	if (sb->s_dirt)
> -		nilfs_write_super(sb);
> -
>  	nilfs_detach_segment_constructor(sbi);
>  
>  	if (!(sb->s_flags & MS_RDONLY)) {
> -- 
> 1.5.6.5
> 
> 
