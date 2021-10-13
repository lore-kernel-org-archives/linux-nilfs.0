From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 29/29] udf: use sb_bdev_nr_blocks
Date: Wed, 13 Oct 2021 12:47:27 +0200
Message-ID: <20211013104727.GJ19200@quack2.suse.cz>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-30-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1634122047;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=3iVmoGzS1CFC1ZYp5GIospF+GcEKdIrbvLtreROQEfY=;
	b=rXel6gwbSuBhNp51al563AO6FS+XBZGOh/Hjm+BJIWuWOyU/3AT5rJWXw07dBi66Lgwd4D
	ooX5FTPfl/pC0Td0V4J2NhW4+JnUKlh9zrRP1nHxExJjHSCOfj8B/qV2wki4afni9YWLzI
	rwBdjQuKJBSvHiqfDFKdm53Pp8cWtVg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1634122047;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=3iVmoGzS1CFC1ZYp5GIospF+GcEKdIrbvLtreROQEfY=;
	b=pxc3ajuVJ6QppWl3+pNc7cHhWSy4VS/lmsQeRbZ/ZEMgrJnYBtPjQ3jjf0R56GrDxVMQsV
	jv2YKpSzp52reSBQ==
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-30-hch-jcswGhMUV9g@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso>

On Wed 13-10-21 07:10:42, Christoph Hellwig wrote:
> Use the sb_bdev_nr_blocks helper instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
