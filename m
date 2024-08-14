Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9575423AB
	for <linux-nilfs@vger.kernel.org>; Wed, 14 Aug 2024 01:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723597811; cv=none; b=HqataIzvTP1edre8u60u9yg45RJqJLlZeT0r2kMn64Hkg22jCLfflvERpTh4WXai+LnJaz/rNNYu4ZjtaNY3CKgiIgttqCHoZrT9w0rJL2/quSxrqkOEyGOl6CLdqYDARJ0HdrrzI8rCbaFjx0PL7Xtz3vWNuhigglfYlWQi2CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723597811; c=relaxed/simple;
	bh=w+m4BtSU08bqc17+hpSfYVQGgJWJJtBa8HgaYD23KzY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MqtMdOqBU9dITgFKBu8qnnNtmriYZBfrBkKQLy0tjGwpsMW9evOXl7+ibMLNDJNnNLk/n99V17oOeYeJVwy0wYoVALoTVPURgZw+JtZ72c2XlKl5rIGrChQgOuKbrYXR4wXgNAQW0ZElCn2WKEhyjGjqUIU1Hz+XX8Ltidb3Jf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.stonybrook.edu; spf=pass smtp.mailfrom=cs.stonybrook.edu; dkim=pass (1024-bit key) header.d=stonybrook.edu header.i=@stonybrook.edu header.b=rm9ngOAC; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.stonybrook.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.stonybrook.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stonybrook.edu header.i=@stonybrook.edu header.b="rm9ngOAC"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e115ee08372so33277276.3
        for <linux-nilfs@vger.kernel.org>; Tue, 13 Aug 2024 18:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail; t=1723597807; x=1724202607; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8zIBD/Tngb9DR3NVNtr8SRjzFGMbrZogkUVSrCW2ENg=;
        b=rm9ngOACjcpANWwsOVrNxvj8wthd9X1gCO2NVY97t0h+GL0vbrAucqpSZvPHQIVTEG
         2wsA34+kPP9p22Kb3hVBZXEDWhbOqtSBPw4LscYqqlY3793bXuFVQnLV+USnRLUMbc9R
         BatCXRLNOq59fGtnKkM/CrLBI/WJStFBGNNG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723597807; x=1724202607;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8zIBD/Tngb9DR3NVNtr8SRjzFGMbrZogkUVSrCW2ENg=;
        b=LRIxvYSnoeCv3aptmWLSeUnEfDoF8HCzQkw1h8wc3GhyiqJQHUbf3I5hnfIukaWM47
         v2G2/fpwWHVpQOgHgOZU2v6ClbkQJc93LRsdL+enMqJIuAUeZxkLWCqQuNNjLQQ3JwY3
         E03yVYyln5hurcKqNqXnttjNAxFqc4jGMB0JrwvLsQbSaOFBsjyvxnco2pdH/Sjhu2vn
         LH09Ge+aXaM9JLGgKepQdOKaGRq10vF/28AUujNPSwY7E2QdBXrtE1MqcLKvLjwB1nX1
         6nNPPdpgr63rcS+zMRxweEcfp3Whd9T6dQ7Swu7DbxhoIA/pmMKbh/hGwraN450Z3geA
         PoTQ==
X-Gm-Message-State: AOJu0Yy+RLWcZ1wjUVRANggnypbPyIib+tMZyffv9iTE5AFdL3USoHCS
	lI6A2fp3S/bOW8YrKFjg1cvadJKmVU2/wFQlXakXHFOEPL0oCTdEQ8LEbDu/Bgseea4aBW+OSeO
	KS/KJ8DY4UtB/3U4ZLsB6HNVxBY0bVHjuPoMFHg==
X-Google-Smtp-Source: AGHT+IGx8yh9bjwN3+ksjglZPayMu/Ufu8Lz0yUUXAUQyiNkd2jUQEK7s8EqWNEMDMXBsfgwl+AKDcU4EoF/60qBXOY=
X-Received: by 2002:a05:6902:240a:b0:e04:e298:3755 with SMTP id
 3f1490d57ef6-e1155adb6f7mr1576359276.28.1723597807366; Tue, 13 Aug 2024
 18:10:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABHrer3rrUS8x+te16eXF7HMdyYCRcoj+CS6c2T-5EmxjKO-7g@mail.gmail.com>
 <CAKFNMo=gnn5TL7moJR7hgtvH_ML_3V3XXgnntPqiYq6RpzHT+A@mail.gmail.com>
 <CABHrer2U3nNFQzT0QLjTHJ9yUiwOuxtcP44jEP4huTSRTED2tg@mail.gmail.com> <CAKFNMokChMGs5FaXRhCDsh6Nd0XtEdoF_LBs_6HYXY8HV=khrg@mail.gmail.com>
In-Reply-To: <CAKFNMokChMGs5FaXRhCDsh6Nd0XtEdoF_LBs_6HYXY8HV=khrg@mail.gmail.com>
From: Yifei Liu <yifeliu@cs.stonybrook.edu>
Date: Tue, 13 Aug 2024 21:09:56 -0400
Message-ID: <CABHrer1zSr7GETOarUaVn7w08eWOcofD=oDX4T8X6DpePL1q-Q@mail.gmail.com>
Subject: Re: Potential Bug in NILFS2: Disk Space Not Freed After File Deletion
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org, Erez Zadok <ezk@cs.stonybrook.edu>, 
	Geoff Kuenning <geoff@cs.hmc.edu>, Scott Smolka <sas@cs.stonybrook.edu>
Content-Type: text/plain; charset="UTF-8"

> Well, what you're saying is that the file system got stuck.  And you
> cannot recover it even by running the "nilfs-clean" command or
> manually starting nilfs_cleanerd.  Right?

Yes, that's right.

Thank you so much for the explanation and feedback!

Best regards,
Yifei
