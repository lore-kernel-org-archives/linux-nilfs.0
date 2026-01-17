Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F702D0C82
	for <linux-nilfs@vger.kernel.org>; Sat, 17 Jan 2026 08:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768639756; cv=pass; b=rnMb/JdpWQaY5q+VS9yCKvAGKgYjrdT7feFcNOGPYmoWmqUkO9eEjnARxrkgPI1vdCcNyeV/eGR1XWo5MkfphXx5NQLY64AEXrDuQwbiDflFduFKd7CZJygYpIH5S//IQbnSYjqfrbHQo+ELWCe6bbIG6es2hKin2nRNPsA007A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768639756; c=relaxed/simple;
	bh=cA/bnCAkdhRGmPLezosqZUtUa8snn9JfJCuTW+E+6sQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=TqrP+NvqSX4xaZhjgGt+N6hT+1MgKIV79wX39U4vmDhciGT6H7ym6X2HDMG+0mdGs0AdnWQAQ6G7zW4mxfQbRpL1akVD+3IYosk+1fttLyMI9upXL5psYc+gUuEUdbEcc+myYdnP0xcbWEHAmqt1KYw8LrNB4/bes07wNLwIiig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JIO/KQs4; arc=pass smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JIO/KQs4"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45c733ccc32so1764489b6e.0
        for <linux-nilfs@vger.kernel.org>; Sat, 17 Jan 2026 00:49:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768639754; cv=none;
        d=google.com; s=arc-20240605;
        b=VexRX2aCMyXW0Tyvxr290FGoiNg8vvC/PZkc7FwBk671dpflwllTybRUC8udcVHOXN
         cXCxSGtpfTPCcHVpLbeUgMzuJW8d6g4+rzADj25F894Oj5eyG5K6C3PnUjq5UtnukVdF
         OuSbFNLVAoDffyLVYut0TOv6quRq2XuCvtQNFR40DIzRgVZxowlGnjEVRT70/n5onQRY
         Yt5j/GOlFJExSEcrR//U423PcEETeSmLVUJdRQyeyrjwGT4q1ZKpe3XVXW3ZDSwCCpSY
         QGObUueCeC7T9BBcBlpsjcq5gUPLPT8Oks2x9CNQ/38E+liQtpgsM1xZy7d7D0ma+EAS
         Py+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :dkim-signature;
        bh=cA/bnCAkdhRGmPLezosqZUtUa8snn9JfJCuTW+E+6sQ=;
        fh=Afbqn6eya/G+dOUTlJ1LpDbmd7FU0jRH4DaWLsAvfgU=;
        b=jQTekmCib0OtsFpjcMWFW+hIOvq/etwHEICODhhT3exPgV6Z3KbKWUL5KEUfg/eG3Q
         M+LVhKkMAF5Xq2GBm9NYmnoOOwqrP3d9kPJLHaHpci79uJYsT2dlMwEe2L+JQsaKsFOP
         VhqNx6Rqdu6FMb3V5UD/hkHWpCl6R2v1rHjxEEDSq2Fnjhuxk+M2N405+qXdpGJFatFg
         l3YcYkM9qyR/kgW+Vpt/b519iXsk20dS1b9yNh6O8G5blksDf4xQLe3Z+bX4A6J093sT
         08G/db2M4quQO+36u3sLD1FAioTIpbeakcXyqwK6D1fOGozUzE8mwePui23qUo12388U
         o4Aw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768639754; x=1769244554; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cA/bnCAkdhRGmPLezosqZUtUa8snn9JfJCuTW+E+6sQ=;
        b=JIO/KQs4FXbyT/0C4EeB7ycpTkQShsoIUGZc7CH6hWAeeGMBXu9lp/3C3PQl0SRGxX
         BOz2COq9Bm4QHtFzVir03ryKbQQkGwj6LIBR15KoDFA7dFYsm10hHyzPJzFQexS+W+68
         LmO/BmUFGcnTGEYZKiTtvtwkE2nXQ/M/hAn4N7u4vwEV7cDb1QkPlkhG5zEQTGhyZS45
         1BUYG0ccXCzJfhx91B8URwbNkMh4R7ciQWsuzaqHgH6jm0w5g43kUr1p371eftjzgnon
         HGKhZoDCeWO+gKZTWdGEt3aqpDKAp/8V2Zxe6KL/PTXAk0WPo0EREerbvizMQRYWRM5i
         tqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768639754; x=1769244554;
        h=to:subject:message-id:date:reply-to:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cA/bnCAkdhRGmPLezosqZUtUa8snn9JfJCuTW+E+6sQ=;
        b=soilEsBJ2kmd7Gv6CJmo0lXxTz2sVJdIu3ABB946oXWNTzFtB4NAmVyNKjwIcGZIkt
         K15AaClqlio7jiHMSv2noIXiwaeAB/uhwg4+4k5oPeWvxuh0HgBcuNrfKSrs3Hd0yb+L
         6rRHwXQ5oJP/pDwWy85W2t2kOl2TvDNelAkONrDUxfV0NvdP0YoQlZnyxmUlt/p4+bCY
         QXyeV2Aeov7dtDT2jGlB2yQE87j8P/CIihoGFKHr9VqNGLVxQx96R6ff+0NfymU0WGIz
         3rstH1r7TJ4CA0mQjOsM8XO+HYR75iDgML1WJLSyyjWn12Nh5RC/99I5m8gUCpWiHAiq
         PwYw==
X-Gm-Message-State: AOJu0YxtanAlVz7luf6rI6W9Bw+ky2HHUagJVNdFgTH9jPoZjEC60GYX
	Uo2PdcI2WjVRB+I+EfT/SB3nN7eUT9TFavdHIFD3Cdkblb0nY2DTmjCPi04Z3G+Q9ttyS4jqJPh
	gly8NCiAib3c7eMdi7YpU1STSfvZa0jA0vw==
X-Gm-Gg: AY/fxX4f6JbIw8BzPjENQLN0xk+fcR+/j4nCTmkYPBLxd8TArJ1MnzeWE2CGC8vA7QH
	umnW/ZbEfK0GtzK4ICZ3/EzxT28C6hKHQN2dpQ6DqplbY2CasQjgWS0M3SfoMWG1SsO7ebWDPjx
	VUhfS8xQ9P6XYm9ukf0kYr2VQegoyl7EEK9KtP9vtQ6jiQGBccqfYcZlzDBmI+tPDnv7TUyRSgQ
	01pHlBBmCu/6Ep90L+wof+pKQKx7lAvXd9gXOtLyxB241n2JQAunftwlTq3QyLvqK3R
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1887:b0:45c:7c9e:854f with SMTP id
 5614622812f47-45c9c16ee73mr3301078b6e.58.1768639754185; Sat, 17 Jan 2026
 00:49:14 -0800 (PST)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 17 Jan 2026 02:49:13 -0600
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 17 Jan 2026 02:49:13 -0600
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Sat, 17 Jan 2026 02:49:13 -0600
X-Gm-Features: AZwV_Qi6QMWEFmX-2OsT8wyagP3mnfpaT3VEqol4CSj7UwZvXQJx5AUjwTUIDqo
Message-ID: <CAE7Udf8=cCS7rqEnQoMRaF-ydz_ugML9cLzefNRuBJ6NAHgxwA@mail.gmail.com>
Subject: NILFS utils 2.2.14 was released
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fixed various error handling issues in the mount/umount helpers.

from https://nilfs.sourceforge.io/en/download.html#2.2.14-u
