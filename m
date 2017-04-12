From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 19/25] nilfs2: Convert to properly refcounting bdi
Date: Wed, 12 Apr 2017 01:17:46 -0700
Message-ID: <20170412081746.GS9830@infradead.org>
References: <20170329105623.18241-1-jack@suse.cz>
 <20170329105623.18241-20-jack@suse.cz>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hkzcISUYlL8SoJwlOSZ8q3/hOl+mjcegInK2bmD7O5k=; b=EvayHxN662vdDb361ObC72KPi
        R9xslBYDRIhbyzbKDYM0nwT0XZ1aeePCy94dOKxfsCNq4ohxRgG20ebuQlxpjRCz45EnA5AJi5pU5
        mN7T+ma/F/A6rACD6ekz8kw5uKB72nzq0A+u5PijP+NpvBkvmgsO6azNa0EklUhOqjm6dU4ihZZAE
        HWOv3XCbv9p3+KhDpZ10lWD1PHUehsS/zBn9FmUnLFCe966mOyLZNfvVE1KiL9juyWl/DatwluvPm
        i5k3AoJ9WoshL2lnJthgxaQeJBQlK5aHBJ2k9QdrhzmgPoRFJElYOvoIQ7R0StIeqJ0sQza/IkCKD
    
Content-Disposition: inline
In-Reply-To: <20170329105623.18241-20-jack-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 29, 2017 at 12:56:17PM +0200, Jan Kara wrote:
> Similarly to set_bdev_super() NILFS2 just used block device reference to
> bdi. Convert it to properly getting bdi reference. The reference will
> get automatically dropped on superblock destruction.

I really wish we could get rid of this open coding in block based
file systems..

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
