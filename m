From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/2] nilfs2: add nilfs_sufile_trim_fs to trim clean segs
Date: Mon, 17 Feb 2014 13:27:33 +0900 (JST)
Message-ID: <20140217.132733.480322001.konishi.ryusuke@lab.ntt.co.jp>
References: <cover.1392470644.git.andreas.rohner@gmx.net>
	<02d463460388a9bdc1413aa4d6fdfa5a402b9452.1392470644.git.andreas.rohner@gmx.net>
	<20140217.120000.397306175.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140217.120000.397306175.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 17 Feb 2014 12:00:00 +0900 (JST), Ryusuke Konishi wrote:
> Hi Andreas,
> On Sat, 15 Feb 2014 14:34:25 +0100, Andreas Rohner wrote:
>> +	    segnum >= nilfs->ns_nsegments ||
> 
> This is bad too, because userland programs usually don't know the
> segment structure of NILFS.  When we specify the partition size to
> range->len, FITRIM can fail due to this check.
> 
> The upper limit of (range->start + range->len) should be
> the block device size.

I mistook for this.  segnum was the start segment number, so what
we should do was:

 - Return -EINVAL in ioctl side if range->start is larger than the
   block device size.
 - Escape this function without an error setting range->len to zero if
   segnum >= nilfs->ns_nsegments.

And, range->len should not be limited by the device size because it is
set to ULLONG_MAX by default.  We have to accept larger range->len
values.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
