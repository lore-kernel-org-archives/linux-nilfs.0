Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD6B271476
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Feb 2026 00:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=148.163.139.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772153099; cv=pass; b=aTpF/EwAcOnpuqlCwDVPB216mwJ3HihPLa2Exnp9OkVfttjDwH4InJSVdQMpN1myNfNg9dKUB/SBUjqagIjTwHASkYsi+9kUzeGAXupF9vt1nIQt60nfTH+cr3lpHQzXClV55CuOtIPPWwZhVPRJflKSzw2EZwh7LM3gY0nGDy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772153099; c=relaxed/simple;
	bh=O+HRxgiHT2z7n5ch0TYyL93nG95Cvo9LlcSt25e21Gw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qlCwreuzhCdUt9mQVHUvTnclYb6SnRMJabIhDis7Nl9+J0xr0VX8NCUWaqwXMItJ9OdIp6L3AKgEVIhBFEHxASajKr2NW3z4BeaKQEUifrujnagOwo/gWnhHBz9rFkYaISNxU3PdEVBR6eYseXntTzHZiBn5ftWnZ1tHFTzAzU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=i1OndWU+; arc=pass smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="i1OndWU+"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61R0RGa01963969
	for <linux-nilfs@vger.kernel.org>; Thu, 26 Feb 2026 19:44:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=X7pD
	kBpYJ27xEgY18ooGDGOhBD+yHFwQylYRdDgNI+M=; b=i1OndWU+3hVbPOhJLPdB
	3dZ4nSkztb1ikKbvdbatjVGkVMLfV8JFZoIoELwMzvOYxfwUR6nLGakr/qfu4h1Q
	GO8wKJ8wC4UazfM1LbiYLaf16jQ5TxOebgu7QRs3IVlvCrkOwzJVdNdZd6DNe2SA
	UyzFa/gtDwTBn+WHSFtqboptIKXNMRyDXiRy1/HJUeBhpCt4ysnry1Waeo2FSSbr
	T44fjXhU7o2QxsSczc0EG487y0F+MHbUzU5UXRAbhPw2wSNZ/rXct8p9OvNCLgVx
	J8CkKDZsIksblH1voMgwtFzQHi7YdkePQnLp9goufCO+S9tQvuISr4koC2RoM7Sx
	xw==
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4cjsqn466f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-nilfs@vger.kernel.org>; Thu, 26 Feb 2026 19:44:49 -0500 (EST)
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-79801be4ca3so29440567b3.0
        for <linux-nilfs@vger.kernel.org>; Thu, 26 Feb 2026 16:44:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772153089; cv=none;
        d=google.com; s=arc-20240605;
        b=IZ7XbxI7Bk8xPljhu0wg4PgLTJxiLijLicp0+ORloMdkMvQfiUaNZ9dOYawOCPpYAT
         YtDWuN+kpuGRImw1Dep/L2xtPDI+/yh9IXsLGwEkB49UVnVJ1izqH6p/RZOpOGU7MLOI
         Aj8eQa7a8yeRYfy/f6y7IjbAWBmuvCKLBR8zogQQTfYettzZInz3BT6GpToRkATfzQZH
         dCbfDKE06mYZVBakCey3lPSs/1QS4aIrXRRN4k7PDFEmJalNSKTf+LlPvQGVTSX1SUpT
         DdKHJ2c30MF8qw+GlaS2FqE0aj4t77cp60XaZQox3evOyvGeQ5qGQwFQAVYevGuKWOvV
         EJLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=X7pDkBpYJ27xEgY18ooGDGOhBD+yHFwQylYRdDgNI+M=;
        fh=tZMIIN+8rtF+qJn72CWkEq6kwoDauep2cuc1nziUdIc=;
        b=LGrc7tqbMWR6eDpQgbF+FR/u/IutQVWD6fhx03tzAGoDaEIjDqQSMCy25A13RQTLZC
         E38o96aRHxQF8KQYJdjTpPDbhOOt0luTouQDVWzTCowYV9nT1Qzh+eNG0pXKbEUOz0Nu
         t5iwElEZnF2dsS/USlIGdiJ/3M2mv5Lk8JlBw0w0aMmgYXcwkvVnxZVYMaHP0tHvDC2T
         wsEh6ugvV1jbEWnu5May4EQwctxAJP2JgUgPGHl/XPa8gjV/ihC9tMEfaSrTeL3hJtY1
         wG5YKTwQpw8axYMicBHDZczf2ql2LUf/PnHd0Cr3Z57VVubOW1RrxKOJ2sGpksamlUwl
         IuOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772153089; x=1772757889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X7pDkBpYJ27xEgY18ooGDGOhBD+yHFwQylYRdDgNI+M=;
        b=Yl3VlabL8daeJqikBNMQI7QpV41vkbx3vOLHMky3O3AA36DdWz56KQivyHoS3YSNZC
         HyF/jmZCEgj7UZRlsQdzNEpMkOXRV8F9kqJ24CAIyr5hqfKrk+2bfQa1CxmIslxueVys
         2JuaUTJ1zdxXnPFUna8oMC3apnkUmPlfbNSVunZgXax238tyDqKFF7Y0LshDqG7FSTCH
         YPfokfnAszxzE4Wina3kJQlxAj+mcOmQxSqdBQCMiPPdg/9Lj4plSInB1uTOaxFuFwzX
         EH6wMuyxkmUBnmNXNLXgUHYzh2tKbCcZimxP2E+p0rrYheJaYNtFJGZX8jUBiLuRDCUt
         NhTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJz9RpjEw8WnPI5pzHKqE/9DHkPDP4/uvbBSY4ItMDiD+QW3QzzzSNAP6UmKI5UTmhRsgReldIGaJ++w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvwMYS2xHzolywSHkPvtDcZa/VMPpx2CAqZYTTTxnvY5de82cC
	G0eo1ZgwEvApSrrrxI+w9Bp7pEWrbaXH1SU1XiUaZTq2EdFZhT+sxUrsJi6S72JFkEDEKGFZ1+8
	7VQWp69t2a6eAp0wUpKFFC8UnOIJou0f1e22CWGTSbtKb8C8qauPUlepG+HRV4pEcpFHjYV5nwd
	c8KYnxJwxyVas7VyclnsK+NRVTCAlRkRHFLH8=
