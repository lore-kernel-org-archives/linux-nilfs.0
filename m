Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E8D626A3
	for <linux-nilfs@vger.kernel.org>; Mon,  4 Mar 2024 18:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709576344; cv=none; b=tSbdyuFTtlHIajBDaFtX4bwd0ZDcebDhQOtoVJCylRAzpMVJXdKFae6bjn1jwDnmU3TUiNLoLC+lA88y7/7cgOsB/au1QzG/eDS7cHKpyvW/h3EDNeXurNdZunFbKy03yem7vQkzUPPQNDQqxDoaXwBtJAwR9v6tMvNR0T44NnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709576344; c=relaxed/simple;
	bh=jHTjbx0u1MMYXn8UkuXeyY3a9pxFRC3XpcfxgMoEtjY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=iL4ehvWUwhg6/AQqKaklMGcfF8S6TNn0p1b+Bdf74bybrMmblTsbQCk/4x0MkhpNkFHP7tqmxS7cmTiIj0OleC5/0Mihpx60s5n55UK2HPPCEVmNghKNnmBNZgDphqg1AvE3Fvqczeay/Z+cjDO+GhAFo9k41UinjTi2bTs/HO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N3OsDs50; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3OsDs50"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6e4eb1ec4e9so480417a34.3
        for <linux-nilfs@vger.kernel.org>; Mon, 04 Mar 2024 10:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709576342; x=1710181142; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHTjbx0u1MMYXn8UkuXeyY3a9pxFRC3XpcfxgMoEtjY=;
        b=N3OsDs50OcCoDe+a7lWdSgQqJCXw8/enrWvP2TnXqiEcFmCNmFgsMj0y5QXbPVhPV1
         U46ks9OiIo8h3l3fon7bxx1SkNxDqqWZYILLX838rHutAUVQ8vAAlppAiUaD0H1ZPety
         dU/mrVnRbMKuwsFw0B51KtafR/Nqjp3C4sArzNfKD2QLNsR98byDsjCXxStC4LwKHn2e
         uXcKaT1MUc0L0nH1GdsvR02HZEiEWqSTVv2Q1CeAa/+pgEIIzzt1m3NnGIJqZNu5T4Qi
         PcB+CrYnLt2PbQUzf5JhtY9umyoTfQP1s9/hoxTgAzN2URNtlPEiJT3glfpfE5lNnEHr
         tb4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709576342; x=1710181142;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jHTjbx0u1MMYXn8UkuXeyY3a9pxFRC3XpcfxgMoEtjY=;
        b=EOfxF3MVm/tUC18kv4ZN90ZgCEY9PK/8QhwLWwg87UJAW0JW9x4e6THeOetYd/yAoJ
         kfaQOm+FKHw2yzbsFdOAQtBVjDnkumFDDjlp+P5LcAbKoJc1bjt8t1TzQZmCMdjeRNxJ
         PEYx5nTgi0tSHuWUKoTYcPdbEueOo8ijvOfobfuxFYjqZSwCHo3OgeEqrQJLMglCaEbj
         aegkgV5l3j0iLZv6pwdgYffXCon05cljDKkBSiKaFTxNR7OG5BKaE7pq5s8nqTRYwINK
         U+y8RpqJ+TzsZvCFZ+EThNDgETEZPHnvPxVDx4h0svWgjvJ36pUE5CnRxLk9CU6AJDS/
         wgHA==
X-Gm-Message-State: AOJu0Yw6tlU16qK7ZNIuk48sjN6Nnkp/2T+IzD5dPoxbwjnJ83gl6GxE
	zbNL2Rd3KDvtRK/v4q30E7Lzr7d6T0LlsrfART+zGJpS9IpqlHYZ+2ey7TRpiMpHhBt+LMWJc14
	VustNLrcDtfeeS4FHgiSyJcU+ixmNATTG
X-Google-Smtp-Source: AGHT+IFjs+6sLFP4ha7p+VPAL+Aw8X5+A8o+YpkhobfwYeReebCfJAb0eNt6yFQz/UjGFsAsZI4fc67yTTg1QUhwBS0=
X-Received: by 2002:a05:6871:3409:b0:221:225b:a6f2 with SMTP id
 nh9-20020a056871340900b00221225ba6f2mr1826500oac.20.1709576342268; Mon, 04
 Mar 2024 10:19:02 -0800 (PST)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 4 Mar 2024 10:19:01 -0800
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Mon, 4 Mar 2024 10:19:01 -0800
Message-ID: <CAE7Udf9BB4nqEy8+bKVv_FLN7CqToy9ZpiULv2GTwGT7xtCUcQ@mail.gmail.com>
Subject: NILFS utils 2.2.10 was released
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A maintenance release including a wide variety of bug and issue fixes

from https://nilfs.sourceforge.io/en/download.html#2.2.10-u
