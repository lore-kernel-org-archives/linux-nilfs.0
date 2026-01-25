Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325571DE3DC
	for <linux-nilfs@vger.kernel.org>; Sun, 25 Jan 2026 04:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769315676; cv=pass; b=sHjnXIxcuDQ/qHHnwiQkeNaTO1y2UY60T+cUYSPyIkWx4X6u3TICdDcg0GMYsGKL+zN3Z00jysb49K2qNs5jDIXjqiDUQy527SnWW/+nlShslm5et+94REM9RpTNvyjWsB8RJz5PN1cPtctX5zy1zDG/Gi+rbCWeSMI0joqjHOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769315676; c=relaxed/simple;
	bh=ICWWFwZoVo2lGZIeLqMzauQCnI7KfiaS2QFGUNSAx0A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=q4y+HC5v53uTTdpyWfkL5r+/3m789tm5cJHWoOKNspi7rAPHBNFSpjpENUe6zvr1UxjLV4uyyc8lF1P2sSDsQhV9e7YPLQ8T0R8jFf2a4daWyAm6nuIKroMJ5F8wqgHI2Ug1fOOrKNLP8DsWQeo/4o5HvlsNVuCih275orNykyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+0LyO4M; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+0LyO4M"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8860d6251bso274958466b.3
        for <linux-nilfs@vger.kernel.org>; Sat, 24 Jan 2026 20:34:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769315673; cv=none;
        d=google.com; s=arc-20240605;
        b=QhGpQesAiLDrAK0wCACimadoMhny3vU8RMIXJ4JV1T0Yj1R+Z65ea1oi7ZXEzrH2wg
         wNphBbIasnCBOVbhB32wxjaadrm+JY2cRTTfuBf80Q46JZSr4GvYQWCzPTkN/uBvCTRY
         YSZTr4x+zRJZnW9Ubn7Ct+lVcfYIrbzNpH91cZluyrXhUEV+EIKZ/L9IO/Ovm6isT6sE
         x2zpaatP/lgFp5LyYtJ7dq3Pqxofg2ZaGILWTMX4uUc81IglQtrBpi128vWPR+u3eYLE
         dDv+A3tvvrAvE/KyPcX+kHlhsvpJTzvGlHceaJrhmEia+OQxH8lPAeHww4SmO5jJjA2Q
         00XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :dkim-signature;
        bh=ICWWFwZoVo2lGZIeLqMzauQCnI7KfiaS2QFGUNSAx0A=;
        fh=Afbqn6eya/G+dOUTlJ1LpDbmd7FU0jRH4DaWLsAvfgU=;
        b=Hl4KjrJFysEY0LPgoYOsNRzXUqh0Dsmjdz1IKuwO8zZ2VaTWfC70eaBsP8CV/hdX16
         UcEeeWzKQFhmYJYonbTjRFAdunbvzgSLsv9HU7GzlMWapG1nl3IHl0pGaxgMvSciCaCn
         W2jeATdqAzJHzmKrTdcoSTfWeiR1hWywg52/P+GHGiEZbOv/w3RdtVm4IfQHecZwiI/v
         3MFC/5V/BmJZ9oFBBt7zL73Ue5BIl96huOi3QjQQOTz6JLDCuCT5MocJs1LA7YFreD5j
         bpTMgSRDbjiEWSeQK2sLD1UnzVFXW3n40gqNxQXaeYFnxwtlpstYfzNFJP7Jc3YFu3cO
         8eSQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769315673; x=1769920473; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ICWWFwZoVo2lGZIeLqMzauQCnI7KfiaS2QFGUNSAx0A=;
        b=B+0LyO4MlWXXnbhjuRlGO3twDLjnFeRJ2ZoecyuXuY4g5Mv1PCZLDdOgdwljGci/xf
         /W9eoa1L7BE07Aj5mAH/Vmc5OxfmeJWiPG2ClWnWE59VwemzGXaYu/4iV0IB5sh3vr5A
         uuPdrxuRf/f2TGvEe3EybaBLjKEF0frS2NhgNqrZNU61J1MSz3Xa7AWk1ohEfYioxnwu
         FQFLcoIzAl7edTFqhAp/DP9ovQxMN7NnQsJg+HFauz4MxQ2A3/2b6UsVCo9ipUZ8iXnm
         O6yjR9wd8TEBKV+f001xezdhF+WnXx7EVxWYqlCCXuiDhU/e4qibU/MGH6kd2rBW4JVO
         gycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769315673; x=1769920473;
        h=to:subject:message-id:date:reply-to:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ICWWFwZoVo2lGZIeLqMzauQCnI7KfiaS2QFGUNSAx0A=;
        b=T44Ks2qzu2lfOk16QM+Me0rcb2aHZ7mo9F+OW473+Tw0SfGMOmcPnUeF9P8MDKK7pG
         0uEAqMafyPd3TWgkxv9MxBt4IAT7Y5rlAdLdEdLHUcakupvbZsm+ykb9R2vHWbKKhX/0
         gTCyd4RLrkE9VC+u1FAozlXudfNmqNb3eUBzXGWEvGr9JUD97LX7IyC2Te5m2G2dxI1p
         IBcRw7iyg0YYOfFOSsThSeVkmHO6+gn5ko67v+OMTE1+Y5YruSrkMV2S1hxWQUW3QDfW
         mb0dGxq0O2QWsH/3tcLOgiNMsdXYNFjK9PbFHAO1WQsKbv1AVPwn1iyDXbsWTun2Ag7a
         eweQ==
