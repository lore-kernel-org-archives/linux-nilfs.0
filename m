From: Chaitanya Kulkarni <Chaitanya.Kulkarni-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 05/17] block: use an on-stack bio in
	blkdev_issue_flush
Date: Tue, 26 Jan 2021 19:15:02 +0000
Message-ID: <BYAPR04MB4965E6615D7173005E4C634586BC9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
	d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
	t=1611688507; x=1643224507;
	h=from:to:cc:subject:date:message-id:references:
	content-transfer-encoding:mime-version;
	bh=KNUDY51cFN89cFLkxV84w9yHk/E66+9qddWBN8QDq9w=;
	b=pP0AgalHkfiMEDWkKCigde1WbklIN2AhSpRW+fshwyJqNFG9ebJ7eEQ5
	7ecF88neUs9/+c1GXHbjQZXp2ys3jQDqoohcj2kPEfBGrMq1qfVdpLaAt
	ArvaT9soNcUMJIyWLZRTHc+U1UxfR1A+S6wul+s6+hKEEVQ7KHf8Xoqbc
	xIRB5lrR2BC80hncZkSGSM8FQusI+85HR8mR0+qOJ1wi4fIuPeX2XJxg2
	2fNvTOaPgq+6irSBCTWy+G7e9vEu4oDpaHzCln9PnYG/a4GUOFSTBIaDQ
	zxMRDDnVvYIHA0mfDOWrU4q06csbJyVQ2fpVstODB6PcCq6ewzxKYZrN5 w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com; 
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=KNUDY51cFN89cFLkxV84w9yHk/E66+9qddWBN8QDq9w=;
	b=FQuF/oxOCpteS65+OEJYNhD4SLodAeq84LUWNm+payTM0LKZIvCujeLwmkPO6okCD+L3w01zJjQh21wtlrSqWbj7MG72Ork3CQ0fYh7nWD4qR8uBkhWPrD0qTJqzc3ee/A66GnkicBo+jmCHpWfvFx5wEfyvhjD6QtUf8+4wVMQ=
Content-Language: en-US
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
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Damien Le Moal <Damien.LeMoal-Sjgp3cTcYWE@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryusuke-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Philipp-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Naohiro Aota <Naohiro.Aota-Sjgp3cTcYWE@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-

On 1/26/21 7:07 AM, Christoph Hellwig wrote:
> There is no point in allocating memory for a synchronous flush.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

True, looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni-Sjgp3cTcYWE@public.gmane.org>
