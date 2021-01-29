From: Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 08/17] f2fs: remove FAULT_ALLOC_BIO
Date: Fri, 29 Jan 2021 09:04:17 +0800
Message-ID: <3301f2da-60c5-79ca-ab3b-0fe3345f0731@huawei.com>
References: <20210126145247.1964410-1-hch@lst.de>
 <20210126145247.1964410-9-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 MIME-Version:Date:Message-ID:From:References:CC:To:Subject:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ROV6mYn4UcvrSDwduTMP74gdjx4Z+1oL2rm9DnUsNUQ=; b=MmHnOlLvXs99GgR8AkyYTe1nBt
 PdzDfdEQNJHkOGoeLh1E0vrrHmHath/H7YUdzCknwDxGmaU7IW3B9weUQKgLE7sR1b/Vn5A7KpFv+
 THre8tAhfVwATfGEtK5c4paDKiMv46cEdsCjOK8B5FM+2LhG4/iLbzRim8cIFdP4q4+g=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
 Message-ID:From:References:CC:To:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ROV6mYn4UcvrSDwduTMP74gdjx4Z+1oL2rm9DnUsNUQ=; b=ljIeL2fJZGx5urAZiFkTRJpLDy
 9PpHc+o0299R+QHUveTFYXXJf9wuVYZrxxg3L7UvnAg0opW3zodwMsyDoM20GXCSIFIpOOi6JRAIH
 4FzR6hZld58/JQZ9OMtXXkkMHNzRwvD7drUgGv1QvUmhYcbA5V4LBT6q42vre+vbZvRc=;
In-Reply-To: <20210126145247.1964410-9-hch@lst.de>
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
> Sleeping bio allocations do not fail, which means that injecting an error
> into sleeping bio allocations is a little silly.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Acked-by: Chao Yu <yuchao0@huawei.com>

Thanks,
