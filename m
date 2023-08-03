From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 07/12] fs: stop using get_super in fs_mark_dead
Date: Thu, 3 Aug 2023 20:15:10 +0200
Message-ID: <20230803-umringt-aufprallen-e3adc44d2c75@brauner>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-8-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691086517;
        bh=7WvYC67Xe7oFF+cFC3hBpoW1fSKlO5ncgxOAS6uNu5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M+0H21hPL+ViqgirVBRmgZ4PVVO0IsTWsesv9cA8GHZUL2nO1Jaskrh1hTcb8hJgn
         zcbTF80tO8RHk8SPGrBaIY1HWV9lAP9kNCAvgF90TSNFmKJ61pagPvH2VFoo87Hcb6
         R4MGzUpmn/vOw9saQfSEZSvf4/PMN97ff43Y1NGByYWS7kQY2fYrEvIo6C0QHTG02q
         khnbhGSsGhhH0hk6KEOVJA7QyCJawZo/H8HB+DK7XECpYi8elC4KWWHzdhJoLk80T6
         k6n3yR57Ezm420usiThIMT2fn0n+EuAnrG0tm69k3En+xpEtbBxuMQMsPeRVFWq9as
         HeB02bJmZTTNw==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-8-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Wed, Aug 02, 2023 at 05:41:26PM +0200, Christoph Hellwig wrote:
> fs_mark_dead currently uses get_super to find the superblock for the
> block device that is going away.  This means it is limited to the
> main device stored in sb->s_dev, leading to a lot of code duplication
> for file systems that can use multiple block devices.
> 
> Now that the holder for all block devices used by file systems is set
> to the super_block, we can instead look at that holder and then check
> if the file system is born and active, so do that instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
