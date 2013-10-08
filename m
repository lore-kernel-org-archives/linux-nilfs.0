From: ggeorgiev-75tzoU7t5/k@public.gmane.org
Subject: Is it possible to avoid nilfs2 corruption on power loss
Date: Mon, 07 Oct 2013 22:57:53 -0400
Message-ID: <14aacfe4a690e434f9f49401ddd6c1be@znet.ca>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=znet.ca; h=
	user-agent:message-id:subject:subject:from:from:date:date
	:content-transfer-encoding:content-type:content-type
	:mime-version:received:received; s=dkim; t=1381201083; x=
	1383015484; bh=vD/131aE78UC1ewFaFS9zlkz+tPd+Y60qZQIMA2UrG0=; b=f
	uuolFlHm60Agsfzxu5BK/M/cA9BFhJIwFZT8yiiJIezlni3zuOrYmalC4BijhLRU
	kzh5iupPyULXNfzxoRQzLTWOzrDoS4CGVEOWrw44uKTiVbzIp32E3q/BwpgRrafC
	zMQkO8rpKxF0Q8/tT4KYss/a4oOdsq8GA8GHGRx5/E=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello everyone,

I am in a situation where I need a way to make a practically 
incorruptible file system upon power loss. I know I can make this with a 
read-only fs + aufs + tmpfs, but it looks that nilfs2 may do this alone.

Situation: I have few friends/clients whom I give a Raspberry Pi (RPi) 
with XBMC (actually, Xbian) for a home theatre. The RPi is powered by 
the TV USB port, and when the TV goes down, the PRi loses power. The 
/boot and / file systems are read only; that can be done. The /home 
however has to be writable - users may (rarely) change some 
configuration there. So, I put a nilfs2 there. The fs is ~7G on a 8G SSD 
card, full < 10% and almost no writes come ever.

What I need is the fs to never crash in such conditions. One idea to 
guarantee consistency is, I think, upon power on to mount an old 
checkpoint - say, 1-2 checkpoints back from the log end. It does not 
matter if the last written data is lost.

I have no conclusive data, but my tests with random power pull-of show 
very good corruption resiliency up to now, but is there a way to 
guarantee that the file system will be truly incorruptible? Again, the 
use is very light and the SSD card partition will likely never fill.

All suggestions appreciated,
George.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
