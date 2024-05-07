Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334C953E18
	for <linux-nilfs@vger.kernel.org>; Tue,  7 May 2024 12:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715086532; cv=none; b=D3RUWs9TygGxdEkkJHoNqE03vhzj5vZwS+BGzl0VtJG3AmS0aYFfZsxdqYrKnsnO5Qit/P6rzlv1rctu6IAncE3bfJXVgL8uuo5BBr39fKT6IgOgeWJAvnlJI1kNKPkbmJpKqlCPy+xGDgfEFvvdSkRoPeMAUfZaCg02Gjx5QTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715086532; c=relaxed/simple;
	bh=4GIOUbDDnXZYvpnIn62YFzZrfoGyaokPq3jThcGPeD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D/KdjJthJR363Y5XwLHr94C+RPDugsprr/J4uYp3nlxp7SrvWriRE1MQ+5CK9QIRaUwtMrs+dW0jtUKd6fCGHe7cm+d0xnK5/6t7gsNy6e3z7FHf8/Rzyq6dLjR9XWLvHUCLImar2t4pdKSCMG3CgCd4ne6gx1xiNllpQskSArI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qT8GF5Pm; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qT8GF5Pm"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VYdYF43gvz6Cnk90;
	Tue,  7 May 2024 12:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715086527; x=1717678528; bh=MAIYwoTDDiZge4ZwSGOKK8kf
	ScJSLdUfr3hXSeAd0C8=; b=qT8GF5Pm8Wf5NeIJd6+ByW0BQNB4oho1H3iFkNS4
	t/i67aqacklHnwycK9P0+QUAWBujUzxS4Kj0uM1N2pMETqOBBJyVJhM4TAiHo9ph
	lCSgQ0JPy3bfcGXwru9NplPghXl6kZrJd0GeebtKJvTQR/mXhjIwe9DpzVrRz6Yu
	3WrVc1vGfqf1DeKJd1r1Io9hNL57TyuiAmpKXlg63Qbm9GK4WQvKmnZn9V39aUD4
	J1YIvKcf9VZ/ZnZ+T6Ct8uOlkhP9f5QFhJEEcZBmgGrYal+FgryB/uo5dlUVnasN
	r3npoUJx15UB18kE48CbrnW/oWHXxlztgLHHARKyARQarg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oUli2uZEul2m; Tue,  7 May 2024 12:55:27 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VYdYB5XN9z6Cnk8t;
	Tue,  7 May 2024 12:55:26 +0000 (UTC)
Message-ID: <ae807f93-aba8-407e-a731-4634b2da03f2@acm.org>
Date: Tue, 7 May 2024 05:55:27 -0700
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nilfs2: Use __field_struct() for a bitwise field
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-nilfs@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
References: <20240506232437.21264-1-bvanassche@acm.org>
 <CAKFNMokz-zJu95hu42YVC6P5VJCJq-DStPWHuWpOkHwiq_RduQ@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAKFNMokz-zJu95hu42YVC6P5VJCJq-DStPWHuWpOkHwiq_RduQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/6/24 21:10, Ryusuke Konishi wrote:
> So I'm thinking of having Andrew pick this up instead of my patch
> currently pending in the mm tree.
(+Andrew)

The patch Ryusuke is referring to is available here:
https://lore.kernel.org/linux-nilfs/20240506232437.21264-1-bvanassche@acm.org/

Thanks,

Bart.	
