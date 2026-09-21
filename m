Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116073C10A7
	for <linux-nilfs@vger.kernel.org>; Mon, 21 Sep 2026 15:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790004132; cv=none; b=XRnqrQOzu7cWu+YzNbJjP0nXPwig2ZMiK8ipI1MeOclp2h7Nm/lMy1N3nDj6WCfIkoWl2cgGiHl2MgTdu6uHV+TFMcpa6Y494POx2KFbznf0oe5osyXJ/TArVB5ZkxA/EwXKPJpKAhbFx/n5hPhtGC/Jp8fH8lk7WaVF7wzWBN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790004132; c=relaxed/simple;
	bh=aYD4nV9Wj797N5jj1Ny6OHeo10YNZu5Q6nXuUfYTHdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DwnFoMlAGXWVZuBlKWMaVxLjVf7fE7a//KZo0MJJKiKzxjosKnpsmpwaujLGqpAFb5YMHpo8halZengQmEFuedUKxUFJj0ZX3MkynmJLQCLPi53Dd0Laz0mRurIQgJ4SwPMZ/dcOeoWc/vynnJjvomTotFEHx26J4ZubIE3avgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C6xgDeQr; arc=none smtp.client-ip=74.125.231.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C6xgDeQr"
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-469fdb78b1cso2150738fac.0
        for <linux-nilfs@vger.kernel.org>; Mon, 21 Sep 2026 08:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790004130; x=1790608930; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SI73avUfus8pqTPOHeH7viJKyMI8CsxokGnHNJh0Wgw=;
        b=C6xgDeQr80LhdaFW7J8j2h64gvFSzAZznJPVjnZqyyZeDh5rM14PdUKt/bJhqP6M8e
         Rt+PwfRQy1R/Y7EiR7LChiD2Yy4FeEfYKg2pXq13+UN9u7FHKNwxPOuCVTzTxkRA2nhc
         fAWzIaf77bewHSVy5U7clQtWjJgYeVhoQLOszBZGhJvHtyXF+zh9HAXuS512o3qjILoO
         FLjimCZgWCBSbt3XUlmP8jHTBnBKMEY79WfyQe4gJxGv58ZKDMwOlcXDFlUpNCkZKHF9
         91o5XpoR9M+4waECoA5/Ob29rlL8mlr9bH+mvl0d/Ww+JhjEC2mP1tmYEhQwNHrZJYJf
         7fXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790004130; x=1790608930;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SI73avUfus8pqTPOHeH7viJKyMI8CsxokGnHNJh0Wgw=;
        b=xJxdgREkLLGGz2CAQRzAIc6tXmNNnpz/QagXDFLO78ER5C65ufdMOirtsn6JG3egIA
         fPF2/nDsj+v3FZ6ylQQjIE5nqoeEYqyoPxTix/JFvq3mDhiA9acGSR+e68ZsW9MX1U/9
         Wt7L9NRK+bFrsMRjTsCmPHNbxRSUa6X/41BqAihD5dynrrp6STBA3wfF/IOlxUvRKeaJ
         pExyhjksg52MV9WeYyWrGDIwKQbXOOaakVP9b8PisvPnqWWjmZGh1j4wuNc6JNWAbIxK
         iAprVdI1TAzi7vMCqHasT6uMZR04Y3ICyij0Bc5Tiuuhjw0+lQTqW0Q8DULOMtNJs5IL
         8Yhg==
X-Forwarded-Encrypted: i=1; AKwUvBzWfywlL34lxru/wtgxVYfN1h9ZfrGau3umXBTQq+TxQGIW+0x3I8vd0jcr06T6kntZlNeGH/zqxhh1eQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kNzRp7IPFMIDpYgYGiZleNo1KqzHsM7kbRXEE+ch8Pd6QgIBLH
	mKTbdgwBjhc8NIy9v26Z8EoZn/8s8nk43uBpPpzkFmIbaQmypG/ZHQ//
X-Gm-Gg: AYBFou2PyRbcSNuHpJzi+p0I0aH+c/V7foQjfE2Hobvxl1nvtNZ5DNZELZciYA1TfDV
	dEzu/EMhsyBquDAIl5K5Lr4w0TlB2TLf4oRqADtzzJuZrmOxwjuUNdZPQ5o3sAh1EflpuVGv20K
	gnhQCV/LeEY5ISY3i0fWXk25pqjKz8/W3rS5H+ed7FxK4pUC2ueAcfEB/+Rq4GiQAfSn/JE6wbX
	jPYnqw5JGogMEnuRj3gOiPvUIx9NB6RcaaqFHe6f54E6oEBdMDjoxGbiOGQ6tn3VIGg9+nmZv5U
	wkLcK9M9XJq+U1bJ2GGC+DOKYY9xyHqKpoC5Lbt9/2DQnYYNWt+G8D2x6na8dXBprDJ4Yt9JRdQ
	0QQGNq4FT0h1V+XK8faEIhaXiKdedzPxLIEq5lvpDnWWgYUchi2O5zjIp6qkJ+evekCaRbQctIJ
	SPHD5lOeOuiCDdVRFuiYgw2fQaVl/l7SKfCfXLJm5CdDIpv5qfz4UUJTeqDfqyS0E=
X-Received: by 2002:a05:6820:c8e:b0:6b7:46fc:1db with SMTP id 006d021491bc7-6ca9d5540e1mr9509282eaf.58.1790004129624;
        Mon, 21 Sep 2026 08:22:09 -0700 (PDT)
Received: from beelink.. ([187.13.30.172])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6d1476b906asm185690eaf.14.2026.09.21.08.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 08:22:08 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: konishi.ryusuke@gmail.com
Cc: dubeyko@comp.asu.ru,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] nilfs2: fix checkpoint root lifetime on sysfs errors
Date: Mon, 21 Sep 2026 12:19:38 -0300
Message-ID: <20260921152144.3983736-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAKFNMonYVUbzjYm343Aw-=xjUk78x4EdUwGBfNRwE6zfmRVhvA@mail.gmail.com>
References: <CAKFNMonYVUbzjYm343Aw-=xjUk78x4EdUwGBfNRwE6zfmRVhvA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In-Reply-To: <CAKFNMonYVUbzjYm343Aw-=xjUk78x4EdUwGBfNRwE6zfmRVhvA@mail.gmail.com>



Hi Ryusuke,

Completely agree — that is cleaner.  v4 (below) does exactly this:

  nilfs_sysfs_create_snapshot_group():
    error path does kobject_put() + wait_for_completion()
    
  nilfs_sysfs_delete_snapshot_group():
    kobject_put() + wait_for_completion()
    
So nilfs_find_or_create_root() and nilfs_put_root() just call the
helpers and kfree(); they never touch the completion directly.

v4 also keeps ns_cptree_lock as a spinlock and creates the sysfs
group before taking the lock, per your earlier message.

Aldo
