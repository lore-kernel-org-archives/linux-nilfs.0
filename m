Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="ajmIPgE3"
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1828DDD
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Nov 2023 02:05:33 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-32fdc5be26dso3247149f8f.2
        for <linux-nilfs@vger.kernel.org>; Tue, 28 Nov 2023 02:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1701165931; x=1701770731; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZKJsy/O9sQNKnNFyRJVuTOt01SElG6aFkPQ2+Lfq3iI=;
        b=ajmIPgE3cf4/VQcKecwZurNFwBZ7fhShFWpQSsfDV0gtymPBLKvL5H3127D9k1L6dp
         hX+TAPJ6uHosbFCDtux+M7ll0rT1Bey3JLg8DNYEpumCySiJ7nd6xroxIcltB8532kPn
         gu41KkYYBNQIm56IEzzrBy+Y2oWQCUj/A3o20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701165931; x=1701770731;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKJsy/O9sQNKnNFyRJVuTOt01SElG6aFkPQ2+Lfq3iI=;
        b=qvWq+wRC1T60LLWuctS6oaIvdAHx+umR98+niSoN1KOfxPoA8KBm6rQYRCbN8nh73s
         CqpMmOmc/iEWVvYU/u3/Fz9SFnulFqQ8oMiBp1wxBuPbnoKneNYU1Mxa4eJpK2+f/LSY
         3VzjInXyEEThLARLb0fXC0rC85matgOKubYBizfXvbxfWwVnkJDpr+Qtgs+q+QQxA6ik
         Q9o1eqCRNp31VFajyeIl7AgsI3DYJYvzfiNDD3T8Zxu4eb6CXuMZlpP/qy/E2veZ8c8k
         msq4FUsQUV6TMiiZcvifajt1y3m0wCc/5L9M05Gu6xAhH2r54DDUEQ309/aCx9i6poOZ
         wYfw==
X-Gm-Message-State: AOJu0YwVjVv2PPjuxJDdWqzN1FyALsDvY99Ls2VUv6p0u54Nm0Ieut8e
	Ptnt3Tpr6ZpAjCpUoIdKbCp1/w==
X-Google-Smtp-Source: AGHT+IHso67qiRejATVe+y4q8GA8WkjBME6ZXNG2nx2AvipjQBf9Fe7u/GIhGV/RuBTAoKaGDDxyQg==
X-Received: by 2002:a5d:4bcf:0:b0:332:f81d:8dac with SMTP id l15-20020a5d4bcf000000b00332f81d8dacmr6833150wrt.67.1701165931581;
        Tue, 28 Nov 2023 02:05:31 -0800 (PST)
Received: from localhost ([213.195.113.99])
        by smtp.gmail.com with ESMTPSA id l10-20020a5d674a000000b00332eef1ca7asm9779426wrw.80.2023.11.28.02.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 02:05:31 -0800 (PST)
Date: Tue, 28 Nov 2023 11:05:30 +0100
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, ming.lei@redhat.com, axboe@kernel.dk, colyli@suse.de,
	kent.overstreet@gmail.com, joern@lazybastard.org,
	miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
	sth@linux.ibm.com, hoeppner@linux.ibm.com, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, clm@fb.com, josef@toxicpanda.com,
	dsterba@suse.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	nico@fluxnic.net, xiang@kernel.org, chao@kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, agruenba@redhat.com, jack@suse.com,
	konishi.ryusuke@gmail.com, dchinner@redhat.com,
	linux@weissschuh.net, min15.li@samsung.com, yukuai3@huawei.com,
	dlemoal@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	hare@suse.de, p.raghav@samsung.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nilfs@vger.kernel.org, yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH block/for-next v2 02/16] xen/blkback: use new helper to
 get inode from block_device
Message-ID: <ZWW7ag6vIhc_Skh5@macbook>
References: <20231127062116.2355129-1-yukuai1@huaweicloud.com>
 <20231127062116.2355129-3-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231127062116.2355129-3-yukuai1@huaweicloud.com>

On Mon, Nov 27, 2023 at 02:21:02PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Which is more efficiency, and also prepare to remove the field
> 'bd_inode' from block_device.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Roger Pau Monné <roger.pau@citrix.com>

Thanks, Roger.
