From: =?ISO-8859-15?Q?Niccol=F2_Belli?= <darkbasic-DEeHIYRtcplPMsqi6aon0Q@public.gmane.org>
Subject: nilfs2 per directory quota
Date: Sun, 26 Jun 2011 11:48:32 +0200
Message-ID: <4E070070.1060502@linuxsystems.it>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=linuxsystems.it;
	s=linuxsystems.it; t=1309081872;
	bh=DV0CyFEBKeeWNm4KhfXdQA7zVJk6VBUFZDbQtDYdnQc=;
	h=Message-ID:Date:From:MIME-Version:To:Subject:Content-Type:
	 Content-Transfer-Encoding;
	b=h62VVXmOKZlXDSMeeixHeLY65AA2UdfcA9qW1KXFr/rbtN/ayU6JmnL6K0ivoJN9l
	 5wGDE39tjYRhHxoVKAjJzkGwi7VliXTEJeuq6VlAFTJIO9SY+LhxLzuVCo3ZZX1NU1
	 e5biAUWisIt3d+9nxJTF2TbxzR/sseppsvhd1wp8=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
I read nilfs2 does support per directory quota, but I didn't find how to
achieve it: the few peoples who need directory quota do use xfs.
Can you please give me some more info? Is nilfs2 still too much immature
for a production environment?

Cheers,
Darkbasic
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
