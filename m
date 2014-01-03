From: "Mark Trumpold" <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix segctor bug that causes file system corruption
Date: Fri, 03 Jan 2014 18:48:17 +0000
Message-ID: <W743292615760561388774897@atl4webmail03>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: andreas.rohner-hi6Y0CQ0nG0@public.gmane.org

On Thu, 02 Jan 2014, Andreas Rohner wrote:
>>If you follow the 10 steps I outlined in my commit message, 
>>you should be able to see the problem. If some of the steps are unclear, 
>>I am happy to provide a more thorough explanation.

Hi Andreas,
Would it be possible to share the 10 steps to reproducing the problem?
I want to evaluate the risk in my context before going through another
kernel spin.
Regards and thanks,
Mark T.



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
