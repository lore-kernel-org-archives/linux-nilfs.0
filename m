From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 05/12] ext4: make the IS_EXT2_SB/IS_EXT3_SB
 checks more robust
Date: Fri, 4 Aug 2023 16:34:23 -0400
Message-ID: <20230804203423.GC903325@mit.edu>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=i+Cv8ZO3I5bUEr/K4+xoZ/gjA4JFPErOdbDf0LaFzCo=; b=fnm6XLYJb0F6ccBnncQVN9wqoP
 0VAT4ZlHmxB3YFhW2s3Z1whKQjqNgkKqRJ4fntiVB0+CF6UPBhN6i/zxJ6PVNtOeKvYKxt44symE/
 zvX7iJjV2hMWjAmV0tv6VRh8vFmJUyjP++GmdZhRDvkugOi/buT2w8E5Itgxge5i2jXk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=i+Cv8ZO3I5bUEr/K4+xoZ/gjA4JFPErOdbDf0LaFzCo=; b=MAz/FHfP8PseclmvphjOULpBi2
 6i8biTZM3qwNVk48EQbaGULZV96ZEWgh1URUEahq3TLubcYvFhod0Mck4ALGkd7AhzTC3dPEsq6Dm
 ybvJ1HNkZuH/K045jNQDMjZvsRo11u5wgYgaFkfQwstG+XGuyv/G7equr0V3Ay1hJTho=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
 t=1691181272; bh=i+Cv8ZO3I5bUEr/K4+xoZ/gjA4JFPErOdbDf0LaFzCo=;
 h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
 b=LhpVy8vBk/XSt8GuwK8JeXWAhbhaGHwiCvogm7byiRopRon8u+Fy2XpuWbDJ/DJqp
 1MMHjMZrvP/bsYQt+4oPnfh3oX7+RXyu/JpuSynvYo8OM1HCFI//PZ6OtV7t48eW1k
 NczmO7BbNuqBpq+Z1Q/3jmfHsAXJRjU74h7ISZ3IYJA5kgGBxhqB59mAzguEkGCU4Q
 Bwd2anIeqw6Ugk0Z9GGvE76JN2snxvF4uJsmny2lVz8LKkRpZ1vWGxJrBJy7Lvy0+7
 VCsPzXGzk5tcsNFAq0U09qFE0XG9yw9L2KHuZ/yc1old2bUvgfhBiWegJLllkThH6J
 DmzoegwwJSRQg==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-6-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-btrfs@vger.kernel.org

On Wed, Aug 02, 2023 at 05:41:24PM +0200, Christoph Hellwig wrote:
> Check for sb->s_type which is the right place to look at the file system
> type, not the holder, which is just an implementation detail in the VFS
> helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Theodore Ts'o <tytso@mit.edu>
