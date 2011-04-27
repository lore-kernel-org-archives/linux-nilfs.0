From: Ivan Telichko <itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Regarding =?utf-8?b?YGBwcm9ibGVt?= with =?utf-8?b?bmlsZnNfY2xlYW5lcmQ=?= - part 2'' and =?utf-8?b?YGBOaWxmc19jbGVhbmVyZA==?= err=-17''
Date: Wed, 27 Apr 2011 12:29:20 +0000 (UTC)
Message-ID: <loom.20110427T140022-700@post.gmane.org>
References: <loom.20110426T231606-740@post.gmane.org> <20110427.154007.255390385.ryusuke@osrg.net> <loom.20110427T111017-105@post.gmane.org> <20110427.204042.153209394.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> How was the output of lssu command ?

Here: http://pastebin.com/DUn8UuvS

No difference between segments with
duplicates and normal ones in that output.
Only thing I can see here is that GC stopped
at segment 1363.
 
Is there any additional information I can
provide? Partition is filling up and will be
unusable in several days. I can keep image
of it if needed.

---

Regards,
    Ivan Telichko




--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
