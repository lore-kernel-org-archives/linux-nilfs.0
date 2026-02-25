Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B1334B42B
	for <linux-nilfs@vger.kernel.org>; Wed, 25 Feb 2026 22:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=148.163.139.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772059394; cv=pass; b=m+e8/0Qaier7H50gAYEHq3oBaLnVzgNAG8quHBUCWnar/kQsok+usT857Im4mS9sCLQu7QWrnWoxsxalay7ZKiC0Hm6oyjuYNkA5On23BHCWCqGDDFFkvh6ijwHqOa3xOQD7fr5IXZPkscYeWbTESeME8jkOAlAhYgIwSTHD/Gc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772059394; c=relaxed/simple;
	bh=pDtBt1IUvockGTD9sAkNQUVYnZ2xavhQA7l7ZDVpiZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KJ+w2/4sFbgcQhuNlGTmhi31JyhqLThjdLeem4K40RgC/8lh9ju5tYth5Ge9hhN7/HiLH+Of/M8/fRFM9mYflwYEfUShzaZYGVDxZRpvjOn9MYUf5yb9XGL+9HUqyzlIwVZyv4Cmj9L8fwDKsGZMp2F06ahCcHTkKszXkm3X5rM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=nsrj0T6H; arc=pass smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="nsrj0T6H"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PMg5nh2790552
	for <linux-nilfs@vger.kernel.org>; Wed, 25 Feb 2026 17:43:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=pDtB
	t1IUvockGTD9sAkNQUVYnZ2xavhQA7l7ZDVpiZY=; b=nsrj0T6HCt6fbehQN3aM
	mCW3EK4O0E/cM/Qy7KmXDptiP9Si3inQNFYIQScWj2MSnIVqk1bh6Ulf2iHVeiyG
	jOkKvI97CiUm8nbFeOE8ZSU6uEg9o21CwOqyT0zDJZaulMCy+81avk/zmfLBGPpH
	8zS2au6AvembXSGV6xYbFUcUF5MKKn8LhyrXp7Sf7rQ/fIjdSv01VirEFwBfgwbZ
	WZtyfKQt0yCgnh9sFSfrI9pnPAcpLvFJNu3YOATmrfvTleq6h4woEObun258q4a+
	8GChmZaWdoX1h6JiicGPjWZ3UYKC3TK6vAzSf9/FhEcslwYYazjWijqQesgqf0ma
	CA==
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4chnrtqt76-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-nilfs@vger.kernel.org>; Wed, 25 Feb 2026 17:43:11 -0500 (EST)
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-797b0076763so3362037b3.1
        for <linux-nilfs@vger.kernel.org>; Wed, 25 Feb 2026 14:43:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772059391; cv=none;
        d=google.com; s=arc-20240605;
        b=hz7+znQaq8RmlMN79rJ/OGwXDtKvxYwDZbn+49KPOgQEUI9xkt0SVpq358stYq8UyL
         0FxxSbqWepS3eMa2UdpOeW2kG1HxOd7KrLTyIzTfE0tJgQmqqFHWWKo64tnSq2etS01C
         r2eMMPV5nguBlZ1/9jO2VAPAzt3P1UihACu08jAVaYNWKgNc3MYu9v9zeZWO6pgqtkrS
         YJnSWMUZhIGa2QpBsYsZp200UjkRD00kfyQs7r09AnjroxWwOQgQTl2JiIe5wIuuID2E
         wpfVMID1tCosnmVZM97dfD0zF3v+8G2oVbTALGHl7BQuKySWXcrvcjVUv0j82KdO24l8
         O0zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=pDtBt1IUvockGTD9sAkNQUVYnZ2xavhQA7l7ZDVpiZY=;
        fh=bsqCm7/vVwgJ10bP8mcmgOzRK79SoV6is3p3eOFVBLI=;
        b=X9O9n8+ro60JEG7MHz1FB4d7coMx+A9z5BVjZmTh+SPpcjMh+hx6C78DJd9RiT2+tF
         j13TJ8tESLWXvCyF+BIn7rlR95efWgwGchizOCcymf2L3Qh/hjphJc264UhkWlqlsDn0
         jEZF2pEHohpEHTmV+tPhwJlwiQDNGubR8KzVEBtpNiaNTOdahq959zjWTVwWrHRkTtoa
         MTfJ3eeRxukwwYUn5EjVXENX0jCoOTplXn0Gi4Cp3QScd9fPRjrgIjK857v8B1PZb/cY
         7AlXrQSEyRNPNRKcfaFskPTmimve/gSVYKOwSXr5lym2fWD2r+XlbHjhhC3vyeJceaqB
         8bqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059391; x=1772664191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pDtBt1IUvockGTD9sAkNQUVYnZ2xavhQA7l7ZDVpiZY=;
        b=JRERqB6zU4Zh6tvT98RlpDrl0ZGhPFzchgzRkjquO38mATUxVHU8t+aaJqu0JIiFR4
         JyS50wyO2tJD+N2X3+ElW70I/WBhq9cfO/zWiYWUEBrMGSrR94i2KzKhfDJpqg200X4W
         h+ZLtV8Lj+c01z6zws7S4upRSKi9cBJ+mREhkgn6IxP59+K/eonM1G1EhVjad19lK8W6
         60BAwn3A+nyuSyflyg+/IhomSYCWBr8zShim3UlXxdH8hYuYQOYhV+ni4IYeN4LA4qOL
         ZWYJ/pDgyAXZGp6J1nVrhG/C2cr/FO3v1AZFE4+KXsjdrtIOmpNWPCqk9efSDfNK5c7d
         BHkg==
