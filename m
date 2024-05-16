Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D4B156F2A;
	Thu, 16 May 2024 21:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715896326; cv=none; b=RpRbn9OVLM12wEvx+q86CAKucJOaIqKN1keO+ZUE5bW17T5fkfyoRzU2Kfhz0y20xAgjbgxwh453F1Nz4+WzK5/+YZHhivZ7Azq2+Os2E3pvQBcz4BAbbnE7AVdEeP+patpeRFBHC7oNiyyTeYZZQQH0u/luMnJTA3IzZIxQg2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715896326; c=relaxed/simple;
	bh=AJ+oje2i3UVqPU/z/dt3ZEHV3byJ0YBoiG6SDi/9wvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rh+Aa4HALpPrPxcjKYV7KmtNL/edyV4Ql7VhQYYnbmQYnYN2jJd/HIC3EcDT2vMBG4Ukq2Gv3J8MzU+bMePzDdan7sqI4Hhl3WWyHgyZQ8EPOgIxsgQtDCmh592sVqHwhiPlg2bOsDWAldE1OhakHQD+UsaKddKZJAKtN356V5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g28s2P68; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g28s2P68"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VgP2C1Wb3z6Cnk8t;
	Thu, 16 May 2024 21:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715896318; x=1718488319; bh=Bj5eq4OL55W+rSK34Om4WapA
	HrhBgkSRR4zqYMOa1zs=; b=g28s2P68w6nddG6TXyHYAcas2m9OfthI/sezG3gI
	V98hD0ogSxI6tDZ86MfOBqf/FrGTEEGxlGpDUbJmfclilROt/u2QQIdfGJaIxKST
	vWLUTLHwlVPtmA5twqSrt+1VkOpEWJ4hmTwF4cw6mux7HENLEmg0bAZQrXnY3fML
	2Gaw6XNWclnKAJSZz7Etw8pi8+DE0C/WYVpaci+7cBBi1RAnMu6aQSDnVwz8JFct
	xiJG2dfN8fpYauv4lT6IjMyf2hcHakxNkHSh/y1Xj5PGah0FnV+U5zkb9ehKtH8F
	xgbVXlvuVYo28ZxCaZ1I8KmzoDtCjHgeUZO9InPLznuciA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0YZ5q-mvcmGY; Thu, 16 May 2024 21:51:58 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VgP242XHVz6Cnk8s;
	Thu, 16 May 2024 21:51:55 +0000 (UTC)
Message-ID: <4a5cf233-a4e6-48ce-b9ba-f1014f452892@acm.org>
Date: Thu, 16 May 2024 15:51:54 -0600
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -mm] nilfs2: Use __field_struct() for a bitwise field
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Steven Rostedt <rostedt@goodmis.org>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>
References: <20240507142454.3344-1-konishi.ryusuke@gmail.com>
 <CAHk-=wgogPoSdCYw9jhc2Zm=BaE19nXYwFn_F9SwD2C-DyrmCw@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAHk-=wgogPoSdCYw9jhc2Zm=BaE19nXYwFn_F9SwD2C-DyrmCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/24 10:25, Linus Torvalds wrote:
> On Tue, 7 May 2024 at 07:25, Ryusuke Konishi <konishi.ryusuke@gmail.com> wrote:
>>
>>     Despite that change, sparse complains when
>> passing a bitwise type to is_signed_type(). It is not clear to me why.
> 
> Bah. The reason is this:
> 
>     #define is_signed_type(type) (((type)(-1)) < (__force type)1)
> 
> Basically, the way "is_signed_type()" works is that it casts a
> negative integer to the type, and checks to see if the value has now
> become a large value.
> 
> Now, it looks odd, because only one of those casts has a "__force" on
> it, but the reason for that is that casting all-ones and all-zeroes is
> ok for bitwise types (think of bitwise types as being a "collection of
> bits" - so all bits set or all bits clear are sane concepts regardless
> of any other semantics).
> 
> So it's not the casts themselves that are problematic: that part works fine.
> 
> But you cannot compare a random collection of bits for greater than or
> lesser than.
> 
> Think of things like byte orders: you can compare two values for
> _equality_ even if they are in the wrong byte order, but you can't
> compare them for "larger than" unless you turn them into the right CPU
> byte order.
> 
> Basically, a "collection of bits" doesn't have an ordering in itself,
> even if equality comparisons are ok.
> 
> So yeah, is_signed_type() doesn't work for bitwise types.
> 
> And I don't see a sane way to make "is_signed_type()" to work for
> bitwise types - the whole concept of signedness of "bunch of bits" is
> kind of nonsensical - so I suspect your workaround is the best we can
> do (alternatively, tracing would have to figure out a different way to
> test for signedness).

(replying to an email from ten days ago)

Thanks Linus for the detailed analysis. I tried the patch below but
unfortunately it is not sufficient to suppress sparse warnings about
bitwise types (all enum req_op values have the type __bitwise __u32):

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 8c252e073bd8..940563438b87 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -287,7 +287,14 @@ static inline void *offset_to_ptr(const int *off)
   * Whether 'type' is a signed type or an unsigned type. Supports 
scalar types,
   * bool and also pointer types.
   */
-#define is_signed_type(type) (((type)(-1)) < (__force type)1)
+#define is_signed_type(type)            \
+	(_Generic((__force type)1,      \
+		 unsigned char: 0,      \
+		 unsigned short: 0,     \
+		 unsigned int: 0,       \
+		 unsigned long: 0,      \
+		 unsigned long long: 0, \
+		 default: ((type)(-1)) < (type)1))
  #define is_unsigned_type(type) (!is_signed_type(type))

  /*

It seems like sparse verifies the types of all expressions in a
_Generic() argument list instead of only the expression for which the
type matches. Could this indicate a bug in sparse? On
https://en.cppreference.com/w/c/language/generic I found the
following (I'm not sure whether that website is a good reference):

"The controlling-expression and the expressions of the selections that 
are not chosen are never evaluated."

Thanks,

Bart.
