From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/29] block: Make blkdev_get_by_*() return
	handle
Date: Mon, 28 Aug 2023 15:20:47 +0200
Message-ID: <20230828-durften-hauswand-67319ee0c17c@brauner>
References: <20230810171429.31759-1-jack@suse.cz>
	<20230825015843.GB95084@ZenIV>
	<20230825134756.o3wpq6bogndukn53@quack3>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693228864;
	bh=QtirhpZ6M4wRBs0PcZuQKaZInNnIQCord7zI9oR3eYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dGzUUvJG87+eWzsz6xzROYCBNDl7W5LTOJNZSdrdj6kC4UZhu/D9tYCBTY1kzrQPe
	x7WILXB1VLYusnI7i57xbkDNp7AlezoIITxDEYtPZbpKeaRaDjmpnSpx19pqxTzCO1
	eHWv5jG6Kk405k0HzfGlQ5FnGrphH6RQF/qbsChQZpHtUi1E5k/RJY2W8E0veW1Pw4
	WmlHIAC8kSpEcFeEGWLjHX2ee4G742ubGUZGwha6A7RHD325wN5SUYbEQ3omUMFDG/
	CM1aA/cNlMXqkEYlHa/Phek8pvPKy4SQPmUA3IhuobWAQwG6yFUbEhG6jgGYrQO+H2
	J9dq9/E4F2ZeQ==
Content-Disposition: inline
In-Reply-To: <20230825134756.o3wpq6bogndukn53@quack3>
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
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Gao Xiang <xiang-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Borntraeger <borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sven Schnelle <svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Snitzer <snitzer-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joern Engel <joern-o6zPIXG8fmPj4SYmN/TMmA@public.gmane.org>, reiserfs-devel-u79uwXL29TbrhsbdSgBK9A@public.gmane.org

> So besides my last fput() worry about I think this could work and would be
> probably a bit nicer than what I have. But before going and redoing the whole
> series let me gather some more feedback so that we don't go back and forth.
> Christoph, Christian, Jens, any opinion?

I'll be a bit under water for the next few days, I expect but I'll get
back to this. I think not making you redo this whole thing from scratch
is what I'd prefer unless there's really clear advantages. But I don't
want to offer a haphazard opinion in the middle of the merge window.
