Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23071A8F63
	for <linux-nilfs@vger.kernel.org>; Sat,  5 Apr 2025 18:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.193.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743878011; cv=none; b=Esr4ugKDiOGRAHqgVOg1vz+0drcwnp75z6/2gjLVp7qXFX7yBCg+htfbrSn1p0ifZ5k640/C3OUWQZqA8Umtit7o8CirfQbrTx+dVLmodB5moqUjtpMkcONb30qB04kvm9tYB9fJDUDKm0eZWEb31UyXTDH+reWaZz2dSxMpVto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743878011; c=relaxed/simple;
	bh=uxhqY1YSip8wrLoA7rJKVntpVvxVOcrCmwg1BeQuBYs=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=aCUgIY4Sc/+R+S1coShjEVjX8rWguXUgz1Jk2OO3DxiP5Kpe4emlfExOeD/o17mtkLM4UjmhMpZu6qPAQFlsyr7zZwgIYYuP+NWIAjdwWj2pYlr/yuiuWqVCKGqRBA4KSk2/0gaJ8f5My9jsdKD+Q+He9lmaGXNT7qVvs3GmR8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=askholm.net; spf=pass smtp.mailfrom=askholm.net; dkim=pass (2048-bit key) header.d=askholm.net header.i=@askholm.net header.b=bkBmR7T0; dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b=boaisdML; arc=none smtp.client-ip=34.202.193.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=askholm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=askholm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=askholm.net header.i=@askholm.net header.b="bkBmR7T0";
	dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b="boaisdML"
DKIM-Signature: a=rsa-sha256; b=bkBmR7T0tdp75GfEzzPv7bXzEfoEc4igDn3Nqk9YFPlTT+ciZwinsYiGiqwO0PLjbSWv04p0JlATc3rqicAnlBpI+8Wx5abaOrfm1gP89yZoU4uy0rwGWC+4z8Lw+J4E8ZYhkY2Fr29/xbSlX4CsurKvrhwZsTMHYOswbEVmQTAh1Ygd6KWjttCbm5bekPm6zFh4P9H3ikX8agYgcfU9TbFs+qzgxa8U8NGJ6n0Lv3FeLP6ewKW+yBTJzefiFL+g438YOMj6K3LPwAkVImaKOWvhKSyVnwirYQaZ7DkE6rLpBklWn5PSzfo/CpJuSy9PYzq823fPSTbtvQadCVAG+w==; s=purelymail1; d=askholm.net; v=1; bh=uxhqY1YSip8wrLoA7rJKVntpVvxVOcrCmwg1BeQuBYs=; h=Received:Date:To:From:Subject;
DKIM-Signature: a=rsa-sha256; b=boaisdML9t3aWEskGBEm6SyXhZIG/KwnKiUvHwGpiTtby9K6I8YpqvqYtv7kgqgWibpCFlghY9yw56QAhWiLMqpjdvcsHmfaEc4aRbRJhJ1f0Ivm620sJxswgGK/V0n5yo8+yyCRHn6DBWwNBFrm2oMNJJoUskqY399SEY+9ey/LfX4rSUZbv6A8OKAEkwrgUn3tKM9C3XJzKe/70sObfivip8SSaYD78iUBsOL/ifbvop7N7J8tpWUDwaA4tFLgLVtnVKeEej7uQNHv3sjbhLCTIEexbrLkXnNPYUb7johezlzkNu3WGewuz9+hpuk8yaAjm1D1zT2zdwO/FvcBcg==; s=purelymail1; d=purelymail.com; v=1; bh=uxhqY1YSip8wrLoA7rJKVntpVvxVOcrCmwg1BeQuBYs=; h=Feedback-ID:Received:Date:To:From:Subject;
Feedback-ID: 2561:640:null:purelymail
X-Pm-Original-To: linux-nilfs@vger.kernel.org
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id 1843737438
          for <linux-nilfs@vger.kernel.org>
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Sat, 05 Apr 2025 18:33:14 +0000 (UTC)
Message-ID: <822efaae-2317-4002-bebe-538cbb90acbc@askholm.net>
Date: Sat, 5 Apr 2025 20:33:11 +0200
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-nilfs@vger.kernel.org
Content-Language: en-US
From: Magnus Askholm <magnus@askholm.net>
Subject: Question about reflink support in nilfs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Some places, I see people say, that nilfs is a copy-on-write filesystem.
But when I try to copy a file inside nilfs, using reflinks, this happens:

$ cp --reflink=always README.txt README2.txt
cp: failed to clone 'README2.txt' from 'README.txt': Operation not supported

Normal copying works fine:
$ cp --reflink=never README.txt README2.txt

So it looks like nilfs doesn't support copy-on-write, where you can copy 
a file
without using extra space. E.g. copying a 5 GB file won't take 5 GB of 
free space.

Is this a bug or just a missing feature, that could be implemented in 
the future?
