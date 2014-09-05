From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: add a tracepoint for tracking stage
 transition of segment construction
Date: Fri, 05 Sep 2014 10:40:43 +0400
Message-ID: <1409899243.4164.6.camel@slavad-CELSIUS-H720>
References: <1409884917-21440-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=y1xA4DKWwJ0/35WvgxmrKi2Nyk55x8fOwBIt7iPqgx8=;
	b=VyhyQUXeazBelmZh3AmWxjMRE1fiMe0o86iSObQbUdXak/g7FI+2zAH20Vj/sxMaZt+07AoeSSHpMLCGsQv2RasoQtqZPYqLZbYkH+AgiCPKgjBpOLd3Prbrkz+bIH/W;
In-Reply-To: <1409884917-21440-1-git-send-email-mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, 2014-09-05 at 11:41 +0900, Hitoshi Mitake wrote:

[snip]
> diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
> index 38a1d00..1e9b931 100644
> --- a/fs/nilfs2/segment.h
> +++ b/fs/nilfs2/segment.h
> @@ -66,13 +66,14 @@ struct nilfs_recovery_info {
>  
>  /**
>   * struct nilfs_cstage - Context of collection stage
> - * @scnt: Stage count
> + * @__scnt: Stage count, must be accessed via wrappers:
> + *          nilfs_sc_cstage_inc(), nilfs_sc_cstage_set(), nilfs_sc_cstage_get()
>   * @flags: State flags
>   * @dirty_file_ptr: Pointer on dirty_files list, or inode of a target file
>   * @gc_inode_ptr: Pointer on the list of gc-inodes
>   */
>  struct nilfs_cstage {
> -	int			scnt;
> +	int			__scnt;

It doesn't make sense this change for my taste. As far as I can judge,
you've made this change because scnt field should be accessed by means
of wrappers. But __scnt name doesn't provide from direct using this
field. So, I suppose that extended comment will be enough.

By the way, do you plan to add tracepoints for another NILFS2
subsystems?

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
