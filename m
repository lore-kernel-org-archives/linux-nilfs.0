From: Zeke Rondel <zeke-iuD2ETIrjQqsTnJN9+BGXg@public.gmane.org>
Subject: Small device
Date: Thu, 10 May 2012 00:33:30 +0100
Message-ID: <1336606410.14957.140661073496877.75A2D273@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=mailup.net; h=
	message-id:from:to:mime-version:content-transfer-encoding
	:content-type:subject:date; s=mesmtp; bh=cA+d1EnJa0gqnZ4cD1dqtvs
	GHfU=; b=qRA3qrqRJ3vAgK5sk3D6P+DbHp1xGhQGrVoOI0t5+6GYUNtF53er9OJ
	Hm9y6iBdaCSFtpf5cIcKYLE8cHR1N5sDboxHmvhpMqowFGNANOvI4caIJARKC1QI
	NWC6r+RED4ze23FrbDVkv++e+v4y4VMpROByeS7KCEhi4Jo7cKZY=
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=message-id:from:to:mime-version
	:content-transfer-encoding:content-type:subject:date; s=smtpout;
	 bh=cA+d1EnJa0gqnZ4cD1dqtvsGHfU=; b=BB6JWsTURiLUks+RmfJI8Pq7Frpz
	R3a8xFlJdX8HxYshMUh2uPkm3pU2GBtdb1OvnZFWiRomsl+azoTl9Rk9GHUIDkAJ
	rX12lXGq9Epa/MhWkPq47xvgWAp0BoBG6b2lEtghHT9pcSBnKNwQUxypau3kuHla
	cLc3PgbFopFXnSE=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I've a small memory card (SD) of 64MB used for keys related to crypto.
stuff so I need a log filesystem that avoids the data can be re-written
or modified. Is NILFS suitable in case of little devices? If so, which
size of blocks per segment would be suitable for it? Thanks in advance!
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
