Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817AE374D9;
	Tue,  7 May 2024 22:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715122459; cv=none; b=lvymKOJAxXi0hEn0vEJBbqCBLmZU4LXxdR2Xg4+9gxtKAcUgkyaBKCyBAzkiNVWBP6JyrjbaL/wol34wtqZnH4EAGLZ3x3JziuhmcR9yGWKHcDIFu7geZABLu6ZO1hwbDNFRgjkm9gqYwVxpvYeD8p9f8QkKEiTcvK2AmL2gs9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715122459; c=relaxed/simple;
	bh=weDT3AULG+DpymysMWig04MbDKwtN3q1YtaWP79mB3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tSTYxRY/cw+exUcphe2kFhrVtITPmMzKmD1l1wB+56eV+ia2kLQPzbZnvW3m0gqo6/PIEJeiTyvXHs1jZIkti/wF8VW2SS9HUmTv5u6ng8/gEMmEakLHu5D8h/voGSs48NdVELDInInRUtytgL6o+PR8EveF/ccqKCmxw3Ck1Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=a2SyUCMt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="a2SyUCMt"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 447LY5jb023828;
	Tue, 7 May 2024 22:54:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=jyuABFncq0D2svYrB9Ea/MoDwXfjAhm3n9NkBI3OXIw=; b=a2
	SyUCMtTYFraD8tzVLCCGUHVZSPGFMwgyyvnASA1hD32xvty9cvnbE2UVC8BMp371
	VQ5RlXZrrLyhCRwTBDTK2EgejXo5vNFrsLh9qOxrmh0yB5OVul+znT0vupw34Ue6
	jqjMis4rj14aGI3XQVUjilxjX4nTSS/wa17zKxnB8E/sMdMADBPMKM1dtopbEEOt
	MHoQB/ixERhmRddUHvVtned4H3VSKYZ0XhbpJk/8tHcEVCK0J7Uw410bAhW7cIfz
	tz6cs6NpVAd5IEnJF4nvC+porV2/pT0s/+UpAvuAreeUgKbVtgdUPw7ACX6iU6an
	bv/5y70JCrEmqs4o5VYA==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3xyspggebj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 22:54:15 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 447MsDEd021810
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 7 May 2024 22:54:13 GMT
Received: from [10.110.84.74] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 7 May 2024
 15:54:07 -0700
Message-ID: <9d9c2912-e965-435d-b0d9-7e6071c24ab3@quicinc.com>
Date: Tue, 7 May 2024 15:54:06 -0700
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nilfs2: fix nilfs_btree_commit_convert_and_insert()
 kernel-doc
Content-Language: en-US
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC: <linux-nilfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240507-nilfs_btree_convert_and_insert-kdoc-v1-1-bab3514eb753@quicinc.com>
 <CAKFNMomG+GuKJ53WmdWFONtimhbanKU-B_ZTdt5sEFxcuYxJ3w@mail.gmail.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <CAKFNMomG+GuKJ53WmdWFONtimhbanKU-B_ZTdt5sEFxcuYxJ3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: W7eNOJR1f83XcDyEtKRY46EpQEVwCOd6
X-Proofpoint-ORIG-GUID: W7eNOJR1f83XcDyEtKRY46EpQEVwCOd6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_14,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 adultscore=0 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405010000
 definitions=main-2405070160

On 5/7/2024 3:45 PM, Ryusuke Konishi wrote:
> On Wed, May 8, 2024 at 7:23 AM Jeff Johnson wrote:
>>
>> Fix the following reported by make W=1:
>>
>> fs/nilfs2/btree.c:1871: warning: Function parameter or struct member 'btree' not described in 'nilfs_btree_convert_and_insert'
>> fs/nilfs2/btree.c:1871: warning: Excess function parameter 'bmap' description in 'nilfs_btree_convert_and_insert'
>>
>> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
>> ---
>>  fs/nilfs2/btree.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
>> index 65659fa0372e..8299839b5129 100644
>> --- a/fs/nilfs2/btree.c
>> +++ b/fs/nilfs2/btree.c
>> @@ -1858,7 +1858,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
>>
>>  /**
>>   * nilfs_btree_convert_and_insert -
>> - * @bmap:
>> + * @btree: bmap struct of btree
>>   * @key:
>>   * @ptr:
>>   * @keys:
>>
>> ---
>> base-commit: dd5a440a31fae6e459c0d6271dddd62825505361
>> change-id: 20240507-nilfs_btree_convert_and_insert-kdoc-7753c4a6e7c3
>>
> 
> Hi Jeff, thank you for posting.
> 
> However, a fix for this kernel-doc warnings is already queued in the
> mm tree (to be merged in the next merge window).
> 
> Please refer to the patch below:
> 
> https://lkml.kernel.org/r/20240410075629.3441-3-konishi.ryusuke@gmail.com
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-stable&id=3da9b9650acc3a2a0c3d3f4542b93d4abe9da1de
> 
> 
> Thanks,
> Ryusuke Konishi

Awesome that others are helping to clean these :)

Guess I should check lore before fixing so that I don't replicate work!

/jeff
