Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03142157A64
	for <linux-nilfs@vger.kernel.org>; Tue,  9 Apr 2024 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712692473; cv=none; b=euGBuV3aXGxeNgerfMMjQbm2bNLPOl9McX/CsJpY+ww8QPvSXYAeuheSz8x5xtSaraY0ofrw+jMeAShq3+FNW1UY9uBWt3jSJ2wl3bbSwYz2CDlFX1SSw82yID8crO0quaazKWSxQVIOsQv9+TUer+AEF0UlqxSTFgnY370Pgg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712692473; c=relaxed/simple;
	bh=l67aTjnNpFYAoPTxHzPuufGySndTmNH07X0grHatjKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gbVSSlp8umTJwvnxva9LMZ5Ik9pUWn+qToFpLOLMdGghaXPZhVEUTcABkrJ7hhu4rwGZYzUPwy0Qa3Qy/X2vmlRfao4N1LbvlSzQdWieEOYUeXxVB3tqWy7i1aYOYTvl90E1R0guYu26BrEPfQchzQ+gPSphiQXk3ZwGN/QfOZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fY7/u1Bq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fY7/u1Bq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712692470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4OxSzcKyFuBqi32//G0z93E1O8CHkeQW+JP1kOp1fTo=;
	b=fY7/u1Bq6t1w2PD2SUVzcnjP0GiB16sAHYrZosbC6okpGIDpWHam7cdjsKjnXcI6/Pk5zE
	Ke6qiUXLeQ0r/Igrl4Jm0iyyRyEMTQk9HWkwtdJitM4EtHfnU1KMwE7POHXBbakQs2AFck
	nQA8jf6MC8LZ8E02v/M7+TROXu/4tAE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-Tzb9x9NXMkStba1jgrPytQ-1; Tue, 09 Apr 2024 15:54:29 -0400
X-MC-Unique: Tzb9x9NXMkStba1jgrPytQ-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-36a14031548so38708305ab.2
        for <linux-nilfs@vger.kernel.org>; Tue, 09 Apr 2024 12:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712692469; x=1713297269;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4OxSzcKyFuBqi32//G0z93E1O8CHkeQW+JP1kOp1fTo=;
        b=CE+l6rVZaOhdzw/rs3RndjRQru/PJ4oObE8MfXJgOVsGfDQtWcerLx0ZhDmEcO5qMW
         CZJOpXJZhs+QeDHU6u3YKmZCm2jg35xtTIFwg5ixlbXt+exGpKK09xhuz8KNrrEM7Fda
         yJZihN1A5YmZ2WeWAgnHoa2CfcOKHlorDcv3nhkk3WXiYBx+7FrBGgHWSdWN3/ptrGcs
         Dxcbl2rzOB16ev/o54c6LUfnmbkBRmT5zqrk/1uq6mFMwnCW9dmitotjTOPcaJ8gkU64
         QzO52QKO1ba82vZRTmX44R4j6z6cydrLryiOtS7oEUkwprXfcMOVXHE44uW2bLAnFe6Q
         Sxiw==
X-Gm-Message-State: AOJu0YwnvgHaNCli3AoFd69gMfZvacr0UYAfMbLs0kg+WQXZF4dWv+rO
	lZBMtCgAAStloBeOUUrKtV4NsXFrBY9GWFm5M5dw+Wti5MddSorj4zCYt+l38yCKRpDOQl3CR0h
	HKuISjN494Nw/RLHW3Ac3ROwAnMcbSPh+igkMOcxrITMsL08vnMm7siD4lzc/
X-Received: by 2002:a05:6e02:180e:b0:36a:2812:f067 with SMTP id a14-20020a056e02180e00b0036a2812f067mr983227ilv.28.1712692468824;
        Tue, 09 Apr 2024 12:54:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOiGdxpIrILMKjkV/0qN/oyB88YnyeUIXAxneqPxxnecWADNdPZ7rHT6qXiKR6bopHe5X5CA==
X-Received: by 2002:a05:6e02:180e:b0:36a:2812:f067 with SMTP id a14-20020a056e02180e00b0036a2812f067mr983211ilv.28.1712692468522;
        Tue, 09 Apr 2024 12:54:28 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id r10-20020a056638044a00b0047f14f6a3f8sm3458693jap.107.2024.04.09.12.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 12:54:28 -0700 (PDT)
Message-ID: <55663cac-42e0-4be6-9f3a-e3f9f3d1ab50@redhat.com>
Date: Tue, 9 Apr 2024 14:54:27 -0500
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
 <CAKFNMonx-qZPUn6-qCFGbiFd06K-3bjsHyaw+rw_uq3YU_m=9w@mail.gmail.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <CAKFNMonx-qZPUn6-qCFGbiFd06K-3bjsHyaw+rw_uq3YU_m=9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/9/24 2:13 PM, Ryusuke Konishi wrote:
