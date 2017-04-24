From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 06/20] dax: set errors in mapping
	when writeback fails
Date: Mon, 24 Apr 2017 08:24:06 -0700
Message-ID: <20170424152406.GF9112@infradead.org>
References: <20170424132259.8680-1-jlayton@redhat.com>
	<20170424132259.8680-7-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com A65C323E6CB
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 2F90E80F93
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209;
	h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yhVxFenIgPub/w/35qpJsH+EleYVEBaF1uzR5/OHDEM=;
	b=GwXebVG2vI8ZeU/uvVu5NoPC/
	spnRF2021Vbvgqibfsxo2ST8L1RRCmFvXJbv/YKChZJRK06JHrjHyTV/l+jDRI7lGvSatGHMiD9LV
	0FnFpCm9OaaQOeBhmMxoiZACmfXbdRT6CPE9UvtucAsZD9ByXiVBs7y6eGLSbjY5cvcQLlK+WI/tQ
	MvUCSGnd7tztrZH99FyBRiFuu+mcP8YsPb26VEPSq6eirYV9lXc6X20mWHY/Q+2v31YKgUAm4JS6J
	MA94goZ5RLc+SIRMPP7O/qeWM4lG5gqM3SudqE6cEiTfnM2vy0iCq27qKfxOEh3HRC2WPJRpUTvW/
	bQ0cncwpg==;
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-7-jlayton@redhat.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: jfs-discussion@lists.sourceforge.net, neilb@suse.de, dhowells@redhat.com, linux-mm@kvack.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, corbet@lwn.net, cluster-devel@redhat.com, v9fs-developer@lists.sourceforge.net, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, linux-block@vger.kernel.org, osd-dev@open-osd.org, axboe@kernel.dk, tytso@mit.edu, clm@fb.com, mawilcox@microsoft.com, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jack@suse.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

