From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/6] nilfs2: implement tracking of live blocks
Date: Sun, 16 Mar 2014 15:34:08 +0300
Message-ID: <3EC9549C-84A7-49B5-9BE1-34A7337BFFDC@dubeyko.com>
References: <cover.1394966728.git.andreas.rohner@gmx.net> <532584A2.8000004@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=TdFeP14hG+Cd55YkWC+VjfRBD6eQUhh+8/gb6kgoBr4=;
	b=aoySYWCOuHChXESbhErGTiMna9sfC6uM8g0QjzKeJz/873R2EoA1iXL7XGoG6d3Bo8pudItJaYjG1OSRz363SKO+YQw0YRttnMC5fcjcItMoyzMbCDdU6I+FCF00jhrV;
In-Reply-To: <532584A2.8000004-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


On Mar 16, 2014, at 2:01 PM, Andreas Rohner wrote:

> On 2014-03-16 11:47, Andreas Rohner wrote:
>> Hi,
>> 
>> This patch set implements the tracking of live blocks in segments. This 
>> information is crucial in implementing better GC policies, because 
>> now the policies can make informed decisions about which segments have 
>> the biggest number of reclaimable blocks.
> 
> IMPORTANT:
> I forgot to mention, that the patches are based on linux-next/master,
> because they rely on previous patches that aren't in master yet.
> 

As far as I can see, some guys mention about it via [PATCH -next 0/6], for example. :)

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
