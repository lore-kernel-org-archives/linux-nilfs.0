From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/6] nilfs2: implement tracking of live blocks
Date: Sun, 16 Mar 2014 12:36:57 +0100
Message-ID: <53258CD9.4040402@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net> <532584A2.8000004@gmx.net> <3EC9549C-84A7-49B5-9BE1-34A7337BFFDC@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3EC9549C-84A7-49B5-9BE1-34A7337BFFDC-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014-03-16 13:34, Vyacheslav Dubeyko wrote:
> 
> On Mar 16, 2014, at 2:01 PM, Andreas Rohner wrote:
> 
>> On 2014-03-16 11:47, Andreas Rohner wrote:
>>> Hi,
>>>
>>> This patch set implements the tracking of live blocks in segments. This 
>>> information is crucial in implementing better GC policies, because 
>>> now the policies can make informed decisions about which segments have 
>>> the biggest number of reclaimable blocks.
>>
>> IMPORTANT:
>> I forgot to mention, that the patches are based on linux-next/master,
>> because they rely on previous patches that aren't in master yet.
>>
> 
> As far as I can see, some guys mention about it via [PATCH -next 0/6], for example. :)

Thanks! I didn't know that. I will keep it in mind for next time.

br,
Andreas Rohner

> With the best regards,
> Vyacheslav Dubeyko.
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
