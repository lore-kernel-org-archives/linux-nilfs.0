Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792745514;
	b=eRcn8Zwh+Zh+Sd8iK+2DMysHRrMIwfYmwOvMYPVe8863kApWVBayzXb/WrrpWo4kjOl+
	 Rnko+9Vc682T/wtAar6s/0+d2dvkGBEEl9hJ8J7PEQVavz/4Fl/rfCuVvaXnWVHcdeqa7
	 wDMqPToPptw4M7d95NEHhlW3BydtM7PKwPdwHyAahbMX2G+cteuVvKRsJsAyW1goXf2Ko
	 iTSXUpoBE746996b0WJk9b9beg8+gWEWX9CiwNOsM5GqN33nBI0+1ORO320K1zLeo+jey
	 ga8BXlhXiuAqDDRU6p12MbUROdZ8Avf0RejZqoVcPlydMTezo2VamRbtE0CUreNZbtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792745514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XsQ7jb7KO3Mrp8snOLVCes53wF+hkQPQbyMlf+Nofr8=;
	b=fL3zrQPO5RguNzc4y+k5SH3Esi5Jtku/mRdRGfeHG+BZfNFXPsGCW8yevUXuXrdPs2gj
	 3PqiBEyWblbCjqFLWmdVwiuiP7Bmwx83xesJLwY+JGCvVt9F/PD7VSDgjL3HKaEHqgs1E
	 pF9AYcuQlpIjilQe83bGYbJwLVYXVUysEVK8lF9XQKPhGVcS2FoR3a+qI3qenZ3VGQhR6
	 LMdkFnK3Ss38eeoNY5gzOzduH2Au0dbPLqPR84jA7WnJxbxMtqmGrKixorTe2IEjgbMEk
	 Cij0XuwAqA8otCEsKqdQL6SJAgJpBJhpDACy4M+OTUrEl7NAY2eolWPBXO9Iib8gATw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OlLf0Bg8;
	arc=none smtp.remote-ip=209.85.221.169
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F484606A31B
	for <linux-nilfs@vger.kernel.org>; Fri, 23 Oct 2026 08:51:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F484606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OlLf0Bg8
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5eab93a9862so186696e0c.0
        for <linux-nilfs@vger.kernel.org>; Fri, 23 Oct 2026 01:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792745512; x=1793350312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XsQ7jb7KO3Mrp8snOLVCes53wF+hkQPQbyMlf+Nofr8=;
        b=OlLf0Bg8codaTQcw5DcH+h/1/uwGj+Gp1nUwjStmUDhQDUIqGONd2WeFQGkvXClMUW
         j7bHlpOcJqBfCHIqNM40FRxOKlMouS+yza9v51Vv7WrITnDywHcTI9xXeMPt0C85gJMD
         x290lNXjcjVDmopfljxhH9DYat5XDr3jXk5/FWGkfLtNf3k6KoPmbcy8GmVayqlyvFML
         fkngQ4lb05PQHFd15G2kksBYmExgt90FgwA9iUTUclFiRhfVk2e4SfcUnkEv8KAWRXmr
         RlwT+bMTMLEwZM1PSIiO0ecW1+Z2PpKovuPpBF+8bmPE3XUnCUEsQdjTXrZqjIjA+nkE
         lc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792745512; x=1793350312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XsQ7jb7KO3Mrp8snOLVCes53wF+hkQPQbyMlf+Nofr8=;
        b=vs1C4eo4F49lTagWMU4tpOAZHNVV+Z/9JQZ4VpJbs9wYM6VZf/citZjpdCGRlhrkJg
         IYssq2Xqq9pWWBMgUtRB5nvqQBj95bY28cYqMu7SKTaFxeBUU5x9mVSGfXixH64lurru
         YXDZowEIo5VyQlATz488HvlWxfUb7E8GfnCP1DMutq92b/D3EVjg1V4da4yTbSoS+aV0
         gffMvbjw70EoeMQL8xZGW3rr1gikLi/xO66n83sImP0k65/9rvrtcJ62IJbkxtTKG+NE
         2HBtSzymGodMwciGbyqoR/XAr7yovG6NmNm3bSqgMs4EBe1o1eN9RyP4IJcqONfl0w/O
         kH0Q==
X-Forwarded-Encrypted: i=1; AKwUvBwKH7YVh7QIpmS9FXQw63ixrmLBn2O/XDDTaEC9LFrCEVtttoV5nU5PSBqlZueiw5eTUwH2yyAu4wY3SA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLHBNSUrNi7IJjkqhRrnkD0y43MDiH5gkoKeYSELsKtjTyCEe44
	iuU+UNpFBYaHtxDpMwwfNTlTUAtQ+40XwThQuCGf+BTpwUELqNWtx5xv
X-Gm-Gg: AYBFou2FqsxIbFaUjFVNCrydg9IGaFUIKD5iUU/fjie+tvZ/Ge1VFQHXU++bKI2+rEY
	t1eNH8Mjnqn9Ua0nmnSkJ/cFg9ss5JEKb+aXX7UYizyuouSCOQPZDaxT0hCAXLK8sO+TNqcVq9W
	zZb4PzMyY+dwMKxxO5UwgkYIP528A4ogp7hSrglAymlfDt8RKI1mS/L7xL20NbTycO2SuCFyyk/
	Ni41TxIFvuvtWurmOF4TBHGqHZqn3cpeXQBQ2ZLDwEmyGUOoS9n/lF2WKaY1zRSaGs8HPhrO7WX
	LAk36kgy1H7ndavyYI+uiXbFr1tmbMxLn1UQTPgayGtAH6NQwhGW0ztJMrl4BqVqzYKMtQGzphd
	BXaOaPLdKmqnCOl/iTIcAXwdKYHs15IYnD/AOYDVsslHShvEzRraXG+aQm9DbWYVoblFCT409XM
	P4WYaVPgkptJ2seOJjrr7BYDE/jRl5rOUw0dGCbMKKOZjU68FAhGxSVAYSfpRqW711Q12zqrb1E
	6WwS1sP1b9OsQVgs+zGaERrWXvhrPNamuI97HYOiYWjoudaeJzhdjDagxhlGSLmhRnDmxX+LRFj
	lbBD0t3zfLI+Py/FWVei
X-Received: by 2002:a05:6122:3482:b0:5d4:dd7c:b22b with SMTP id 71dfb90a1353d-5ec14a86114mr472271e0c.12.1792745512510;
        Fri, 23 Oct 2026 01:51:52 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec13f674c5sm1717371e0c.16.2026.10.23.01.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 01:51:52 -0700 (PDT)
From: Breno Rodrigues Alves <breno3011alves@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Breno Rodrigues Alves <breno3011alves@gmail.com>
Subject: Re: [PATCH] nilfs2: remove two dead '#if 0' blocks
Date: Fri, 23 Oct 2026 05:51:32 -0300
Message-ID: <20261023085132.4874-1-breno3011alves@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <CAKFNMomoPV87KM94eYMHNz9WG9CuAHOWVEgPbsEBUZi55jhHpg@mail.gmail.com>
References: <20261022220637.89697-1-breno3011alves@gmail.com> <CAKFNMomoPV87KM94eYMHNz9WG9CuAHOWVEgPbsEBUZi55jhHpg@mail.gmail.com>
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ryusuke,

Thank you for the pointer - I should have checked the latest mainline
master and the linux-nilfs list history before sending.  Please consider
the patch dropped.

I will be more careful next time.

Breno
