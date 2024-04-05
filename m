Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E05A2A
	for <linux-nilfs@vger.kernel.org>; Fri,  5 Apr 2024 01:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712280087; cv=none; b=p3650r16pEYlOUNepnAqWQswrho0Zh5yE6Szfe/vR7yUqFw3rDW0Rxx0ihQXwFbglO74Z7RN8rEJqEv8iWHDWwWvqv2PysY07EQCm/2xpJLSCdEJx0ylsFyIzrZ9UoxD3zpO0jDZJvSZfjW90e1VgyNY4UXuhEPxXNaU9KeMq5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712280087; c=relaxed/simple;
	bh=iEo8xNKGfswNkFapjaZByhAJnnpEXs4pGIa1203ToYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GLsQyuus/LeioiKr3ZuAVp4JQvCcdeIO/XlN5+IWEyES7bQGSWN8Y+P/+V637LDFvV3njqsH3cw0oaTuZgLx3rii5K8jzJaMpW0OZAuaa0yiOa9XgHYkd0ldHRJrzUtCAMmkHyAjxqVAg5oVp7MOkP0DikX2d2GIp/EB/6O39b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ip80WtYt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ip80WtYt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712280084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3UXUPEUPW+emrph0LU2twk8APOF78TzQaw+ZM0Wb32w=;
	b=Ip80WtYtOrZmSq7V+hsnvJtLRJVLj6mlcRHL8vIUljbZkHoS1spsRPsDqwO7etTq3831N5
	zEdO45BmhQFGoPTBxbuNu7huJ87pk4TSNtPeJ+DrMcbM28EwbdWS1Du8ZLKPTQDSWYvOwf
	gqaUbnZM/g4yEZGDOJlxZ1OKAlTRMc8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-uhb3YJO-NwerGaDCNIKeWQ-1; Thu, 04 Apr 2024 21:21:23 -0400
X-MC-Unique: uhb3YJO-NwerGaDCNIKeWQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-78bd232b170so159839785a.1
        for <linux-nilfs@vger.kernel.org>; Thu, 04 Apr 2024 18:21:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712280082; x=1712884882;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3UXUPEUPW+emrph0LU2twk8APOF78TzQaw+ZM0Wb32w=;
        b=j2MsIRinAOBdbugr/2oYY15B1Ft57pp4lzBRH+QBwtf9KTuC8EHRfeCpccGiZpKs6C
         47zn35flIhabvHkDVmqg+RD+Inr0g3lDUXT6JYkeJopDNPeBDhQI8R08Fe+ss2I3YNnI
         lIEmRxBWPZf3i0hf6yzfKhO71XkfypMSUkof/pomwpWgWU99JYqh1zmTN3VnMFVmr7LM
         fRtsyUrXSJcyWdNz6CVgUCOnTJfqZQOcQry7l+kVlhR/WIvC7TQedzWws+pEa4YT/xYH
         nlDPUCks+HmMfFppUL88UBlz0Oe9+BQ8+tv8kQCf6JbA6iW3g35tqaAo0bzQYw7cwK54
         bMjg==
X-Gm-Message-State: AOJu0YwXmNeMLmV8cZrLw9T3dYy7YDi+uf63RdYbFwOEGq7yC8M03INS
	Zw6XVsZHrSfrb3TUAcXroJMj4AnlfGJPrvv0190kj8dtiWpxlooYNvFlNx+UVNgmNhZZXjKUzHB
	0ELG4303pL3IwhQRhZ4tzusJab/m5PKoXCqVyyZQAKVtltR5jm2u57GVCesl1N7TgKHng
X-Received: by 2002:a05:620a:4155:b0:78d:477f:55ed with SMTP id k21-20020a05620a415500b0078d477f55edmr155397qko.0.1712280082176;
        Thu, 04 Apr 2024 18:21:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXm9LF33LBTD7iVesgQsQoNu54Nb5MaMG2+aAgIwHgvCjPbRLUbty8Irlr2rOj1IcP6vOK9A==
X-Received: by 2002:a05:620a:4155:b0:78d:477f:55ed with SMTP id k21-20020a05620a415500b0078d477f55edmr155381qko.0.1712280081898;
        Thu, 04 Apr 2024 18:21:21 -0700 (PDT)
Received: from ?IPV6:2601:447:cd81:ac10:24d6:b45a:a529:a73f? ([2601:447:cd81:ac10:24d6:b45a:a529:a73f])
        by smtp.gmail.com with ESMTPSA id pi34-20020a05620a37a200b0078bdce0acecsm233116qkn.80.2024.04.04.18.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 18:21:21 -0700 (PDT)
