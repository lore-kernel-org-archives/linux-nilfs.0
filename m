From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Tue, 24 Aug 2010 11:32:14 -0400
Message-ID: <20100824153214.GA25897@infradead.org>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <20100824074844.GH3948@amd>
 <20100824083027.GA27594@infradead.org>
 <20100824.215823.121933465.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100824.215823.121933465.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 24, 2010 at 09:58:23PM +0900, Ryusuke Konishi wrote:
> Actually, I recently wrote a patchset to unify all super block
> instances on one device into one sb, which makes the inodes outlive
> superblock eliminable.

Yes, that's how we handle things everywhere, including btrfs with
it's subvolumes and snapshots.

> But the patchset has a problem that it cannot shrink a number of
> versions of namespace when unmounting all snapshots and a current time
> instance.

Can you explain the issue in more detail?

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
