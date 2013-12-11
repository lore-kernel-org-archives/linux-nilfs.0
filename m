From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs error
Date: Wed, 11 Dec 2013 10:31:06 +0400
Message-ID: <1386743466.3991.12.camel@slavad-ubuntu>
References: <CAJgyHGOeRhj7D4GeyfHhBjXLE3K40DiakT2Zms2D7TPB-BiRog@mail.gmail.com>
	 <BA9C3894-7D2F-4FA1-88DE-E830102A0B5D@dubeyko.com>
	 <CAJgyHGMmxs8RUiFiZyJW2xNODuip_1yYkUTZ1_-VSPWivtHeSg@mail.gmail.com>
	 <1386657940.4007.24.camel@slavad-ubuntu>
	 <CAJgyHGMKCwOKR9dZ6tfTr8j7vMaye94HsiWVZSYZ3Y=+P=HkYQ@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=lPt/PvQqye0MsMb37krwjrod/3/7bNtGQNuefI/+eN8=;
	b=A1WrICi6wvpClNaCuR1qALJqy0xVtlaI5ERVXGyCUi+96kj2mg1fY+H9tHZOicMKZhCM/I8R2IMmqM+8Gl/z88ZLBqEhkcfieE7uZ7lMUooPvHu+Vy5QFAb51AyfK4LB;
In-Reply-To: <CAJgyHGMKCwOKR9dZ6tfTr8j7vMaye94HsiWVZSYZ3Y=+P=HkYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jon Watte <jwatte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 2013-12-10 at 08:47 -0800, Jon Watte wrote:
> Thanks for your suggestions. I have no idea about how to reproduce the
> issue -- this is a light-to-medium-use desktop system.

I think that it is important to understand a nature of workload on your
system. Maybe do you use some application frequently or process some
data mainly on this system? Is it possible to distinguish frequent and
repeatable workload?

> I took an image of that volume and can mount it on an older kernel if
> I need to copy out any files, although all of the important stuff was
> in git or dropbox off-site, so no data really lost.
> Is there anything I can do to this volume that would give you more
> information about what the cause might be (i e, whether the cause is
> patched or not)?
> Some debug utility that will create a dump of some sort that will
> help? Else I will probably just wipe that image and recover the 30G of
> space.
> 

I think that I have a request to you. It is very important to understand
that my patch fixes the issue really. So, please, take attention to the
situation on newly created NILFS2 volume under Linux kernel with the
patch. If you will encounter the issue again then it means that the
reason of the issue doesn't be fixed.

I believe that I had fixed the issue's reason. But there is probability
to have another reason of such error messages.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
