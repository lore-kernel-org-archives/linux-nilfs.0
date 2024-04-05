Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AD643170
	for <linux-nilfs@vger.kernel.org>; Fri,  5 Apr 2024 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712329467; cv=none; b=Ovz7zBZm9zS2+xnnKv5ejQtyjNXz6DIJN37Cfv0YvWj7RvyXeJDgPqDh4BZV1Qii1Eau7dkd0JvzNwSD5YftTL3czIU/fSadiQ8tuA2PaAD+2IYnFlYFJAsB6P2CokqkJg4caeiSAP+6VpdP8Unm+kz4e05TSHmaLO2tFxueHoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712329467; c=relaxed/simple;
	bh=kjGB48cTD6PQC3PnyaxiugtDeKsxNtqt3ogEvC1PLGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hPHc5CStcBfucJ/EQ65ei6IlPMp4VM0VE7WSx4gNkUEfQZOGysGnTzff8o6hvin81+yi0+yYQei17az3F4B5JX3LQg4i/fcmtrV1G9Dk7dedw1J5d+0vzLvhghI3T+4fhJkfIrtKeDJ0hmAH91imta9/dEGmc1VFmR2mhZ20LqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GNH09IdV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GNH09IdV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712329464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hIgy60hZ2sPA62jTHvS0vUS0e8ALaFwVrgUmF8eqcuc=;
	b=GNH09IdVLHm8wW2yge2j9em2a6x438RT8CUJfPlyF512a/drndW9c7zT1Yt+y9mflZitJF
	+utmO55gy0r7HRNt7n821T6CB8w8fRHeaSCJj+2u/FNLGPnj0Zbts1KM2ootm+wFlQExpn
	S9GziH20WfBUcTrFMm/U5C35Y5OZjwE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-smMoDD2oNkmRg2F0Qfyuvw-1; Fri, 05 Apr 2024 11:04:22 -0400
X-MC-Unique: smMoDD2oNkmRg2F0Qfyuvw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7cc7a6a043bso223062839f.0
        for <linux-nilfs@vger.kernel.org>; Fri, 05 Apr 2024 08:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712329461; x=1712934261;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hIgy60hZ2sPA62jTHvS0vUS0e8ALaFwVrgUmF8eqcuc=;
        b=EJ77WJI42sHNUMBEnRRo1vQ+tBsGDOG59De/20YVd5jSDD6UoqjIF289fbWfVfLARp
         0ueEzIOBiaPLvv7f2iim1M8IbEG4lK3c4RW1483QbUP8vHqjtiMOPf3AcVm0/JZzPsF9
         jIhJtocCTi89HS95frkdTZo0JfFRwwmYRoVtu3J9JUJZTQRlNFUov3QKaBE7Ur+j3wRr
         7KY/lop86oK3pW1g0HmqHj3FBJrHaWC0rMf2xN45opAgGRWiKOyG8Gblwkj41L6FjGfR
         XWVh9M8aqeSs465U6g3lo2BMQoyK5YFBJugfIX5dO8wrZKgOCW+5g50W5tfg+botALa9
         XmHw==
X-Gm-Message-State: AOJu0YzHgzvFtkcJTBIsv+AWaucqRDH4MRQSrqIxziGA5zLh6vuk7dpx
	5RZGKJEjMXCYuS23iEKWcPmgHbFMCFCglqsYmiGePm6HMTQ2vI2Cnc3XGsocQp340bYeYYxmnmW
	Xcb1VkImoqLNqZFjpmUAHwU+54lq/297484xt7Lgma9OEjWenUyjmD4o41XxBoT2rFTHD
X-Received: by 2002:a5d:9c4e:0:b0:7d5:bd2a:9f7b with SMTP id 14-20020a5d9c4e000000b007d5bd2a9f7bmr1795619iof.9.1712329461689;
        Fri, 05 Apr 2024 08:04:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSPzykGirrLohWSKJ3HAEMYvXf0iJmY5cjqOEL4LY/5NkH0Osm7MFeCet8qgHGbXPWo7kjPw==
X-Received: by 2002:a5d:9c4e:0:b0:7d5:bd2a:9f7b with SMTP id 14-20020a5d9c4e000000b007d5bd2a9f7bmr1795591iof.9.1712329461265;
        Fri, 05 Apr 2024 08:04:21 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id i2-20020a5d9342000000b007d0c5dfe05csm547599ioo.37.2024.04.05.08.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 08:04:00 -0700 (PDT)
