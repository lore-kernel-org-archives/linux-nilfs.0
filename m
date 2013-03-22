From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: undo mkfs
Date: Fri, 22 Mar 2013 21:08:38 +0300
Message-ID: <6CE8E9EF-13FF-436F-BFE5-F5BEE677E838@dubeyko.com>
References: <1363970576.27210.140661207862681.6F2B80E6@webmail.messagingengine.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=AnHm6pacCFexWsgkhRrF4A30BZVuyFEjaBzRpR9+1vc=;
	b=lXnImvKwgvwrTEOEk/WFXuHrOAAJlxB9zV3G6Fs5/MKrfcWiN+a72eueIOjAxzh/eJVBJKJi7ktzU7Ts068oxTJSajAoGBEPMbtDbLwWEmezhZuD1GILeIE4kAZ79+Uj;
In-Reply-To: <1363970576.27210.140661207862681.6F2B80E6-2RFepEojUI2N1INw9kWLP6GC3tUn3ZHUQQ4Iyu8u01E@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Hendrik,

On Mar 22, 2013, at 7:42 PM, Hendrik Levsen wrote:

> Hi,
> 
> I may have issued an mkfs command onto an already existing, healthy
> NILFS volume. This is nothing that can be undone, can it?
> 

Currently, as I know, there is not utility that can rollback your action. Maybe it is possible to recover this volume by hands on raw sectors basis. But it needs to analyze current state of the volume with care. Anyway, I am afraid that most part of old metadata and maybe user data were corrupted by new metadata structures. 

If you ask about opportunity to undone operation then it means that you haven't backup of the volume. Am I correct?

By the way, did mkfs utility complain about presence of NILFS2 volume on this partition? If not then it can be treated as issue of mkfs tool.

With the best regards,
Vyacheslav Dubeyko.

> Regards
> 
> Hendrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
