From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [PATCH] nilfs2: correct logic of translation virtual blocks
 number into physical ones
Date: Wed, 03 Jul 2013 13:24:55 +0400
Message-ID: <1372843495.2230.8.camel@slavad-ubuntu>
References: <1372674852.2198.23.camel@slavad-ubuntu>
	 <20130702.010238.65450534.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=83awiR8tmDfF03Kh8JrpJ19yEdB8cvItRhGc/KRANyo=;
	b=DpgRusabynlOPanISNS0gUZNuvK59G10zmRAURiLaVapUy85eCCFXrgiF5TYPEbXv6oinxgfLbTasHwCkTKCuGUDNbvS1rkP4hhYEGF1qccFQjnzBe8AElhwix4WnZqC;
In-Reply-To: <20130702.010238.65450534.konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, bryce@gibson-consulting.com.au, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

Hi Ryusuke,

On Tue, 2013-07-02 at 01:02 +0900, Ryusuke Konishi wrote:

[snip]
> Vyacheslav, this patch breaks snapshot mounts because past blocks
> deleted from the current file system have an end checkpoint number
> smaller than the current checkpoint number.
> 

Yes, you are right. It needs to rework this patch.

I will be on vacation during next two weeks. And then, after vacation, I
continue to work with patches and fixes for NILFS2. I will keep silence
during my vacation time.

Thank you for the remark.

> Also, the title of this patch looks wrong.  You are trying to insert a
> sanity check in the translation logic.  It doesn't correct translation
> logic itself, nor removes the cause of reported problem.
> 
> I think the title of this patch should be "nilfs2: insert sanity check
> in translation logic of ..."  or so.

Ok. I agree.

With the best regards,
Vyacheslav Dubeyko.

> 
> Regards,
> Ryusuke Konishi
> 


