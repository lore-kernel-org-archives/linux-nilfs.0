From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 12/30] btrfs: use bdev_nr_bytes instead of open coding it
Date: Fri, 15 Oct 2021 09:59:35 -0700
Message-ID: <202110150959.D3A3EBD2DD@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-13-hch@lst.de>
Mime-Version: 1.0
Return-path: <reiserfs-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KeY5Iupdn4Pa1b1ywzkz23CB7y+Fa3Cfufu6RZZIPYI=;
        b=VfHpzO3tYcRdDu0YlVkKzx/ciItoc9jkR356sB11SejVmPNb6TbARwblxJNv77Pw+N
         f8l5X6Xk6dZ16M5aIo4oyfynzDADoHwHbbl+nEWOg/Hpm3DtdjVVH1S12Q1eI7nmyOz6
         dWXhnsHrWbhYXafHG9GJqGCTKk1oPJdLtiQOs=
Content-Disposition: inline
In-Reply-To: <20211015132643.1621913-13-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Oct 15, 2021 at 03:26:25PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
