Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD596FE26
	for <linux-nilfs@vger.kernel.org>; Thu,  4 Apr 2024 20:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712262914; cv=none; b=OlqyPyMK9LuBXxT7K+niN9AvDMZgLG//Msl6Q2nGfsRYerJM2TAeHkedgOuOQWN7gwhOzI3HhtPhJBVlQlrE+qot7MdQwo7c3ezCz0xO0/4hphtvifwxww81q49ntaAHnw4JH6jgaeg3N/YIMBZ72B6cFIzPzCLt9MHRZKaGb4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712262914; c=relaxed/simple;
	bh=JiTZN7evsq9OC5taAspqio4rcpHNpcsD8mS5ZKnUNwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ijgH7UfbdbWgTZNgkFDEG8zwswSvHnGQ9GlxZA9gbFh9NDrNDfVFL8ovmzkM/Yr8PEoDrasM+JACiHf60v0v+oG4JSpkIIMtv04/5jKnRN1ZNB4qE+nJa5rgj82oyMD0x+5sDxpkGnfmiqcbA6QYwJNXqP7GK1D6Zb4W8Vam47s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FFdmttMc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FFdmttMc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712262911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3C9N3AVOYdyr3yAXFyxbkgUg63n5c6VZe9KvVCVj2ao=;
	b=FFdmttMcKYNOvExlY5LT26SZ0EJpHVMG1dk4qQ+GuvlnYbLJBQIyVkdf7pNraUOT0Ruv8t
	iI1uNiwDhBpyZQGwN3M3Ei+7q3Twqi6aP/ALhtwSlVP1BN+qErsvdx18iSDQOGDO8v9a5t
	XYbYlgBZVJ3RZERw41ofbIvKnom7rCA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-LcYZ9oHeMd2wmF0bsM7F_g-1; Thu, 04 Apr 2024 16:35:10 -0400
X-MC-Unique: LcYZ9oHeMd2wmF0bsM7F_g-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7d096c4d64eso99940439f.1
        for <linux-nilfs@vger.kernel.org>; Thu, 04 Apr 2024 13:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712262909; x=1712867709;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3C9N3AVOYdyr3yAXFyxbkgUg63n5c6VZe9KvVCVj2ao=;
        b=e5v/6mmEg86jTJq/Wbh1zDZWqbAklMqVNdqnm1hy8A4om9riCiZ7ltwf4yrRt8RJWA
         29a+KMrKoGMyqrDxuFw77Jfm1ABRiBHCATcGhd9dVQQO/UlmWY7cgUVGncgX0Z5tzKps
         V2sBnGsR5nZw9qnEa3Z94DocnQnCygFwH6vwfQskA4nNKgMNFLy88qPCYAW3aJjC7Sfi
         LRJNf2Gq5RZeZsH95K+2frY3EwliT30Ww5n0Cqn5drVZ+X4J4yiWnwwWO9li5CtLLJ+x
         f20OwpOiHWYOXt3gR4kpIXnl4DOfEInBvaG8hi4fvP+kyHI4FCy5UTWxQge6roIcZzQF
         Cg6w==
X-Gm-Message-State: AOJu0YxAymsIOEJ1AhIUBUvwiOCYJ2JW9fkdSftfyGUblVMGflQHYA7e
	A1CxkLd+gnCGFNeOEU0DO67GV4YEbkiRVx6eAy5IdoNBp1O4obwJ5Uv6DHE70EIuJBj2DrA9VVM
	POY7tS6tXgqy1aGZuAxY0UcY90sG1TyXahCFuhh1vEw4/TpQ8Xa7VedzC5TBCg2HCQLjx
X-Received: by 2002:a5d:861a:0:b0:7d0:858c:e0f with SMTP id f26-20020a5d861a000000b007d0858c0e0fmr546538iol.0.1712262909777;
        Thu, 04 Apr 2024 13:35:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUK8j52g6J6pNmr+Hl22J1EyFQsyvgxZUFhW8T+fMSqSPr9x3IUt2OrI7TUu48hKuGdvlSAQ==
X-Received: by 2002:a5d:861a:0:b0:7d0:858c:e0f with SMTP id f26-20020a5d861a000000b007d0858c0e0fmr546521iol.0.1712262909475;
        Thu, 04 Apr 2024 13:35:09 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id ep7-20020a0566024b8700b007d06f222614sm82225iob.32.2024.04.04.13.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 13:35:09 -0700 (PDT)
Message-ID: <f99b0c44-c5b4-4e0b-892b-dd9793a80f9a@redhat.com>
Date: Thu, 4 Apr 2024 15:35:08 -0500
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
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <CAKFNMo=bbdBsW2xvTMiZcrD37n8MWmDfhH7V2jKZ14=odduRXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/4/24 3:11 PM, Ryusuke Konishi wrote:
> On Thu, Apr 4, 2024 at 7:12 AM Eric Sandeen wrote:
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> Note: This one was relatively more complex than others, so I would
>> appreciate review and testing. Basic checks of mounts, various mount
>> options, and snapshot mounts do seem to work. I may well have missed
>> something though, as I am not very familiar with nilfs.
>>
>> You may want to look closely at the handling of case Opt_err: which
>> no longer uses nilfs_write_opt() and open-codes the flag change, so
>> that I can use the enum. If you'd prefer to make 3 independent
>> Opt_err_XXXZ cases, that would be possible.
>>
>> If any of the other changes here are unclear, or problematic, please
>> let me know.
>>
>> Thanks!
>> -Eric
> 
> Hi Eric,
> 
> Thank you!  This is one of the modernizations that I thought I had to
> do with nilfs2.
> 
> I'm planning on doing a full review later, but when I ran a mount
> pattern test, the kernel restarted without any messages (probably
> caused a panic), so I'll give you some quick feedback.
> 
> The mount pattern that caused the kernel to restart was a simultaneous
> mount of the current tree and a snapshot, which occurred when the
> snapshot was mounted and then the current tree was mounted.  Something
> like below:
> 
> $ sudo losetup /dev/loop0 ./nilfs.iso
> $ sudo mount -t nilfs2 -o ro,cp=38866 /dev/loop0 /mnt/snapshot
> $ sudo mount -t nilfs2 /dev/loop0 /mnt/test
> --> panic
> 
> Here, 38866 is the snapshot number that can be created with the
> nilfs-utils "mkcp -s" command or "chcp" command, and the number can be
> checked with "lscp -s".
> 
> I have placed the mount test script I used in the following location:
> 
>  https://github.com/konis/nilfs-test-tools/blob/main/test-nilfs-mount.sh
> 
> The panic occurred in test #17 of that script.
> 
> I'll also try to track what's going on.

Thanks, I'll look - I was hoping/expecting that you had better tests for
mount options than I did! ;)

Feel free to debug if you like, but it must be a bug in my patch so
I'll take ownership of trying to track down the problem and get it to
pass your test script.

-Eric

> Thanks,
> Ryusuke Konishi

