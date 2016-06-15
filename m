From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Bug with future timestamp
Date: Tue, 14 Jun 2016 20:54:32 -0400
Message-ID: <CALJXSJpSYW6jpPWWMUQEkmWoGyNhKBB7jJ+mUBxrM6=8G6uPEA@mail.gmail.com>
References: <AM4PR07MB1443A58B1332FBF20D3ED835A0540@AM4PR07MB1443.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=82OM08vNOmtSEnitmWWVIEkSgxVZMJKnRuQt5/Nhwa0=;
        b=fza51CMyrpAxE7o1zm1uB66yL1NrPGVHQueBV+FPiYw4/Kp7b9gG94Vb3HZSBq77Vv
         gw160FtCZacYRtbsMu4WpFv44dyQqY2q59/SwjYF4UPn/guf9/h532t5K5UOJ8RKAQR/
         6ybakofbxlBGetZFsT4OEY8y65SmH5pj8Xb+HVggF94L9tZJH8aokh9PvFLcGlJAx3AN
         AqQDCstME8khbWKyj4mRFhURzvRk6tAiKL81QfA2+DeIW1zfmnnTk4gL3NN437l9/JNW
         9pce5R1dSVHQr4C1PP43cIWWkOr34Ww56ef4T8W9dWsvtvwXrye+Ayw2GwT7/hR1aF6M
         RTOQ==
In-Reply-To: <AM4PR07MB1443A58B1332FBF20D3ED835A0540-OW1adBbnE/AmxLT4/akQWjzdlHkvsOLVvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michele Marcon <M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jun 14, 2016 at 10:54 AM, Michele Marcon
<M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org> wrote:
> When the garbage collector starts, it will notice that the checkpoint "from the future" is protected and will not remove it.
> The problem is that it will not remove subsequent checkpoints (but with timestamp that shouldn't be protected), and therefore there won't be any garbage collection until 2020.
>
> The only workaround is to manually remove the "future" checkpoints with rmcp.
>
> Is this a known issue? Thanks!


I was bit by the opposite problem on my day to day laptop. I set my
time in the past for some hours, then after restoring the correct
time, the garbage collector destroyed all the checkpoints from the
past. At this point, the FS was screwed. I reported the issue and
can't find the patch that fixed it but I guess this is the kind of
protection to be expected from my issue, checkpoints from the future
can't be cleaned up.

Pseudo-References:
http://www.spinics.net/lists/linux-nilfs/msg00592.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
