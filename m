Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272261D90AD
	for <linux-nilfs@vger.kernel.org>; Wed,  5 Nov 2025 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762354878; cv=none; b=tghOjOxhkNijEd5zLFG02c5WySZz+Esoc7vRbzMLZHMsOuJTVg6zocceAomlSEe0A+qHeioXAWkgv3Euw8yYvTTR7ELhLTJ7HuTgazdcYe2K1+fvm06APjVIiTrFU1k6+sAoWECnNaQDTNzTT5/6CUhC24+V8pQ8zspZ9IJf7iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762354878; c=relaxed/simple;
	bh=bAm6t8rPyJySoZj9CJIRcl8XyO3CdL0m6UHioYJInXM=;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ARyYqb+tC1ndtSHDbsbnvgnteG7SMhffOt4wJcllvOd5oQxFvDwfqoRpKsyVV2Rbu0E4H9HJi8bhJlion3nkHIjJHfuVVnGkE9TALMNEgDjNCC230PuBx+nEpVoXy7jYlSf1It4/D0OGHcJStve2WQR100wIEC6DqrRxKRMiW9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gxv8rALX; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gxv8rALX"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so1782910b3a.1
        for <linux-nilfs@vger.kernel.org>; Wed, 05 Nov 2025 07:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762354876; x=1762959676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J/9wQ+QLv1LipY2KGPvcEfKIp32ghzdO2uLU18Rtzog=;
        b=Gxv8rALXdhHW49Mcv14Oc//Xq7AhqAvenrVErr2zwlr8FHa3+wLpio5nlk+3X7vvhT
         wgKc9iOWoqxDlLHxNDJM7MS+z7OpdxRi0g4DhjEByzkEuWRW8zOtUKD5PHb4U9x2QsSz
         mKJ5jlyBbsf5ZXmYm/SdgfhJ1MH9Db0O+bhq9AFghNWLg0xUe7XAJ2FbD0cvVSd1n8FX
         7LhAxWOwDC8zgGaqDaWAXsDYPNyCcU5ylsr5qMbMFTo1RRNXEr/A1Vpdvp3d1TA8Rc/l
         iLzBrkgqUJ0fMDtM1Eb7cFjtco57bICaV7O1GlDLUwL+/3PWi+GbdqaF1GmERJ8sQTi0
         TI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762354876; x=1762959676;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J/9wQ+QLv1LipY2KGPvcEfKIp32ghzdO2uLU18Rtzog=;
        b=s8msKBXGcPhz0vyj4CBN7uVBlrX3Jaf6/VX6pDq6606NgpbqvuboIwJaoOLcRnGFkA
         JwY/IWd+YG6SHLoxAUoEZxb0HCGaiWRkwimgf1CIeEEArEuqd/PmQ+LsmZVXmIM9nN6m
         P6PiL2Zk5QxqNeYM7jP6G5ZZkYxAeJyJHpGMihp0cX2T2bxEvyPXW1V0fy9tXXUhHqNb
         elTm74TyMrv32neI/lZt+8m8yDS1ZIgvCN8xcAfxEzayFPjyfFcqkb2pNR8UYJYIyUEZ
         +6xDpghL1b583rbLO4enDKhPmrirBmtEeV5S9O5Znu6ypwT9eKj+vsN5KtD5lZSs8riy
         Vseg==
X-Forwarded-Encrypted: i=1; AJvYcCX+zu8C/wh+cCJ0OGAmVMD3GO5eTLwmJFGrvaz1RqnpwiKUot8C5nbjFVhfc6o/SOV5PFnFo6pSKiRiUA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0jTJxwSAnVqcgidWRjNoyvmi4Qm5yMNIKfukkTezuzMkTSPV0
	KzTkIO+sjOGGMPKq75UG2vj/6A/CV79IeP2i0YySsit9vrbkTViSDqW2