X-Gm-Gg: ATEYQzwnlI6LV5Zd+3XNsjUb3Y0xQpoiadcu1UHoqwLGjE1mqsDyqwNBnkgkPHZ/b56
	7nlIv3gNGpG6QJedsm4hgVQr8mONyo1axrpO4g4/QQTU2rwvlQZlNx6HFesgR+15Kn9yA+5VDY6
	SwFwuYToHIcTkmdO1ICiuYj8+1eOjaJ3t+IyYn2CiJDqjkZXMBCY5c62wml2XZnpIVmmTksem7N
	gdE7Q==
X-Received: by 2002:a05:690c:f16:b0:798:6401:fd1f with SMTP id 00721157ae682-798854a7e4emr11636107b3.14.1772153089297;
        Thu, 26 Feb 2026 16:44:49 -0800 (PST)
X-Received: by 2002:a05:690c:f16:b0:798:6401:fd1f with SMTP id
 00721157ae682-798854a7e4emr11635807b3.14.1772153088806; Thu, 26 Feb 2026
 16:44:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-2-70e7ac4f7108@columbia.edu> <aaDEEjVKBKrLxsht@infradead.org>
In-Reply-To: <aaDEEjVKBKrLxsht@infradead.org>
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 26 Feb 2026 19:44:38 -0500
X-Gm-Features: AaiRm52uN73WQ1q0q0Bsy0nLJ7MoTUQc88yWQcbleL3GQlPfTUc323g8dJKyM6s
Message-ID: <CAKha_sonOvAGriyromHtyRc-VY6Zyg3J3zd9UJPfBOAt1a522A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/2] block: enable RWF_DONTCACHE for block devices
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Bob Copeland <me@bobcopeland.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        linux-karma-devel@lists.sourceforge.net, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=NLPYOk6g c=1 sm=1 tr=0 ts=69a0e901 cx=c_pps
 a=g1v0Z557R90hA0UpD/5Yag==:117 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10
 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=azVShVRs0zEubeQ0wG0L:22 a=JfrnYn6hAAAA:8 a=lVyRQGvDAGr_LZokY8wA:9
 a=QEXdDO2ut3YA:10 a=MFSWADHSvvjO3QEy5MdX:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDAwNCBTYWx0ZWRfX+bQgsItcjkSI
 s7jlwuu6O7CYi48H7yOdIzzzi7lH8qu5mp4iuumOZRp1yLkrhdpBCgiLHuuKY6U37iXuj0nj6oa
 bTQDZmw8p69EmjwRsbNcIcMG0XXD2yBw1f+ACEh2FW4/mBQec5+E8Be5rTLeo43Fz7EO5lGIbhZ
 GFSAXwWwNefhL5KMoTNcpzkbXolXrbylysPAnmPQQ3qlYuCuAL86zlfTQCkllpQKr8cgBoGpdxZ
 zY9UqpRnxHV78Y/pQIgQBs0c0hWl2oDq/5/fcuUdgAdepAM7APJspekzhSsLeAbk7yyWDLiNiGJ
 3c4+OFQ1kPXtgQtfNwx6SbMczUKtJSe1228rp0YQ6oDcTXy5Dj4SwkYaasJNRV9J7FIOHjt+r/H
 pvxVy7EM+VX2i9rHEjqFZqUEsbxmZ+aL7+uWgqvysQMShf/IetJDbfO79WOTilwMnjj7p253/9y
 CCAG0H7l677VEbEPb/g==
X-Proofpoint-GUID: nZWNlgH8EWLli3bxsLU6HCRxJmaJY7_F
X-Proofpoint-ORIG-GUID: nZWNlgH8EWLli3bxsLU6HCRxJmaJY7_F
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11713
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 clxscore=1015 spamscore=0 priorityscore=1501 phishscore=0
 bulkscore=10 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270004

On Thu, Feb 26, 2026 at 5:07=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
> > --- a/fs/bfs/file.c
> > +++ b/fs/bfs/file.c
> > @@ -177,7 +177,7 @@ static int bfs_write_begin(const struct kiocb *iocb=
,
> >  {
> >   int ret;
> >
> > - ret =3D block_write_begin(mapping, pos, len, foliop, bfs_get_block);
> > + ret =3D block_write_begin(iocb, mapping, pos, len, foliop, bfs_get_bl=
ock);
>
> Please don't change the prototoype for block_write_begin and thus
> cause churn for all these legacy file systems.  Add a new
> block_write_begin_iocb, and use that in the block code and to implement
> block_write_begin.
>
> And avoid the overly long line there to keep the code readable.

Will do.

>
> Note that you also need to cover the !CONFIG_BUFFER_HEAD case.
>

I don't think there is a !CONFIG_BUFFER_HEAD case. The only user of
block_write_begin_iocb() would be blkdev_write_begin(), which is only
defined under CONFIG_BUFFER_HEAD. !CONFIG_BUFFER_HEAD paths use iomap which
doesn't use it. And buffer.c is only compiled for CONFIG_BUFFER_HEAD. Unles=
s
I'm missing something?

Thanks,
Tal
