From: Eric Lan <tenoreamer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: Feature request: A user-space program listing versioning history
 of a specified file
Date: Fri, 5 Feb 2016 00:59:17 +0800
Message-ID: <CAFm8q6dfuY9_vrqp_H_rePBBLeZc6TBt20G7pEhpzr5eYifQZA@mail.gmail.com>
References: <CAFm8q6eW-3dT7FqmKC3-cg0TpaoKEOt6RCJY86jE9PrK=tZKSQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=5vWuEOiHfj0KwYd5zhJVvExvxPSZCmjsuTdd2Zzm8Y0=;
        b=YR8yvEwUt7n+CdlVvoBXFT8Y9ebLjthcThMGWhh6SFzNv5p6lknkcT/iYdgdbA6rU7
         kbya1xaO0UXUwQykm/c8ualCV0bCj8vgAIoFJiScXbpAdXcX2DdNrm1ePZt6Bz1zFMWl
         Qh2c0yF7sPQ9Z+xYa+oO4CQvWTyIiHaFI8WcAaMLvfbkkWay86q7bu0B3BrG8uS+Ji3d
         tjVFlRVihdqWwaRJglH+Hf/O2KLBCYvfRKvrWKE0Bkq8H38INyguogo3ixwiB7534amd
         t+6wXr5WnvEhzjj/+ENy+LEznjSIUmKATrHmFwm22PuYvVPrCcYb4v1OjW8GlqAuPvc8
         r0sQ==
In-Reply-To: <CAFm8q6eW-3dT7FqmKC3-cg0TpaoKEOt6RCJY86jE9PrK=tZKSQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Recently, I have installed NILFS2 and feel it quite cool. I wonder if
you are insterested in developing a program that can trace back all
the check points to list the revision history of a specified file.
With certain argument specified, these versions of files can be
collected into a directory for the user to choose a good one from.

Such program may be easily extended to have the function of
"undelete". That is, to collect a series of versions of or the most
recent version of a specific file that exist only in the past
checkpoints.


Best regards,
Eric Lan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
