From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v11 52/63] dax: dax_insert_mapping_entry
 always succeeds
Date: Sun, 20 May 2018 22:33:15 -0600
Message-ID: <20180521043315.GB27043@linux.intel.com>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-53-willy@infradead.org>
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
 bh=MmjQbubd2M6MTQfN7Ri69AebD2iF10HivTsao17qdy0=; b=Hl8196ozDLdu6yS+R1vGuZeP5q
 4EDxgXzgjqwa7NvRkPKERIQcguKPD1cuRXpnSjNDqqsBCEUW6B1JrFi0n0UCDHg3ZifRTAqeQM1GA
 ZwWeaGsraPKYyY5kAS8OtO61ngDFMybsAX5oxT0gXNtsDGimXHMUj6OzeodVnR73dSBk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=MmjQbubd2M6MTQfN7Ri69AebD2iF10HivTsao17qdy0=; b=PtD5zRJUsW7fv7Ckoo022wT6l7
 ensnuvaDn15P/rcKGH3vmT9DcfBq2Le3CWeK6gY7zDsEgZfOBzLi4+qzc73UlkhDP/vPkech53EYB
 SEM6HfIwtAj8POTzx40oXnOKN8Cq+NL4GMuON1Pa5keLKzaIYiKZZozu+/9pwe/moEmI=;
Content-Disposition: inline
In-Reply-To: <20180414141316.7167-53-willy@infradead.org>
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

On Sat, Apr 14, 2018 at 07:13:05AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> It does not return an error, so we don't need to check the return value
> for IS_ERR().
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

Yep, this looks correct to me.  You can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
