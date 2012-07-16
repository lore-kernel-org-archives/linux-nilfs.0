From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: set_nilfs_init definition
Date: Mon, 16 Jul 2012 18:12:32 +0400
Message-ID: <1342447952.1975.5.camel@slavad-ubuntu-11>
References: <CAGS5fSwzATDAj4wKr-gZF=s_3Fb429nnq9=w3Wgun-p77xn=+w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=OBmC7gmeZBkmNrqNve832xYb7hTjAXgbMNwHARsruEQ=;
	b=dEDloidDZszstMH8XgJPpx0FKhfTqmN2vxuB8m3YtF2anDnZh5mFW9StrbxxocgfKB1e1ragB7M++yYzE68M7t8/wjpfehAqaYy2ukt074FHTOL57tvpwvbBveiUSTg4;
In-Reply-To: <CAGS5fSwzATDAj4wKr-gZF=s_3Fb429nnq9=w3Wgun-p77xn=+w@mail.gmail.com>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: shubham sharma <shubham20006-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Shubham,

On Mon, 2012-07-16 at 19:26 +0530, shubham sharma wrote:
> Hi All,
> 
> I was trying to understand the code of nilfs (kernel version 3.4.4)
> and in the mount function i came across the function init_nilfs. In
> this function there is a call to another function set_nilfs_init().
> But i could not get the definition of the function. I wanted to know
> where the definition of this function is present.

The set_nilfs_init() is macros that is declared as THE_NILFS_FNS(INIT,
init) (please, see the_nilfs.h file).

> 
> Regards,
> Shubham
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
