Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138319;
	b=DHGeKITJse63lzw3LLhZosPoiZlaS5n90/GCGmRnKu5Ux2zUxm/1VCP6GNszCjcO+clV
	 FbiIVEQYD1haY7BGXIdhoOlnFOgzOmdBN32LCKOhjncOLRr8ujtI9VLodCHYf5Ok14dM0
	 cPDMumjCiI1hpT6zYhrNKmHVh0ChPlyc3l+qL1OPtWj4sX+bi1Shi4585WcJcgp5chTJ4
	 1B3/2eOOebavf9y3OHj0fFHSbxvTsue88PeiniYAN1nP50jzvF2Z15vfUd9a13wVlepSQ
	 1b4howxH/D1tJQpwM4/bGrw7g+3F7G+XPf5A8CCu9xerjHZj44K490u5RDst7LdDEzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138319;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iqfPoWTkUvjEoiyLTnmr5mj5KovsR6sHRhbPRdxo4UA=;
	b=v6INA1vP+NjbfC7j6CEfI5NhKzeb0YNK13dBKC48aeV5sf6D1YdbTzFRpZ32ErjRCbA0
	 8L1sRbh8/lDyWGkmfTuG4j3euLXkZYfKWLTvvw6pUxpQUi2M+Q8rXX1iIVNS7XP1FXXdm
	 ewN2m1maOPnIPGaI+P2pURuE55EvPwPagrr/3WNHI7LLZdUdmkFJA6AeWMUf9rXLM9mN9
	 BbxJOVIxwLUY6x4di71OjcrfOooquP/EpPR6EYPUOHcsp0b2CY4jiZglQzur9dEBDpfgN
	 N4GaoGII9iOyjSur4ECRt6KCc5cfooVfbx9yGe43uoKz2uOsrQ3SHDq0hqCN/+xOxQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHefbI+9;
	arc=none smtp.remote-ip=74.125.224.42
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5D6606A31D
	for <linux-nilfs@vger.kernel.org>; Tue, 27 Oct 2026 21:58:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F5D6606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHefbI+9
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-677dbe051d4so380189d50.0
        for <linux-nilfs@vger.kernel.org>; Tue, 27 Oct 2026 14:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138317; x=1793743117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iqfPoWTkUvjEoiyLTnmr5mj5KovsR6sHRhbPRdxo4UA=;
        b=hHefbI+948nzC9V3ObgOm7xqIlu0T2MEDj0gG6avl8Xb2kbhf6Z/cbqoyxSTnA73BW
         CDF5OTDEdklbOqujS6eVhxL5dGvh/C6tEqLgDMTWvMNYjG/xe9C8VnbQomQrlEVPuJFG
         m+SVQ/r0R6uk3NynScu0b7mMuf29mIgeofx6m0l3z2mL0kRhgjYRJbMWyYYrRrbZUIG4
         AG1hLaUcgUGyfeP1pEu8FX4TgOHzM5iAwdAKt4hZbNHbOhfpISpbqGywIGZjvg1dRFdo
         GgL5HVvBjS2vRht/e+neQcTE4BQOXDlg/uGmJh01kZlWUbRinQzJknNHTTrFiU4vjNMu
         iDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138317; x=1793743117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iqfPoWTkUvjEoiyLTnmr5mj5KovsR6sHRhbPRdxo4UA=;
        b=uM4hJvD6GGS1YWkc5Zj9LjXm0r71C+WDzQwxq+5fmISO4w7QERZSJmBSDW0VHowA+9
         wrXZfe92FZ5gGgsCOmT5TMPp53bxvNKgDm+7i5T2nPf98k2bSLM4P1fORRGNEfWDn3rm
         m4YyPa61TxjOVLh6UHWrxX/L1fg3Q8p7Oy455pbzNmskCeF5s1TjDnmqQWDOamB60tn2
         299Q1NuduA2/jlTZQqgzxtSxcJMdbq/Ydj5vBpPhI7mAPt1b8/vCl/SHZSRdOD7k/eWq
         vRq6whQJzgeAKrnhVhhtJFRhDL4P0rqhY/BWjZa8SE72sfDzdqfV11DPoTOvPeqMl+Te
         9j5Q==
X-Forwarded-Encrypted: i=1; AKwUvByfp1aSo+ZaF1MmTxmO8Oh/JKsfAOso+J2zfcYb+lVAx3rcum49K1OUEt48iiq10wf1s6r5dgWl07IH6g==@vger.kernel.org
X-Gm-Message-State: AFq9FYKYUQeu53zwlJoDrZ7nNbjxOQUvOCfxWOSPXM4gNS5132/hCNbD
	PImYAeu7qhMU4gOPfPS2oeHmASmqtaq/KB/UFoPgcP0PCVF5oBM3tBRK
X-Gm-Gg: AYBFou3V061t8bwqtbTbG1W/AV3XPRU0eo4KV8V8h+83iCpinmdI3uSsC1Lvhr8Loe9
	EvtGm6vypnsOvIEsjh4F1UXg2xx9EHeLa3IW6m4gLKWHawF0rj3MF9oD5OXzql937dkdgUeZN2r
	L8ctpa5I+2RWhBFrr6rtzeMAwyvyGP9Z7G8z1aIU1FseW38zIh3QqMdYjtxUi65BR11RRMRWgVs
	zv3HibU1E2V3DHU4X0lc13pl/IHQNCGoxv6eBM9oBz/bHI7r9LY7BhrDg/J2uZgjm+VY5D1KC2v
	oLGx/SSkrqTKXPIZFGzPyKCKkPD6+hKaTdDdPkJooAavekkLAFgy963sML+6FMNDJ2rZJKbNsA1
	cvz5xFJ5Xt+k6xm97RHPG1I2KLnY/n/DO5uP6xSPckoLngoBtgRtyQoG0a2mP/+ibi0EpfgwHnI
	HiKwZ0rm0Eos63WAsEjLXb/n+/yT0ey7O/CN0UMb3caDkcsItE2xJY4K3sWUVajcEsLC2vyPEBS
	SqeYwdJzLFC5YbAgUfirjp0QnensH8/taS/BwcQ2TfpHZ2QfNcTMJ//JtA5pZMoKktBBfElDOj0
	WW3d2iatnxlv75Rq3y2k8gI+VuiVVn/B
X-Received: by 2002:a05:690c:a418:20b0:8b1:691f:ab4d with SMTP id 00721157ae682-8b1b5ba3a5emr1705147b3.35.1793138317281;
        Tue, 27 Oct 2026 14:58:37 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e43e1d2sm18903937b3.5.2026.10.27.14.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:36 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 2/5] fuse: convert ext_map iomap ops to ->iomap_next()
Date: Tue, 27 Oct 2026 14:53:23 -0700
Message-ID: <20261027215326.2693300-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
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

Convert the fuse ext_map iomap_ops to the new ->iomap_next() callback.
The callback is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which
wraps the iomap_iter_next() helper to finish the previous mapping if
needed and produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/ext_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
index 7f04edc33fe3..edb19498d496 100644
--- a/fs/fuse/ext_map.c
+++ b/fs/fuse/ext_map.c
@@ -210,8 +210,11 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(fuse_ext_map_iomap_next,
+			      fuse_ext_map_iomap_begin);
+
 static const struct iomap_ops fuse_ext_map_iomap_ops = {
-	.iomap_begin		= fuse_ext_map_iomap_begin,
+	.iomap_next		= fuse_ext_map_iomap_next,
 };
 
 static vm_fault_t fuse_ext_map_huge_fault(struct vm_fault *vmf, unsigned int order)
-- 
2.52.0

