From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 08/20] mm: ensure that we set mapping error if
 writeout() fails
Date: Mon, 24 Apr 2017 08:24:38 -0700
Message-ID: <20170424152438.GH9112@infradead.org>
References: <20170424132259.8680-1-jlayton@redhat.com>
 <20170424132259.8680-9-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=yhVxFenIgPub/w/35qpJsH+EleYVEBaF1uzR5/OHDEM=; b=OHLDoaOBqefMvXFxS7fEX4q2s
	xyM3R7XxfG+BF2Lqf4AQ0rx1truUpzqjKNy5GKy45S6+zS2zSMejr80e5fY5Hhfv7RUYQDzMKi5fi
	7dP9lxpzlrw9pD5qAUuH/bEozxYgykcaA9HWJ3bDNHrsjXKsoo6ONZuCzydAD9t/Qo8vDzbrqlduU
	ti08b+gYNKI0Lwa+59Q7Xmm56zTwqAbPxLQgVVUxmno15QJ2uZbFGXXVaewFS5hwZ5OYkDJF0uV2i
	sMHr++LFzd0s4tyA/Btn2+mxF4uxXVcZgMLsEFU3MsHSXzxJ0nA2zHeXRNyoUHGFPHPxDNMIQZVgD
	D+4YFHIOg==;
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-9-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
