From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 06/12] fs: use the super_block as holder when mounting
 file systems
Date: Sat, 5 Aug 2023 10:36:17 +0200
Message-ID: <20230805083617.GB29780@lst.de>
References: <20230802154131.2221419-1-hch@lst.de> <20230802154131.2221419-7-hch@lst.de> <20230803115131.w6hbhjvvkqnv4qbq@quack3> <20230803133330.dstks7aogjogqdd5@quack3>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230803133330.dstks7aogjogqdd5@quack3>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 03, 2023 at 03:33:30PM +0200, Jan Kara wrote:
> As a side note, after this patch we can also remove bdev->bd_super and
> transition the two real users (mark_buffer_write_io_error() and two places
> in ocfs2) to use bd_holder. Ext4 also uses bd_super but there it is really
> pointless as we have the superblock directly available in that function
> anyway.

I actually have a series to kill bd_super, but it uses b_assoc_map
as the replacement, as nothing in buffer.c should poke into the holder
and the buffer_head codes uses b_assoc_map a lot anyway.  Let me rebase
it and send it out.
