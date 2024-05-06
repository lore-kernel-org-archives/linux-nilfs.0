Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0F715746D;
	Mon,  6 May 2024 17:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715016370; cv=none; b=Kk4JXmMVrd/Em2IfUe/b1ovlOrMq1hbSYCGi/RRJYvkmz1Q3WH0S4/iIIxF9IxVbKBOsrNHsXLC6YHLmNPiS4Nju+uYd1ag7G68NUBVYZSyl3IzXYkD3qqxOE/g4gjlfxpUyEefrR2Eut0OqdOwJhIjOSNHr3EVNF9TA3ID+75o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715016370; c=relaxed/simple;
	bh=/UEdzWG6W3N3O/mmzu5JT7SpPAIeYbPNPjDDE2tNG3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ALQc6EbbeLzxUonOBcLyKLVRtGkb+BpT9h/6FQHbD3Q9NdZIRVrARsifWIeq6je8X48vCogGuFLxdRKwr8HErjaQN07hDf4CoOdGSf/EJd36C7VBdR3O9D+apGIRN72m8Biyzf7Qgd9kpvp0uvmSCYnUvDAAlfUTcLsaCmsZgu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=D8uO3I7i; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="D8uO3I7i"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VY7c02D1Vz6Cnk9X;
	Mon,  6 May 2024 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715016366; x=1717608367; bh=o74xjSgX6ct8IVhhMhcaWWX0
	LqgWCepZXu5YS4av2Bo=; b=D8uO3I7i5qgxMTT3MRWY6m34AzGmqRocT9xTmb2M
	TEphfE6dJ1cepLDC0xCrhswRYwwNjSAl9i+1mOrKnA9EzQPgD0L7FjE4p/T0tjuT
	CSGb4dUz2MetdcIVcwkBKWfb0WBrDaLhErKRfcdk56uSD5gV/psP32gnstj34VtD
	AS+8zAtsqQvRgWJZ9SeBX5uUF0b+EHJHxGkc/gyplXkCY29qaOlyycaMAKp1LGsM
	BwMHw7tPFTLupK+CpYKNiYvwtV2QTNtHubnG+cwCCnlZKqLZ4y9Vc0i3Pht9ceaX
	9Tj5M23RFO7LeMDzShoEifev/W4iKhBcxUcn5LDklX1UXA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sRWVsYLPV9Et; Mon,  6 May 2024 17:26:06 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VY7bw61x4z6Cnk9W;
	Mon,  6 May 2024 17:26:04 +0000 (UTC)
Message-ID: <5a1ebb30-d6b8-4f1f-9324-4d7b12e1be21@acm.org>
Date: Mon, 6 May 2024 10:26:02 -0700
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -mm 1/2] nilfs2: use integer type instead of enum req_op
 for event tracing header
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <20240430080019.4242-1-konishi.ryusuke@gmail.com>
 <20240430080019.4242-2-konishi.ryusuke@gmail.com>
 <650ed9f6-fa50-4a3b-939d-633f9e389137@acm.org>
 <CAKFNMomCzNMU0tjLkEchr=GQwSVW1zr1GAq7vUToeOvX-M3eVg@mail.gmail.com>
 <CAKFNMo=rkHF6urydfDbcvTbGzUEHmsTudVMm517pTE32vzqiwA@mail.gmail.com>
 <32e6621b-cbd9-42be-8626-49c12c25f139@acm.org>
 <CAKFNMokSLHrB8jyGuNH-HBqcrAmJ5-SFwu-sTgt30X2j+=KykA@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAKFNMokSLHrB8jyGuNH-HBqcrAmJ5-SFwu-sTgt30X2j+=KykA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/24 12:04 PM, Ryusuke Konishi wrote:
> I also tried typecasting on the declaration header side of event
> tracing, but so far, the sparse warnings don't go away except for the
> patch I first proposed.

How about this patch?

diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
index 8efc6236f57c..b1a364a33a62 100644
--- a/include/trace/events/nilfs2.h
+++ b/include/trace/events/nilfs2.h
@@ -200,7 +200,11 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
  		    __field(struct inode *, inode)
  		    __field(unsigned long, ino)
  		    __field(unsigned long, blkoff)
-		    __field(enum req_op, mode)
+		    /*
+		     * Use field_struct to avoid is_signed_type() on the bitwise
+		     * type enum req_op.
+		     */
+		    __field_struct(enum req_op, mode)
  	    ),

  	    TP_fast_assign(

Thanks,

Bart.
