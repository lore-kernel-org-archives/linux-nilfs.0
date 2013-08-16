From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Nilfs2 crash debugging (was: Broken nilfs2 filesystem)
Date: Fri, 16 Aug 2013 11:11:10 +0400
Message-ID: <1376637070.2301.34.camel@slavad-ubuntu>
References: <51F2A8A4.4020400@antoneliasson.se>
	 <51F2A945.6050909@antoneliasson.se>
	 <9016EBD5-1E01-476F-B1B9-66AE593F4728@dubeyko.com>
	 <520CB032.2000602@antoneliasson.se>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=v0Po8NwR8+1mKTI2sqthn0EF7BlNHTmvDgffXBgYVFc=;
	b=XPAV9NIquIO1wqGydxT4N7OBS/FROdwByBrC4VpA7+Qo2YH+BOVzinzYEsoi000Y4U2ZhhVsS0EyATeH9M3Nc/1gjjE3xzM1UeDmkBRu7q4aG+yfGA35TLtSf6a01zW8;
In-Reply-To: <520CB032.2000602-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anton,

On Thu, 2013-08-15 at 12:40 +0200, Anton Eliasson wrote:

> Hi again. I was able to reproduce the crash on a fully updated system by 
> starting the two virtual machines simultaneously as described in my 
> e-mail from May 25. I made a new attempt to rebuild the kernel with your 
> patches. I selected these options in make menuconfig [1], which resulted 
> in this generated config.x86_64 [2] which has the following diff 
> compared to the stock config.x86_64:
> 

Thank you for sharing the debug output for the issue. I am going to be
acquainted with shared materials during this weekend (or on the next
week). Unfortunately, I have busy week.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
