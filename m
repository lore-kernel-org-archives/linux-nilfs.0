From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Could someone share his experience with Samba and NILFS?
Date: Fri, 01 Mar 2013 09:56:59 +0400
Message-ID: <1362117419.2088.5.camel@slavad-ubuntu>
References: <f3924e57f7fc9be324620e2fdc930e3f@piterdias.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=mUoz34Ump/RIcCmyEFAuJNga/odW2X7sJmEnrGdZZ0Y=;
	b=b0IpUyjyFJ1nPwYJzWORh0Wj774+7lcC29k19qZY/sNbX2nlczENt9OblDZFseJaLeXmrHA7lVg8FI7Vcl53qBwglxUxBPJastja6Xv4+iTDk9Eu8fDMSjpSfvZ10H9r;
In-Reply-To: <f3924e57f7fc9be324620e2fdc930e3f-dmjmWuXPryWakBO8gow8eQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piter Dias <piter.dias-dmjmWuXPryWakBO8gow8eQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piter,

On Fri, 2013-03-01 at 00:26 -0300, Piter Dias wrote:
> Hi.
> 
> I am using NILFS for few days, testing it to replace a /home partition
> (currently ext3).
> 
> Although etx3 folders are easily available to my Windows machines, the
> NILFS folders don't. It shows on Windows explorer but it says that the
> network resource is not reachable.
> 

I guess that you should have error messages in your system log. Do you
have it? Could you share NILFS2-related messages in your system log?

I think that you can encounter an NILFS2 issue. But it needs to have
more details about the reported issue's environment for the
understanding of situation on your side.

Thanks,
Vyacheslav Dubeyko.

> Could someone share his experience with Samba and NILFS?
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
