From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Cluster-devel] [PATCH 00/35 v1] pagevec API cleanups
Date: Thu, 1 Jun 2017 04:36:04 -0700
Message-ID: <20170601113604.GA10829@infradead.org>
References: <20170601093245.29238-1-jack@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=29SBSR+7TTw5fuD+gKvrBSS8CTPmK2cPr0p15NiRhZY=; b=OEtCjBlfbe5WaViiKzlO60KKN
	r3uTjHlA+01jvEYEiUljurMPxlX3oI4OYi6wJLRKA3+Vpj6ocyCvu23G/aih28iL/Ja2cD7ty2Yal
	8D9NTmL+2Hlxr2CZ102lBZyje5qqHgG6k0Il4nMGKvQtB1mDJVQ2JQ5a5wR4Ll7YGPQ/hESRTNnTm
	7jyxD+SVFghGxDVElG0UAHKqGWOvlarj5ulRymTaHLoeQ5uNwmgZ45/IY4DcX0TN7uM77NNaN+MJU
	RXExw+zP8Ry//WqbpN3zZ4SHX/2+zOgcIPZ18cGWZ9nRYUtP7ZF77XyJBbGk20sgNLAjh9puiW6bB
	BHuVatf3A==;
Content-Disposition: inline
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, tytso@mit.edu, linux-xfs@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Hugh Dickins <hughd@google.com>, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, David Sterba <dsterba@suse.com>, ceph-devel@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Jaegeuk Kim <jaegeuk@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Thu, Jun 01, 2017 at 11:32:10AM +0200, Jan Kara wrote:
> * Implement ranged variants for pagevec_lookup and find_get_ functions. Lot
>   of callers actually want a ranged lookup and we unnecessarily opencode this
>   in lot of them.

How does this compare to Kents page cache iterators:

http://www.spinics.net/lists/linux-mm/msg104737.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
