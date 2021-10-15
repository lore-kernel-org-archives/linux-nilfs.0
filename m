From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 12/30] btrfs: use bdev_nr_bytes instead of open coding it
Date: Fri, 15 Oct 2021 15:52:47 +0200
Message-ID: <20211015135247.GD30611@suse.cz>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-13-hch@lst.de>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634305993;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XE1Zr0WGvW2BDyQXJdIRIiNu9IGR6oole7AChDGbfow=;
        b=FkrOYMCvwR1WV8YcSADck0o3TXEJmoIrrStNwAyJqd5gJtxOKI0CvnGjbCGyMxwd1yNCeH
        zEBVH7sdh2t2qaGhwsLNHOqdjz5oxqFduSjyptxcsRk7M3YKn/qvXYLrh+ZrHNjtfMqSoR
        o2Vcyhzm0y0ABVfIcRluaAPS8AtvIcI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634305993;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XE1Zr0WGvW2BDyQXJdIRIiNu9IGR6oole7AChDGbfow=;
        b=lur2cVP0ZZIUagJCcyCSi3a/9FA4e33CHIEO/wJi1ldSGsZcWVqbr1pPLn6NfTVCjleY7d
        /71NcgdcrKDA81BA==
Content-Disposition: inline
In-Reply-To: <20211015132643.1621913-13-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kern

On Fri, Oct 15, 2021 at 03:26:25PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

Acked-by: David Sterba <dsterba@suse.com>
