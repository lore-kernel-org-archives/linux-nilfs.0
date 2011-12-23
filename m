From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 7/7] rmcp: print sensible error message on permission
 failure
Date: Fri, 23 Dec 2011 14:56:29 +0900 (JST)
Message-ID: <20111223.145629.123971064.ryusuke@osrg.net>
References: <1324503249-17432-1-git-send-email-dan@archlinux.org>
	<1324503249-17432-8-git-send-email-dan@archlinux.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324503249-17432-8-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 21 Dec 2011 15:34:09 -0600, Dan McGee wrote:
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
>     lt-rmcp: 30: cannot remove checkpoint: Operation not permitted
>     lt-rmcp: 31: cannot remove checkpoint: Operation not permitted
>     lt-rmcp: 32: cannot remove checkpoint: Operation not permitted
>     lt-rmcp: 33: cannot remove checkpoint: Operation not permitted
>     lt-rmcp: 34: cannot remove checkpoint: Operation not permitted
>     lt-rmcp: 35: cannot remove checkpoint: Operation not permitted
> 
> Since May 2009 the kernel has returned EBUSY instead of EPERM for
> removal requests against snapshots, commit 30c25be71fcbd87fd. We should
> be able to treat EPERM as expected now, as the commit message there
> indicates.
> 
> Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
> ---
> 
> This does introduce a behavior change as well- we no longer exit the range loop
> immediately on an error code, instead we continue the loop and attempt to
> delete the rest of the checkpoints in the range. Objections to this? I'm not an
> expert by any means.
> 
>  bin/rmcp.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/bin/rmcp.c b/bin/rmcp.c
> index 780a192..3c5c184 100644
> --- a/bin/rmcp.c
> +++ b/bin/rmcp.c
> @@ -105,7 +105,7 @@ static int rmcp_remove_range(struct nilfs *nilfs,
>  			nd++;
>  			continue;
>  		}
> -		if (errno == EBUSY || errno == EPERM) {
> +		if (errno == EBUSY) {

OK, let's stop regarding the EPERM error as EBUSY.  For most kernels,
it's more important to distinguish real permission errors from the
snapshot removal error.

We have only recently bumped the version of nilfs-utils to 2.1.x from
2.0.x.  It's a good opportunity for this change.

>  			nss++;
>  			if (!force) {
>  				fprintf(stderr,
> @@ -115,14 +115,16 @@ static int rmcp_remove_range(struct nilfs *nilfs,
>  		} else if (errno == ENOENT) {
>  			nocp++;
>  		} else {
> -			fprintf(stderr, "%s: %s\n", progname, strerror(errno));
> +			fprintf(stderr,
> +				"%s: %llu: cannot remove checkpoint: %s\n",
> +				progname, (unsigned long long)cno,
> +				strerror(errno));
>  			ret = -1;

> -			goto out;

Could you revise this ?

I think the loop should abort immidiately when the rmcp meets an
important error even though it will change behavior for the real
permission error.

Thanks,
Ryusuke Konishi

>  		}
>  	}
>  	if (!force && (nss > 0 || (nocp > 0 && nd == 0)))
>  		ret = 1;
> - out:
> +
>  	*ndeleted = nd;
>  	*nsnapshots = nss;
>  	return ret;
> -- 
> 1.7.8
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