X-Forwarded-Encrypted: i=1; AJvYcCX5JqQPTUBBeBOJQA60s2uAJfjz1BLu/d0h3fDgFZPwcqobhyXfzq6j+JAPpzEunJwrBJTWb4XPKldRCg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9AMxtrgktomI++jK+OG2aysEqZkvge2e/HXqR3yDy2XBKq/qn
	E1es0/5Z++KkG91Yw329j0yezgtFTVkqmA3RBC2BbqAGAabhKBDNYGZVdx9dbth0z2LSH7yvrum
	ASrMPOVta1OuVAWAQglShYyy+BDDKfWkny/z/xRBeL5VuUrbrSi9O/TCvKKVO1mA1dhyByjp8Ck
	8DqI8iKi6sag51lOSNmvR6hCSYfminwUXT110=
X-Gm-Gg: ATEYQzwQ5dDQknDAiMwnkhqMZhNtUmq+fsfQEsYALpFXDTXM/6K18de4dThoGBQt8KO
	0M+VvtBhXIYZeg7RSnkPYrGZoLcwlNKH2lKgzT4w2vAgR9fKpYlgoKpCo2bBPn9jA8hwiHitolR
	J8Ou2LSLbuzUEj+yJn665Oxakp2rh7i+0GWI0m2Z9WZHURAC+CF30eOWz3wV1rRz5hB5/uz6nhO
	Be6hCJw
X-Received: by 2002:a05:690c:4d8a:b0:794:e72a:f664 with SMTP id 00721157ae682-7986ff6368dmr23925657b3.60.1772059391039;
        Wed, 25 Feb 2026 14:43:11 -0800 (PST)
X-Received: by 2002:a05:690c:4d8a:b0:794:e72a:f664 with SMTP id
 00721157ae682-7986ff6368dmr23925517b3.60.1772059390662; Wed, 25 Feb 2026
 14:43:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218-blk-dontcache-v1-1-fad6675ef71f@columbia.edu> <35866783-2312-4e31-904d-3746510eaf56@kernel.dk>