X-Gm-Message-State: AOJu0YwMdJHSjttPbx3hcHus6xPutgXrAUhsgeDWE4evt9/4ZQR2tgcp
	jahSA6Ba+NZqDFJN55wj61paANfWBLhySj0c6ZKYpUBbTwTFkZK4Y1B5eyn9bsvNif5q9ParKI9
	/OOx5MdMLARaKhLgbQDUnLGH5SRDsrACxYg==
X-Gm-Gg: AZuq6aKAwTC+L0NVXS30XXp2fRD8HjjelmZKIRBK8SpdQcTFQvP1C3AVoaMbWieMqwT
	6SHYLGve4wwKJM+VyUMeM6cW/Mi8W4GK/xFm01M+MatZDVGFjmsNvVspyJBEuilLQJZk5qfEyV6
	/LTzDIjNIjNSDsDDe0TpUfa+x+/66YDZ+fEjw/EDFWda+PRoXNW4MPUgbxcXxq2erQiopH1K57b
	JM4fbX3ub2UMGxVNC60f2Qxl/VmkvIVWDywQLrijziWp4nE2O1t5qyHKdq8TCy+kJoOooU=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a17:907:5ce:b0:b87:39d:2bb4 with SMTP id
 a640c23a62f3a-b8d2e8cce50mr46055466b.59.1769315673317; Sat, 24 Jan 2026
 20:34:33 -0800 (PST)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 24 Jan 2026 22:34:32 -0600
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 24 Jan 2026 22:34:32 -0600
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Sat, 24 Jan 2026 22:34:32 -0600
X-Gm-Features: AZwV_Qg2vM6lYT8hT3rhNCbebnSi1oOFWGdVb7LuvughxX6-RHJAF2XDFDgp0Mg
Message-ID: <CAE7Udf8CJgBr-C-4zYwOEaRTUV90h4POib3B-6qfTpbOjdmehQ@mail.gmail.com>
Subject: NILFS utils 2.3.0 was released
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

An update consolidating feature changes and bug fixes since v2.2.5 to
refresh the codebase. Features include GC improvements, support for
specifying filesystems via path names in management commands, and
pkg-config support.

from https://nilfs.sourceforge.io/en/download.html#2.3.0-u
