From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 03/29] dm: use bdev_nr_sectors instead of open coding it
Date: Tue, 12 Oct 2021 23:10:10 -0700
Message-ID: <202110122310.36F4C08@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-4-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HKDYpp4YSVsNULamooLUjhsr3ltG6/c66elTMRrkKgQ=;
        b=NoF0hG29o29DKsntYKpCXV92mD6h6EMom48z8tQzSN8FHu905ky+Xz3bE0nNtk4PY1
         0HNqwx/qtRzx7vXjuatnB9t9z2CQvezADG+ChrPjw5Rsdx9XyUR9gAFLAQnuxS6pqLaj
         euLxlv/sHfBVUNSEFnk9jxaM9RIcQ1jZpnz4Y=
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-4-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Wed, Oct 13, 2021 at 07:10:16AM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
