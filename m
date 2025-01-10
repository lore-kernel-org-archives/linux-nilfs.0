Received: from mail.inka.de (quechua.inka.de [193.197.184.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5202821171A
	for <linux-nilfs@vger.kernel.org>; Fri, 10 Jan 2025 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.197.184.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736524478; cv=none; b=lgcIwbS879FCPj28fBBfEVXWJhHCFFPSya2Taxf6WHo85o8zYYoDuCp3k+U/uKFAP2jyOwoBeBcELXZjb54LcmDEBnmcMnHQ4PZLGcOTtza5xa2E1tiS1ycoqYGL8wkqXIJNJGvDDfOD1FAOT8bB0FBAw5igQHoH2CCV0RV+wRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736524478; c=relaxed/simple;
	bh=DXWeQ40v8QqfQHMJcAfsIzz+Ze1xsAHwFrKvTyPBWIE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ORZO1eYFhjeZ/yzrTLZyZZqiIfrKMOJLWS9I8Tc+6VMNZ5CUtKYse7i2v5i4RsRyopF+GSlPhg7IhBWTFtLm/DKpbyM3vnaPV0CC9t9BngyTL0kn3CXADr4V1r6xGp36fEhkPxk4hzA+/4MyPVumulZ2EEYXzTyHZfCd/sr9h1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inka.de; spf=pass smtp.mailfrom=inka.de; arc=none smtp.client-ip=193.197.184.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inka.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inka.de
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by mail.inka.de with esmtpsa 
	id 1tWHLF-006YS2-4A; Fri, 10 Jan 2025 16:54:33 +0100
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21634338cfdso4759325ad.2
        for <linux-nilfs@vger.kernel.org>; Fri, 10 Jan 2025 07:54:32 -0800 (PST)
X-Gm-Message-State: AOJu0YxSTCy9izkkvVCIL1OVP74un+2wio4j8Rp/pjSkfr6D/YZXudDK
	7hbENQUVT7Nn4mW4pFbf9b0smkSMt4XTE0iM8jY7ROKNWvOTMQpd5DPIps2z1RyBM/KN3WxMIK5
	5dPWbTlC5lVP4e3i684teF4Li/vfBgFGi/ztf
X-Google-Smtp-Source: AGHT+IFRQ9SNquNsCXd8reMh1Of0Dfn3SAihyB9xGnl8AyGMnw9XSMWH6lV8zDX0MMQt/8BoeK0jgmV3eKbAUGyyOv4=
X-Received: by 2002:a05:6a20:8416:b0:1e3:e77d:1460 with SMTP id
 adf61e73a8af0-1e88d133bdbmr19652037637.22.1736524471494; Fri, 10 Jan 2025
 07:54:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Felix E. Klee" <felix.klee@inka.de>
Date: Fri, 10 Jan 2025 16:54:03 +0100
X-Gmail-Original-Message-ID: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
X-Gm-Features: AbW1kvYiKnWM4KE86u9TlmAPJw7weu8_6GFlMw1evDEdNLDU5gs0P_da2BcvHUg
Message-ID: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
Subject: Massive overhead even after deleting checkpoints
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The disk is full close to the max:

    $ df -h /bigstore/
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/mapper/bigstore  3.5T  3.3T   65G  99% /bigstore

Yet, not that much is actually used by the files themselves:

    $ du -sh /bigstore/
    2.5T    /bigstore/

Using `rmcp` I deleted all checkpoints, but that didn=E2=80=99t solve the i=
ssue.
Furthermore, there are no snapshots:

    $ lscp
             CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
          443574  2025-01-10 16:41:44   cp    -    652100924     421961
          443575  2025-01-10 16:41:44   cp    -    652100923     421960

The cleaner daemon is running with default configuration (Arch):

    $ ps ax | grep -i cleanerd
        827 ?        S      0:39 /sbin/nilfs_cleanerd
/dev/mapper/bigstore /bigstore
     117067 pts/1    S+     0:00 grep --color=3Dauto -i cleanerd

I also rebooted the system, causing a remount of the partition. Yet,
still no improvement.

Is there a solution, or is the missing space simply used up by NILFS
data structures? (it would be a bit very much overhead)
