From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/25] fs: Provide infrastructure for dynamic BDIs in
 filesystems
Date: Wed, 12 Apr 2017 01:09:28 -0700
Message-ID: <20170412080928.GD9830@infradead.org>
References: <20170329105623.18241-1-jack@suse.cz>
 <20170329105623.18241-5-jack@suse.cz>
Mime-Version: 1.0
Return-path: <ecryptfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3ZzByIiCCKOeKzhHg7A++DyUhFjB5BlR1xFscOLQ7hc=; b=FhAFL8P0nJKIra1EQ/jOKBrU+
        fzYPtI2w/BShgT0KEW8BkL0WyuOKViGkXgk4zL79hzcUGGPm5y9pTHXAfLizXLof39bFxeqhhYEL9
        C085ylb8Q8g1MKlOBfuOL6Qko11m4bwvhWiwRvecvh+BxUSgU3FTfXGuZFwL4wOLbmTHiz4yX6WE6
        gc1Z5zm//5Y1ix5a6aZTILxPyMpUWypBiX9RGt4SwF4bszOJb3TX1E6LElZffdduYlBkNtBr55WUn
        Twj2Hxedo+znKSJzLUZ+I6cX3jTc+6YrF9HB3IqxU+gCu4yNaM1DN5dTbn5qIGT7Zxnbb4fnhoGqO
    
Content-Disposition: inline
In-Reply-To: <20170329105623.18241-5-jack@suse.cz>
Sender: ecryptfs-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org, Petr Vandrovec <petr@vandrovec.name>, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, osd-dev@open-osd.org, codalist@coda.cs.cmu.edu, linux-afs@lists.infradead.org, ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, v9fs-developer@lists.sourceforge.net, lustre-devel@lists.lustre.org

> +	if (sb->s_iflags & SB_I_DYNBDI) {
> +		bdi_put(sb->s_bdi);
> +		sb->s_bdi = &noop_backing_dev_info;

At some point I'd really like to get rid of noop_backing_dev_info and
have a NULL here..

Otherwise this looks fine..

Reviewed-by: Christoph Hellwig <hch@lst.de>
