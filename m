From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 2/3] nilfs2: clean up nilfs_write_super
Date: Sat, 18 Jul 2009 01:24:14 +0900 (JST)
Message-ID: <20090718.012414.19435380.ryusuke@osrg.net>
References: <1247821968-31232-1-git-send-email-jir@unicus.jp>
	<1247821968-31232-3-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1247821968-31232-3-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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

On Fri, 17 Jul 2009 18:12:47 +0900, Jiro SEKIBA wrote:
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

By the way, you should add changelog to every patch even if they are
in a series.
 
> ---
>  fs/nilfs2/super.c     |    8 ++------
>  fs/nilfs2/the_nilfs.h |   10 ++++++++++
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index ba69601..55a4359 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -368,17 +368,13 @@ static void nilfs_write_super(struct super_block *sb)
>  
>  	down_write(&nilfs->ns_sem);
>  	if (!(sb->s_flags & MS_RDONLY)) {
> -		struct nilfs_super_block **sbp = nilfs->ns_sbp;
>  		u64 t = get_seconds();
> -		int dupsb;
>  
> -		if (!nilfs_discontinued(nilfs) && t >= nilfs->ns_sbwtime[0] &&
> -		    t < nilfs->ns_sbwtime[0] + NILFS_SB_FREQ) {
> +		if (!nilfs_discontinued(nilfs) && !nilfs_update_super(nilfs,t)) {
>  			up_write(&nilfs->ns_sem);
>  			return;
>  		}
> -		dupsb = sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
> -		nilfs_commit_super(sbi, dupsb);
> +		nilfs_commit_super(sbi, nilfs_update_alt_super(nilfs,t));
>  	}
>  	sb->s_dirt = 0;
>  	up_write(&nilfs->ns_sem);
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index e8adbff..ee448ea 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -201,6 +201,16 @@ THE_NILFS_FNS(DISCONTINUED, discontinued)
>  /* Minimum interval of periodical update of superblocks (in seconds) */
>  #define NILFS_SB_FREQ		10
>  #define NILFS_ALTSB_FREQ	60  /* spare superblock */

A null line should be inserted here.

> +static inline int nilfs_update_super(struct the_nilfs *nilfs, u64 t)
> +{
> +  return t < nilfs->ns_sbwtime[0] || t > nilfs->ns_sbwtime[0] + NILFS_SB_FREQ; 
> +}

The nilfs_update_super() sounds like a function to do update operation
on the super block.

How about nilfs_sb_need_update() or so?

The body of the function looks not to be indented properly.
Please refer to the Chapter 1 of Documentation/CodingStyle.

> +
> +static inline int nilfs_update_alt_super(struct the_nilfs *nilfs, u64 t)
> +{
> +  struct nilfs_super_block **sbp = nilfs->ns_sbp;
> +  return sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
> +}

ditto.

>  void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
>  struct the_nilfs *find_or_create_nilfs(struct block_device *);
> -- 
> 1.5.6.5
> 

And then, this patch has some style problems.  Applying checkpatch.pl
can save a bit of time.

$ ~/git/linux-2.6/scripts/checkpatch.pl nilfs2-clean-up-nilfs_write_super.patch
WARNING: line over 80 characters
#22: FILE: fs/nilfs2/super.c:373:
+               if (!nilfs_discontinued(nilfs) && !nilfs_update_super(nilfs,t)) {

ERROR: space required after that ',' (ctx:VxV)
#22: FILE: fs/nilfs2/super.c:373:
+               if (!nilfs_discontinued(nilfs) && !nilfs_update_super(nilfs,t)) {
                                                                           ^

ERROR: space required after that ',' (ctx:VxV)
#28: FILE: fs/nilfs2/super.c:377:
+               nilfs_commit_super(sbi, nilfs_update_alt_super(nilfs,t));
                                                                    ^

ERROR: trailing whitespace
#42: FILE: fs/nilfs2/the_nilfs.h:206:
+  return t < nilfs->ns_sbwtime[0] || t > nilfs->ns_sbwtime[0] + NILFS_SB_FREQ; $

total: 3 errors, 1 warnings, 35 lines checked

nilfs2-clean-up-nilfs_write_super.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Regards,
Ryusuke Konishi
