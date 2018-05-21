From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v11 51/63] dax: Fix use of zero page
Date: Sun, 20 May 2018 22:25:34 -0600
Message-ID: <20180521042534.GA27043@linux.intel.com>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-52-willy@infradead.org>
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
 bh=sPur5FTUESoHoTjSiN5b4cETyvnScdH/8zu/FFD9DCU=; b=R8VDZ5mGXKXB8iqNA8D5MsBSch
 zu+4ZoWqa2Ldrrya1fp7Wk7EhfbdDAcGBK565/wMjOGgwcuOONdnHGBP/g2K9BYv0FfbBEL9fcgB9
 +2dSyQfX2l7cYbeRSPkXylaDptt+mlkRIfhgztYYqPUYDENQDm3X8tZgMZMIFyIWBGe0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=sPur5FTUESoHoTjSiN5b4cETyvnScdH/8zu/FFD9DCU=; b=muEb8Rein57a8FgKm5L4+k7atH
 TdQFjs1srVAhrRRGsjP6opYXgsBu2WpeBcMHGs8BqAxG/IJKigkpwbItg7J1X2/fITw3hmOj5g3Ma
 cdcA9x35Mvvaot4KWnxsUXa7Odr6CaBW0652y4do/vGN7+ljmOm/9OmUrYtOmfpcgFFA=;
Content-Disposition: inline
In-Reply-To: <20180414141316.7167-52-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

On Sat, Apr 14, 2018 at 07:13:04AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Use my_zero_pfn instead of ZERO_PAGE, and pass the vaddr to it so it
> works on MIPS and s390.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

Feel free to add my:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

To this version as well if you keep this patch in the larger series.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
