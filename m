From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Work around uncleanable full filesystem
Date: Tue, 15 Jan 2013 17:57:21 +0400
Message-ID: <1358258241.2094.9.camel@slavad-ubuntu>
References: <1358178899-26347-1-git-send-email-sven@narfation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=tC4iCcMBvyUMdXN9JJptTxoS3Q3wmQyj8mJE5fEaMGM=;
	b=nv9rMMGHVeKG3JyHwnoq0gq3acjLh2SRIEbh0xIj9NR9bfnH+IJRFWYdrXRz0KpJ9Ufpkn4QruASs2yCw/rIAx0zb4f10WrvOQcTo+92GXzGd0iPNSj6vehjUAKl52lL;
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

Unfortunately, currently, I can't reproduce the issue. All works fine on
my side.

Could you share more details about your environment? What version of
nilfs-utils do you use?

Maybe do you have some NILFS2-related error messages in your system log?

Or, maybe, reproducing path is more complex as you described?

With the best regards,
Vyacheslav Dubeyko.



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
