Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4DE13C68E
	for <linux-nilfs@vger.kernel.org>; Wed, 17 Apr 2024 11:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713352609; cv=none; b=UsW7xa9jfkABVHdbrC7rNwDioCpfxSDDpvMv/Bp48sS+d+vivXVrgRXxLDsM/QIOFrhInD6zVXlIgeud09y6glJqTy9bBo1sy3xjLUhrLz53AaU7Gf8+nKKUUQj2Yn5kUaH8sXXLh6k0U+xbxCf9WbHZzzbskZKDTgEGbNMR9WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713352609; c=relaxed/simple;
	bh=M4bIOowrVpNivBAKEGd9wvIBfs5SCrkUUaiX6nxR92s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=l16rsApSVor7ZO46gYjmEqmRt2ZPLuBcHqEWMh5fyaXDIFnk18P38mvciMs2jmUAmZrK8T9hOzx6WJv/KGehOJqcY233uKBwbU+wtYY0x2d6XkPm28jfJjejAzXKUvK786zPJ4A8QRkDFaUzfeCbxRsbqA/tbMS4qboz8vk+TsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bbLq4SSB; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bbLq4SSB"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-22ed72b0082so3581323fac.3
        for <linux-nilfs@vger.kernel.org>; Wed, 17 Apr 2024 04:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713352608; x=1713957408; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4bIOowrVpNivBAKEGd9wvIBfs5SCrkUUaiX6nxR92s=;
        b=bbLq4SSB1UOkVRcy/tJekNyk9jlq74+VVJxF8Y0TNp0OaemafKi2SejDBw/Mzph5cy
         sj4bu7Hd04PVHuJmtSKeUEYBuZjitoFddoYWzs8FWxFDbQoc5Wd0uXk3209zZ7fw6X9o
         Ux0SIbBGFOO59C6apFtTqRs4TpZaTYhk3daivAzdjJuj6TpbqA8D0sFyYPIF1VyB6DO9
         zPYIxkpNIVx28JVGHiFXN09S7btd+1QEKCmHXJTRbJSMXMf9qMDDxG/u+raVLa016olg
         xUj6/3+hioA5DBi6wELrgrJrwjAlmVZfS8Z9/fBPkyMwlFNS3FEH3Q4pc/5SUQDsInb4
         97/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713352608; x=1713957408;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M4bIOowrVpNivBAKEGd9wvIBfs5SCrkUUaiX6nxR92s=;
        b=V4gJ61HPrNP21X00YqWh6ResFCDdn/JAdQfKQNAu5gtJkLUOG+E2BsziNUXm5hu8I2
         PCfNClE23jGY0Q2YQ+f3XQMj5/Kutpg8wMNOGOGfSAeJC+pfiCTuoTMZwfDyb7nDmWWK
         hf9yVgaHb99uq6Vbhi2yzRCkPQQyQGCHgYthOW+SgPJqy9FMYVF1j2gcKGUAgfw80BB2
         A1MQPffs4Zpw5L8IYEemdpryq1a5uBAPvN6tuqidF1b5QFuGmwmz23IOqUzWNGsPU4rE
         7pi9uMqVAWbddLt+OcmjsoElLiKIjN241ZITy3L+sJuLIEEIAt1zyxFyINlxd2UwHwIt
         ZK4w==
X-Gm-Message-State: AOJu0YzA4c4cQXlZxfms8xW0re6BaA73mSGymVetqKSf3hADh24a+axc
	+YHSQgr6JNnL9i+7aS1jH7b4sYPwdvKSaQUsFbstjsqWTMdU4295jBICDdYi2MHjOmhQaMTsbiL
	AoHineDigVkLmPRaJ8xM0zPOAfmmaIA==
X-Google-Smtp-Source: AGHT+IFx9x3evT4JT/nj63uGgropZaWQEjTJzy+iXh7fRHqry9Zjpdck0QRbzl6yPy/WHHNFqDxyMX3ZFGkflyWpUTM=
X-Received: by 2002:a05:6870:80d2:b0:22e:9432:df8b with SMTP id
 r18-20020a05687080d200b0022e9432df8bmr21198139oab.54.1713352607767; Wed, 17
 Apr 2024 04:16:47 -0700 (PDT)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 17 Apr 2024 04:16:47 -0700
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Wed, 17 Apr 2024 04:16:47 -0700
Message-ID: <CAE7Udf8gmAE_97SEWy16zn_y8buxbY-MnMba9pPCPDxPd2rs6Q@mail.gmail.com>
Subject: Released an important update to the standalone kernel module for
 CentOS stream 9
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Released a modified version of the standalone kernel module for RHEL 9

clones to fix a panic that occurs with newer CentOS Stream 9 kernels

(RHEL_RELEASE >= 375). For details, please see nilfs2-kmod9 releases

(or ChangeLog, commits).

from https://nilfs.sourceforge.io/en/index.html#n139
