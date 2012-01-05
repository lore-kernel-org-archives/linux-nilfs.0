From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] rmcp: print sensible error message on permission
 failure
Date: Thu, 05 Jan 2012 14:14:15 +0900 (JST)
Message-ID: <20120105.141415.16062951.ryusuke@osrg.net>
References: <20111224.162041.267403683.ryusuke@osrg.net>
	<1325619960-9715-1-git-send-email-dan@archlinux.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325619960-9715-1-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue,  3 Jan 2012 13:46:00 -0600, Dan McGee wrote:
> When running as non-root, the error message seems to indicate a
> checkpoint is a snapshot, rather than the actual problem, which is that
> I do not have permission to delete the checkpoints.
> 
> Before:
>     $ rmcp 29..35
>     rmcp: 29: cannot remove snapshot
>     rmcp: 30: cannot remove snapshot
>     rmcp: 31: cannot remove snapshot
>     rmcp: 32: cannot remove snapshot
>     rmcp: 33: cannot remove snapshot
>     rmcp: 34: cannot remove snapshot
>     rmcp: 35: cannot remove snapshot
> 
>     To delete snapshot(s), change them into checkpoints with
>     chcp command before removal.
> 
> After:
>     $ ./bin/rmcp 29..35
>     lt-rmcp: 29: cannot remove checkpoint: Operation not permitted
>     Remaining checkpoints were not removed.
> 
> Since May 2009 the kernel has returned EBUSY instead of EPERM for
> removal requests against snapshots, commit 30c25be71fcbd87fd. We should
> be able to treat EPERM as expected now, as the commit message there
> indicates.
> 
> Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>

All your patches were applied to nilfs-utils git repository.

Thank you very much.

Ryusuke Konishi

> ---
>  bin/rmcp.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/bin/rmcp.c b/bin/rmcp.c
> index 780a192..9f4666a 100644
> --- a/bin/rmcp.c
> +++ b/bin/rmcp.c
> @@ -105,7 +105,7 @@ static int rmcp_remove_range(struct nilfs *nilfs,
>  			nd++;
>  			continue;
>  		}
> -		if (errno == EBUSY || errno == EPERM) {
> +		if (errno == EBUSY) {
>  			nss++;
>  			if (!force) {
>  				fprintf(stderr,
> @@ -115,7 +115,10 @@ static int rmcp_remove_range(struct nilfs *nilfs,
>  		} else if (errno == ENOENT) {
>  			nocp++;
>  		} else {
> -			fprintf(stderr, "%s: %s\n", progname, strerror(errno));
> +			fprintf(stderr,
> +				"%s: %llu: cannot remove checkpoint: %s\n",
> +				progname, (unsigned long long)cno,
> +				strerror(errno));
>  			ret = -1;
>  			goto out;
>  		}
> @@ -237,8 +240,10 @@ int main(int argc, char *argv[])
>  			continue;
>  
>  		status = 1;
> -		if (ret < 0)
> +		if (ret < 0) {
> +			fprintf(stderr, "Remaining checkpoints were not removed.\n");
>  			break;
> +		}
>  
>  		if (force || ndel != 0 || end - start + 1 - nss == 0)
>  			continue;
> -- 
> 1.7.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
