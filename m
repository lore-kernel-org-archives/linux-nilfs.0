From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 06/12] fs: use the super_block as holder when
 mounting file systems
Date: Thu, 3 Aug 2023 15:33:30 +0200
Message-ID: <20230803133330.dstks7aogjogqdd5@quack3>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-7-hch@lst.de>
 <20230803115131.w6hbhjvvkqnv4qbq@quack3>
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
 bh=du0Z70X155ISlaXGxW4wp6Y48mig4odO4voIGMDl2xk=; b=N3N04QrDa5fBLIbE6Mt1iH7F+E
 OxJt+22flyd2kg11xlitJ2O9LyLbjQ6z87nht7jOqhODLNauiq1f6RxiQ4dUPzhkGGlbO6LxsQZPj
 KPS6XAprBYAkTo+MohKH57T9n6D8amx0YGcPWdC3y+RawPEyGwj1K6Szr+AmvfCoIEdE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=du0Z70X155ISlaXGxW4wp6Y48mig4odO4voIGMDl2xk=; b=jU9GmnDoLuww181mxNJTwBOXFA
 BqmRw/7W6eiQyL3LVi4hHkMdohHATR9LmiBgx8XubXp1FgGqA2fVpT7VBYUIJ1SLBGC8kj/Tl5oD1
 id5vRMbIoym0rwjM4m7EU2vlv2WpXbqMmoe2TUXQE/Ftt9VDVhtD4pdJReGz+IeGovx4=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1691069611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=du0Z70X155ISlaXGxW4wp6Y48mig4odO4voIGMDl2xk=;
 b=WSThLGh5TEJlC2zqxUr829BXGh9BB964D/DpAf80OivGVyDFjKi8qi3yL2jZmX2XVxeHql
 0TKeSDcOHnYIT4J24RhGZYydOnwkzEiWP2/UykyXLONZlsOKV3dQWpzTpXbJZJZ88qyNor
 7GCVNVcrD3BsRADBFqYCtXRYyEu/TnI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1691069611;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=du0Z70X155ISlaXGxW4wp6Y48mig4odO4voIGMDl2xk=;
 b=bFFXY2fQpz4y83Dou+dieZJmMgc/fDw9xHqvionrKHFPePEk3QgCOGG9fcv6pv8LVaYKVs
 6FTlW6XPrhE8WQAQ==
Content-Disposition: inline
In-Reply-To: <20230803115131.w6hbhjvvkqnv4qbq@quack3>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, Jaegeuk Kim <jaegeuk@kernel.org>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-btrfs@vger.kernel.org

On Thu 03-08-23 13:51:31, Jan Kara wrote:
> On Wed 02-08-23 17:41:25, Christoph Hellwig wrote:
> > The file system type is not a very useful holder as it doesn't allow us
> > to go back to the actual file system instance.  Pass the super_block instead
> > which is useful when passed back to the file system driver.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Nice, this is what I also wanted to eventually do :). Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

As a side note, after this patch we can also remove bdev->bd_super and
transition the two real users (mark_buffer_write_io_error() and two places
in ocfs2) to use bd_holder. Ext4 also uses bd_super but there it is really
pointless as we have the superblock directly available in that function
anyway.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
