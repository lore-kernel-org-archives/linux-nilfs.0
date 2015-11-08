From: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: nilfs2-kmod7 version 1.1 was released: improve decrease of available
 disk space on aged file systems.
Date: Sun, 8 Nov 2015 02:37:52 -0800
Message-ID: <CAKFNMon6Vev__7yjMNA-FkVwY9LQmB7GLr=f6yjMnx4dptpdyA@mail.gmail.com>
Reply-To: Linux NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:reply-to:date:message-id:subject:to:content-type;
        bh=fILEwIHiuno6p0Z8/OTP/1j4hAtnZHSIiNl+watZWqs=;
        b=nkdoV3y+rXggufGBRIExIhgcfQgDCoEgjpvZo+V6NLtfBbzFRPuZkEzYq/EI4Ysk7W
         0AHn1miBbffqtPmDwxhBflywzVLJyg8SXPanPw4oAdythc3bGIbq8PUaPq+cr148Kq3O
         UOd2xUqh4dR9ppfwq0T/S49Oyk/5DjUdX18U0ZCq/0F7TzfPj123c2wEYe41erg/MTZC
         l3HgCcECL6jNyF1Cs7dGzZxXS7RRVQYf3tq+uYuS1nPbfE+WF42WxS8jHhssJrBHqetP
         kiSKOaPis2XgE/FRj9ScLQ24Nn0rmG9AWB3DrGT1LIxtpZEs1ersZqUaZVOrDhvO+bs7
         RecA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs2-kmod7 version 1.1 was released. Back-port fixes including ones
to improve decrease of available disk space related to aging of DAT
metadata file. For details, please see ChangeLog file or commit logs.

from http://nilfs.sourceforge.net/en/index.html#n121
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
