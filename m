From: ffffd sssd <notstop-EMRzualFZlQ@public.gmane.org>
Subject: RE: How to restore snaspshot in nilfs?
Date: Wed, 27 Jul 2011 23:19:34 +0200
Message-ID: <BLU152-W567E135957B79607CC415ECE350@phx.gbl>
References: <BLU152-W53BCFBB71148893681289CE350@phx.gbl>,<BLU152-W1990E7DAA23E5566FC3925CE350@phx.gbl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BLU152-W1990E7DAA23E5566FC3925CE350-MsuGFMq8XAE@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Given several checkpoints, from 1 to 14, and those corresponding to 7, 10, 11 and 14 are snapshots, how can I revert the entire filesystem to the stage 10, for example, discarding all the newer? The only way I've found is to mount the snapshot 10 separately, copy to another disk the contents, format the nilfs and copy back again from the temporal disk to the nilfs...

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
