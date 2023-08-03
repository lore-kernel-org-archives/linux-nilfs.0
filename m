From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 08/12] fs: export fs_holder_ops
Date: Thu, 3 Aug 2023 20:15:34 +0200
Message-ID: <20230803-hergibt-nachzahlen-296067ae0bb8@brauner>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-9-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691086541;
        bh=Yz12o17pxjfv8UNlGb+RqV6iHvHIX5yYabFhIVcGnJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NzNzQ0kZIAWvy0jQWijO38E4IFU1ELuOTm+2z0/vri0vio9s55oaqAQUbTAugZAIc
         pzSwoiINevuBV/XhzNXc0q3NFdO0ZzAFSLxi3cGXgl3HAJB+X2Uh/r/FdNfEqxzs+x
         oEq7YaNNZC/rU+FCceLfXnczQ2a6sngVIJgi7nDzGkT1xBRDxTdPkZIen5+avgHd07
         8LXZzFT3Mn8qRcc0ic5S1kmXh1ScTSp3TgroiVqjyefr1jttGt6WWRWdWDbRFCjKZx
         XR0/Ri/7v2mM1CSXfr+YKoex1c07NyImzjyMt49SbRHVJ4+fuKehgj3MggKmlENRpl
         ceZJCjJnHL38w==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-9-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Wed, Aug 02, 2023 at 05:41:27PM +0200, Christoph Hellwig wrote:
> Export fs_holder_ops so that file systems that open additional block
> devices can use it as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
