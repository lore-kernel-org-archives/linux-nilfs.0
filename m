Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC9E1A3BC5
	for <linux-nilfs@vger.kernel.org>; Thu,  1 Aug 2024 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722527045; cv=none; b=BveVdGwMelA6lZsW5oSgw5rECmlsk0tkm2yPsXXcMPVHw8LlQOzw/neo31f9L3lPcbrglQjgyQFXcRgP55gI5UVC2T3HbFkVR+m53q5rE71hXfhvUq9AJLIcqW8G+DOcYyNBVkTAxSfrwaGT97MPtfB3L7YzPdq2pnZv0awV0+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722527045; c=relaxed/simple;
	bh=bjtO0OCNixinMela1FxJ9MrglssDBuKC3DZxSuWU6AA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Ef8F4uE8IwEcTG8/SABds+kmMXW+6h1Gvtx6p46o8R2xycwufyp7Vpc/OkNog7pYbkXr/YnrLtNskpIGSxr1ec52nxfVwPXhYwYYAIlbuRUfdhI/SPPE/uL9QHiw69A7jT78Zb1SBnFd+AAN00p3xhl8yZwRWqtrBHuEo++fTCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.stonybrook.edu; spf=pass smtp.mailfrom=cs.stonybrook.edu; dkim=pass (1024-bit key) header.d=stonybrook.edu header.i=@stonybrook.edu header.b=qz6Q8wo4; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.stonybrook.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.stonybrook.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stonybrook.edu header.i=@stonybrook.edu header.b="qz6Q8wo4"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-66a1842b452so44592547b3.3
        for <linux-nilfs@vger.kernel.org>; Thu, 01 Aug 2024 08:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail; t=1722527042; x=1723131842; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bjtO0OCNixinMela1FxJ9MrglssDBuKC3DZxSuWU6AA=;
        b=qz6Q8wo4IRIylZQrMrVzF9beQBgA7b0WKQBDK2u9+ihyZADKLeKInYg6l3ZYoEMs5S
         KyQziLhXLoSlbPIxoYTo1HQXBWTjhj6YcLW2G4po6Q7yMSL0yDdqviqIzkcGJ97s6FzG
         tTAnz58GkESVhzIv9vP2o4Z++TR1EC+Y7s7LI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722527042; x=1723131842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bjtO0OCNixinMela1FxJ9MrglssDBuKC3DZxSuWU6AA=;
        b=nJxcLhwDOVHhuQ4jm8xQ4iYP7P7ogdCb/f2hI/G8ERMVN0tUDV3FYo/60FsSL0gu4D
         vK+m70bLDhR9DnTLP8svuIt7soVBlwXb/UfzupANv6dVdNfre0YqXk6mR3oFkp7YGYdY
         qNi5aCA/ERgqgq57rw04nflaVKa0RI/kc13TVW6DMjgumrLQAKwvYeiBiCX88RShl9kl
         PdWA9KOccOmGBE1uomItzTZNt6R/cXgFLRUFtNtT9BNUO7HIY6g2X6aYdRghfvw1LM4D
         UR/V0+ryAqK6Q9rRU+7zcWZ2vtShGf7t1lkcR1ki2NL4JMi3e9r7Arwfcr5S36uTSGXz
         vORQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6Dc9lE8gTI6VDmD9FbMIWeXClcVPa+JdWt3EYKKgr21C1cr+2AVlM8S58oIdig1yIlQju4XhGvnCx+rjxVcCSY8L7SEKLvUBUs0Y=
X-Gm-Message-State: AOJu0YyB/de/hyc8mwAbQZewhLgmIgTi4tBH7643N0vdxIQxsuKx+6yW
	jfVwPC0LC87Ttl5CsF/sMaGDjhGMxb9S5dS9r5UyRZYPzMc9arsFbTKzC50dF8kNoIsLCor5RQe
	06ASFoBgEZ+lqpRG8HsuLMn4f6I5uGdyHcr0clQ==
X-Google-Smtp-Source: AGHT+IFYifmv2N8xT7kwlSTB2dkdhE8/SD31Pl8JF0Mm2ax3F/EeqlkioW1G7bXkeKfdt6Hy/oJ90Sszpra2TiXeq8o=
X-Received: by 2002:a05:6902:1b06:b0:e0b:dfc5:3f9b with SMTP id
 3f1490d57ef6-e0bdfc5627bmr186781276.43.1722527041794; Thu, 01 Aug 2024
 08:44:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yifei Liu <yifeliu@cs.stonybrook.edu>
Date: Thu, 1 Aug 2024 11:43:50 -0400
Message-ID: <CABHrer3rrUS8x+te16eXF7HMdyYCRcoj+CS6c2T-5EmxjKO-7g@mail.gmail.com>
Subject: Potential Bug in NILFS2: Disk Space Not Freed After File Deletion
To: konishi.ryusuke@gmail.com, linux-nilfs@vger.kernel.org
Cc: Erez Zadok <ezk@cs.stonybrook.edu>, Geoff Kuenning <geoff@cs.hmc.edu>, 
	Scott Smolka <sas@cs.stonybrook.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear NILFS2 Maintainers,

I hope this message finds you well. I am writing to report a potential
bug we have encountered in NILFS2 related to disk space management
while testing it with our model checking tool, Metis. The issue arises
after performing the following operations:

Steps to Reproduce:
1. Mount the NILFS2 file system.
2. Continuously create files in the NILFS2 file system until the disk
space is completely used up (ENOSPC).
3. Delete all the files created in the previous step.
4. Sleep for 1 minute to allow the cleanerd to run.
5. Repeat steps 2-4 a few times.

Note: The protection_period parameter in nilfs_cleanerd.conf has been
changed from the default 3600 seconds to 10 seconds for quicker
observation of the bug.

Expected Behavior: After deleting all files, the disk usage should
decrease to zero or near zero, reflecting the freed space.

Observed Behavior: Occasionally, after deleting the files, the file
system remains stuck at a high usage (88% or 100% in our experiments)
and does not free any space. When we try to create another file, it
fails and reports "no space left on the device". We also tried
manually running the cleanerd once the system=E2=80=99s space usage was stu=
ck
at high percentages; even though some of the segments appear to be not
protected and have 0% live blocks, according to the lssu output, the
space was still not cleaned. This issue occurs sporadically and is not
consistent across all tests (thus, we suspect it may be a race
condition).

We have created a GitHub repository containing a detailed README, the
script used to generate this problem, an example log generated in one
of our experiments, and the necessary files. Running this script and
obtaining all the outputs takes approximately 10 minutes. The script
sets up a ramdisk and mounts NILFS2 with the minimum possible size of
1028 KiB. Here is the link to the GitHub repository:
https://github.com/sbu-fsl/nilfs2-full-space.git.

I would appreciate any insights or assistance you could provide
regarding this issue. If you require any further information, logs, or
specific test cases, please let me know, and I will be happy to
provide them.

Best regards,

Yifei Liu
File systems and Storage Lab (Stony Brook University)
