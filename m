From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs_cleanerd: support relative pathnames in arguments
Date: Mon, 07 Mar 2011 11:32:26 +0900 (JST)
Message-ID: <20110307.113226.93467027.ryusuke@osrg.net>
References: <20110304.120604.248913114.ryusuke@osrg.net>
	<1299447018-19088-1-git-send-email-dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299447018-19088-1-git-send-email-dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun,  6 Mar 2011 22:30:18 +0100, dexen deVries wrote:
> canonicalize pathnames of device & directory before daemonize() to support relative pathnames
> 
> Signed-off-by: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  sbin/cleanerd/cleanerd.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)

Thanks.

I applied the patch with a minor amendment.

Ryusuke Konishi
 
> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
> index 1f03cfb..3d58916 100644
> --- a/sbin/cleanerd/cleanerd.c
> +++ b/sbin/cleanerd/cleanerd.c
> @@ -1343,6 +1343,7 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
>  int main(int argc, char *argv[])
>  {
>  	char *progname, *conffile;
> +	char canonical[PATH_MAX + 2];
>  	const char *dev, *dir;
>  	char *endptr;
>  	int status, nofork, c;
> @@ -1406,6 +1407,12 @@ int main(int argc, char *argv[])
>  	if (optind < argc)
>  		dir = argv[optind++];
>  
> +	if (dev && myrealpath(dev, canonical, sizeof(canonical)))
> +		dev = strdup(canonical);
> +
> +	if (dir && myrealpath(dir, canonical, sizeof(canonical)))
> +		dir = strdup(canonical);
> +
>  	if (daemonize(0, 0, nofork) < 0) {
>  		fprintf(stderr, "%s: %s\n", progname, strerror(errno));
>  		exit(1);
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
