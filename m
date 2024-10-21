Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184261E1A3B
	for <linux-nilfs@vger.kernel.org>; Mon, 21 Oct 2024 11:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729511650; cv=none; b=UcZmPk3yFHTJbLlB83vnO/isqRQvNovESBOMdACXkJ83IOZdQMWre338A7tp1VD4zub8VQGtscgX6XzlFT3bpNd+++h8uIfyxQezDNNrFkTmieqUIUS2GhqdtfwDDQrvZJk2n34bl+qF2QBO93fOEcONV31ovqODTf7Z8GmbBe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729511650; c=relaxed/simple;
	bh=YlLyiQ0IyoSrf4p2b4R1meDiOh/k2SlLbx+vvxOCYjE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=NlV64X3LpBCB2QD773dv0kS8v3/BTCNmMG5GAdsThPPoxmFL03VedfermHIHzxs3xq2I5RsZSBqpspzlYMEmIdKDZ7BQwCzoGKlVlkFwpD510Xb3wJOJ5quW6p/53gQ2dgk5U0iskqs/1m9DgAjVqb841q7cXwaksqS4hsragmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ivUqOcil; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ivUqOcil"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6e5cec98cceso20969767b3.2
        for <linux-nilfs@vger.kernel.org>; Mon, 21 Oct 2024 04:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729511648; x=1730116448; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=smZCTPgoDncyQJmz82P4k8sCJXzMcfgxSbXRpQ6JE9g=;
        b=ivUqOcilC7Q9B7YMX77IDix3M1QqYTCqWLSs9FD2O9LMbWYIX7i0mS7AEtOVR3kDcG
         OmvcLGomyigLv8NknqcWNBwtHHw6FabfZLe+pk0jRweBEhRLG2R3fhYHcUmYZA6Y5+Hj
         EKLt6/vDEQfFwNezRhCqpO6D6z66gtYnbC0zQYjri9YcD6uG+mfgevgTWlh2dHA3i7eM
         mTKrHI3mxrYESYQpIdPhTKyI38msg+2uMzlNjOFQgYl7mWn003qyQZzxlos1kT91eOmN
         02f0maWq8HbzmqJxVQvxaqBrAGdlL3VCYKOLQr0PrbOFN5Vil85C2/SpJtBCoZATEGc5
         wYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729511648; x=1730116448;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=smZCTPgoDncyQJmz82P4k8sCJXzMcfgxSbXRpQ6JE9g=;
        b=r6i6xcofXXtSWPJAgMJlERDt5K6ZS1Bftgx4e6v27IJMj/fo1fXx8KnC9yPtjA5Lud
         sKJMmszQKWeLUzzcqWVIfJrVPQghwQiI5Sxjo2poXvpAZTqr6gbqJNBIGAgivtSKiCXe
         5QAzHV3bvLTV4MR1axDI0iZ/ywN32y22RbjJAO3xB9iH+EPh2tCMSXg4e7s5mGRe1dgK
         jHkV4WLBwgC8WwJltsKqlsRi8xoCEmHzj69bOpx5Yqeu5ZekstDNGhKpTsjoYM9YwzuE
         5+aC2fSdCa4hEAZaEFkwL+FTE3c3Nsct8KXRCpDChq3mOuUF1vJm6RYZ8t+BPeXcruGE
         STrg==
X-Gm-Message-State: AOJu0YwsRCKVRIfGDJxu4iKEG2Vt9dX1jX/bWbx8ZWaFQwT5T/ZysyPH
	3r3HxZQJ2CwHll5fbBgG+ljE58b8Jn0Ty45UqF5ve4y+vrtGe7GK/UGe3/PLo2PHTa+adpUshdz
	OvoCJfqG5esyaAtxmu27myby64oDlkgoD
X-Google-Smtp-Source: AGHT+IFYYDMi8WFvXvGAspmWQrAvKSiUITUx3O4xELZscXy6p9w/qR8/mMnkJHm/KI4Mco4FhD2/GcJGuk37Oy64t5E=
X-Received: by 2002:a05:690c:fc4:b0:6e2:4c7b:e379 with SMTP id
 00721157ae682-6e5bf9e62ccmr111943977b3.19.1729511647996; Mon, 21 Oct 2024
 04:54:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: dexen deVries <dexen.devries@gmail.com>
Date: Mon, 21 Oct 2024 13:53:57 +0200
Message-ID: <CAJUT6o4xwggZDcyHq2yYiRRLgqkho5oQSsqW0g4ZCWR6R0w-MA@mail.gmail.com>
Subject: lscp and number of used or appended blocks
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello list,

lscp's "-g, --show-increment" option seems to give misleading number
of appended blocks, significantly under-counting disk usage. i
expected the sum total of increments, plus the full size of the first
checkpoint, multiplied by block size (4096 in my case) to be equal to
total used disk space (or slightly below it, due to partly used
segments). and while the size of each checkpoint is indeed roughly
equal to disk use by that checkpoint, the sum of increments
significantly undercounts disk space usage.

am i using it wrong, or is it bugged?
using latest kernel and long-running filesystems

example from one of my computers: 170GB calculated vs 356GB actual use
Nr checkpoints: 49477
Oldest checkpoint used space [MB]:          141903
Computed sum increments used space [MB]:     28777
Computed sum total used space [MB]:         170680
Actual used space reported by df -m [MB]:   354072


example from another of my computers: 34GB calculated vs 119GB actual use
Nr checkpoints: 2368
Oldest checkpoint used space [MB]:           27520
Computed sum increments used space [MB]:      6813
Computed sum total used space [MB]:          34334
Actual used space reported by df -m [MB]:   119040

repro script:
#!/bin/sh

fs=`df . | awk 'NR==2 {print $1}'`
lscp $fs | awk 'END {print "Nr checkpoints: " NR-1}'
lscp --all $fs | awk 'NR==2 {print $6}' | awk '{printf("Oldest
checkpoint used space [MB]: %15d\n", ($1*4096)/1024/1024)}'
lscp --all --show-increment $fs | head -n-1 | awk 'NR>2 {sum=sum+$6}
END {print sum}' | awk '{printf("Computed sum increments used space
[MB]: %9d\n", ($1*4096)/1024/1024)}'
{
lscp --all $fs | awk 'NR==2 {print $6}'
lscp --all --show-increment $fs | head -n-1 | awk 'NR>2 {print $6}'
} | awk '{sum=sum+$1} END { printf("Computed sum total used space
[MB]: %14d\n", (sum*4096)/1024/1024)}'
df -m $fs | awk 'NR==2 {printf("Actual used space reported by df -m
[MB]: %8d\n", $3)}'


cheers,
--
dexen
