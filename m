Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364BD43AB2;
	Mon, 20 May 2024 13:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716211614; cv=none; b=Ys3bTNXEXRVtGFkh7xjnWMZ6KaJqWRjwwSgd8KAw/XPoW3d5LrKyjVeNeSSup4JhCk7f17Jod7rK8zm/4A16rwUVtbmYcFQrDkqW57UUSUsCTPJFIg49E4lbrFUMBNYd0aUKDSD5WLv7ncrJEPPNJNIcjaDpVyI/gPSLQXHyYWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716211614; c=relaxed/simple;
	bh=T5Wo2pvviVIACX7QA8ii+1HdfJ1FHfk+CMJR1M37hQw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L042MiFd2HeLBlGS4rLTGqmEcZX7j8eRC/+/WjBRxIyplUoNY/xZRP1sPuT3MgjxLS9t3WVzVhCXm55XBBLVvteoj4al5+K/ka/JmDw1cmBPMaEqTHrayl7kWGfNigHuukiLfSeH78QIPbAr0GuMdYNWEnfQDDZs+CXaYcR1Rbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NPtvOKGl; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPtvOKGl"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f2ecea41deso65963445ad.1;
        Mon, 20 May 2024 06:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716211612; x=1716816412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+vda9tFexxLKNGcsYdoPozVExQoerKf1WK1tXFrdiU=;
        b=NPtvOKGlX3NHjFBKHA9AJEZ5S4VGUFCXihm7bYzZSPn9tbRNxkEahYyEBdibH4wbfy
         MtGyUi3MIl/ZFS1+DpefCPbAOEOeHQsxM3QutXYN+hL9h/u9mR0bjifNojeVOBOYL/UM
         GvVF8Egu8kUwVriZRBumm4II2irQVh4CnX3zvQKu72sD3CcD+P5m1lLi9PGAW3prTOcd
         29VHvrOUoN8qzAkEhwNeYwcbmQisF0+2w9bKl8fw65yHq7asHOU32uvu9wpE5QfJuPux
         XEKhSzaK+1gSZGEDvshSCjGHZAncNQS9zTcY++Kkk1ZeoHVJGGLFcHtDdd/8nGfJVcBW
         JrtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716211612; x=1716816412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+vda9tFexxLKNGcsYdoPozVExQoerKf1WK1tXFrdiU=;
        b=U3HQtYckcGcY4u7/QGL/+zYFPPNBczwChiceDyjAmTm4yvc2l8Z5hfnkDbyI6vjESk
         O0pafZ6iQ/yewdEhAyY4O6yVSE0RX3ZqczD+CC7p/EHylGBDEk0XDTzOieGDGZr/k81q
         uhEtdrqrJ1YaQPvZPNZ4VTnFF5oXCxZ0Z/q7N5XiwKCee/3itbfIFaiI/g4xhoTDWZ8Q
         Va0EeLGQ7Zt4TbyqUEjUaSXLqMt8T53DOiFiwFHq3GOYadI/WtFXC/IEVOEWG5USbZYM
         H7Enr6NomCnaO6kC0aSjXgOJJIaxA59JcGJFIJR1W57dOc7iIwri/Ij5scfx35+NnR/u
         1sUA==
X-Forwarded-Encrypted: i=1; AJvYcCVSJt8Ik3Aq3xAQtSAz8pq2qodn44qg08MLMKeaFhl1edjw6v1W082al+3Lg04zN4QX/MyI0qutoUmjsIfV08D23Yx5CjGwk9cvJiLu
X-Gm-Message-State: AOJu0YwIn9tKf8C/4Iz8ubXJJ9Wj/+DYefLWdsydV7AUqG46OOb5jI6m
	Li+BYxjz1WkvWMcCU4WsDxeWiCRIkUx5WDMaJ+eW/eTeZi9GozX49fveJw==
X-Google-Smtp-Source: AGHT+IHn7/ypm5FvEMDqH0Gp+f/Z0xit2mLbhfknUKCi0nOAgkqvdRbtuttAlskIvSPghNonw/fMHw==
X-Received: by 2002:a17:90a:778c:b0:2bb:b23e:11e6 with SMTP id 98e67ed59e1d1-2bbb23e1a34mr9552547a91.17.1716211612401;
        Mon, 20 May 2024 06:26:52 -0700 (PDT)
Received: from carrot.. (i222-151-4-139.s42.a014.ap.plala.or.jp. [222.151.4.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b628849c40sm22011380a91.18.2024.05.20.06.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 06:26:51 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot <syzbot+e3973c409251e136fdd0@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org,
	sjb7183@psu.edu
Subject: [PATCH 0/3] nilfs2: fix log writer related issues
Date: Mon, 20 May 2024 22:26:18 +0900
Message-Id: <20240520132621.4054-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0000000000001a167a05ebc4f62b@google.com>
References: <0000000000001a167a05ebc4f62b@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Andrew,

Please apply this series as bug fixes.

This bug fix series covers three nilfs2 log writer-related issues,
including a timer use-after-free issue and potential deadlock issue on
unmount, and a potential freeze issue in event synchronization found
during their analysis.  Details are described in each commit log.

thank you always.

Ryusuke Konishi

Ryusuke Konishi (3):
  nilfs2: fix use-after-free of timer for log writer thread
  nilfs2: fix unexpected freezing of nilfs_segctor_sync()
  nilfs2: fix potential hang in nilfs_detach_log_writer()

 fs/nilfs2/segment.c | 63 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 13 deletions(-)

-- 
2.34.1

