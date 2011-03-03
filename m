From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 1/8] lscp: support opening mounted filesystem by
 directory pathname
Date: Fri, 04 Mar 2011 01:15:11 +0900 (JST)
Message-ID: <20110304.011511.83301246.ryusuke@osrg.net>
References: <20110302.232110.169818198.ryusuke@osrg.net>
	<1299156472-4707-1-git-send-email-dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299156472-4707-1-git-send-email-dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Thank you for posting this series.  I'll queue it up in
nilfs-utils-devel tree.

By the way, may I add your "Signed-off-by:" line to these patches?

FYI, you can do it yourself as follows:

 1) Register E-mail address and user name to ~/.gitconfig:

   $ git config --global --add user.name "dexen deVries"
   $ git config --global --add user.email "dexen.devries@..."

 2) Convert the series to separate patches

   $ git format-patch -o <work-directory> <branch-base>..<branch-head>

 3) Apply the series with sign option

   $ git checkout -b <new-branch-name> <branch-base>
   $ git am -s <work-directory>/*.patch


Usually, we add a sob line with "git commit -s" when committing each
patch.

Thanks,
Ryusuke Konishi


On Thu,  3 Mar 2011 13:47:45 +0100, dexen deVries wrote:
> ---
>  bin/lscp.c |   32 +++++++++++++++++++++++++++-----
>  1 files changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/bin/lscp.c b/bin/lscp.c
> index df9a0af..a9be26e 100644
> --- a/bin/lscp.c
> +++ b/bin/lscp.c
> @@ -28,6 +28,14 @@
>  #include "config.h"
>  #endif	/* HAVE_CONFIG_H */
>  
> +#if HAVE_SYS_TYPES_H
> +#include <sys/types.h>
> +#endif	/* HAVE_SYS_TYPES_H */
> +
> +#if HAVE_SYS_STAT_H
> +#include <sys/stat.h>
> +#endif	/* HAVE_SYS_STAT_H */
> +
>  #include <stdio.h>
>  
>  #if HAVE_STDLIB_H
> @@ -324,12 +332,14 @@ int main(int argc, char *argv[])
>  {
>  	struct nilfs *nilfs;
>  	struct nilfs_cpstat cpstat;
> -	char *dev, *progname;
> +	struct stat statbuf;
> +	char *dev, *dir, *pathname, *progname;
>  	int c, mode, rvs, status, ret;
>  #ifdef _GNU_SOURCE
>  	int option_index;
>  #endif	/* _GNU_SOURCE */
>  
> +	dev = dir = NULL;
>  	mode = NILFS_CHECKPOINT;
>  	rvs = 0;
>  	opterr = 0;	/* prevent error message */
> @@ -384,15 +394,27 @@ int main(int argc, char *argv[])
>  		fprintf(stderr, "%s: too many arguments\n", progname);
>  		exit(1);
>  	} else if (optind == argc - 1) {
> -		dev = argv[optind++];
> +		pathname = argv[optind++];
>  	} else {
> -		dev = NULL;
> +		pathname = NULL;
>  	}
>  
> -	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDONLY);
> +	if (pathname) {
> +		ret = stat(pathname, &statbuf);
> +		if (ret == -1) {
> +			fprintf(stderr, "%s: cannot open %s: %s\n",
> +				progname, pathname, strerror(errno));
> +			exit(EXIT_FAILURE);
> +		}
> +		if (S_ISDIR(statbuf.st_mode))
> +			dir = pathname;
> +		else
> +			dev = pathname;
> +	}
> +	nilfs = nilfs_open(dev, dir, NILFS_OPEN_RDONLY);
>  	if (nilfs == NULL) {
>  		fprintf(stderr, "%s: %s: cannot open NILFS\n",
> -			progname, dev);
> +			progname, pathname);
>  		exit(EXIT_FAILURE);
>  	}
>  
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