In-Reply-To: <35866783-2312-4e31-904d-3746510eaf56@kernel.dk>
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 17:42:59 -0500
X-Gm-Features: AaiRm51munUdTrnZZ7c7FkAWOz4juVf_xR9vg2o7Xlz46s_YpnQLMylaXhWKvd8
Message-ID: <CAKha_so5z7S6vD-betDLr=GREewxnWxeK9qawhZq8yKt=TD2XA@mail.gmail.com>
Subject: Re: [PATCH RFC] block: enable RWF_DONTCACHE for block devices
To: Jens Axboe <axboe@kernel.dk>
Cc: "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Bob Copeland <me@bobcopeland.com>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        linux-karma-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIxNyBTYWx0ZWRfXx+pGa1YoYH0b
 vXbaOBL8U4st89+SNAdadV1hUzQBsowZQwvPH/jA+JY302BaaviD37znvoOlp8AqPBzF5kde11T
 3gn9qtzdaf3iiQ8yusWDd+BsdSXst4fihyqWEw5CutKHOqnM0h8CPnN7LB4tMLY7ipLdKNLVPS9
 bs3whP0pelDq0GCFTCTpHHw38kNCQY87OPCUcddkeCbB25ix5672UXTomWJscvPjFbukr1txNrS
 V0Y+Ysh2E7iKa3C/nkk5UOQoorHok6ra7U/EdVl+5ybSFun7ujH51e2jkbDRiH/ABigOmOWNgFc
 Ulk/YnA1UGvxjjWjvlKI9vDPgop1oVY6NLyjfJqgAKO25XK+Pm1CyUMuoRYqy5dQpGLkugK9RAD
 8ZsEqknWC+xbpt5N64qURICwYF6advVkp8PhPWAC7JwS4Zkd3H33zH9wZ68bV+zeZeHkMMRf02q
 0yKIagzO3JDigEBZCaA==
X-Authority-Analysis: v=2.4 cv=bcRmkePB c=1 sm=1 tr=0 ts=699f7aff cx=c_pps
 a=72HoHk1woDtn7btP4rdmlg==:117 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10
 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=QOCMdifcju39GKoXhKua:22 a=VwQbUJbxAAAA:8 a=VNoZ5ujv9kIkDPz7VAoA:9
 a=QEXdDO2ut3YA:10 a=kA6IBgd4cpdPkAWqgNAz:22
X-Proofpoint-ORIG-GUID: daJ3rHkqrYLHtbyqvHZVRl9YEy-MmMJK
X-Proofpoint-GUID: daJ3rHkqrYLHtbyqvHZVRl9YEy-MmMJK
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=10 bulkscore=10 priorityscore=1501 phishscore=0
 clxscore=1015 adultscore=0 impostorscore=10 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250217

On Thu, Feb 19, 2026 at 10:24=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
> On 2/18/26 2:13 PM, Tal Zussman wrote:
> > Block device buffered reads and writes already pass through
> > filemap_read() and iomap_file_buffered_write() respectively, both of
> > which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device file=
s
> > by setting FOP_DONTCACHE in def_blk_fops.
> >
> > For CONFIG_BUFFER_HEAD paths, thread the kiocb through
> > block_write_begin() so that buffer_head-based I/O can use DONTCACHE
> > behavior as well. Callers without a kiocb context (e.g. nilfs2 recovery=
)
> > pass NULL, which preserves the existing behavior.
> >
> > This support is useful for databases that operate on raw block devices,
> > among other userspace applications.
>
> OOO right now so I'll take a real look when I'm back, but when I
> originally did this work, it's not the issue side that's the issue. It's
> the pruning done from completion context, and you need to ensure that's
> sane context for that (non-irq).

Thanks for taking a look! That was very helpful feedback.
I sent out a v2 hopefully addressing that here:
https://lore.kernel.org/lkml/20260225-blk-dontcache-v2-0-70e7ac4f7108@colum=
bia.edu/

> --
> Jens Axboe
