From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Feature request: A user-space program listing versioning
 history of a specified file
Date: Sat, 13 Feb 2016 01:58:24 +0900 (JST)
Message-ID: <20160213.015824.937707282163873059.konishi.ryusuke@lab.ntt.co.jp>
References: <CAFm8q6eW-3dT7FqmKC3-cg0TpaoKEOt6RCJY86jE9PrK=tZKSQ@mail.gmail.com>
	<CAFm8q6dfuY9_vrqp_H_rePBBLeZc6TBt20G7pEhpzr5eYifQZA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=H3dZcX4xgCEAhr9SeyeR/XwS5DJnetU+wLPWkMay9kw=;
        b=N3Gfqo8p7OWJkDhAe9RYTB+fhk2eeSdXwvJ1Rs7jJ2Nk4WgmjNJLnHR+JDRCwDZDo5
         hxWFDT3iBu54kdFHxlA9aaLxnHwYQkOkuJDgQ19GmEYAjxnoX6mK5pCvsgDSSY59NLPX
         zqZWdwqjumb/tNNZxDO8GLYvxepaIizUACIIwqc44j7NQ6PpFIkIRtmQal9fEkQ5TzPf
         nJbER+/Tw2ccBleG2Elsi/25PQSJ2Wks7zNgInYT0CK5foYcig5RJVdAa1WVb4TMsCrn
         bcVEQYMnu6bU6lgJo7UAJHzOfIsH4IKJax98uaCjMbz6Vv6NxFxL4jD/X9/XYscr3aF+
         Oxtg==
In-Reply-To: <CAFm8q6dfuY9_vrqp_H_rePBBLeZc6TBt20G7pEhpzr5eYifQZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Eric Lan <tenoreamer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 5 Feb 2016 00:59:17 +0800, Eric Lan <tenoreamer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello,
> 
> Recently, I have installed NILFS2 and feel it quite cool. I wonder if
> you are insterested in developing a program that can trace back all
> the check points to list the revision history of a specified file.
> With certain argument specified, these versions of files can be
> collected into a directory for the user to choose a good one from.
> 
> Such program may be easily extended to have the function of
> "undelete". That is, to collect a series of versions of or the most
> recent version of a specific file that exist only in the past
> checkpoints.

None of your requests look easy to implement ;)

Anyway, I added them to the todo list at
http://nilfs.sourceforge.net/en/current_status.html

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
