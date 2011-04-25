From: Ivan Telichko <itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: zero fill unused portion of super root block
Date: Mon, 25 Apr 2011 05:23:23 +0000 (UTC)
Message-ID: <loom.20110425T071539-581@post.gmane.org>
References: <1303234036-11127-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> If you are still keeping the partition, could you test if the
> following patch makes a difference ?

Patched cleanerd dies with the same error message.

There are more messages in the log if I start nilfs_cleanerd by hand:

  Apr 26 02:54:21 nilfs_cleanerd[4734]: start
  Apr 26 02:54:21 nilfs_cleanerd[4734]: pause (clean check)
  Apr 26 02:54:21 nilfs_cleanerd[4734]: resume (clean check)
  Apr 26 02:54:21 nilfs_cleanerd[4734]: ncleansegs = 244
  Apr 26 02:54:21 nilfs_cleanerd[4734]: 4 segments selected to be cleaned
  Apr 26 02:54:21 nilfs_cleanerd[4734]: protected checkpoints = [69325,69425]
    (protection period >= 1303760661)
  Apr 26 02:54:22 kernel: nilfs_ioctl_move_inode_block: conflicting data buffer:
    ino=97606, cno=281, offset=14, blocknr=3526535, vblocknr=1555981
  Apr 26 02:54:22 kernel: NILFS: GC failed during preparation: cannot read
    source blocks: err=-17
  Apr 26 02:54:23 nilfs_cleanerd[4734]: cannot clean segments: File exists
  Apr 26 02:54:23 nilfs_cleanerd[4734]: shutdown

---

Regards,
  Ivan Telichko

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
