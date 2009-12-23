From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 02/12] nilfs2: Storage class should be
 before const qualifier
Date: Wed, 23 Dec 2009 23:55:59 +0900 (JST)
Message-ID: <20091223.235559.25155531.ryusuke@osrg.net>
References: <1261573067-8673-1-git-send-email-tklauser@distanz.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1261573067-8673-1-git-send-email-tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Wed, 23 Dec 2009 13:57:47 +0100, Tobias Klauser wrote:
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.
> 
> Signed-off-by: Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>

Applied. Thank you!

Ryusuke Konishi

> ---
>  fs/nilfs2/ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index f6af760..d6b2b83 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -480,7 +480,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  				      unsigned int cmd, void __user *argp)
>  {
>  	struct nilfs_argv argv[5];
> -	const static size_t argsz[5] = {
> +	static const size_t argsz[5] = {
>  		sizeof(struct nilfs_vdesc),
>  		sizeof(struct nilfs_period),
>  		sizeof(__u64),
> -- 
> 1.6.3.3

On Wed, 23 Dec 2009 14:01:05 +0100, Tobias Klauser wrote:
> > Subject: Re: [PATCH 02/12] nilfs2: Storage class should be before const
> >	qualifier
> 
> Sorry, this should jsut have been [PATCH], not [PATCH 02/12]. The
> remaining patches are not targeted at nilfs.
> 
> Cheers, Tobias