Message-ID: <10925ebc-4e91-48b5-8a99-287fbc8248fc@redhat.com>
Date: Fri, 5 Apr 2024 10:03:58 -0500
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] nilfs2: convert to use the new mount API
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
References: <e282e150-2bc1-4b6a-8aa1-0417371c2671@redhat.com>
 <CAKFNMo=bbdBsW2xvTMiZcrD37n8MWmDfhH7V2jKZ14=odduRXg@mail.gmail.com>
 <f99b0c44-c5b4-4e0b-892b-dd9793a80f9a@redhat.com>
 <CAKFNMokYkO-WsvrcZh=-FpR=LtCQnsyxET3ZjSzx-o5zXcMU9g@mail.gmail.com>
 <2fd47dc7-e130-4c67-b39a-b1c38aa1c500@redhat.com>
 <0d26ef52-91bd-4108-bf09-5d92fa58cd28@redhat.com>
 <1ba497be-64cb-4a4d-99a8-16707da32cc4@redhat.com>
 <CAKFNMo=zu38X+SYDgyP=g4aD9E1ee209C7FqvF9_cj1vxZgjuQ@mail.gmail.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <CAKFNMo=zu38X+SYDgyP=g4aD9E1ee209C7FqvF9_cj1vxZgjuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/5/24 5:33 AM, Ryusuke Konishi wrote:
> On Fri, Apr 5, 2024 at 12:00 PM Eric Sandeen wrote:
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> V2: Fix call to nilfs2_reconfigure() in nilfs_mount() to ensure
>> fc->root is set.
>>
>> Clean up some extraneous comments and whitespace
>>
>> This one passes your current test script.
>>
>> Thanks,
>> -Eric
> 
> Yeah, this v2 patch resolved the panic issue.  It passed the test
> script in multiple environments, as well as my manual checks for mount
> options with and without using the constant table.  Seems to be
> working perfectly so far.

great!

> I'll get started on the full review, but I'd like to provide feedback
> on style warnings detected by the checkpatch script at this point.
 
> ---
> WARNING: Missing commit description - Add an appropriate one

Not a lot to say; I can note 'interesting' things about the conversion
if that'd be helpful.

> WARNING: function definition argument 'struct super_block *' should
> also have an identifier name
> #146: FILE: fs/nilfs2/nilfs.h:338:
> +extern int nilfs_store_magic(struct super_block *,

As you say this is pre-existing; I can change it if you like, I was just
following current style.

> WARNING: function definition argument 'struct nilfs_super_block *'
> should also have an identifier name
> #146: FILE: fs/nilfs2/nilfs.h:338:
> +extern int nilfs_store_magic(struct super_block *,

same
 
> WARNING: space prohibited between function name and open parenthesis '('
> #220: FILE: fs/nilfs2/super.c:721:
> + fsparam_enum ("errors", Opt_err, nilfs_param_err),

This seems to be the pattern for every filesystem using these calls ...
 
> WARNING: space prohibited between function name and open parenthesis '('
> #221: FILE: fs/nilfs2/super.c:722:
> + fsparam_flag_no ("barrier", Opt_barrier),
> 
> WARNING: space prohibited between function name and open parenthesis '('
> #223: FILE: fs/nilfs2/super.c:724:
> + fsparam_string ("order", Opt_order),
> 
> WARNING: space prohibited between function name and open parenthesis '('
> #224: FILE: fs/nilfs2/super.c:725:
> + fsparam_flag ("norecovery", Opt_norecovery),
> 
> WARNING: space prohibited between function name and open parenthesis '('
> #225: FILE: fs/nilfs2/super.c:726:
> + fsparam_flag_no ("discard", Opt_discard),
> 
> WARNING: Missing a blank line after declarations
> #317: FILE: fs/nilfs2/super.c:770:
> + struct super_block *sb = fc->root->d_sb;
> + nilfs_err(sb,

easy enough to fix.

> WARNING: quoted string split across lines
> #576: FILE: fs/nilfs2/super.c:1193:
> + nilfs_err(s, "invalid option \"cn=%llu\", "
> + "read-only option is not specified",

Just let me know your preference on long strings like this (out-dent?
go past col 80? leave it alone?)

I'll wait for more review before I send a minor update just for these.
(or, if you prefer, feel free to tweak small things on your end.)

thanks,
-Eric

> total: 0 errors, 10 warnings, 563 lines checked
> ---
> 
> Of these, the warning for the function declaration of
> nilfs_store_magic() is an existing issue, so it can be left as is.
> 
> Also, I feel like the warnings for fsparam_{enum,flag,flag_no,string}
> can be ignored for the sake of appearance.  (I will not omit them here
> so as not to make any preconceptions).
> 
> Thanks,
> Ryusuke Konishi
> 

