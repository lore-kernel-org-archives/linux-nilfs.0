From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/10] f2fs: Convert
 f2fs_invalidate_compress_pages() to use filemap_get_folios()
Date: Wed, 8 Jun 2022 01:03:39 -0700
Message-ID: <YqBX23zzkYAkZcty@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-6-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RK8Xp72T5lkf7UuehHLsjFoDi+
 GX4mTxtWcGGxDm9ZbR9b4pCbSrnafNbrl4+M/n9p9tOcfgabuFPF0rQ+hYUWYqjHpRY3wih3EHIns
 prV1Cr0fxc6NB9qznxMF4fa5BQY44HGQ9xFLCk/+DAvIO+6+CKVIlgum7CS9Zc6HHvj8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hcoznC6Z1fVJVk26w5E9KSozLs
 nXjaj3BaX8b2qd8lzx8C4UPV7Tu4PkouXWlZMIcJlFMjt3D13QlHNgmj0bGOJuUFE3v6cCkO2LCP+
 tgBTuNloPg0ltbs5EFL2peoA2VpCTcPXiYijsvrVwcJxZYY1pgY0eOSqsV1SyqGCBUHQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ETGyWJmiVwl8uakzt6P4V+CU2A
 G94sm1P++WCgbDigiam9tX5SkQ0ieLw5fLJDSl6Z4lAT67M8VRyXCg96za4TLKnvfyJL/oNNep9yb
 dlGqJMk2irV5SIRfGuVkQlACUCtWUy4F2Zrr9XJoYbRvD/Gf/muV6R6I5KWIer/FIatDgdLhyfGAy
 RLSEiUPbWKPNRrvLf72fJzjbTXcnaOV0un4Nv4LP8mfLNiOwgI0leoYZMCPyMScgezsmat3Crd7NS
 myCTQwyfvkACIZw4oiUY7hIMFuXTPaMl6e+BNQv6a3fmXMcNNOkER0uA4JlVrpJuNotPUsNHgTQ/b
 Sa5gDe4Q==;
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-6-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
