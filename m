From: fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org
Subject: Strange "flush" process bahaviour
Date: Tue, 13 Nov 2012 00:19:08 +0400
Message-ID: <50A159BC.9060600@li.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello!
Some time ago I've noticed, that "flush" kernel process associated with 
device running nilfs2 filesystem, generate huge amount of IO activity 
(using 100% CPU time). "iotop" utility show speeds about 5-15 GB\S on 
that "flush" process, but no actual disk activity happens.
This condition lasts about 1-2 minutes, and then it stops for some time 
(usually 10-20 minutes).

Is this a normal behavior ? I'm using kernel 3.6, and nilfs running on 
luks-encrypted partitions, that belongs to software raid-1 array.

//Sorry for my English

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
