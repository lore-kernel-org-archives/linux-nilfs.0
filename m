From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: simple file system cleanups for the new bio_alloc calling conventions
Date: Sat, 26 Feb 2022 07:18:55 -0700
Message-ID: <164588513511.8353.16195805858154505642.b4-ty@kernel.dk>
References: <20220222154634.597067-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=YLa//Mj+DxSVB6ps7DGXFT54Z3VfJ89NQIGANWGG0d8=;
        b=4ZL0rPQtivoPekslBbHbwd4MefOSslZozUIbdtrwySGfwrmJgBc+4NYFds5wDTHm4t
         2becxLEhcY0AudOFZ4Leuds9nQWinUKLxN6SxVY8v/DeIiB7zFc+sge2xTZt7HZ22E4c
         wI8SYLYmz84xi4a9xzyzJHo9eCJMOD1cjl7Bb1Nv4I02Ks91P50Txh6GFwxAX+nN/N2O
         4a3u/5VfFZioKhCo+T586yBD3Fo6GXnd1mbYw8bBPJ4/YmkfAFihTXT5w4NyzBoo6HyQ
         98T2uukeyBcSTCwQEyXQsaWbpdGz1EsLyNLehoM9MUUXu2vWcjMBduc3+jxZEqlAQhXS
         njbA==
In-Reply-To: <20220222154634.597067-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 22 Feb 2022 16:46:31 +0100, Christoph Hellwig wrote:
> this fixes up the remaining fairly trivial file system bio alloctions to
> directly pass the bdev to bio_alloc.  f2fs and btrfs will need more work and
> will be handled separately.
> 
> This is against Jens' for-5.18/block branch.  It would probably make sense to
> also merge it through that.
> 
> [...]

Applied, thanks!

[1/3] mpage: pass the operation to bio_alloc
      commit: 8020990b8e1be0b4e325371ccb45a427acbabf9e
[2/3] ext4: pass the operation to bio_alloc
      commit: 6a9856721a18208a50c826ed84b3665c4851dfe8
[3/3] nilfs2: pass the operation to bio_alloc
      commit: 91f6bd2d4d0aa91abf11b5780221d776f30cbac1

Best regards,
-- 
Jens Axboe


