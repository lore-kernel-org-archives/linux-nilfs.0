From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Thu, 16 Jan 2014 14:10:46 +0400
Message-ID: <1389867046.2565.46.camel@slavad-ubuntu>
References: <CAFvQSYSzpX_WpUi9KpGj0pZvzhw2mfzzOqcgdj9ripXAjipmtw@mail.gmail.com>
	 <1389783139.3913.23.camel@slavad-ubuntu>
	 <CAFvQSYTG6HBVc9iodYyvCejwf889jiwOPsVb1Hi8cDrR9pOGeg@mail.gmail.com>
	 <1389787304.3913.28.camel@slavad-ubuntu>
	 <CAFvQSYSC7+dd93pRH-uok9N+A_s=1VKrfGEppu3qRTg3q=CuXQ@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=gcx/jJpDUkidpe/9dNz1b//k3NJR7K6ME9sHNgGJCBA=;
	b=Ag6HDmhFgKs4KkyeRMYWenq9h6WXy2qyBCZMwvPfCzauZzht9KReH46aKZyLr35XPV1t//okMAQY4W0KPApul1Ln5J5RMkirImjAB3Ww1nVI1l5PdqaS+hRu2cVWp4F2;
In-Reply-To: <CAFvQSYSC7+dd93pRH-uok9N+A_s=1VKrfGEppu3qRTg3q=CuXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2014-01-16 at 11:03 +0100, Clemens Eisserer wrote:

> 
> Maybe it would be enough to detect whether the stored pointer to the
> last log is recent and otherwise perform a slow scan?
> 

Slow scan means slow mount. :) Are you ready to wait the ending of
really long mount?

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
