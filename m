From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix data loss with mmap()
Date: Thu, 18 Sep 2014 16:24:16 +0900 (JST)
Message-ID: <20140918.162416.1553343892940167544.konishi.ryusuke@lab.ntt.co.jp>
References: <20140916.225726.1211879952201061873.konishi.ryusuke@lab.ntt.co.jp>
	<5419436E.4030501@gmx.net>
	<20140917.213439.867924114484975245.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=P3sAMCRlXLUDOauVeSayGnwYvuL2M0054os29Ucc3ls=;
        b=jYYUAWkiJGvLXu3dnI940vOVIGdl5C5F7BwoFrY3wHXLUX+cZDBMVLdkFblSh+oPqg
         0krYvyV4BTujA51V0ADUMzLmxtrfkeGeo//L14zsUXGLp4oT9qZG1A6vbo+GxrVKBGAa
         pJG1e3ykDoatS07Oo3oEtyvy2/XEeuWcKdcMqqZQPSkaVz95kasQoRHjHAizzil9uiN0
         aFpt+WbweR0mi0Ba5mueKhKNnUr+MBu7z9SaZrJqkZYm4//u1gNjxHIjPGdLShMYoV/b
         Pwto4xsZY6SSHRNFFDuZV9yfeyIT9isLcyn2HLXqBrH4nEntPemKA6cQ86FtNCeCtFxn
         K+Tg==
In-Reply-To: <20140917.213439.867924114484975245.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 17 Sep 2014 21:34:39 +0900 (JST), Ryusuke Konishi wrote:
> On Wed, 17 Sep 2014 10:16:46 +0200, Andreas Rohner wrote:
>> On 2014-09-16 15:57, Ryusuke Konishi wrote:
>>> On Tue, 16 Sep 2014 10:38:29 +0200, Andreas Rohner wrote:
>>>>> I'd appreciate your help on testing the patch for some old kernels.
>>>>> (And, please declare a "Tested-by" tag in the reply mail, if the test
>>>>> is ok).
>>>>
>>>> Sure I have everything set up. Which kernels do I have to test? Was
>>>> commit 136e877 backported? I presume at least stable and some of the
>>>> longterm kernels on https://www.kernel.org/...
>>> 
>>> The commit 136e877 was merged to v3.10 and backported to stable trees
>>> of earlier kernels.  But, most of earlier stable trees are no longer
>>> maintained.  Well maintained trees are the following longterm kernels:
>>> 
>>> - 3.4.y  (backported commit 136e877)
>>> - 3.10.y
>>> - 3.14.y
>>> 
>>> I think these three kernels are worty to be tested.
>> 
>> I tested it on all stable kernels including 3.4.x, 3.10.x, 3.14.x. The
>> bug is present in all of them and the patch fixes it. The patch also
>> applies cleanly on all kernels. I sent it again yesterday, and added the
>> Tested-by: tag.

One thing I have a question.

Is the original issue that commit 136e877 fixed still OK ?  If you
haven't tested it, I apprecicate if you examine the test for the prior
issue.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