X-Gm-Gg: ASbGncvSVDbGhPHUCSRZQyd6JX35luYk38PJQXGGA1ps5qVWjoetZ/VcJjrFXNs/4qU
	SJjEMNXEel5lo8g45K54qWzfTn6F9r5fSCPXDF8i/6M1XvEvAtjj0G8mAXQOtGF4rCWwJ/kDWPN
	4e55gLaQQwyQTVcLlMvRZ27bUhEgpSuKh02qvyAi3BVxcFvraev7BggPedq76Z0i+oD4/bRe7OX
	IdCf/JnJ859qmJWTZxUh6cgfurZ3F+BpeN1ZNYlVom7eyjtBi9at/pfytZuewlnCIbWtDsDGniq
	Y6UY1aM4/RtIqxs2yQmo3YS3GbMhhg1Y+k5kPrcTJ8/tzzVZi93lhOl1gdZYacffZjWEocfvq2L
	98bJ0Uvh9sFaS7EODM59E6l2OhmA+XPWutBSBkFPGSnurR+DCnj8CX+/GGh0k2Ad0qZs=
X-Google-Smtp-Source: AGHT+IFxF2ravXAqKMNI4wFCi3+ALhZa7OTXOmRJeppwpOE9OolRY2a2K3VYHVcoVsv9syqzdGoxqA==
X-Received: by 2002:a05:6a00:80f:b0:7a2:7cc3:c4f0 with SMTP id d2e1a72fcca58-7ae1cc60d39mr4571411b3a.1.1762354873430;
        Wed, 05 Nov 2025 07:01:13 -0800 (PST)
Received: from localhost ([240f:3d:c6f9:1:392e:ad68:8d70:58d3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd324680asm6693502b3a.1.2025.11.05.07.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 07:01:12 -0800 (PST)
Date: Thu, 06 Nov 2025 00:01:10 +0900 (JST)
Message-Id: <20251106.000110.54762674.hdk1983@gmail.com>
To: konishi.ryusuke@gmail.com
Cc: christopher@gmerlin.de, linux-nilfs@vger.kernel.org
Subject: Re: nilfs_readdir: bad page in #
From: Hideki EIRAKU <hdk1983@gmail.com>
In-Reply-To: <CAKFNMonYLKSikthtoGP9z6Loetu0LxrUsGC6vMSAwaCPE6muqQ@mail.gmail.com>
References: <CAKFNMonRtuknO7G6p-eOuY+WgSQQGsYOWrDdbO2Zh1mBsGp3RA@mail.gmail.com>
	<aQoHEXBY9tusAkQ9@merari.gmerlin.de>
	<CAKFNMonYLKSikthtoGP9z6Loetu0LxrUsGC6vMSAwaCPE6muqQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 28.2
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: nilfs_readdir: bad page in #
Date: Wed, 5 Nov 2025 00:28:54 +0900

> It's becoming more likely that what I feared is occurring.
> I suspect that an issue (probably a regression) that shouldn't occur
> during normal operation has occurred.

I have seen similar errors since last year with a kernel provided by
Debian 12 as follows:

6.1.0-17-686-pae: 2024-06-15T17:57:31.618788+09:00 nojima kernel: [13858689.003220] NILFS error (device sdb2): nilfs_readdir: bad page in #114046
6.1.0-21-686-pae: 2024-07-15T17:02:30.630090+09:00 nojima kernel: [1915188.018182] NILFS error (device sdb2): nilfs_readdir: bad page in #618331
6.1.0-26-686-pae: 2024-11-09T21:44:58.562985+09:00 nojima kernel: [307159.828834] NILFS error (device sdb2): nilfs_readdir: bad page in #884
6.1.0-34-686-pae: 2025-06-04T21:58:36.641306+09:00 nojima kernel: [2953327.992010] NILFS error (device dm-0): nilfs_readdir: bad page in #29039

When I saw these errors, I thought it might be caused by the SSD
issue, because the sdb2 drive is data storage (since mainly used as
read-only, sometimes write, but many sectors are rarely accessed), and
the dm-0 drive is too old (used as root fs and NILFS home directory
since 2011 & Power_On_Hours is >120k).  However, if these were caused
by software bugs, the above versions might be good hints to find
whether recent regression or not.

The kernel package information including changelog is available at
Debian web site, like
https://packages.debian.org/bookworm/linux-image-6.1.0-34-686 .

Regards,
Hideki EIRAKU
