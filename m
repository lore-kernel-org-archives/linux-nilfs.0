Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C773D305050
	for <linux-nilfs@vger.kernel.org>; Wed, 24 Sep 2025 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721511; cv=none; b=V69a7L6mDGnDDnyTLyvqHsO/bGvScpNjHeuKcEvkDBxiT49Q2oFOTn8Q5dMCAKnGxmUHIMjE6Tt6A7sxoCoUusPvqD5Gv4LzSLYg4O5hCiSfMU165r40n1Ml/IbzW/H0zAvk3AbKncAyaiD3pO4j9WefArFlPidMJ/ukQUsqi8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721511; c=relaxed/simple;
	bh=XpovNoQrHLDRa2d3bvXHRdOCQ6hCK4CZOtSjxOfSRPg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=C9wA7CHLPlevxN+m7Mfm8/7Et5PqBmCP90AqbetxFhvkGt5k/plqB/CFR/UuZ1aWbnN5wTrhX55Oqqee9X5SbJAxjzZ9CR8D7xcpQe3bEwWptS2g/1K8jhoWKrEOEOMGoyS0AWwY4trwr4D2Qk2xgi4qECg3mSi6KHkFRW/TJPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eY9Wnyj4; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eY9Wnyj4"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758721506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XpovNoQrHLDRa2d3bvXHRdOCQ6hCK4CZOtSjxOfSRPg=;
	b=eY9Wnyj4ml/7oZauWpjSqHWXWOekHE9SguB1/bZ1rlD5f7QsVFxXwNDgdcaUdwGraeqHCY
	uScxc9Ij9xFTqJSUja/X+tpQPZGoRjQHiF6hYavlyiPwBYO6QhTxgkvj04fO/bwxYlRQq1
	UAHzy+1BzS0XBXvCWOUTIZi8GJ+T9VI=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] nilfs2: replace vmalloc + copy_from_user with
 vmemdup_user
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <CAKFNMonHxWSxW72Af8F_3Mhx39iO5hgVKAhTjpHVKsTBOQ-Z8g@mail.gmail.com>
Date: Wed, 24 Sep 2025 15:45:02 +0200
Cc: linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <2B76A58C-8AE6-4DAF-9B6B-7927FB301F6B@linux.dev>
References: <20250923120902.1844458-2-thorsten.blum@linux.dev>
 <CAKFNMonHxWSxW72Af8F_3Mhx39iO5hgVKAhTjpHVKsTBOQ-Z8g@mail.gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
X-Migadu-Flow: FLOW_OUT

Hi Ryusuke,

On 24. Sep 2025, at 14:18, Ryusuke Konishi wrote:
> ...
> So, rather than rushing it into the upcoming merge window, please let
> me schedule this to be sent upstream in the cycle after that.

Sounds good as this was meant for the next cycle anyway.

Thanks,
Thorsten

