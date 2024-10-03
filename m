Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1491A7263
	for <linux-nilfs@vger.kernel.org>; Thu,  3 Oct 2024 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727975364; cv=none; b=Bs/GSGUlllA3vbcq0YyeVOJviPsoPi8ddm0igZXMiDzxgHD6XT8gJf6ipSSlzWCt1dJX7hz2aHJWSi1RT41sXpXZ0TYAh38FKrp5280e59moIkQLaQm0sRMcD6dmzdiGH1z4m2OyVWTXHeygX56sJEBBz9rROsjCQKIFgSn0xcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727975364; c=relaxed/simple;
	bh=veZob2f6f+jF2aoHyYukXoVPX5HhWe0/4HygDAWChU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fACPns2rLnShOYb8V1eGO188v63phUUU1vVoghpxUpv70q5f3HCokJI0+H8nOyEr1HwyDhRDSkATflmQTnigDYJ/khP5KZS9bMVCy/YXHvT31BI3znlWQTm9I+98K1IFT2uSGVofD2OlnD/EH57QfEAME16guaYyZPdv8HecUPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=eQ0ANPeT; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="eQ0ANPeT"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6cb2aaf4a73so10687176d6.2
        for <linux-nilfs@vger.kernel.org>; Thu, 03 Oct 2024 10:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1727975362; x=1728580162; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lv6+V5DD1q+EbvJERytZupM7GavIklndcKQm84ak25U=;
        b=eQ0ANPeTYr8J7l35leuTWmevYYkn3K9uaDc2xiHwiHkiLe3SJ+5kibIXt7agq4PFDA
         JQeUfRsW08ZF3ba3BvlcmILg9PRosdgOwcoWZ610B9g29P9PX8fWgVVh9fqSJrT88H/P
         JqNHnzjsVMK8ESNdiSz1gSOgah2yixAcfEi5aXNaUFOBKEKyBJwaFtjtZCoSuHMHpLoY
         dzU2ZZ0ItUGWtzbdHoDRBlvR8C0YHbuhPLB81Is+wNq9pgJ08W/T017eQLZ7VGm3fG8z
         wuUzmqxV6scwPswbdeJUiaSFdUZYanVxkelJwG+RVL3CIF/01tKvZL0HKohFo0pr2syG
         wg4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727975362; x=1728580162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lv6+V5DD1q+EbvJERytZupM7GavIklndcKQm84ak25U=;
        b=JKo8j4pt1sVLifAWdbUH9OLfOrA1p9JGLZIb55CHkDNTq6nC8BSIItl+LDZ7Qa3aWj
         FwPzyGOtCPXeGpcv+b7mG2JWM1flATodgnx5cXew/u9g2187wv96VZ6MEclogq1f9ixM
         b4sEjXcEauaUej1fxLeW3PpoIc9nPlwN3PXyO7+vO7PpgL0vd+2TSgySzY4iaLR+oGTk
         hYtcI0wkaPj1BR2U1kdl9s2ySn6BbgGlf8/osM70wgEKU6iH72jwt2qNE1AU0DZu/FPO
         XmF2Ie1rSpHthTRi7aeuNqsUHKxsM/g+TlBy83BVOr4XQf5BTobLijY15OuJhYJRU98/
         W8qA==
X-Forwarded-Encrypted: i=1; AJvYcCVOFqJKLBeLjVg2kG8Z9Aer+dOvfeW15DX3jQXN6ymoUyvcKoLpM04pfrmiB4861BWyYIBILZBlnSkYvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzhrRCmcWoq5JB+agFGLPtDg0iigzJhpi++vS7T76DF0pTBPWUF
	nHxPR1Rg2p4pKPMRC4zROvaJuB4be18F3u/zha3JDP06spMvm9oolfiyLko7yNI=
X-Google-Smtp-Source: AGHT+IEkPpCAXCAtA9gfAP3eyJpKVnJ4NiXCYXXWlVAcJ8PH9XCm1z/O2+YTyJX5Rf/ppniNPbZCyg==
X-Received: by 2002:a05:6214:5547:b0:6cb:3d8c:994a with SMTP id 6a1803df08f44-6cb81a955femr111164996d6.32.1727975361783;
        Thu, 03 Oct 2024 10:09:21 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cb937f478fsm8082636d6.121.2024.10.03.10.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 10:09:20 -0700 (PDT)
Date: Thu, 3 Oct 2024 13:09:19 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/6] btrfs: Switch from using the private_2 flag to
 owner_2
Message-ID: <20241003170919.GA1652670@perftesting>
References: <20241002040111.1023018-1-willy@infradead.org>
 <20241002040111.1023018-5-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002040111.1023018-5-willy@infradead.org>

On Wed, Oct 02, 2024 at 05:01:06AM +0100, Matthew Wilcox (Oracle) wrote:
> We are close to removing the private_2 flag, so switch btrfs to using
> owner_2 for its ordered flag.  This is mostly used by buffer head
> filesystems, so btrfs can use it because it doesn't use buffer heads.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
