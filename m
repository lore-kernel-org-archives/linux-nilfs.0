Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1193BE174
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Jun 2026 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781888861; cv=pass; b=NLCdVrkHXj51pDzeSal4t4jdagsQ5sbc0DKDueuKQgxo6pd7RB7/wpJ+ACXyoZoCUL2Z0G9URxe9bUA6pYt7KXrBCawzXY3B5B3EEKafzcgyu8YmL9V0AvlEvYY9nK+W2tzMrZyzoULyzZUY4UnVa/XIsZn2ab2NhM4/HwbsAzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781888861; c=relaxed/simple;
	bh=PHbOwDSZDfn8sD2jCiOH8/z9cSHPBd/WrmCPiQ/OEuo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=SNjQAxruXQK6geRh2/E81Zqt4IGi6DtEj7g3rGPragcPjsthcgf84EVXAVIOjEvw95aZgCI2bLm/pC8VHoKZJ1ZGzFDyhjmus/hI1pEm06mo47nLpta0/sxyVvzf1BVuJVb+mLGFNwkmFLpkct7Z6KxUXVU3PFnnW5Q17/2RFw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mVwrkR93; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mVwrkR93"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7e0aa486af8so32047917b3.1
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Jun 2026 10:07:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781888859; cv=none;
        d=google.com; s=arc-20240605;
        b=Fq+5pipRl9+7JeuDvvP4L/93Jeol/QEC2o0WC9T8HSZ8cEbFed5l3Cd9qvH4T5eX6j
         go1uqkyMyZNLh3RhMouZz4mfTGB21yKSDuu12nrSgtFboc4/dhHFw2lnpI5qa8BNbpUY
         k7I1OhMzUCmvQou3C4oYCIeZrEtFTGtoNkMoSnqj7tYY52fs2OjZWdpjD7o3rCDXVbIy
         5cJGMmdZu0pCkYlnnXhsIsDowIkfdVFKCJZBEUiCK/SJi1kfc5xVWaS2XmPD35QXHZcY
         zRM8lC7TYV7jnsaxaPUk73O8EKVxiUxcmf9Z24Pft7nxISKIfVBq93SsBhURhej0dtAH
         +Plg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :dkim-signature;
        bh=PHbOwDSZDfn8sD2jCiOH8/z9cSHPBd/WrmCPiQ/OEuo=;
        fh=Afbqn6eya/G+dOUTlJ1LpDbmd7FU0jRH4DaWLsAvfgU=;
        b=C+wAE0SpFYFKmlEjcE8lQTFOXeG5ybKc8D6M5npB/5OcB1WMaLPX2CJR+cJZlN/CmD
         gCukSErofGpLbVO7K2SN4HUX3Jfx7k1IymISDHUby84iRJF1Na8HpprOYvAzyPUisTNZ
         2KxffqPubz50zkZ82tyMD0CO6rVBTKtrfnH3+OsAM3zKLmM84JF9nJwdwNoFj9jgGIO9
         kcjgszMFoJ+g84OJ2pXuviS792jciXDLnfRvvLfMNRHnBDRi3bXPXy/W6vXdv8JyLyQr
         EsoXa7+XQtuvYnzNzWWhsfYBs/0PBs2RRUPMoU/0Q1zgBUef+pcMyvL2yO6Gn6swWPJC
         QH8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781888859; x=1782493659; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PHbOwDSZDfn8sD2jCiOH8/z9cSHPBd/WrmCPiQ/OEuo=;
        b=mVwrkR93Hn3+CO8lhNjMBw2b8CM0So6Gum7PJLKHsm8jOmQKKFMkObqxSMUhdDgFgc
         SxZtN3fYOkFr4n5FZcaquMagg0p4n22DWOb226XnI5SXosgK8tZjGdpNMF1EKgsP4tsD
         vzrmm/2+9gsS+yF8Fba6xkp0pYMaiCQu0dSmkSjVYzaH4ohlIMtjmaaB14c6U4c3ZmBS
         kEq7FZyBam0oGc+AuqVVP9v3nR8OP2Iofwc1Z8RpRH1j7ALyi5sNy4bjJajqB+sQgplx
         FeGZFYLfsByA1y7lRLbUvCXQoA/wL7FKLIYqRbHTStMY5nhlxD0tpsxi0VX2Ub+r3To2
         JDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781888859; x=1782493659;
        h=to:subject:message-id:date:reply-to:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PHbOwDSZDfn8sD2jCiOH8/z9cSHPBd/WrmCPiQ/OEuo=;
        b=S5/mup2jeZ1xpCaAlMCgkXLfd4serAfeFyaQJAlC48pvpXJ7r8TJ2UXbSPVkNJdVzv
         Q21IaJYqtmQqKjVktcrbqqXamdnjKqOtdO3UUApbEy055+uXkZZtkx4oB+9RyKwVo4o5
         hbcO3YJ6cANGw5yeegIF47v56rMrXoh+15TQnHhP+EBx73q3JDsWQWt505ezIR4Bts7H
         ATrgz2vbCT/h0fHN4x/rDv9j5tR/cZd4Px8mbCShd+dNbSEcyiO/QjZHcu/roXT7+QC+
         gbwREUyaX5HU1f6iRAcJ3QQrRdEeWTMwoP4w6N0lOx09vf6mcwEnrVvdbjNTb1poasGW
         jLyQ==
X-Gm-Message-State: AOJu0YxNn6SCsJAf5Vvmv+apYxQSlWAkhygUV+1xpG+c80AUT17kr7Uu
	hNvEuEebjboQjyTEcW8+a+JF42f5tyZ3rSMq4qhjcpOZIfbR6IZg7xDtaCSdHkmPwsFbKt0NVoU
	RE8yv6EhFKiE+GnKKLDjOIxG8nam/5sIQdg==
X-Gm-Gg: AfdE7ckV/3vVOOKBJmLZyHEJo+ObLNV+UesCtMrDT4TJEU81Xg28c0rTC0exeeWum4y
	bBY/JwbzwOJP0/GiMwKfgN7xqCyw9hpJv19G8xvHM6K7UEi/EY0ne/PkTKRcdQctGwvbSfo+QjJ
	bZpx6q2uvxpvJdfts5DIiFTkT3RBVL8lwNP5D42kVrOddQ5+G9jOXkHJ98hwM1N58Sc00/8nIhs
	SN6BJ7k8mfzD3ypouQYFEA5iyQVUXk9CLfXKJ05WkUkYPyamyD62/ThrMLcPJk4q8Rk
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:690c:6b12:b0:7ef:e7ec:b6e7 with SMTP id
 00721157ae682-80123a87d47mr36378587b3.27.1781888858860; Fri, 19 Jun 2026
 10:07:38 -0700 (PDT)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 19 Jun 2026 13:07:38 -0400
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 19 Jun 2026 13:07:38 -0400
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Fri, 19 Jun 2026 13:07:38 -0400
X-Gm-Features: AVVi8CePNJg5CtZtjh5wMx9NaHKbnqpzBFWSo3z17BMWptpD7CgI0p5YXnAGMmw
Message-ID: <CAE7Udf-Y9trkpVONYC0NodvconyXcqwrSXDCzEf10mWjxTcPDw@mail.gmail.com>
Subject: NILFS utils 2.2.17 was released
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fixed a vulnerability in the library routine that determines whether a
superblock is valid, as well as a bug in the cleanerd fallback logic
during memory shortage. (v2.2 maintenance release)

from https://nilfs.sourceforge.io/en/download.html#2.2.17-u
