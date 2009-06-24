From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] Implemented nilfs_show_options to display
 mount options in /proc/mounts
Date: Wed, 24 Jun 2009 17:08:57 +0900 (JST)
Message-ID: <20090624.170857.10732213.ryusuke@osrg.net>
References: <871vpa84oq.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <871vpa84oq.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
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
On Wed, 24 Jun 2009 16:35:33 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This is a proposed patch to display mount options in procfs.
> Mount options will show up in the /proc/mounts as other fs does.
> 
> # mount.nilfs2 -o ro,barrier=off,cp=3,order=strict /dev/sda6 /mnt
> # cat /proc/mounts
> ...
> /dev/sda6 /mnt nilfs2 ro,relatime,barrier=off,cp=3,errors=continue,order=strict 0 0
> ...
> 
> thanks
> 
> regards,
> -- 
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Thank you for the patch!

Could you append "Signed-off-by:" field to the changelog?

It is automatically inserted by using -s option when committing
change.

 $ git commit -s

Also, there are a few coding style violations.

Please look at Documentation/CodingStyle file and apply
scripts/checkpatch.pl to verify violations.

Thanks,
Ryusuke Konishi
 
> ---
>  fs/nilfs2/super.c |   31 ++++++++++++++++++++++++++++++-
>  1 files changed, 30 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index ab785f8..123d14f 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -50,6 +50,8 @@
>  #include <linux/writeback.h>
>  #include <linux/kobject.h>
>  #include <linux/exportfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/mount.h>
>  #include "nilfs.h"
>  #include "mdt.h"
>  #include "alloc.h"
> @@ -537,6 +539,33 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	return 0;
>  }
>  
> +static int nilfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
> +{
> +	struct super_block *sb = vfs->mnt_sb;
> +	struct nilfs_sb_info *sbi = NILFS_SB(sb);	
> +
> +	if(!nilfs_test_opt(sbi,BARRIER)) {
> +		seq_printf(seq,",barrier=off");
> +	}
> +	if(nilfs_test_opt(sbi,SNAPSHOT)) {
> +		seq_printf(seq,",cp=%llu",sbi->s_snapshot_cno);
> +	}
> +	if(nilfs_test_opt(sbi,ERRORS_CONT)) {
> +		seq_printf(seq,",errors=continue");
> +	}
> +	if(nilfs_test_opt(sbi,ERRORS_RO)) {
> +		seq_printf(seq,",errors=remount-ro");
> +	}
> +	if(nilfs_test_opt(sbi,ERRORS_PANIC)) {
> +		seq_printf(seq,",errors=panic");
> +	}
> +	if(nilfs_test_opt(sbi,STRICT_ORDER)) {
> +		seq_printf(seq,",order=strict");
> +	}
> +
> +	return 0;
> +}
> +
>  static struct super_operations nilfs_sops = {
>  	.alloc_inode    = nilfs_alloc_inode,
>  	.destroy_inode  = nilfs_destroy_inode,
> @@ -554,7 +583,7 @@ static struct super_operations nilfs_sops = {
>  	.remount_fs     = nilfs_remount,
>  	.clear_inode    = nilfs_clear_inode,
>  	/* .umount_begin */
> -	/* .show_options */
> +	.show_options = nilfs_show_options
>  };
>  
>  static struct inode *
> -- 
> 1.5.6.5
> 
