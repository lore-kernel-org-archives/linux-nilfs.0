From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 01/23] pagemap: Add
 filemap_grab_folio()
Date: Mon, 24 Oct 2022 20:38:08 +0100
Message-ID: <Y1bpoF9Flds1tHdl@casper.infradead.org>
References: <20221017202451.4951-1-vishal.moola@gmail.com>
 <20221017202451.4951-2-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666640724;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=rWeKahqjg8VAD1dtAEhE4rortSi/MmENxoyZPPFT3KA=;
	b=C9SU0RromkVqludgQcTwuHy9gbqUtyFPB+CE+00UfaZQc/04pqooXagJfnJfX8Zc37enwg
	1kxXEDmuFTPO4wqbSzYEkZx7Dud7Rp50okNQEYSXIxAviJrWQZYZKakilc6qehGrzRLm3+
	rKya9XdqHMEC2ah7Th8b25/Nrkgw+q8=
In-Reply-To: <20221017202451.4951-2-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Mon, Oct 17, 2022 at 01:24:29PM -0700, Vishal Moola (Oracle) wrote:
> Add function filemap_grab_folio() to grab a folio from the page cache.
> This function is meant to serve as a folio replacement for
> grab_cache_page, and is used to facilitate the removal of
> find_get_pages_range_tag().

I'm still not loving the name, but it does have historical precedent
and I can't think of a better one.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