> Thank you for waiting.  I've finished the full review.
> 
> I'll comment below, inline.
> First let me say that this patch is great and I don't see any points
> that need major rewrites.

Thanks!

> Regarding style warnings, I will reply to that email later.
> 
> On Fri, Apr 5, 2024 at 12:00 PM Eric Sandeen wrote:
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---

...

>> -static int parse_options(char *options, struct super_block *sb, int is_remount)
>> -{
>> -       struct the_nilfs *nilfs = sb->s_fs_info;
>> -       char *p;
>> -       substring_t args[MAX_OPT_ARGS];
>> -
>> -       if (!options)
>> -               return 1;
>> -
>> -       while ((p = strsep(&options, ",")) != NULL) {
>> -               int token;
>> +const struct fs_parameter_spec nilfs_param_spec[] = {
>> +       fsparam_enum    ("errors", Opt_err, nilfs_param_err),
>> +       fsparam_flag_no ("barrier", Opt_barrier),
> 
>> +       fsparam_u32     ("cp", Opt_snapshot),
> 
> Checkpoint numbers require a 64-bit unsigned integer parser
> (originally parsed by kstrtoull()), so I think you should use
> fsparam_u64 here.
> Since nilfs_parse_param() was written assuming fsparam_u64, I guess
> this is a simple mistake.

Yep, I think I mechanically changed anything like

{Opt_snapshot, "cp=%u"}

to _u32, and missed how the actual parsing works.
 
> Also, "nilfs_param_spec" is not declared with the "static" class
> specifier, so could you please add it ?

Sure thing

...

>> +               if (is_remount) {
>> +                       struct super_block *sb = fc->root->d_sb;
>> +                       nilfs_err(sb,
>> +                                 "\"%s\" option is invalid for remount",
>> +                                 param->key);
>> +                       return -EINVAL;
>>                 }
> 
>> +               if (result.uint_64 == 0)
>> +                       return -EINVAL;
> 
> For the case where the "cp=0" invalid option is specified, could you
> please output the following error message with nilfs_err() as before ?
> 
>    "invalid option \"cp=0\": invalid checkpoint number 0"
> 
> Other similar messages seem to overlap with the message output by
> fs_parser routines, so I think just adding this one is sufficient.

*nod* good catch

...

> 
>>         sb->s_flags = (sb->s_flags & ~SB_POSIXACL);
> 
> This "s_flags" adjustment overlaps with the flag adjustment just
> before returning with normal status.
> I think there is no problem with deleting this.

Ah, I think you are right. Will make sure nothing depends on the sb
flags before then, though.

...

>> @@ -1180,130 +1163,57 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
>>                 root = NILFS_I(d_inode(sb->s_root))->i_root;
> 
>>                 err = nilfs_attach_log_writer(sb, root);
>>                 if (err)
>> -                       goto restore_opts;
>> +                       goto ignore_opts;
> 
> Here, if nilfs_attach_log_writer() fails, it will return via
> "ignore_opts" without restoring the SB_RDONLY flag in sb->s_flags.
> I think it is necessary to repair the flag only for this error path,
> what do you think?

Again, I think you are right, although maybe if the above flags copy is
moved to the end, it won't be a problem? I'll look more closely.
 
...

> 
>> +       if (ctx->cno && !(fc->sb_flags & SB_RDONLY)) {
>> +               nilfs_err(s, "invalid option \"cn=%llu\", "
>> +                       "read-only option is not specified",
>> +                       ctx->cno);
>> +               return -EINVAL;
>> +       }
> 
> This error check conversion (to check after the read-only flag is
> determined) is ok.
> But, the option name in the error message has changed, so please correct it.
> The original message looks like
> 
>   "invalid option \"cp=%llu\": read-only option is not specified"

Whoops, I think that's just a typo.
 
> The checkpoint number expression cannot be reproduced to be exactly
> the same as the input (as in the case where the radix is specified
> like "cp=0x123") but I think it's acceptable.

Yup - that's a difference w/ the new mount API, I think - all of the mount
options need to be parsed independently, and we can only look for invalid
combinations after that's all done and by then we onlly have the value, not
the original format or string.

If you would like to keep the original format of the option, we could store
it in the fs_context as a string (I think) and emit that in the error message.
Worth it?

Thanks,

-Eric

> 
> That's all for the non-style issue comments.
> 
> Thanks,
> Ryusuke Konishi
	

