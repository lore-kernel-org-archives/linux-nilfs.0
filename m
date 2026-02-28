Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3E930274D
	for <linux-nilfs@vger.kernel.org>; Sat, 28 Feb 2026 04:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772251867; cv=none; b=jQtSA4nkhuWzbXRJXkiDjcPL0bfhQRdQAvezvnlwgEeCU6g6VmXZseJOuBsYrEm/xm6XxJjkcHpgTIPYO0ZDc6ptnIT3bEoviD7/QO5s2PLdv3BfkLxuIiQM7iTk47boFZKVC7LCBcfjxrR1ugrGKeXB/S6Vnd0wSdzoPsyYDng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772251867; c=relaxed/simple;
	bh=plyVn+BKfoyL9u0QhzlEuFxYs62Qofix5INAmvZbgaY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=bLxrxbtOnB7Ul0JYyeNP1EzmwE+gB9WPxS3zgS79QXioRBAt5AYjZXeIq1KCVf1hf+DELKKOcDcaN3SS45soypJQxxaj6kHJtZW5TnACnesgMEgY500VY+a+48Af36LxJ5fjsdOsLFggPZke6BeXpM4LHsAlSykHZVwZ2lcpGp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=kvxRBJTV; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="kvxRBJTV"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SGDrRcmOhvI7U5Idyqp+usjzvWo8orTDNcE7eLcziwE=;
	b=kvxRBJTVpuiDyhuduxdlQaYjEIOFA3r6t3cNUL0MLYvnC/VNMw7L0VN2WK1Oq/Std+C9aIgqq
	IBYEB6+Mj57q9DcK5ICpD+mP4CdryzqDEixmajHU0qq0x0gXcIbW0YQwr/odqTxOnNAb5W+ye5F
	XWOz6aEQ4txWBEE7aOlLen0=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4fNBSv2Z0dzRhTB
	for <linux-nilfs@vger.kernel.org>; Sat, 28 Feb 2026 12:06:07 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 25B4140569
	for <linux-nilfs@vger.kernel.org>; Sat, 28 Feb 2026 12:10:55 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 28 Feb 2026 12:10:54 +0800
Message-ID: <a7212afb-29e0-45ba-b349-b5ab86d5af63@huawei.com>
Date: Sat, 28 Feb 2026 12:10:54 +0800
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: <linux-nilfs@vger.kernel.org>
Content-Language: en-US
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
Subject: subscribe
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf200016.china.huawei.com (7.202.181.9)


-- 
Regards
