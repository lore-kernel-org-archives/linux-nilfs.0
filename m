Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E16912DD97
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Apr 2024 22:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713564418; cv=none; b=Mli3+LbgKmNQrKpqB1jwxKKVylDRAe1D415419KXBm35nQiaG/4AfzZAkUIGTscHu77xjXXNHjSp+pzjFJSsUBf7KWeeqyA61Al8BtzOwvXH4vYHyHm07sH1q3Oe5e/K6n0dQwIAyo4tKA7dpQR3VfgTOjb2zvhVwWw9TZ3b9jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713564418; c=relaxed/simple;
	bh=HUJHe8tWu/WUIKOVBV8kufrBqIL0xRGJonKiaO5RbvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZlaOZPj9Z5NQkpD20EMAVasQrJBMlrgabtibDcQi9ccTpNTIaqEKlzyMOHYDVgjrqWG0e4auNsWqlc2auviouGsWNppzMbPpW5NnQfENRF2SJqf4rhYFnmrJHW+PivLCQuveF+YmDppxwCPxRZgo8OVbCpDSZI0YPviRSEIiY8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=akH7STQ8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="akH7STQ8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713564415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A7zGvxwxCcGIJPA3G64f+Hzny8qcQ4BMDayIg7lNZbo=;
	b=akH7STQ8EU1e5Z6ttCmbNpLBmLM5+XhTBtfzYZoq8Ogj6HTi0wM0yVmfuGp/T2DTwEo7DB
	MIPraW+XykcmZmZouyUqM3WVr5bbQ6KkkqOmwRMeenMm87ASoAbGWAVRAXH0bYwIotSvJn
	WW/Xx4MSBmrLNiq9h/S+LozyqUJOTns=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-B3HMU9_XMPCpg0-pH9IoMg-1; Fri, 19 Apr 2024 18:06:53 -0400
X-MC-Unique: B3HMU9_XMPCpg0-pH9IoMg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7da41c44da7so196692439f.0
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Apr 2024 15:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713564412; x=1714169212;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A7zGvxwxCcGIJPA3G64f+Hzny8qcQ4BMDayIg7lNZbo=;
        b=t17EKhcUnO3u2F1zC1Z5Iqk/lF7Q4o1XsCURdeZwpy+G0ThEj1RarFtvMeAOQusV3f
         NYSARIPghAqRNIhCO6a2GTr+mSKaHjfwTugP9StXgG5SjC31USfFSxtgM6+LKKIHeQzB
         GDT4sdvIc4FeQQ94BDQHmf1YgcAHu/37KnEkHM1VBH5rL6rnLa/e++XCnZvRCzOAgO/j
         SCsSKTUhsRFqxwvTtDVH+nTzrG4rYFIz6Yc+LwHgd/X78vlxnc74HfVqqJAfcMqHE7SZ
         smceRlq7uc3dxQ/hrvRtgZoctetyQ3MaDwGM4/llmUVehwE4v68Y2O1C+VR5eSeSG7tz
         dNQw==
X-Gm-Message-State: AOJu0YybuvronN1RIXqJABnrTcs7GfVV5ORQeezIfeV44MzeC9TPTRXE
	qIetgafyiZZm0j8w33A8qD7/0dpB88rOD6M32iVdvfYef+kdKOKVWvfubJ72QZ1/SKLC6pKhQ5H
	wv9MLkVsPctrpFgV3n5J5vt6GV8OQIU+fNYeVFXJXicMTKuaIDcVD8l/SpqYsXQhT1iFj
X-Received: by 2002:a5e:dc48:0:b0:7d6:3f52:2f27 with SMTP id s8-20020a5edc48000000b007d63f522f27mr4018175iop.0.1713564412071;
        Fri, 19 Apr 2024 15:06:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErEsTDkYmnbGsrF3ichPMlabImp0ZKiwsnOdTWDeEzr/iwyTFi9b0/eBYwuxVpJvyEZuu93Q==
X-Received: by 2002:a5e:dc48:0:b0:7d6:3f52:2f27 with SMTP id s8-20020a5edc48000000b007d63f522f27mr4018158iop.0.1713564411807;
        Fri, 19 Apr 2024 15:06:51 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id g4-20020a056602150400b007d65ee260d0sm1112617iow.6.2024.04.19.15.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Apr 2024 15:06:51 -0700 (PDT)
Message-ID: <98da70e0-8a2d-43d3-863d-edc37b56ece4@redhat.com>
Date: Fri, 19 Apr 2024 17:06:50 -0500
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] nilfs2: convert to use the new mount API
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
References: <33d078a7-9072-4d8e-a3a9-dec23d4191da@redhat.com>
 <CAKFNMokRBcoP8z8Y6m60bYb=Se9SSn3N459hE0KWAnN7tEop=g@mail.gmail.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <CAKFNMokRBcoP8z8Y6m60bYb=Se9SSn3N459hE0KWAnN7tEop=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/19/24 3:12 PM, Ryusuke Konishi wrote:
> On Fri, Apr 19, 2024 at 1:45 AM Eric Sandeen wrote:
>>
>> Convert nilfs2 to use the new mount API.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>


>> +               if (result.uint_64 == 0) {
>> +                       nilfs_err(NULL,
>> +                                 "invalid option \"cp=0\": invalid checkpoint number 0");
>> +                       return -EINVAL;
> 
> At first glance, I wondered why the nilfs_err() super_block instance
> argument was NULL here, but I see, it can only be used by remount..

Yup that's right, no sb yet on initial parsing. Hopefully the message
is ok this way. There is also an option to emit mount option errors through
the API, but nothing is listening for that yet.
 
> ...
>> @@ -1172,7 +1157,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
>>                                    "couldn't remount RDWR because of unsupported optional features (%llx)",
>>                                    (unsigned long long)features);
>>                         err = -EROFS;
>> -                       goto restore_opts;
>> +                       goto ignore_opts;
>>                 }
>>
>>                 sb->s_flags &= ~SB_RDONLY;
>> @@ -1180,130 +1165,56 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
>>                 root = NILFS_I(d_inode(sb->s_root))->i_root;
>>                 err = nilfs_attach_log_writer(sb, root);
>>                 if (err)
>> -                       goto restore_opts;
>> +                       goto ignore_opts;
>>
>>                 down_write(&nilfs->ns_sem);
>>                 nilfs_setup_super(sb, true);
>>                 up_write(&nilfs->ns_sem);
>>         }
> 
> There is still an issue where the SB_RDONLY flag on sb->s_flags is not
> repaired in the error path of nilfs_attach_log_writer().
> 
> This seems to be the only essential issue remaining, so I can add the
> following fix (safer one - drop the SB_RDONLY flag for
> nilfs_attach_log_writer, call it, and repair the flag if it fails),
> and send it upstream.
> Is this okay?  Please let me know if you have any opinions.
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index a54fa43331f5..a8f03c860e87 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -1164,8 +1164,10 @@ static int nilfs_reconfigure(struct fs_context *fc)
> 
>                 root = NILFS_I(d_inode(sb->s_root))->i_root;
>                 err = nilfs_attach_log_writer(sb, root);
> -               if (err)
> +               if (err) {
> +                       sb->s_flags |= SB_RDONLY;
>                         goto ignore_opts;
> +               }
> 
>                 down_write(&nilfs->ns_sem);
>                 nilfs_setup_super(sb, true);

Oh, I'm sorry I missed that :( Yes, I think that looks fine. Thank you.

-Eric

> 
> Thanks,
> Ryusuke Konishi
> 

