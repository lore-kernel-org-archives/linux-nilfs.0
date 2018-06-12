From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v13 00/72] Convert page cache to XArray
Date: Tue, 12 Jun 2018 04:31:22 -0700
Message-ID: <20180612113122.GA19433@bombadil.infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
 <20180612104041.GB24375@twin.jikos.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kCJ7AWirobGh2Zm8TEC48kzMvT41UnudiQ0reX4UUcI=; b=LC0v2tgjJerxdiJ825b9lMbb6
        52Z1i98sLxNo/AOLPu+39+JOUKRJ3h8W9KzyIxK4RJLigW3O9iVe+VqNgoxkuvgpZ5XZP/exV3S0O
        OxtbzEcByp5HdUZMQfetJ7iEAKZQZOS3QS9KgY7wB10OVdOXjIRSWFqUYkVpqv1XnjSXe1XgoYjjS
        4Wg4BF2rLGRHxAfKQEx/jkfloM3Ri8usxdDMnJTJoMtAcU0sUgVhXZZ7CRmL8jlrrF6V7v060SafP
        jPfTrEZa5vG6ow4S96SYLZNjIQlKi8dK5dXCW47zXwcegIbYWUEn4HgY9ymqhRUkdsDTa5UQmsb6R
    
Content-Disposition: inline
In-Reply-To: <20180612104041.GB24375@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dsterba@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

On Tue, Jun 12, 2018 at 12:40:41PM +0200, David Sterba wrote:
> [ 9875.174796] kernel BUG at fs/inode.c:513!

What the ...

Somehow the fix for that got dropped.  I spent most of last week chasing
that problem!  This is the correct code:

http://git.infradead.org/users/willy/linux-dax.git/commitdiff/01177bb06761539af8a6c872416109e2c8b64559

I'll check over the patchset and see if anything else got dropped!

