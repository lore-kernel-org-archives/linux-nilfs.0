From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/29] fs: simplify init_page_buffers
Date: Wed, 13 Oct 2021 12:42:07 +0200
Message-ID: <20211013104207.GD19200@quack2.suse.cz>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-10-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634121729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z4HqZyTEwS9Rcr4e8FrndT8Yotl846xcwxeeXUm/Rbw=;
        b=hfTvKDs9tMBALqogMul26UufXr/UDrQs6fQ2xFqJlV4HsPz2oyF/rJyg+bH01us42OgEr/
        gQBKJJBLlltruRPrBFfyACC1OK0Ft4NyUMSfl4pAJ3vBBVqgnncaUQShaZ1/INd0ZXBrCL
        clnKG5sWnOV98zZG/GDtQEKojpj+iI4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634121729;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z4HqZyTEwS9Rcr4e8FrndT8Yotl846xcwxeeXUm/Rbw=;
        b=viBbxLVUsu9I5SCs9Ro+b7QEHFxldjR3jplEXmW7M5M5jUxvO7kpggYe/iz58HOLGzWfYy
        3YAfJdO+WIda7fAA==
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-10-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.ker

On Wed 13-10-21 07:10:22, Christoph Hellwig wrote:
> No need to convert from bdev to inode and back.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
