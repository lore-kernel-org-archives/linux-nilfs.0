Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94079568A
	for <linux-nilfs@vger.kernel.org>; Fri,  5 Apr 2024 01:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712281588; cv=none; b=il/Ug/CVWc2wkExd3/zkuJ60lTcnT/2PZDzHx+60+xThx0foXORdgT/X+GbVyShY6HlJDETCvlD0rnSOqW4936bmq5tBNLgOKl/1qSX8VrwbaRDp3fMazcHFbXGkAh5QnfIkZx1Ay3h/79zxT7FZr5SQPvkEJ38vEall936cMqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712281588; c=relaxed/simple;
	bh=b75+1oRVOOp+DftZBWWaXo4bgK7Ibsu+SLgZi+FP9jE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=nN0FAvUjXVa+ql7aHpqdtJ/2V7mxNg75f2I7ZDEG4YGzZP3aK3QooPyHzIkaghK1u0gDS7KO9Jka4IhaTQ5UBmbxrMiM9F/RwD32C6pECCXj6dVQRoNa9ff6LVT6pmHisTS6FjE9yb9ZEA9cV7af2az5Mmu/oJJacQtlxtLQphg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gWEK2HEp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gWEK2HEp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712281585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2sXQb5f0RBC9j41zCX2OUp4zW722lM9+s8HDUwTTOXs=;
	b=gWEK2HEp8rhOQxgo7hVrRMXzepKIMj0JHf9to2uCM39HEfdOdn0jFN5OQm8QmJbLwjWoUm
	sq+KA4ZQFhq8gkGIGq6cvW2dSVZhxZLLlPBp7hMwlcIgJY0/2jUgLqDd5+Hp30p0W+FW12
	8iv3y3YpMjmFN7W+YS/vhiebSnDwkis=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-gsauSYcVNT-hSMVUL7RdlA-1; Thu, 04 Apr 2024 21:46:24 -0400
X-MC-Unique: gsauSYcVNT-hSMVUL7RdlA-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3c3cbe8055bso1785220b6e.0
        for <linux-nilfs@vger.kernel.org>; Thu, 04 Apr 2024 18:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712281583; x=1712886383;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2sXQb5f0RBC9j41zCX2OUp4zW722lM9+s8HDUwTTOXs=;
        b=bQMtjYnwIItRQfwpOahA4eAjoo5d1p2xlMORgK3coohIa0bN7/YP5kt61Y6FNebMhC
         UO/iiIIdtzcJ4lLZcxQ+uQRBxmzXEc+dig2xpD/xn7039gEuE3bExHMB7Gsip2Obwoix
         t3aGHB+5H1TwclVvLVNHICBtNHyYDt7Ps2dD8IVzju6QtDxwRc1LOMFCJLHyJ9LK+5L5
         ClAzzvRRQVoF0enKOcBfUbjfcShNHxtLZ1ktU3QW7QtVURaeZz4yjyR1f8HC0+QKOGrZ
         4fhlaO94oJDj80orpMHY+w0AAVYd8xOr6V8WBUieYO3zMoa8F1F3L8295rMVoLkQpRIv
         1qUw==
X-Gm-Message-State: AOJu0YwvlItbM45uM5+RI8Co5ypP7mx0T0C6sEX6bLn3D4CRHpmB4k6x
	5R8CsxIrB+9I8JH9BF2V6ZFOfYw3LOOeVw4g2ref0ljZ0xTGNmW3jhbv6dFs4p8Yje42RuWxhpS
	pZ4mqf1e57mTR75mZAilx4nLRVy9/siq8MHGt6u6kp0tIl+lSF5PlbVUyt9LWuKxjPzDe
X-Received: by 2002:a05:6808:ce:b0:3c3:da4e:fb77 with SMTP id t14-20020a05680800ce00b003c3da4efb77mr106829oic.46.1712281583033;
        Thu, 04 Apr 2024 18:46:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzlZNpR8H6+MbodEW2Pc5ljBRHjkeBf1e/EV9wyUV90rXiCw+yhtf7nh9U5zunho07a57n9g==
X-Received: by 2002:a05:6808:ce:b0:3c3:da4e:fb77 with SMTP id t14-20020a05680800ce00b003c3da4efb77mr106822oic.46.1712281582800;
        Thu, 04 Apr 2024 18:46:22 -0700 (PDT)
Received: from ?IPV6:2601:447:cd81:ac10:24d6:b45a:a529:a73f? ([2601:447:cd81:ac10:24d6:b45a:a529:a73f])
        by smtp.gmail.com with ESMTPSA id k14-20020a05620a0b8e00b00789e72b27fbsm245282qkh.120.2024.04.04.18.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 18:46:22 -0700 (PDT)
Message-ID: <0d26ef52-91bd-4108-bf09-5d92fa58cd28@redhat.com>
Date: Thu, 4 Apr 2024 20:46:21 -0500
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nilfs2: convert to use the new mount API
From: Eric Sandeen <sandeen@redhat.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
References: <e282e150-2bc1-4b6a-8aa1-0417371c2671@redhat.com>
 <CAKFNMo=bbdBsW2xvTMiZcrD37n8MWmDfhH7V2jKZ14=odduRXg@mail.gmail.com>
 <f99b0c44-c5b4-4e0b-892b-dd9793a80f9a@redhat.com>
 <CAKFNMokYkO-WsvrcZh=-FpR=LtCQnsyxET3ZjSzx-o5zXcMU9g@mail.gmail.com>
 <2fd47dc7-e130-4c67-b39a-b1c38aa1c500@redhat.com>
Content-Language: en-US
In-Reply-To: <2fd47dc7-e130-4c67-b39a-b1c38aa1c500@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/4/24 8:21 PM, Eric Sandeen wrote:

> So the oops you hit is when a snapshot is mounted first, then the main
> fs is mounted.
> 
> My patch does this:
> 
>                         /*
>                          * Try remount to setup mount states if the current
>                          * tree is not mounted and only snapshots use this sb.
>                          */
>                         err = nilfs_reconfigure(fc);
> 
> (in place of nilfs_remount()), and nilfs_reconfigure expects to have
> fc->root set, which is normally only set up for an actual remount.
> 
> fc->root is NULL, so that's the oops. I'll see what I can work out.

Not sure if this is a terrible hack, but your test script passes with
this change on top of my original patch:

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1cdc38db2612..4a9a8924068e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1232,6 +1232,7 @@ nilfs_get_tree(struct fs_context *fc)
 			 * Try remount to setup mount states if the current
 			 * tree is not mounted and only snapshots use this sb.
 			 */
+			fc->root = s->s_root;
 			err = nilfs_reconfigure(fc);
 			if (err)
 				goto failed_super;

-Eric

