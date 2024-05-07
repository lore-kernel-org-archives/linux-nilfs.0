Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C5516D4C6
	for <linux-nilfs@vger.kernel.org>; Tue,  7 May 2024 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105785; cv=none; b=pb+tdM43S/qG0SM68L+l+3QiQl7GYvRXV8w71jX7mL54XhKvy7pwXQr2mj62WnM+XH6q0Xhf2qTW60XPjIq0B1ngBF7q1fy3vVP7Ft0k5SLIiThxUKaWHcj3pPyyzfmpbFW3ehQumtRgkeLMUZkf2yymcKmPEGX6QuLaE4ggnq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105785; c=relaxed/simple;
	bh=u46cJb8LuSqtF9usJiJSiw7bUonmp9oPLMiyInU555M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LGmtSfCBVsy55kcJoqwvjcVHCtDbjGUOsvjLsbJoN/4U2latSJFzHnQxEOXuFFTKYeBpRB4xcQoz/I9vnRiwrKbw47IYVxaXaAGGvcyl1slpW4fBIPgYFw53XVMmZJJ193Cyz6DxioZztvRZ/BmkaxQxtbtQ9kEUXjbmahhqmFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=z4YfQ0hF; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="z4YfQ0hF"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VYmgP5CpLz6Cnk90;
	Tue,  7 May 2024 18:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715105775; x=1717697776; bh=nx/7177g7QCqC3lx+J1o7xO8
	8dWjfhAUanfqEkWSEfA=; b=z4YfQ0hFTi31aSwFm2UX3ubtlb4jB5IQsukw2RFA
	h16xrDe2rMda/lEpktPiD4Xy3NZ2+dSScHFOMtY/Lb6ZRy2+lyTb8p3pGPyolxtm
	gCupH8C+rKXOkvwRP9T5+Lrxr7Ifs5WgJqnxOccm/64+A7psxI1TF+3lA1bhV1M3
	ilnprriFMi/Bxt9E3V5RK7hQGXeM3gvAv/74762w6lamM3tSrYYelIo+aJxEleTR
	Z8IS0Nu+2+kbMupt7fWORNXq8md79Y9HsCp+uws9ymLApz3KqBAp97Vh4aFq9M6v
	gWG9uKscL2MXQP0SF0wbVe+uIxwLLJv5F6Tyn41t1dkg3A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kBLxWok6JDgf; Tue,  7 May 2024 18:16:15 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VYmgL4H8Kz6Cnk8y;
	Tue,  7 May 2024 18:16:14 +0000 (UTC)
Message-ID: <daf4b0c4-2abf-47b5-afec-41b2644b5289@acm.org>
Date: Tue, 7 May 2024 11:16:13 -0700
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nilfs2: Use __field_struct() for a bitwise field
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-nilfs@vger.kernel.org
References: <20240506232437.21264-1-bvanassche@acm.org>
 <CAKFNMokz-zJu95hu42YVC6P5VJCJq-DStPWHuWpOkHwiq_RduQ@mail.gmail.com>
 <ae807f93-aba8-407e-a731-4634b2da03f2@acm.org>
 <20240507090115.50847c51afaa2b1361f170b8@linux-foundation.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240507090115.50847c51afaa2b1361f170b8@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/24 9:01 AM, Andrew Morton wrote:
> On Tue, 7 May 2024 05:55:27 -0700 Bart Van Assche <bvanassche@acm.org> wrote:
> 
>> On 5/6/24 21:10, Ryusuke Konishi wrote:
>>> So I'm thinking of having Andrew pick this up instead of my patch
>>> currently pending in the mm tree.
> 
> Please identify "my patch"?

I think it's this patch from one week ago: "[PATCH -mm 1/2] nilfs2: use 
integer type instead of enum req_op for event tracing header" 
(https://lore.kernel.org/linux-nilfs/CAKFNMokwnkku4tHcaAJPmFaBONZqoTMOLtKh_A7kcjzoxj3QZw@mail.gmail.com/T/#mfbbd7edb4a3ecc2d819869e58fb5a460dcb5b4bd)

Thanks,

Bart.