Message-ID: <2fd47dc7-e130-4c67-b39a-b1c38aa1c500@redhat.com>
Date: Thu, 4 Apr 2024 20:21:19 -0500
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nilfs2: convert to use the new mount API
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
References: <e282e150-2bc1-4b6a-8aa1-0417371c2671@redhat.com>
 <CAKFNMo=bbdBsW2xvTMiZcrD37n8MWmDfhH7V2jKZ14=odduRXg@mail.gmail.com>
 <f99b0c44-c5b4-4e0b-892b-dd9793a80f9a@redhat.com>
 <CAKFNMokYkO-WsvrcZh=-FpR=LtCQnsyxET3ZjSzx-o5zXcMU9g@mail.gmail.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <CAKFNMokYkO-WsvrcZh=-FpR=LtCQnsyxET3ZjSzx-o5zXcMU9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/4/24 5:33 PM, Ryusuke Konishi wrote:
> On Fri, Apr 5, 2024 at 5:35 AM Eric Sandeen wrote:
>>
>> On 4/4/24 3:11 PM, Ryusuke Konishi wrote:
>>> On Thu, Apr 4, 2024 at 7:12 AM Eric Sandeen wrote:
>>>>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>> ---
>>>>
>>>> Note: This one was relatively more complex than others, so I would
>>>> appreciate review and testing. Basic checks of mounts, various mount
>>>> options, and snapshot mounts do seem to work. I may well have missed
>>>> something though, as I am not very familiar with nilfs.
>>>>
>>>> You may want to look closely at the handling of case Opt_err: which
>>>> no longer uses nilfs_write_opt() and open-codes the flag change, so
>>>> that I can use the enum. If you'd prefer to make 3 independent
>>>> Opt_err_XXXZ cases, that would be possible.
>>>>
>>>> If any of the other changes here are unclear, or problematic, please
>>>> let me know.
>>>>
>>>> Thanks!
>>>> -Eric
>>>
>>> Hi Eric,
>>>
>>> Thank you!  This is one of the modernizations that I thought I had to
>>> do with nilfs2.
>>>
>>> I'm planning on doing a full review later, but when I ran a mount
>>> pattern test, the kernel restarted without any messages (probably
>>> caused a panic), so I'll give you some quick feedback.
>>>
>>> The mount pattern that caused the kernel to restart was a simultaneous
>>> mount of the current tree and a snapshot, which occurred when the
>>> snapshot was mounted and then the current tree was mounted.  Something
>>> like below:
>>>
>>> $ sudo losetup /dev/loop0 ./nilfs.iso
>>> $ sudo mount -t nilfs2 -o ro,cp=38866 /dev/loop0 /mnt/snapshot
>>> $ sudo mount -t nilfs2 /dev/loop0 /mnt/test
>>> --> panic
>>>
>>> Here, 38866 is the snapshot number that can be created with the
>>> nilfs-utils "mkcp -s" command or "chcp" command, and the number can be
>>> checked with "lscp -s".
>>>
>>> I have placed the mount test script I used in the following location:
>>>
>>>  https://github.com/konis/nilfs-test-tools/blob/main/test-nilfs-mount.sh
>>>
>>> The panic occurred in test #17 of that script.
>>>
>>> I'll also try to track what's going on.
>>
>> Thanks, I'll look - I was hoping/expecting that you had better tests for
>> mount options than I did! ;)
>>
>> Feel free to debug if you like, but it must be a bug in my patch so
>> I'll take ownership of trying to track down the problem and get it to
>> pass your test script.
> 
> Got it!
> 
> So I'll try to understand the patch first.

Sorry that it's not really possible to break it down into smaller changes.

> This test script focuses on reproducing NILFS-specific mount sequences
> (such as mounting a snapshot and current tree simultaneously) and
> checking the state of user space such as the GC process and utab.
> And, is not exhaustive for mount options.
> 
> Looking at the patch, if I come up with test patterns that would be
> better to add, I will enhance the test script.

Sounds good.

So the oops you hit is when a snapshot is mounted first, then the main
fs is mounted.

My patch does this:

                        /*
                         * Try remount to setup mount states if the current
                         * tree is not mounted and only snapshots use this sb.
                         */
                        err = nilfs_reconfigure(fc);

(in place of nilfs_remount()), and nilfs_reconfigure expects to have
fc->root set, which is normally only set up for an actual remount.

fc->root is NULL, so that's the oops. I'll see what I can work out.

Thanks,
-Eric


> Thanks,
> Ryusuke Konishi
> 
>>
>> -Eric
>>
>>> Thanks,
>>> Ryusuke Konishi
>>
> 

