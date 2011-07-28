From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: How to restore snaspshot in nilfs?
Date: Thu, 28 Jul 2011 10:25:36 +0900 (JST)
Message-ID: <20110728.102536.53123850.ryusuke@osrg.net>
References: <BLU152-W53BCFBB71148893681289CE350@phx.gbl>
	<BLU152-W1990E7DAA23E5566FC3925CE350@phx.gbl>
	<BLU152-W567E135957B79607CC415ECE350@phx.gbl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BLU152-W567E135957B79607CC415ECE350-MsuGFMq8XAE@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: notstop-EMRzualFZlQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 27 Jul 2011 23:19:34 +0200, ffffd sssd wrote:
> Given several checkpoints, from 1 to 14, and those corresponding to
> 7, 10, 11 and 14 are snapshots, how can I revert the entire
> filesystem to the stage 10, for example, discarding all the newer?
> The only way I've found is to mount the snapshot 10 separately, copy
> to another disk the contents, format the nilfs and copy back again
> from the temporal disk to the nilfs...

Nilfs does not have a native revert function yet.  So, you need to
synchronize the current mount point with a snapshot as follows:

 # mkdir /nilfs /snap
 # mount -t nilfs2 /dev/xxx /nilfs
 # mount -t nilfs2 -o ro,cp=10 /dev/xxx /snap

 # rsync -axv --delete /snap/ /nilfs/


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
