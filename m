Received: from mail-vs2-f41.google.com (mail-vs2-f41.google.com [74.125.227.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE37C455185
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 19:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789502225; cv=none; b=TGCXvv/ms/TmjgoGA3mdjXAg2mIqw/1VAsLSsuescNPbn7ZXKU3m/5OdSGcXHszUEZVmOR9Z5glivGKoTnYFH9IAWSU4siq90+Dtkh4+37AuPmqC+xJC+4L7NxYkQdWny0CkJB2aMpcyJz8Mgu3bwSPdNPztfoKr0kbCahO5oBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789502225; c=relaxed/simple;
	bh=5+nwfIuz8ZbjkA7MsPGWMFLzJnQRW6j0etOXe9L5Lho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CRnqgJxYcZMo9MziHjto1tyhbA3VvOY8cQhxMu3WYvasGwCN7Knu+NARijpqUolnb0oO2JBlgOUeGnvcZkKixvZY092SDehDxoSUlbTnBdViqbXrsFzpXOmzxl3lyTqdjZY/owfanwkmAuTDHC4PVgBRilSE65lFB/zQ2i27UWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YV3/vzTH; arc=none smtp.client-ip=74.125.227.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YV3/vzTH"
Received: by mail-vs2-f41.google.com with SMTP id 71dfb90a1353d-5c67e5168ceso58747e0c.3
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 12:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789502222; x=1790107022; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5+nwfIuz8ZbjkA7MsPGWMFLzJnQRW6j0etOXe9L5Lho=;
        b=YV3/vzTHWkDzLHi7R5YtsXD4SrxE+7/SJ1yi2Dof0gOwjnCi6fdN9Am4mODDBoDU1+
         K0gQS070F7xeJutbZE6FnVR4OoFdkQaUmlBYPiA41FAST3q2AMX8FtvXtygPBa0xxVvj
         +a1JYtoBunMPnFyoyZ43Z7GKklxXU7TQwkjqCFWAIFQujlf6/JVPwIqE+u754Kc+0urS
         yGy2mnf5SFtIqZowusUiDMTabftiqLB4HnhQ9rhvxso2FwPABkwvYDw0dso0IEM4zR1Z
         BTnat+RjpXk0uVPw5b54eU6H4sP0GA+6uDKzFKvT548vyrwKsq5g05mbtahL+1XT1Ebe
         kOwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789502222; x=1790107022;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5+nwfIuz8ZbjkA7MsPGWMFLzJnQRW6j0etOXe9L5Lho=;
        b=vw/fpUcUOtmhSA0IYfj0sh5meB1VSGYE/G3/xLA7vVHlaA3DffxriTJC4UcuXk5paq
         ZTAWyMMfg1QzkQrRtcsY8Nz8MOfRJLhEWMiNvGBJvW6TB+R03tfkKXIhg8xlkRZIQAul
         JJn9r4RHH60Kdy8pbOP1yurjubmspxtDtnCTaYU4jHh+0pwfv9dSQKzOxwcNwkMzRJoe
         +k6q8Plb9Fo0uCUsTNWQG910nzQ0n+MjobGvcCZb4HxYs3xYgnGtGXzKrgsjtGY+MkfK
         YGE08A6bpjCiW9b3KAzzvIfRtCMTgsvXKDuI0PUd/V5C3itT8efd+TEPZRiZYSTazCHH
         b9LA==
X-Gm-Message-State: AFuF++lyO7veXXHfpVy6xlNIfHDYJsT216qN25OIcwjHhzmJ/yt9xZTL
	6UUPbFlfKccdoXIxUDcPpDSDedR56Vqp3ZuLFDf9NTZFuWLahFymuICeipv7WiLOQU4=
X-Gm-Gg: AYBFou0hVjVdqdIcI4kxC0HeRjz4gCTm4J60ftl4nfDKusw2WDqdDS6TWl9J4u/5evJ
	kBqQmPZDMlwVmVDBOU0LVSTMTFk7RAe4UQHmZDGMowB6XpyubIo0nHZE3e1JLI/zQiPkEIJiWA+
	IC3RvMpHuo10UWy8RI9cUSbsJP0yhUh6lLxU5KCXEW/2k5MgKnwbqFdzNaEM9S5JaxtuOEXoggm
	13WX+m3d9ZJ7Nc21tDQ0Mbt5GVNQLmp+hDK09/2M2TJhwTt5/SffeEZjDpfC3anmHJU4786SojI
	hbR14RK9KGf7XWjmQ0v2yF/WLt3FRobBgIyiq/bN6miyHX+lZVo/gkT5i8CjlSuDmktZr0ZH7y3
	Mb1AR9Tiue1JADAE6JZt1f8kx3I+TbjAIZbX+C+05dQ8i2W8xT7Jf/fQAmlQQu04lqADCzyRZWK
	noAL2saDLN07od1j7qnPLGQORtDbOx5hRSydG1iyUcBL7suDSuMvk2swbzBelVcVF2
X-Received: by 2002:a05:6122:e266:b0:5c8:4409:602a with SMTP id 71dfb90a1353d-5c981e978a6mr14043087e0c.8.1789502222518;
        Tue, 15 Sep 2026 12:57:02 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c998a6b665sm566060e0c.8.2026.09.15.12.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 12:57:02 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: Re: [PATCH] nilfs2: validate file block counts during recovery
Date: Tue, 15 Sep 2026 16:56:51 -0300
Message-ID: <20260915195651.3335615-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915111351.2726334-1-qwe.aldo@gmail.com>
References: <20260915111351.2726334-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Slava,

Right, -EIO is more appropriate for corrupt on-disk metadata. Will
fix in v2.

Aldo
