From: Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 07/17] f2fs: use blkdev_issue_flush in
 __submit_flush_wait
Date: Fri, 29 Jan 2021 09:03:57 +0800
Message-ID: <a36e80ab-20b5-47db-7e20-6ac1c7fc4517@huawei.com>
References: <20210126145247.1964410-1-hch@lst.de>
 <20210126145247.1964410-8-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 MIME-Version:Date:Message-ID:From:References:CC:To:Subject:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=MOFhdxVwN1frM25Y/F48/QUoEnQnAOz4O6+GkDU3ylg=; b=A1PSVwL/BV+crZT6F/JkK/dHSU
 4J2eqz2nAe9fszKpcy8u2aRYkjXcQ8IAOY4/Vtnn7vfhykoHWhTKED01OKinUJAvA/4URs6QqAiUy
 z7HCEie+lpGWv1F7VShZgRlyUulxtfdVglICsIcqn59jDkJfu6jkaVXuarLmUS6qpmTI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
 Message-ID:From:References:CC:To:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=MOFhdxVwN1frM25Y/F48/QUoEnQnAOz4O6+GkDU3ylg=; b=XkFvSdnws+u7+fnD066lW5bndz
 Y17hoP/Ct1EM+jfB2JPvFC0YCAZ5/mS7F+SGT6PNc5ScIeIMZcyd5pvKOjsS/XWiRwBodMP3hQD0T
 EyOtXe4UV8SJd2GHqvCrBP6IeV6WULiK2nsND0oVqa9Xc5F6TN5q607ycEn3USv2ot/0=;
In-Reply-To: <20210126145247.1964410-8-hch@lst.de>
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Naohiro Aota <naohiro.aota@wdc.com>, linux-nilfs@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Damien Le Moal <damien.lemoal@wdc.com>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Coly Li <colyli@suse.de>, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, Philipp Reisner <philipp.reisner@linbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-btrfs@vger.kernel.org

On 2021/1/26 22:52, Christoph Hellwig wrote:
> Use the blkdev_issue_flush helper instead of duplicating it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chao Yu <yuchao0@huawei.com>

Thanks,
