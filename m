Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24B2298CC7
	for <linux-nilfs@vger.kernel.org>; Mon,  3 Nov 2025 20:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762202234; cv=none; b=PiLoE7vFDQ9Gxlw0El7/hMiYNolYLo/uMLqcBCWgxgcNxZyIIkXRQVXVAumvTcbh0fwLNaodj7boclleX3fFORq5XOd/gJ4P6k21oA+GXTrMmj9pPyKIINJ1zz/95VtJMoJ0oMs9kQm2KYLo9RMqOew7fFXO/LozfwBWUGMNvfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762202234; c=relaxed/simple;
	bh=Pd0sOdzu5S21IJfxnkyc9AwfXA9XXiNpVRlb7JDJKKc=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=N5PTZdy0aZnJcDVwsNuB64b0aHIeWLp1qfDSZHVlUjwiMTLrkorvA36HGIvhgfHD6rAigKcQkP+BgiUbcPJISjDcQDZzrZfcy0nr6Hho6So4huqHCq5jT1FEDVLwg1+a11T6h9exVOS3eBbKbKfiu/zvhWeRtG05NdnGIzc4RGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=QqNfktKf; arc=none smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="QqNfktKf"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-63e19642764so4858621d50.1
        for <linux-nilfs@vger.kernel.org>; Mon, 03 Nov 2025 12:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1762202230; x=1762807030; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt:date:cc
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pd0sOdzu5S21IJfxnkyc9AwfXA9XXiNpVRlb7JDJKKc=;
        b=QqNfktKf3MBYr97IiOmITf5tAqGYlrmMCMaOKHOVLyF2QwOdthdOaWwpBf4+Klut8h
         +iAUPLDgXcYWbMl80ixjnEuK8Lro93z/BN/5gz48cT51T6KNZlO5aJcJA2DHolsQDlSc
         3bl6WUISCyEa3ozu0dI5K9cp7/wUJsa3XuBbijQRWnytfeyP/6zzS92Mqllnv59LBYxl
         ZxA787XjLqTB/53DWNU4OvJYQA3JcF5+0nDtWWG558CS5luI3YpsTtwbZezzKxrhEahp
         l7ZhaQ4Xz/kM+mLEfnB/iQLKTVmfrDlNoFgbrhjXhHjLKrFghVD9Y38olbOXe7C01ox0
         h3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762202230; x=1762807030;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt:date:cc
         :to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pd0sOdzu5S21IJfxnkyc9AwfXA9XXiNpVRlb7JDJKKc=;
        b=L3qNdDqkfwOqoZEADrIBsH5QK2vUQH1vxZXYpGsrgxIMB2pyXgvQomCjcJgsyKz265
         czWNhTo9Y6F6gd3o7p218EqhobXekeeM8cW7irod7N/ndtiz5rT0ufRVJDAHCmym2wz7
         pu+PaYJGqDg/BEoKV7ZBcAy8ncWt1768bnVgVk4T6RZp0FWrXbn0OaxUJIFXx+7xjjgo
         xGIYa9fbeLlmADN64gsyYLEpzKtP70NvkSrVS18uptf2XAqrT79WBe4YjWWLc0BDc0pQ
         1rLBkoIXSJLFEjw0/631+5OxfglZctbgY+3bf45nOU73C278VnVTfJ3mciVWZXXddz0i
         cBrA==
X-Gm-Message-State: AOJu0YzumwpsqJ6Lr5gDmnL4s8/4ihcBai3wOfgvYA5wi7fWn4WtdMhU
	DE5XTGreourwG/zucKUlrw5Xx2hu4ZDT2FCc9muvkbgV723dv/S9VXRkeO8AoSe/uVg=
X-Gm-Gg: ASbGncvmnoQQ/38f0Z1WJny7sKvDv3CTxEYvlu/G6HTA9qdWjo6if3bxnUUZfoZPcuu
	A5UM+LT1pA5uPvb2HCE7HIGKTV6CBp+TwIL+jxQ2EIG6YwSNMNAPsZldCkTorbY/TebbixnzBDu
	HyOYWxNikQuSPBENKgVYk2ZUQD4t6ssg0VtSDIMrkvJ7TmgnfB31qyR9m9q3GtMCC5ifDJ4cKjr
	H4fgn4rEriNiGGI/Y1X/O2dMHygZKIH13eZ93uVBaPadg53LhoVu0Pn4MRhg3+lkOE91JJzMs2f
	Lr7WZiOjSlVS+AclQ5e8TcXUOaS9XAeKsSYHtaj6Ne8LJ7WhD/XWb3jV3SkDv3D3tFufmjplMcT
	XUHcQhJS7U0IOCVmI2ZbGlrESaNXS+5GscgYtKVvn3SKxahc5sAsLjuw3rI2rgZzK8gfPjED5rE
	OQAeCyY+Cedeyj+fSS84ku/Us=
X-Google-Smtp-Source: AGHT+IHREc63d480HcMLEegixlXHABOLQyfi0wjgmBYEZ6vWUpEMv3qE7+QxkStlSsi7XoDfhHnixg==
X-Received: by 2002:a05:690e:d86:b0:63e:3099:fe7c with SMTP id 956f58d0204a3-63fa0e18cb7mr8046630d50.16.1762202230554;
        Mon, 03 Nov 2025 12:37:10 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:f9b7:b8f2:4183:4284])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78692035fc0sm3880927b3.60.2025.11.03.12.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 12:37:09 -0800 (PST)
Message-ID: <73c75a4192c45e9c8b5054e0ac67f586a8c41589.camel@dubeyko.com>
Subject: [RFC] Sending NILFS2 patches into upstream
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Date: Mon, 03 Nov 2025 12:37:08 -0800
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Ryusuke,

Currently, you ask Andrew Morton of sending NILFS2 patches into
upstream. But Andrew is busy and it makes the whole workflow
complicated and unpredictable.

I am sending HFS/HFS+ patches to upstream. So, I can create the
dedicated NILFS2 kernel tree on kernel.org and I can send NILFS2
patches upstream. I believe that it can make the whole patch management
workflow more flexible and predictable. Also, additional maintainer is
better than to have only one.

We already had some discussion privately. So, let's continue the
discussion in the email list. What do you think?

Thanks,
Slava.
