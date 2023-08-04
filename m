From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 09/12] ext4: drop s_umount over opening the
 log device
Date: Fri, 4 Aug 2023 16:34:50 -0400
Message-ID: <20230804203450.GD903325@mit.edu>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-10-hch@lst.de>
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
 bh=eb93p14LbhHMq9VAU9FSt+DcSUdrlvW15TyYmjztiqQ=; b=cE7vU45XPsF8Me1M4Z5GbRJSx2
 s0olRvnXiT3XPMYKik/qCIxtEWMrKwF2KIfHdlxvMUI1EWGKWfH+wAx4O2cGAwC5a8Vt21T2wSVwP
 2ALOdWdFzIeyCzzQo+Of9JKmQOUcZfK9NA5m0DDRfPEw+e2LDgRQqrV/PFhTWeidZzGE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=eb93p14LbhHMq9VAU9FSt+DcSUdrlvW15TyYmjztiqQ=; b=YVgj0JC14nq5u+tqXAWiySbCXp
 lkJ7oiQtSBiE9fHumr/C8pteMG76SmugN9B2ARZV/2MzNpNiqTG8W2FEYoIC1E6UxpqDEmBUyw7wI
 fuH7cAVbgczVgphAKzMClnOyOfsrN99EsIjTuHEMSrJfkf8aX5K7eO73XCJ8tXHFfsvs=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
 t=1691181294; bh=eb93p14LbhHMq9VAU9FSt+DcSUdrlvW15TyYmjztiqQ=;
 h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
 b=Cmbci/Vas57W7Gs1mmt04uOthaR1e+rzdGz6ITDOXZ7ar1BUIxuloHDQosTWOCKWI
 iB56bnyujn38Bh0Bp8Z9EdtMGK5JGqwP/Dc9817D37D5RzTjBcqX7HfyweGFQEIlNc
 BVs1/MrxyUeyzFJS766n80HD2+PFuYOP4G3VM8zfAxBDEfh2gwQRvXgsgqIMcMc0wN
 OtpY0Qeymqh8HbDn2ZQVvOacBb7LkX38rsikz68ioX6wllgIiRTX9csEEqK5ZCQd2m
 kHOKMhSYpzYpG5XePqQ01RloNzfxpmSlLpaGQE5i8Tm2KMJbuA8zWdXQJfaXrlAorq
 d89+IyylQf2+A==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-10-hch@lst.de>
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

On Wed, Aug 02, 2023 at 05:41:28PM +0200, Christoph Hellwig wrote:
> Just like get_tree_bdev needs to drop s_umount when opening the main
> device, we need to do the same for the ext4 log device to avoid a
> potential lock order reversal with s_unmount for the mark_dead path.
> 
> It might be preferable to just drop s_umount over ->fill_super entirely,
> but that will require a fairly massive audit first, so we'll do the easy
> version here first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Theodore Ts'o <tytso@mit.edu>
