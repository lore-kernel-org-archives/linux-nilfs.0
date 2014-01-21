From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 1/5] nilfs-utils: cldconfig add an option to set minimal
 free blocks
Date: Tue, 21 Jan 2014 15:53:31 +0100
Message-ID: <52DE89EB.6010200@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <22b5b3ac403052d3044dc8c1bebe323191376c03.1390310509.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <22b5b3ac403052d3044dc8c1bebe323191376c03.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-21 14:59, Andreas Rohner wrote:
> With this option the user can specify the minimal number of free/dead
> blocks before a segment can be cleaned. This is a threshold for the GC
> to prevent needless moving of data. If there are less free blocks
> to gain from cleaning a segment than the specified number, the GC will
> abort and try again with a different segment.

Come to think of it, "blocks" is not a good unit. Maybe I should change
that to "% of a segment" and/or "KB/MB". It shouldn't be hard...

Regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
