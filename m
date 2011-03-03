From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/8] lscp: support opening mounted filesystem by directory pathname
Date: Thu, 3 Mar 2011 19:31:32 +0100
Message-ID: <201103031931.32310.dexen.devries@gmail.com>
References: <1299156472-4707-1-git-send-email-dexen.devries@gmail.com> <201103031723.22583.dexen.devries@gmail.com> <20110304.021603.234305303.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=37ftJL5fy1w4t3UoPJidb/KEMnL7boZVUF3zvyKCBG0=;
        b=VHEPgdbz/R9fpk8uqWENZ0HHe/v5mXotE8mo7RoqpVWk92opjvOXgMVeSsrpZ2DuPb
         5xyJMQDl9DM+OBJxe9U0hFOg3/max+D57dRaFicRL4uw2N/Gn6P76beAO36FsdmDQNsg
         7l/06tHHJaS6h8i7jxOIEhSmIumPGLJGqRfks=
In-Reply-To: <20110304.021603.234305303.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thursday 03 of March 2011 18:16:03 you wrote:
> By the way, can you enhance the series so that the directory argument
> works for any directories in the filesystem rather than just a mount
> point?


That actually was aim at some point -- to let indicate filesystem by any object 
on it. However, I can't find a reliable way. If you can hint one, I'll gladly 
implement.

First idea was to use stat's (struct stat).st_dev, but it seems there is no 
standard way of translating (minor, major) into filesystem from userspace. 
There's a kernel function for that, but not exposed through syscall. There is 
a custom library function by HP, but it doesn't feel very reasonable to rely 
on it.

Second idea was to process pathname by combination of realpath() and stripping 
segments -- but it turns out dot-dot semantics are broken in POSIX OSes [1] 
making that way unreliable.

One caveat is that a device would not indicate the filesystem it belongs to, 
but a filesystem on a partition/device it addresses.

Another caveat is that processing a NILFS2 stored in a file (say, a HDD image) 
would require some specialized syntax.

While those may not sound very serious for interactive use, I believe that our 
tools would become too unreliable for scripts in some edge cases.

Thus I gave up ;-)

A minimalistic version -- only lstat() [sic] with S_ISDIR() -- would work, but 
that's not very much of a progress to me.


[1] http://doc.cat-v.org/plan_9/4th_edition/papers/lexnames

-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
