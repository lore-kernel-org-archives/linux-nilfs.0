From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Tue, 24 Aug 2010 04:30:28 -0400
Message-ID: <20100824083027.GA27594@infradead.org>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <20100824074844.GH3948@amd>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100824074844.GH3948@amd>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 24, 2010 at 05:48:44PM +1000, Nick Piggin wrote:
> The reason I broke nilfs2 is because it duplicates a lot of the
> generic inode initialisation code. This really should go in core
> code because nilfs2 does not own the generic inode fields.
> 
> It just needs some helper function to do the non-sb related init
> stuff for you.

No, the problem is much deeper than that.  Having inodes outlive
superblock is fundamentally broken.  All that crap simply needs
to go away.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
