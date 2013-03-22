From: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
Subject: undo mkfs
Date: Sat, 23 Mar 2013 03:42:56 +1100
Message-ID: <1363970576.27210.140661207862681.6F2B80E6@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=message-id:from:to:mime-version
	:content-transfer-encoding:content-type:subject:date; s=smtpout;
	 bh=kkR4B33A+2oJGs0YDsU4C8LUaPI=; b=IP7WVQ0tqWTxHxK2lmm91RcQZGKt
	i48gwRRHsQqYUUfteRzEk3VUFmjug1emgjsXLcyRQk2g3eo0bIm8RUcvhZzW8RgV
	QV9BxcVr4sbLg3z1eFbKj4PW6ByDYg33WmLq1BPzBxVqLFCjMSP0Jk9qcDn4HMdp
	xrUS9iLQrrTMATE=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I may have issued an mkfs command onto an already existing, healthy
NILFS volume. This is nothing that can be undone, can it?

Regards

Hendrik
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
