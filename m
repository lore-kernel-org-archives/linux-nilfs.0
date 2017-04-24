From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 03/20] buffer: use mapping_set_error
 instead of setting the flag
Date: Mon, 24 Apr 2017 08:22:50 -0700
Message-ID: <20170424152250.GC9112@infradead.org>
References: <20170424132259.8680-1-jlayton@redhat.com>
	<20170424132259.8680-4-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com AE9A53D96D
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com C804A80E7B
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209;
	h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yhVxFenIgPub/w/35qpJsH+EleYVEBaF1uzR5/OHDEM=;
	b=HlpzGkDKdwXUj9408CFw9ZQCb
	KUDf+yzulwSZqUUk6eumxJW7QXuVmXX/y5oq5T7ACYaN5tiG0e8HlLyzvbhTXNpiwSlzLcg07tcnW
	5Fw6iH6sKbd1VpcPts/9v5DtwIQEaA5mxnjJx7EZXDzLkphjY7+yVqETVkU5Ex/j0eb4yIfaH1CzX
	R8PRFSQzwqcVaY2iDDx2OPkGdjpBWpR4jRrB3uVeFNqShKYWdKFe0sFbS/jpzfMcvc3awF9nLr40k
	gIPdHldxm24U8h1l3lXPRnR84dGRUICuV2adZn2mIY6M3pBNcUb5fzstH9khwAUSl2sZKK4IwBkZZ
	SC8Z+klVA==;
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-4-jlayton@redhat.com>
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

