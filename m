From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 05/12] ext4: make the IS_EXT2_SB/IS_EXT3_SB
 checks more robust
Date: Thu, 3 Aug 2023 20:10:25 +0200
Message-ID: <20230803-zecken-oberhalb-e30c55d66648@brauner>
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
 bh=Q7SObbTF1yfGSH6tv6wtRCFB84lk2kXVjxLa8BAfcQg=; b=MZL9K0+xu+duilDcMKaHllBKSF
 KNC12VyqDiijfdFWSwJfcfebjR0MFoy5fZBhJhJbMECEDX2PCF6qHyUk/7QvxLNZlSoJbwTGcClir
 JxNcr+b7GpUBO1m1zda9etfMtDj0MKqN1O7/FZS3ta57oHFW2T+zNjzyNXX6NfHO3uWY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Q7SObbTF1yfGSH6tv6wtRCFB84lk2kXVjxLa8BAfcQg=; b=ax3NZxzivoH1T7kkkkIIql/Qyc
 O6tsdQE2g669OstllWZJl9l+Jks4mnj7Y6tApu/5EcF3kd1xDtxkKUNXU49VcI5R/Y7THYPZCKa+S
 m5qJzacKaqphnjJPayswGxr96cinC6HfhBNZikn8+lahm+nviz7MuTYjJebPI+ThBcNA=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1691086237;
 bh=l09B4wLLhFie262qfmXA0CveYXOk2JvcJhfIRHAAK4o=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=MfiQ2gN2z2YzxyG/O3d7GtOXWQ2m6fL49xtZB4NWZWBeLVPdsc4kAabQ8itROH1It
 21T7P0djO9aOpJ5WwnCRkrrEtUHf3uKDbJ1mew383Lt/fdb86kisMz4kq2oDhmj+Cm
 qurmwE1LM1WqgSAR9efG5Fq8Jmbkdlj14b21Xuzk8HjcYIDPRI7lsMh0d3Vha5yCln
 hqeMFKrHRptRejegCyC4bSWm4MvvIMFg9H5P/Pc9QiSz1UCps/9lt5Vhh/F+Sfy4Tb
 Nq31kTyt7Nxxjms3i402ilz2UjoNv7r6S2nPEZ6K3nTsNAyvejcB145/0RXS80IINs
 Cqrwcv6sNoi5A==
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, Jaegeuk Kim <jaegeuk@kernel.org>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-btrfs@vger.kernel.org

On Wed, Aug 02, 2023 at 05:41:24PM +0200, Christoph Hellwig wrote:
> Check for sb->s_type which is the right place to look at the file system
> type, not the holder, which is just an implementation detail in the VFS
> helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
