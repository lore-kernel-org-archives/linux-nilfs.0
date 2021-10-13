From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 28/29] reiserfs: use sb_bdev_nr_blocks
Date: Wed, 13 Oct 2021 12:46:15 +0200
Message-ID: <20211013104615.GH19200@quack2.suse.cz>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-29-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-scsi-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634121975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ReBJ39FQSq2Ri4gzsf/9HN/2AQLJSHkmbvHM+1gQDU=;
        b=Bs0jLE6dW9R2XV5QAW5PANZfFI55neOv68yBXHDkKdpWkALHM8icU9xbSzdfnCREFrZMct
        3+2oN3aeDktCUFxEHYH/VXi16HIjV43KTI+7DyCyp9zZ7xbHI93O8kiQ8PoweiysaY4pPN
        UPyCFVv7pjQ3km4/YPlTqSGByM6p0LI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634121975;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ReBJ39FQSq2Ri4gzsf/9HN/2AQLJSHkmbvHM+1gQDU=;
        b=r7uHZ7+0iVupNri72uYOV4o6jxkgpR8stOFMA8jxvLfFR9bxkjnCTl3Cs+7eA7SAyqgiLY
        muVAi/A9MWKYZLDw==
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-29-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.ker

On Wed 13-10-21 07:10:41, Christoph Hellwig wrote:
> Use the sb_bdev_nr_blocks helper instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
