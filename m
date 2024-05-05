Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C84A21;
	Sun,  5 May 2024 12:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714913263; cv=none; b=c6/GXsc7AG5BgMMekuMVvJu6G8XGzaknWLvlK6WUEErVcF6JlsWJrMcOb4fhs4Y5/PU0rJEwf3mxfso33Qu8OlKUkSiF5XRwhlRXyHmsR6IBd4F6LFpoG7/ap6eOWMn90pKeJHVzmf5+neF6BGdkf16laQTOqWmJnpz3CbG1giE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714913263; c=relaxed/simple;
	bh=F2FHAydrM4Fu97BXK9d3X/PI9bvwXg2FTsbEBxWdXBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mCQDa+ixdW3a3/dSjV7TAn5Vtmx6vAPQBVHpOax4jUukQHBT/8TZ0tfLGglTG8jiXEoXUyZaWjrWE9N4L+emzdsIsCi8avYpQyuprSoAf9ruaBKoD8Mdy0s8xondhsmT5siGhvhuJP5lGZeA7143ehSPWumqOyIwS4tHrGEk8Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=huAE6tgp; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="huAE6tgp"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VXPT32w3zz6Cp2tZ;
	Sun,  5 May 2024 12:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1714913253; x=1717505254; bh=5FHfIpSzEQFovv08YcFGiZz2
	9l56wZcz2Up+cABevP8=; b=huAE6tgp2GeLmDMGShTWY6YYnljmzKcwAm35sqrJ
	2a42oiar46O4zSWCo77BnNtskaNbp3HQUBSbP5vsOTvmFeorKxcc8d8nnzheAaZ9
	5wQ0D3Vk9z4aTEBgO9z/8MnyRNF6KfxyibWh/yJmcwvZDGgO0tVBrgzezmuIjHBQ
	5MQhX1rZ8UJMZqiIy1Id2LZBcM4GgpEh8fkCB2whLa6rvye3rZtCIdI73MEgD4Al
	sDnNiXvka2GAvDaFJYXgfLGOLHFbTneCDnmO1xGjI452SFkfV9BgYaJGhDWO6sRB
	vrUu5j5NeVTuwfTNRgs1yWV//VdlI/Fn+oVRw+1aMq+UYw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RDwhh8cKXPIc; Sun,  5 May 2024 12:47:33 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VXPT04FgNz6Cnv3g;
	Sun,  5 May 2024 12:47:32 +0000 (UTC)
Message-ID: <32e6621b-cbd9-42be-8626-49c12c25f139@acm.org>
Date: Sun, 5 May 2024 05:47:31 -0700
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAKFNMo=rkHF6urydfDbcvTbGzUEHmsTudVMm517pTE32vzqiwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/2/24 12:01 PM, Ryusuke Konishi wrote:
> If you haven't given up yet on solving the underlying problem, I would
> like to withdraw this patch.

Has this untested change been considered?

diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
index 8efc6236f57c..67fd2e002ca7 100644
--- a/include/trace/events/nilfs2.h
+++ b/include/trace/events/nilfs2.h
@@ -214,7 +214,7 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
  		      __entry->inode,
  		      __entry->ino,
  		      __entry->blkoff,
-		      __entry->mode)
+		      (__force u32)__entry->mode)
  );

  #endif /* _TRACE_NILFS2_H */

