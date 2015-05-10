From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 4/9] nilfs2: add kmem_cache for SUFILE cache nodes
Date: Sun, 10 May 2015 09:05:55 +0900 (JST)
Message-ID: <20150510.090555.1085814778092144978.konishi.ryusuke@lab.ntt.co.jp>
References: <1430647522-14304-5-git-send-email-andreas.rohner@gmx.net>
	<20150509.114149.1643183669812667339.konishi.ryusuke@lab.ntt.co.jp>
	<554E5B9D.7070807@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=o0am9LdsatwJqHL4gbjqNqn5LAfjf97Z1U1YXFyy66M=;
        b=tRJk7tvttZ+unicUGj7y2LzOnrGLiSxUWQZ2/dTRSoqjAaInqtigfCGGRORCKTTRTq
         20p2GQ91RpHpVu7f39cKHFu4DHBT7PPEsnsv0L4HAD6aauPjJ1pOb5NuB0+/O7jL1al4
         NBladt326qkDRJd3n0mzMfJzzRLCiX41EpPq7iAyDHdeVqtkaZLMqYtNXSwie6OVtHb/
         72QAUz05mExnNuHF4LErUC8dzqiSiOjsEluh7I1cHKlWH5I0V+G2QDnNsGYTIifjPGnQ
         fOF2m24Jiwxpd9+x4kWfgOfPNPG7Uuu9TwxHVQ4taocbGZZ346wwbXA4UMcwq8E108nQ
         YkKw==
In-Reply-To: <554E5B9D.7070807-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 09 May 2015 21:10:21 +0200, Andreas Rohner wrote:
> On 2015-05-09 04:41, Ryusuke Konishi wrote:
>> On Sun,  3 May 2015 12:05:17 +0200, Andreas Rohner wrote:
>>> +static void nilfs_sufile_cache_node_init_once(void *obj)
>>> +{
>>> +	memset(obj, 0, sizeof(struct nilfs_sufile_cache_node));
>>> +}
>>> +
>> 
>> Note that nilfs_sufile_cache_node_init_once() is only called when each
>> cache entry is allocated first time.  It doesn't ensure each cache
>> entry is clean when it will be allocated with kmem_cache_alloc()
>> the second time and afterwards.
> 
> I kind of assumed it would be called for every object returned by
> kmem_cache_alloc(). In that case I have to do the initialization in
> nilfs_sufile_alloc_cache_node() and remove this function.
> 
> Regards,
> Andreas Rohner

You can use kmem_cache_zalloc() instead in that case.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
