From: Zeke Rondel <zeke-iuD2ETIrjQqsTnJN9+BGXg@public.gmane.org>
Subject: Re: Small device
Date: Thu, 10 May 2012 19:01:55 +0100
Message-ID: <1336672915.6952.140661073861013.227CE5BB@webmail.messagingengine.com>
References: <1336606410.14957.140661073496877.75A2D273@webmail.messagingengine.com>
 <20120511.004222.123644820.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=mailup.net; h=
	message-id:from:to:cc:mime-version:content-transfer-encoding
	:content-type:subject:date:in-reply-to:references; s=mesmtp; bh=
	9P7AwRItWpFJiRUJq1UTwZuNNoQ=; b=LsdSSgcShLY2ydiOS63eLv4fHbp3wG0X
	Xo85hRyK5OLtHby3vQkNiiwqqS8BJudvm3spMvhFT+yjPyr0NqzCcpP1DASmAWEo
	psYUtFFhe40gZBDVJkxBGNpDEpN977huN7KAEVwBlZcIesfs+OC4y382YyoJ3uUM
	UlD7FxcZizI=
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=message-id:from:to:cc:mime-version
	:content-transfer-encoding:content-type:subject:date:in-reply-to
	:references; s=smtpout; bh=9P7AwRItWpFJiRUJq1UTwZuNNoQ=; b=DYJeH
	9xOVoiyBVXbhpM1jSeAXT9hVyA2817p8I3P8NSZ9WmOMTg69OOli+njD/QgUx0zB
	4VuiGLl0otMs1q2G6M9xhq9JanpAiDrQLLYedJQmdogcDEz0YHHpqTH9MsAPBw2k
	QnsgpxhgTNA+ZT+Xor8kJ1eWbxemBhu9NfJ+xk=
In-Reply-To: <20120511.004222.123644820.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 11, 2012, at 12:42 AM, Ryusuke Konishi wrote:
> Hi,
> On Thu, 10 May 2012 00:33:30 +0100, Zeke Rondel wrote:
> > Hi,
> > 
> > I've a small memory card (SD) of 64MB used for keys related to crypto.
> > stuff so I need a log filesystem that avoids the data can be re-written
> > or modified. Is NILFS suitable in case of little devices? If so, which
> > size of blocks per segment would be suitable for it? Thanks in advance!
> 
> Basically NILFS is not designed for small devices.  Its most on-disk
> data items have 64-bit width.  In addition, it's more likely to suffer
> from disk full on such devices due to the copy-on-write nature.
> 
> However, I guess you can use NILFS on 64MB SD card by formatting the
> device with a smaller block size and a smaller number of blocks per
> segment.
> 
> My mkfs format parameter for a 64MB sized device is as follows:
> 
> $ mkfs -t nilfs2 -b 1024 -B 512 <device>
> 
> 
> We may get more disk space overhead for much smaller "blocks per
> segment" because every segment of NILFS needs at least one header
> block.
Using "-b 1024 -B 512", we would get 512 blocks per segment: (1024*512)
/ 1024

Then, what about to use "-B" to 1024 or to 2048 ? So there were lesser
number of full segments in the device.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
