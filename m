From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Work around uncleanable full filesystem
Date: Tue, 15 Jan 2013 11:14:17 +0400
Message-ID: <1358234057.2105.12.camel@slavad-ubuntu>
References: <1358178899-26347-1-git-send-email-sven@narfation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=zpefEzqFpQ8YIg1WkIuTjiNwcxzm6Tzc3SiU3LM9lFk=;
	b=T6yLWNB8H8mfso9/p8u2bEcJzhehWaWgeiE6Q+yQfdvNPj6p0wet8mpvBwD5tucosnSQwv/lH1AaJ3LbmfuBA4LfAPfVP5Cu+tgeOfcT3i8H4sTdflSTI8beDfcY1bNX;
In-Reply-To: <1358178899-26347-1-git-send-email-sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2013-01-14 at 16:54 +0100, Sven Eckelmann wrote:
> The filesystem can end up in a state were the filesystem is full and the
> returned ss_nongc_ctime is smaller than sui_lastmod of all reclaimable
> segments. The garbage collector will not clean anything and therefore no new
> room for new files will be available and ss_nongc_ctime/sui_lastmod will not be
> updated without using special tools. This makes the filesystem unusable without
> manual recovery.
> 
> Signed-off-by: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
> --
> This problem appeared on a current 3.2 stable kernel (Debian Wheezy build). I
> am not an FS developer and have therefore not much background knowledge about
> the NILFS codebase. Nevertheless, this problem hit me quite hard after creating
> some files on a nilfs partition until it was full and deleting them again.
> 
> $ for i in `seq 0 150`; do dd if=/dev/zero of=foo$i count=22528; done
> $ rm foo*
> 
> Looking at the output debugging output using
> 
> $ watch -n .5 'df -h;tail /var/log/syslog;'
> 
> clearly showed that it was not finding any segments to delete. The only problem
> I could find was the threshold. After "removing" this threshold, I was able to
> get some clear segments again. I personally cannot explain why the check is
> there at all. Maybe there is a good reason but the comment above it didn't help
> much.
> 
> So, here for completeness the threshold: 1358164666 (aka: Mon Jan 14 12:57:46
> CET 2013)
> 
> And here are the output of lssu and lscp:
> 
> $ lssu --all
> SEGNUM        DATE     TIME STAT     NBLOCKS
> 0  2013-01-14 12:58:23  -d-        2047
> 1  2013-01-14 12:58:23  -d-        2048

[snip]

> 
> Signed-off-by: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
> ---
>  sbin/cleanerd/cleanerd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
> index bfcd893..12ed975 100644
> --- a/sbin/cleanerd/cleanerd.c
> +++ b/sbin/cleanerd/cleanerd.c
> @@ -592,7 +592,7 @@ nilfs_cleanerd_select_segments(struct nilfs_cleanerd *cleanerd,
>  	 * selected. */
>  	thr = (config->cf_selection_policy.p_threshold != 0) ?
>  		config->cf_selection_policy.p_threshold :
> -		sustat->ss_nongc_ctime;
> +		~0ULL;
>  

As I understand the code of nilfs_cleanerd, this code is correct without
your changing. The ss_nongc_ctime is the creation time of the last
segment not for GC. When thr is set then it compared with sui_lastmod.
The sui_lastmod is the timestamp of last modification. So, the
nilfs_cleanerd works right.

I think that this is a bug on the kernel side. My current vision is that
in some environment the ns_nongc_ctime can be not updated correctly. So,
you have such threshold that prevent from segments clearing.

Thank you for the issue report.

With the best regards,
Vyacheslav Dubeyko.

>  	for (segnum = 0; segnum < sustat->ss_nsegs; segnum += n) {
>  		count = (sustat->ss_nsegs - segnum < NILFS_CLEANERD_NSUINFO) ?


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
