From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/10] vmscan: Add
 check_move_unevictable_folios()
Date: Wed, 8 Jun 2022 01:07:32 -0700
Message-ID: <YqBYxNPu3tLiN5kI@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-9-willy@infradead.org>
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
 bh=FHe9QWtfqKLPf3liBV9b4YYysNdz6TJZPv2RlJSFNxo=; b=kHQpC9LElVWi9Vpa8O0DcuU42X
 PsvpYPabFvS26rp1R0NzBV3HliAfbTL3uD1MrHrQio0MHdzXcKFyRMfx9Qx33qu32b6b0U4YLsHte
 TM0sfh4unjvGshvL8mRQXEvOa0wTwRpveTKPDzqIhG1BDI/apXLiP2fCvr7tKneI2NYo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=FHe9QWtfqKLPf3liBV9b4YYysNdz6TJZPv2RlJSFNxo=; b=e64ymClBN6QBYl3HP+Fc/LI+lb
 dKg5dJOVDy0CTEodcM6c215j4httbKyYquVnmRnpgzqMJDHnE/JpOqWiG9x6p9qp0fiLnOpoqIxwi
 +5H4Ar7LfUdIhOuQyjH+2zZkAiwMt4j0zNAO/StEHcTcvq+nfemwlM4AWdCzeliF5TSQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=FHe9QWtfqKLPf3liBV9b4YYysNdz6TJZPv2RlJSFNxo=; b=rE8eAy8BnhO/uz/cOPnx8UhjAN
 oMvGKU56FernoImgpfLlk3BQh/CFcJRA4pawK69Hf0XfMgy7iNdxfJX1EO/aZC0ILffliqDfLrcv1
 mK9DeJH7OGatXD2YCTu+PsPPGT0W70LT5ii/RbRa1Jdfc1XZU8eOfnFRyejMASzpxhKqQnWsphP9b
 T+QQZKswmqu4Y84dTJy0wevs5sCY40Lii8Swq45uCU+6S053j8cyNLCKL3jVIYDAQThxi54ACP5g+
 ft1Jg5kECbmCdG40aX933ZgsA1UwamOP4geUlHX/USfvpuQaaqivpAgnSN89ea/zPtqMOGHXjCFx6
 OVoTk0Lg==;
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-9-willy@infradead.org>
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

On Sun, Jun 05, 2022 at 08:38:52PM +0100, Matthew Wilcox (Oracle) wrote:
> Change the guts of check_move_unevictable_pages() over to use folios
> and add check_move_unevictable_pages() as a wrapper.

The changes here look fine, but please also add patches for converting
the two callers (which looks mostly trivial to me).
